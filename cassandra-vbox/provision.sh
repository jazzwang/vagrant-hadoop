#!/bin/bash
# Reference: Cassandra Docker Image 2.1 Dockerfile
# https://github.com/docker-library/cassandra/blob/ef66ec669d3930aea018f74dc58f5bd2ef5df880/2.1/Dockerfile

IIP=$(hostname -I | awk '{ print $2 }')
sed -i.bak "/127.0.0.1.*$(hostname)/d" /etc/hosts
# explicitly set user/group IDs
groupadd -r cassandra --gid=999 && useradd -r -g cassandra --uid=999 cassandra
# grab gosu for easy step-down from root
export GOSU_VERSION="1.7"
set -x
apt-get update
apt-get install -y --no-install-recommends ca-certificates wget
rm -rf /var/lib/apt/lists/*
wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)"
wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" export GNUPGHOME="$(mktemp -d)"
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu
rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc
chmod +x /usr/local/bin/gosu
gosu nobody true
apt-get purge -y --auto-remove ca-certificates wget
apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 514A2AD631A57A16DD0047EC749D6EEC0353B12C
echo 'deb http://www.apache.org/dist/cassandra/debian 21x main' >> /etc/apt/sources.list.d/cassandra.list
export CASSANDRA_VERSION="2.1.15"
apt-get update
apt-get install -y cassandra="$CASSANDRA_VERSION"
rm -rf /var/lib/apt/lists/*
# https://issues.apache.org/jira/browse/CASSANDRA-11661
sed -ri 's/^(JVM_PATCH_VERSION)=.*/\1=25/' /etc/cassandra/cassandra-env.sh
export CASSANDRA_CONFIG="/etc/cassandra"
mkdir -p /var/lib/cassandra "$CASSANDRA_CONFIG"
chown -R cassandra:cassandra /var/lib/cassandra "$CASSANDRA_CONFIG"
chmod 777 /var/lib/cassandra "$CASSANDRA_CONFIG"
# configure cassandra.yaml
cp /etc/cassandra/cassandra.yaml /etc/cassandra/cassandra.yaml.bak
sed -i 's#- seeds: .*#- seeds: "node1"#' /etc/cassandra/cassandra.yaml
sed -i "s#^rpc_address: .*#rpc_address: ${IIP}#" /etc/cassandra/cassandra.yaml
sed -i "s#^listen_address: .*#listen_address: $(hostname)#" /etc/cassandra/cassandra.yaml
