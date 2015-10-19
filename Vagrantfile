# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "jazzwang/cm5-base"
  
  # manage /etc/hosts by hostmanager plugin
  # (https://github.com/smdahlen/vagrant-hostmanager)
  config.hostmanager.enabled = true

  config.vm.define :master1 do |master1|
    master1.vm.provider :virtualbox do |vb|
      vb.name = "master1"
      vb.memory = "4096"
    end
    master1.vm.network :private_network, ip: "192.168.90.10"
    master1.vm.hostname = "master1"
    master1.vm.provision "shell", inline: <<-SHELL
        ntpdate pool.ntp.org
        sed -i "s#master1 localhost#localhost#g"        /etc/hosts
        sed -i "s#server_host=.*#server_host=master1#g" /etc/cloudera-scm-agent/config.ini
        /etc/init.d/cloudera-scm-agent       clean_restart_confirmed
        /etc/init.d/cloudera-scm-server-db   restart
        /etc/init.d/cloudera-scm-server      restart
        chkconfig cloudera-scm-agent         on
        chkconfig cloudera-scm-server-db     on
        chkconfig cloudera-scm-server        on
    SHELL
  end
  config.vm.define :master2 do |master2|
    master2.vm.provider :virtualbox do |vb|
      vb.name = "master2"
      vb.memory = "4096"
    end
    master2.vm.network :private_network, ip: "192.168.90.11"
    master2.vm.hostname = "master2"
    master2.vm.provision "shell", inline: <<-SHELL
        ntpdate pool.ntp.org
        sed -i "s#master2 localhost#localhost#g"        /etc/hosts
        sed -i "s#server_host=.*#server_host=master1#g" /etc/cloudera-scm-agent/config.ini
        /etc/init.d/cloudera-scm-agent       clean_restart_confirmed
        chkconfig cloudera-scm-agent         on
    SHELL
  end
  config.vm.define :worker1 do |worker1|
    worker1.vm.provider :virtualbox do |vb|
      vb.name = "worker1"
      vb.memory = "4096"
    end
    worker1.vm.network :private_network, ip: "192.168.90.12"
    worker1.vm.hostname = "worker1"
    worker1.vm.provision "shell", inline: <<-SHELL
        ntpdate pool.ntp.org
        sed -i "s#worker1 localhost#localhost#g"        /etc/hosts
        sed -i "s#server_host=.*#server_host=master1#g" /etc/cloudera-scm-agent/config.ini
        /etc/init.d/cloudera-scm-agent       clean_restart_confirmed
        chkconfig cloudera-scm-agent         on
    SHELL
  end

end
