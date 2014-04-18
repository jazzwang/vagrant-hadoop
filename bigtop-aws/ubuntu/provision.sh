#!/bin/bash
echo "[32;1mUSER=$(whoami)[0m"
## in ubuntu , hostname mapping to 127.0.1.1
## It cause problem for HBase .... can not connet to 127.0.1.1:60020
echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
## generate locale for Traditional Chinese
locale-gen "zh_TW.UTF-8"
## check for command 'add-apt-repository'
if [ ! -x /usr/bin/add-apt-repository ]; then
    ## TODO : following step is just to localization
    sed -i 's#us.archive.ubuntu.com#free.nchc.org.tw#g' /etc/apt/sources.list
    sed -i 's#security.ubuntu.com#free.nchc.org.tw#g' /etc/apt/sources.list
    ## update the repository and install package for 'add-apt-repository'
    apt-get -y update
    apt-get -f -y install python-software-properties
fi
## setup bigtop related apt repository
wget -q http://archive.apache.org/dist/bigtop/bigtop-0.7.0/repos/GPG-KEY-bigtop -O- | sudo apt-key add -
add-apt-repository -y "deb http://bigtop.s3.amazonaws.com/releases/0.7.0/ubuntu/precise/x86_64 bigtop contrib"
apt-get -y update
## install bigtop related packages
apt-get install -y --force-yes vim locales openjdk-7-jdk bigtop-utils hadoop-conf-pseudo w3m hive pig hbase hive-hbase hbase-master hbase-regionserver hbase-rest hbase-thrift zookeeper unzip
## format NameNode
/etc/init.d/hadoop-hdfs-namenode init
## enable HBase with ZooKeeper
cp /etc/hbase/conf/hbase-site.xml /etc/hbase/conf/hbase-site.xml.dpkg
cat > /etc/hbase/conf/hbase-site.xml << EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
      <name>hbase.rootdir</name>
      <value>hdfs://localhost:8020/hbase</value>
  </property>
  <property>
      <name>hbase.tmp.dir</name>
      <value>/var/hbase</value>
  </property>
  <property>
      <name>hbase.cluster.distributed</name>
      <value>true</value>
  </property>
</configuration>
EOF
## start HDFS
for i in hadoop-hdfs-namenode hadoop-hdfs-datanode ; do sudo service $i start ; done
## initialize HDFS
sudo /usr/lib/hadoop/libexec/init-hdfs.sh
## start ZooKeeper
mkdir -p /var/run/zookeeper && sudo chown zookeeper:zookeeper /var/run/zookeeper
su -s /bin/bash zookeeper -c "zookeeper-server-initialize"
su -s /bin/bash zookeeper -c "zookeeper-server start"
## start YARN and HBase
for i in hadoop-yarn-resourcemanager hadoop-yarn-nodemanager hadoop-mapreduce-historyserver hbase-master hbase-regionserver ; do sudo service $i start ; done
## Fix YARN staging folder permission issues
# ERROR security.UserGroupInformation: PriviledgedActionException as:root (auth:SIMPLE) 
#  cause:org.apache.hadoop.security.AccessControlException: Permission denied: 
#  user=root, access=EXECUTE, inode="/tmp/hadoop-yarn/staging":mapred:mapred:drwxrwx---
su - hdfs -s /bin/bash -c "hadoop fs -chmod 777 /tmp/hadoop-yarn/staging"
## run mapreduce for function test
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar pi 2 2
## run HDFS test case
dd if=/dev/zero of=100mb.img bs=1M count=100
hadoop fs -put 100mb.img test.img
## run hbase test case
cat > /tmp/hbase_test << EOF
create 't1','f1'
put 't1','r1','f1','v1'
put 't1','r1','f1','v2'
put 't1','r1','f1:c1','v2'
put 't1','r1','f1:c2','v3'
scan 't1'
quit
EOF
hbase shell /tmp/hbase_test
## run pig test case
wget http://www.hadoop.tw/excite-small.log -O /tmp/excite-small.log
hadoop fs -put /tmp/excite-small.log /tmp/excite-small.log
cat > /tmp/pig_test.pig << EOF
log = LOAD '/tmp/excite-small.log' AS (user, timestamp, query);
grpd = GROUP log BY user;  
cntd = FOREACH grpd GENERATE group, COUNT(log) AS cnt;
fltrd = FILTER cntd BY cnt > 50;      
srtd = ORDER fltrd BY cnt;
STORE srtd INTO '/tmp/pig_output';
EOF
## run hive test case
wget http://seanlahman.com/files/database/lahman2012-csv.zip -O /tmp/lahman2012-csv.zip
( cd /tmp; unzip /tmp/lahman2012-csv.zip
cat > /tmp/hive_test.hql << EOF
create database baseball;
create table baseball.master 
( lahmanID INT, playerID STRING, managerID INT, hofID STRING,  
  birthYear INT, birthMonth INT, birthDay INT, birthCountry STRING,  
  birthState STRING, birthCity STRING, deathYear INT, deathMonth INT, 
  deathDay INT, deathCountry STRING, deathState STRING, deathCity STRING, 
  nameFirst STRING, nameLast STRING, nameNote STRING, nameGiven STRING, 
  nameNick STRING, weight INT, height INT, bats STRING, throws STRING, 
  debut STRING, finalGame STRING, college STRING, lahman40ID STRING, 
  lahman45ID STRING, retroID STRING, holtzID STRING, bbrefID STRING ) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' ;
LOAD DATA LOCAL INPATH "/tmp/Master.csv" OVERWRITE INTO TABLE baseball.master;
select * from baseball.master LIMIT 10;
quit;
EOF
hive -f /tmp/hive_test.hql
