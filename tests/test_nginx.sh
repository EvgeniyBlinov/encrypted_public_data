#!/bin/bash
SCRIPT_PATH=`dirname $0`
ABSOLUTE_PATH=`readlink -m ${SCRIPT_PATH}`
ROOT_PATH=`readlink -m ${ABSOLUTE_PATH}/..`


$ROOT_PATH/bin/generate_nginx.sh > $ABSOLUTE_PATH/nginx.conf &&
sudo docker run \
    -v $ABSOLUTE_PATH/nginx.conf:/etc/nginx/conf.d/default.conf \
    -p 80:80 \
    nginx:1.15-alpine
