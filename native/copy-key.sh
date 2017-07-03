#!/usr/bin/env bash

curr_path=`pwd`
cd `dirname $0`


CURRENT_USER=`pwd`

HOME_DIR=`echo ~${CURRENT_USER}`

scp ~/.ssh/id_rsa.pub   ${CURRENT_USER}@$1:/${HOME_DIR}/.ssh/authorized_keys

cd $curr_path