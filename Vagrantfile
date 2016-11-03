# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  
    config.vm.box = "ubuntu/trusty64"
    config.vm.provision :shell, path: "bootstrap.sh"
    config.vm.network :forwarded_port, host: 9200, guest: 9200 # Elasticsearch
    config.vm.network :forwarded_port, host: 9300, guest: 9300 # Logtash
    config.vm.network "forwarded_port", guest: 5601, host: 5601 # Kibana
  
    config.vm.provider "virtualbox" do |vb, override|
        vb.cpus = 1
        vb.memory = 1024
        vb.gui = false
        vb.name = "vagrant-ELK"
        override.vm.synced_folder "./provision", "/vagrant"
 
        # setup local apt-get cache
        # if Vagrant.has_plugin?("vagrant-cachier")
            # Configure cached packages to be shared between instances of the same base box.
            # More info on the "Usage" link above
            # override.cache.scope = :box
        # end
    
        # disable the vbguest update plugin
        if Vagrant.has_plugin?("vagrant-vbguest")
            override.vbguest.auto_update = false
        end
    end
end