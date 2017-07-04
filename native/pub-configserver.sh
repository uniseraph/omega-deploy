#!/usr/bin/env bash

curr_path=`pwd`
cd `dirname $0`



CURRENT_USER=`whoami`
cd
HOME_DIR=`pwd`
cd $curr_path


#CONF1=`cat hosts/configserver1`
#CONF2=`cat hosts/configserver2`


EUREKA1=`cat hosts/eureka1`
EUREKA2=`cat hosts/eureka2`
EUREKA3=`cat hosts/eureka3`

RABBITMQ=`cat hosts/rabbitmq`


rm -rf omega-framework-configserver-0.1.jar
rm -rf config-repo

ln -s ~/config-repo config-repo
cp ~/omega-framework-assembly-0.1/lib/omega-framework-configserver-0.1.jar .

jar uvf omega-framework-configserver-0.1.jar config-repo

pssh -h hosts/configserver -l ${CURRENT_USER} -i "mkdir -p ${HOME_DIR}/omega-framework/lib"


pscp -h hosts/configserver  -l  ${CURRENT_USER}  omega-framework-configserver-0.1.jar \
                                ${HOME_DIR}/omega-framework/lib/

pssh -h hosts/configserver -l ${CURRENT_USER} -i " curl --connect-timeout 2 -fsSL -X POST http://127.0.0.1:8080/shutdown ;\
                               sleep 5 &&  \
                               cd ${HOME_DIR}/omega-framework && \
                               java -Djava.security.egd=file:/dev/./urandom -jar lib/omega-framework-configserver-0.1.jar \
                               --logging.path=${HOME_DIR}/logs \
                               --server.port=8080  \
                               --spring.rabbitmq.host=${RABBITMQ} \
                               --eureka.client.serviceUrl.defaultZone=http://${EUREKA1}:8080/eureka,http://${EUREKA2}:8080/eureka,http://${EUREKA3}:8080/eureka "

pssh -h hosts/configserver1 -l ${CURRENT_USER} -i ' curl -fsSL -X POST http://127.0.0.1:8080/bus/refresh '


cd $curr_path