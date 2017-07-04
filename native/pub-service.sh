#!/usr/bin/env bash

curr_path=`pwd`
cd `dirname $0`

SERVICE_NAME=$1
VERSION=$2



CURRENT_USER=`whoami`
cd
HOME_DIR=`pwd`
cd $curr_path


EUREKA1=`cat hosts/eureka1`
EUREKA2=`cat hosts/eureka2`
EUREKA3=`cat hosts/eureka3`


pssh -h hosts/$SERVICE_NAME -l ${CURRENT_USER} -i "mkdir -p ${HOME_DIR}/services/lib"
pscp -h hosts/$SERVICE_NAME  -l  ${CURRENT_USER}  ./lib-repo/${SERVICE_NAME}-${VERSION}.jar /home/admin/services/lib/


pssh -h hosts/$SERVICE_NAME -l ${CURRENT_USER} -i " curl --connect-timeout 2 -fsSL -X POST http://127.0.0.1:8080/shutdown ; \
                                sleep 5 && cd ${HOME_DIR}/services && \
                               java -Djava.security.egd=file:/dev/./urandom -jar lib/${SERVICE_NAME}-${VERSION}.jar \
                               --spring.cloud.config.discovery.enabled=true  \
                               --spring.cloud.config.profile=test  \
                               --spring.cloud.config.label=master  \
                               --eureka.client.serviceUrl.defaultZone=http://${EUREKA1}:8080/eureka,http://${EUREKA2}:8080/eureka,http://${EUREKA3}:8080/eureka "


cd $curr_path