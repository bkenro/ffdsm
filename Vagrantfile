Vagrant.configure("2") do |config|
  config.vm.box = "bkenro/ffdsm"
  config.vm.network "private_network", ip: "192.168.56.78"
  ### port forwarding example
  # config.vm.network :forwarded_port, host: 80, guest: 80
  # config.vm.network :forwarded_port, host: 443, guest: 443
  # config.vm.network :forwarded_port, host: 8025, guest: 8025
  # config.vm.network :forwarded_port, host: 8080, guest: 8080
  # config.vm.network :forwarded_port, host: 3000, guest: 3000
  # config.vm.network :forwarded_port, host: 3306, guest: 3306
  # config.vm.network :forwarded_port, host: 5432, guest: 5432
  config.vm.hostname = "ffdsm.internal"
  config.vm.provider "virtualbox" do |vb|
    vb.name = "vm-ffdsm"
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
end
