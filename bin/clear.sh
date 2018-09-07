#!/bin/bash
SCRIPT_PATH=`dirname $0`
ABSOLUTE_PATH=`readlink -m ${SCRIPT_PATH}`
ROOT_PATH=`readlink -m ${ABSOLUTE_PATH}/..`

KEY_PATH="${ROOT_PATH}/keys"

DATA_PATH="${ROOT_PATH}/data"
DATA_METAFILE='meta.txt'
DATA_FILE='data.txt'

CLEAR_TARGET="$1"

function clear_crypted {
    for DATA_NAME in `ls -1 $DATA_PATH`; do
        DATA_FULLPATH="$DATA_PATH/$DATA_NAME"
        source "${DATA_FULLPATH}/${DATA_METAFILE}"
        DATA_CRYPTED="${DATA_FULLPATH}/.crypted"
        echo "rm -r $DATA_CRYPTED"
        rm -r $DATA_CRYPTED/* 2>/dev/null
    done
}

case $CLEAR_TARGET in
    crypted)
        clear_crypted
        ;;
    *)
        CLEAR_TARGET='crypted'
        clear_crypted
        ;;
esac


