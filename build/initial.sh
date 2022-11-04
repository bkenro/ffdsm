#!/usr/bin/bash
#
# installation/configuration script for "drupalizing".
# (should be run as superuser)

# basic configuration
sed -i.bak -r 's!(deb|deb-src) \S+!\1 mirror://mirrors.ubuntu.com/mirrors.txt!' /etc/apt/sources.list
apt-mark hold `uname -r`
apt-get update && apt-get upgrade -y
timedatectl set-timezone Asia/Tokyo

# MariaDB, security enhancemnet, adding interactive admin with user/pass 'dba'
apt-get install mariadb-server -y
mysql <<EOS
UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
GRANT ALL ON *.* TO 'dba'@'localhost' IDENTIFIED BY 'dba' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOS

# Apache2 web server
apt-get install apache2 -y
systemctl enable apache2
a2enmod rewrite
systemctl start apache2
usermod -aG vagrant www-data
echo "<VirtualHost *:80>
  DocumentRoot /var/www/example
  ServerName example.internal

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined

  <Directory \"/var/www\">
    AllowOverride All
  </Directory>

</VirtualHost>
" | tee /etc/apache2/sites-available/example.conf
echo "umask 0002" >> /etc/apache2/envvars

# PHP and configuration
add-apt-repository ppa:ondrej/php -y
apt-get update
apt-get install php8.1 -y
apt-get install php8.1-mysql -y
apt-get install php8.1-xml -y
apt-get install php8.1-gd -y
apt-get install php8.1-zip -y
apt-get install php8.1-curl -y
apt-get install php8.1-mbstring -y
apt-get install php8.1-pdo-sqlite -y
apt-get install php8.1-ssh2 -y
apt-get install php8.1-xdebug -y
apt-get install php8.1-bcmath -y
sed -i -e "s|memory_limit = 128M|memory_limit = 256M|" /etc/php/8.1/apache2/php.ini
sed -i -e "s|upload_max_filesize = 2M|upload_max_filesize = 12M|" /etc/php/8.1/apache2/php.ini

# Composer 
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi
php composer-setup.php --quiet
rm composer-setup.php
mv composer.phar /usr/local/bin/composer

# Drush 8
wget https://github.com/drush-ops/drush/releases/download/8.4.10/drush.phar
chmod +x drush.phar
mv drush.phar /usr/local/bin/drush

# MailHog and mhsendmail
apt-get -y install golang-go
go get github.com/mailhog/MailHog
go get github.com/mailhog/mhsendmail
cp ~/go/bin/MailHog /usr/local/sbin/
cp ~/go/bin/mhsendmail /usr/local/sbin/
sed -i -e "s|;sendmail_path =|sendmail_path = /usr/local/sbin/mhsendmail|" /etc/php/8.1/apache2/php.ini
echo "[Unit]
Description = MailHog
 
[Service]
ExecStart = /usr/local/sbin/MailHog > /dev/null 2>&1 &
Restart = always
Type = simple
 
[Install]
WantedBy = multi-user.target
" | tee /etc/systemd/system/mailhog.service
systemctl enable mailhog.service
systemctl start mailhog.service

# Misc
apt-get install zip -y
apt-get install docker.io -y
apt-get install docker-compose -y
apt-get install imagemagick -y
sed -i -e 's#<policy domain="coder" rights="none" pattern="PDF" />#<policy domain="coder" rights="read | write" pattern="PDF" />#' /etc/ImageMagick-6/policy.xml

# clearing package-cache, compaction
rm /root/.bash_history
apt-get autoremove
apt-get clean
rm -f /var/log/*
rm -f /var/log/*/*
rm -fr /tmp/*
dd if=/dev/zero of=/0 bs=4k
rm -f /0
history -c
