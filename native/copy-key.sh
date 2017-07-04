#!/usr/bin/env bash

curr_path=`pwd`
cd `dirname $0`


CURRENT_USER=`pwd`

cd

HOME_DIR=`pwd`

scp ~/.ssh/id_rsa.pub   ${CURRENT_USER}@$1:/${HOME_DIR}/.ssh/authorized_keys

cd $curr_path