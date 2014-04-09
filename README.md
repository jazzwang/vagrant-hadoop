vagrant-hadoop
==============

some vagrant examples for different hadoop cluster deployment model

Requirement
===========

 * OS: tested with Ubuntu 12.04 LTS
 * VirtualBox : tested with 4.3.10
 * Vagrant : tested with 1.4.3
 * [vagrant-aws plugin]()

These scripts are tested on Ubuntu 12.04 LTS
```
jazz@EA-dev:~$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:  Ubuntu 12.04.4 LTS
Release:  12.04
Codename: precise
```
Some scripts are tested on local virtualbox VMs, you need to install virtualbox before running these scripts.
Due to PXE boot issue of different version NIC support
```
jazz@EA-dev:~$ vboxmanage --version
4.3.10r93012
```
These scripts are based on Vagrant 2 syntex, so you can not use the default ubuntu package (1.0.1)
```
jazz@jazzbook:~$ vagrant --version
Vagrant 1.4.3
```
