#!/bin/bash
sudo locale-gen "zh_TW.UTF-8"
wget -q http://archive.apache.org/dist/bigtop/bigtop-0.7.0/repos/GPG-KEY-bigtop -O- | sudo apt-key add -
sudo add-apt-repository -y 'deb http://free.nchc.org.tw/debian squeeze non-free'
sudo add-apt-repository -y "deb http://bigtop.s3.amazonaws.com/releases/0.7.0/ubuntu/precise/x86_64 bigtop contrib"
sudo apt-get -y update
cat << EOF | sudo /usr/bin/debconf-set-selections
sun-java6-bin shared/accepted-sun-dlj-v1-1 select true
sun-java6-jdk shared/accepted-sun-dlj-v1-1 select true
sun-java6-jre shared/accepted-sun-dlj-v1-1 select true
ganglia-webfrontend ganglia-webfrontend/restart	boolean	true
EOF
sudo apt-get -y --force-yes install vim locales sun-java6-jdk bigtop-utils hadoop-conf-pseudo w3m hive pig hbase hive-hbase hbase-master hbase-regionserver hbase-rest hbase-thrift zookeeper ganglia-webfrontend gmetad ganglia-monitor
sudo /etc/init.d/hadoop-hdfs-namenode init
for i in hadoop-hdfs-namenode hadoop-hdfs-datanode ; do sudo service $i start ; done
sudo /usr/lib/hadoop/libexec/init-hdfs.sh
for i in hadoop-yarn-resourcemanager hadoop-yarn-nodemanager hbase-master hbase-regionserver ; do sudo service $i start ; done
sudo su -s /bin/bash hdfs -c 'hadoop fs -mkdir /user/ubuntu && hadoop fs -chown ubuntu:ubuntu /user/ubuntu'
sudo ln -s /etc/ganglia-webfrontend/apache.conf /etc/apache2/sites-enabled/ganglia
sudo apache2ctl restart
sudo su - ubuntu -c "hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar pi 2 2"
