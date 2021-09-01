Vagrant.configure("2") do |config|
  config.vm.box = "bkenro/ffdsm"
  config.vm.network "private_network", ip: "192.168.12.34"
  config.vm.hostname = "ffdsm.internal"
  config.vm.provider "virtualbox" do |vb|
    vb.name = "vm-ffdsm"
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "www", "/var/www", type: "virtualbox"
end
