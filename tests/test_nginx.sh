#!/bin/bash
SCRIPT_PATH=`dirname $0`
ABSOLUTE_PATH=`readlink -m ${SCRIPT_PATH}`
ROOT_PATH=`readlink -m ${ABSOLUTE_PATH}/..`

TEST_NGINX__RUN_AS_DAEMON="$1"
TEST_DOCKER_RUN_PARAM=''

[ -n "$TEST_NGINX__RUN_AS_DAEMON" ] &&
    [ 0 -ne "$TEST_NGINX__RUN_AS_DAEMON" ] &&
    TEST_DOCKER_RUN_PARAM=' -d '

$ROOT_PATH/bin/generator/nginx.sh > $ABSOLUTE_PATH/nginx.conf \
    && sudo docker run \
    $TEST_DOCKER_RUN_PARAM \
    -v $ABSOLUTE_PATH/nginx.conf:/etc/nginx/conf.d/default.conf \
    -p 80:80 \
    nginx:1.15-alpine
