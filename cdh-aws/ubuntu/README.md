# How to run this example

## install vagrant related plugins and default vagrant box
```
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-aws
vagrant plugin install vagrant-env
vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
```
## edit .env for AWS Keys
```
cp env_sample .env
vi .env
```
## start VMs on AWS
```
vagrant up --provider=aws
```
