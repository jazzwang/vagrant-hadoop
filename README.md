vagrant-hadoop
==============

some vagrant examples for different hadoop cluster deployment model

Requirement
===========

 * OS: tested with Ubuntu 12.04 LTS 64 bit
 * VirtualBox : tested with 4.3.10
 * Vagrant : tested with 1.4.3
 * [vagrant-aws plugin](https://github.com/mitchellh/vagrant-aws)

These scripts are tested on Ubuntu 12.04 LTS 64 bit GNU/Linux.
Why 64 bit? Because [Apache BigTop](http://bigtop.apache.org) only provides 64 bit deb/rpm packages.
Besides, to run 64 bit VirtualBox images, you also need a 64 bit host OS.
```
jazz@EA-dev:~$ uname -a
Linux EA-dev 3.8.0-29-generic #42~precise1-Ubuntu SMP Wed Aug 14 16:19:23 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
jazz@EA-dev:~$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:  Ubuntu 12.04.4 LTS
Release:  12.04
Codename: precise
```
Some scripts are tested on local virtualbox VMs, you need to install virtualbox before running these scripts.
Due to PXE boot issue of some NICs, we suggest to run official virtualbox instead of ubuntu package (4.1.12_Ubuntur77245).
Please install official [virtualbox rpm/deb/exe](https://www.virtualbox.org/wiki/Downloads) for your environment.
```
### Install VirtualBox on Ubuntu 12.04
jazz@EA-dev:~$ echo "deb http://download.virtualbox.org/virtualbox/debian precise contrib" > virtualbox.list
jazz@EA-dev:~$ sudo mv virtualbox.list /etc/apt/sources.list.d/
jazz@EA-dev:~$ wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
### How to check your virtualbox version
jazz@EA-dev:~$ vboxmanage --version
4.3.10r93012
```
These scripts are based on [Vagrant 2 syntex](http://docs.vagrantup.com/v2/vagrantfile/version.html), so you can not use the default ubuntu package (1.0.1). Please install [official vagrant rpm/deb/exe](http://www.vagrantup.com/downloads.html) for your environment.
```
jazz@jazzbook:~$ vagrant --version
Vagrant 1.4.3
```
