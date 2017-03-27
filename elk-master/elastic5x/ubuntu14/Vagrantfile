# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    # configure VM
    config.vm.box = "ubuntu/trusty64"
    
    # configure provisioning
    config.vm.provision "shell", path: "bootstrap.sh"
  
    # configure network ports
    config.vm.network "forwarded_port", host: 9200, guest: 9200 # Elasticsearch
    config.vm.network "forwarded_port", host: 9300, guest: 9300 # Logtash
    config.vm.network "forwarded_port", host: 5601, guest: 5601 # Kibana
  
    config.vm.provider "virtualbox" do |vb, override|
        vb.cpus = 1
        vb.memory = 4096
        vb.gui = false
        vb.name = "elastic5x-ubuntu14"
        override.vm.synced_folder "./provision", "/vagrant"
    
        # disable the vbguest update plugin
        if Vagrant.has_plugin?("vagrant-vbguest")
            override.vbguest.auto_update = false
        end
    end
end
