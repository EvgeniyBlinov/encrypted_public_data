#!/bin/bash
SCRIPT_PATH=`dirname $0`
ABSOLUTE_PATH=`readlink -m ${SCRIPT_PATH}`
ROOT_PATH=`readlink -m ${ABSOLUTE_PATH}/..`

KEY_PATH="${ROOT_PATH}/keys"

KEY_VENDOR="$1"
KEY_NAME="$2"
KEY_FULLPATH="${KEY_PATH}/$KEY_VENDOR/$KEY_NAME"

[ -z "$KEY_VENDOR" ] &&
    echo "KEY_VENDOR not found!" && exit 1

[ -z "$KEY_NAME" ] &&
    echo "KEY_NAME not found!" && exit 2

mkdir -p "${KEY_PATH}/$KEY_VENDOR"

if [ -f "$KEY_FULLPATH" ] || [ -f "${KEY_FULLPATH}.pub" ]; then
    echo "Key $KEY_FULLPATH already exists!"
    exit 0
else
    echo "Generating key ${KEY_PATH}/$KEY_VENDOR/$KEY_NAME ..."
    ssh-keygen \
        -t rsa \
        -b 4096 \
        -f "${KEY_PATH}/$KEY_VENDOR/$KEY_NAME"
fi
