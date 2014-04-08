#!/bin/bash
rpm -ivH http://mirror01.idc.hinet.net/EPEL/6/i386/epel-release-6-8.noarch.rpm
yum -y install puppet puppet-server
mkdir -p /etc/puppet/config
cat > site.csv << EOF
hadoop_head_node,$(hostname)
hadoop_storage_dirs,/dn
bigtop_yumrepo_uri,http://bigtop.s3.amazonaws.com/releases/0.7.0/redhat/6/x86_64
jdk_package_name,java-1.7.0-openjdk-devel.x86_64
components,hadoop,hbase,zookeeper
EOF
mv site.csv /etc/puppet/config/.
mkdir -p /dn
puppet apply -d --modulepath=bigtop-deploy/puppet/modules bigtop-deploy/puppet/manifests/site.pp
