#!/bin/bash
cat > /etc/hosts << EOF
127.0.0.1     localhost
192.168.90.11 node1.etu.im  node1
192.168.90.12 node2.etu.im  node2
EOF

apt-get -y install puppet puppetmaster ntp dnsmasq

## start related services
service puppetmaster 	start
service puppet		start

## send reqest and get certification
puppet agent -t --server=node1.etu.im

## Install puppet-cloudera module
puppet module install razorsedge/cloudera

sed -i 's#::fqdn#::hostname#' /etc/puppet/modules/cloudera/templates/scm-config.ini.erb

puppetca list --all
puppet apply --verbose --debug /vagrant/manifests/site.pp

## Testing deployment result
service cloudera-scm-agent status
service cloudera-scm-server status
service cloudera-scm-server-db status

echo "
<NEXT> if all the services are running, 
please visit http://192.168.90.11:7180
for Cloudera Manager Web UI. Here are 
default username and password:

    Username: admin
    Password: admin

"
