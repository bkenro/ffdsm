#!/usr/bin/bash
#
# installation/configuration script for "drupalizing".
# (should be run as superuser)

# basic configuration
sed -i.org -e 's|archive.ubuntu.com|ubuntutym.u-toyama.ac.jp|g' /etc/apt/sources.list
apt-mark hold linux-generic linux-image-generic linux-headers-generic
apt-get update && ap-get upgrade -y
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

# PHP and configuration
apt-get install -y php php-cli php-mysql php-pdo php-xml php-gd php-json php-zip php-curl php-mbstring php-pear php-apcu php-pdo-sqlite php-ssh2 php-xdebug
sed -i -e "s|memory_limit = 128M|memory_limit = 256M|" /etc/php/7.4/apache2/php.ini
sed -i -e "s|upload_max_filesize = 2M|upload_max_filesize = 12M|" /etc/php/7.4/apache2/php.ini

# Composer 
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

# Drush 8
wget https://github.com/drush-ops/drush/releases/download/8.4.8/drush.phar
chmod +x drush.phar
mv drush.phar /usr/local/bin/drush

# MailHog and mhsendmail
apt-get -y install golang-go
go get github.com/mailhog/MailHog
go get github.com/mailhog/mhsendmail
cp ~/go/bin/MailHog /usr/local/sbin/
cp ~/go/bin/mhsendmail /usr/local/sbin/
sed -i -e "s|;sendmail_path =|sendmain_path = /usr/local/sbin/mhsendmail|" /etc/php/7.4/apache2/php.ini
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
