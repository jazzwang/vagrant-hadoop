#!/bin/bash
echo "[32;1mUSER=$(whoami)[0m"
## generate locale for Traditional Chinese
locale-gen "zh_TW.UTF-8"
## setup bigtop related apt repository
wget -q http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/archive.key -O- | sudo apt-key add -
wget -q http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/cloudera.list -O /etc/apt/sources.list.d/cdh5.list
apt-get -y update
## install bigtop related packages
apt-get install -y --force-yes vim locales hadoop-conf-pseudo
