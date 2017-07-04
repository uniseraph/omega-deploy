#!/usr/bin/env bash

curr_path=`pwd`
cd `dirname $0`


CURRENT_USER=`whoami`


cd

HOME_DIR=`pwd`

cd hosts

awk '{print $1}' all > hosts
awk '{print $1 > $2}' all

rm -f eureka
rm -f configserver
rm -f zookeeper
rm -f mycat
cat eureka* > eureka
cat configserver* > configserver
cat zookeeper* > zookeeper
cat mycat* > mycat

cd ..


ssh-keygen -t rsa

cat hosts/hosts | xargs -n 1 bash copy-key.sh

#pscp -h hosts/hosts -l ${CURRENT_USER} ./binary/jdk-8u121-linux-x64.rpm /root/jdk-8u121-linux-x64.rpm
#pscp -h hosts/hosts -l root ./hosts/all /root/all

#pssh -h hosts/hosts -l ${CURRENT_USER} -i 'cat /root/all >> /etc/hosts'
#pssh -h hosts/hosts -l ${CURRENT_USER} -i 'rpm -i /root/jdk-8u121-linux-x64.rpm'
#pssh -h hosts/hosts -l ${CURRENT_USER} 'yum install -y tcpdump curl jq telnet'
#pssh -h hosts/hosts -l ${CURRENT_USER} -i 'useradd admin && su - admin && mkdir -p /home/admin/.ssh'


#pscp -h hosts/hosts -l ${CURRENT_USER} /home/admin/.ssh/id_rsa.pub /home/admin/.ssh/authorized_keys

pssh -h hosts/hosts -l ${CURRENT_USER} -i "mkdir -p ${HOME_DIR}/omega-framework/lib"

cd $curr_path