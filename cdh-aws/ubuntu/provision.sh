#!/bin/bash
echo "[32;1mUSER=$(whoami)[0m"
## generate locale for Traditional Chinese
locale-gen "zh_TW.UTF-8"
## setup bigtop related apt repository
wget -q http://archive.cloudera.com/cm5/ubuntu/trusty/amd64/cm/archive.key -O- | sudo apt-key add -
wget -q http://archive.cloudera.com/cm5/ubuntu/trusty/amd64/cm/cloudera.list -O /etc/apt/sources.list.d/cm5.list
apt-get -y update
