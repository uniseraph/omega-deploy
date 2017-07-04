#!/usr/bin/env bash

curr_path=`pwd`
cd `dirname $0`


CURRENT_USER=`whoami`

cd
HOME_DIR=`pwd`
cd $curr_path

EUREKA1=`cat hosts/eureka1`
EUREKA2=`cat hosts/eureka2`
EUREKA3=`cat hosts/eureka3`

pssh -h hosts/eureka -l  ${CURRENT_USER}  -i "mkdir -p  ${HOME_DIR}/omega-framework/lib/"

pscp -h hosts/eureka -l ${CURRENT_USER}   ~/omega-framework-assembly-0.1/lib/omega-framework-eureka*.jar  \
                                            ${HOME_DIR}/omega-framework/lib/

curl  -X POST http://${EUREKA1}:8080/shutdown && sleep 1
pssh -h hosts/eureka1 -l ${CURRENT_USER} -i " cd ${HOME_DIR}/omega-framework && \
                               java -Djava.security.egd=file:/dev/./urandom -jar lib/omega-framework-eureka-0.1.jar \
                               --logging.path=${HOME_DIR}/logs \
                               --server.port=8080 --spring.profiles.active=eureka1 \
                               --eureka1.instance.hostname=${EUREKA1} \
                               --eureka2.instance.hostname=${EUREKA2} \
                               --eureka3.instance.hostname=${EUREKA3} "
  SECONDS=0
  while [[ $(curl -fsSL http://${EUREKA1}:8080/health 2>&1 1>/dev/null; echo $?) != 0 ]]; do
    ((SECONDS++))
    if [[ ${SECONDS} == 99 ]]; then
      echo "eureka1 failed to start. Exiting..."
      exit 1
    fi
    sleep 1
  done

curl  -X POST http://${EUREKA2}:8080/shutdown && sleep 1
pssh -h hosts/eureka2 -l ${CURRENT_USER} -i " cd ${HOME_DIR}/omega-framework && \
                               java -Djava.security.egd=file:/dev/./urandom -jar lib/omega-framework-eureka-0.1.jar \
                               --logging.path=${HOME_DIR}/logs \
                               --server.port=8080 --spring.profiles.active=eureka2 \
                               --eureka1.instance.hostname=${EUREKA1} \
                               --eureka2.instance.hostname=${EUREKA2} \
                               --eureka3.instance.hostname=${EUREKA3} "
  SECONDS=0
  while [[ $(curl -fsSL http://${EUREKA2}:8080/health 2>&1 1>/dev/null; echo $?) != 0 ]]; do
    ((SECONDS++))
    if [[ ${SECONDS} == 99 ]]; then
      echo "eureka2 failed to start. Exiting..."
      exit 1
    fi
    sleep 1
  done

curl  -X POST http://${EUREKA3}:8080/shutdown && sleep 1
pssh -h hosts/eureka3 -l ${CURRENT_USER} -i " cd ${HOME_DIR}/omega-framework && \
                               java -Djava.security.egd=file:/dev/./urandom -jar lib/omega-framework-eureka-0.1.jar \
                               --logging.path=${HOME_DIR}/logs \
                               --server.port=8080 --spring.profiles.active=eureka3 \
                               --eureka1.instance.hostname=${EUREKA1} \
                               --eureka2.instance.hostname=${EUREKA2} \
                               --eureka3.instance.hostname=${EUREKA3} "
  SECONDS=0
  while [[ $(curl -fsSL http://${EUREKA3}:8080/health 2>&1 1>/dev/null; echo $?) != 0 ]]; do
    ((SECONDS++))
    if [[ ${SECONDS} == 99 ]]; then
      echo "eureka3 failed to start. Exiting..."
      exit 1
    fi
    sleep 1
  done

cd $curr_path