#!/bin/bash
SCRIPT_PATH=`dirname $0`
ABSOLUTE_PATH=`readlink -m ${SCRIPT_PATH}`
ROOT_PATH=`readlink -m ${ABSOLUTE_PATH}/../..`

KEY_PATH="${ROOT_PATH}/keys"

DATA_PATH="${ROOT_PATH}/data"
DATA_METAFILE='meta.txt'
DATA_FILE='data.txt'

function print_url_param {
    echo -n "${1}: \"${2}\"${3} "
}

echo "urls:"
for DATA_NAME in `ls -1 $DATA_PATH`; do
    DATA_FULLPATH="$DATA_PATH/$DATA_NAME"
    source "${DATA_FULLPATH}/${DATA_METAFILE}"
    if [ 1 -eq "$DATA_ACTIVE" ]; then
        DATA_CRYPTED="${DATA_FULLPATH}/.crypted"
        for KEY_VENDOR in `ls -1 $DATA_CRYPTED`; do
            for KEY_NAME in `ls -1 $DATA_CRYPTED/$KEY_VENDOR`; do
                source "$DATA_CRYPTED/$KEY_VENDOR/$KEY_NAME"
                KEY_NAME=${KEY_NAME%%.txt}
                echo -n "  - { "
                #print_url_param 'data' "$DATA_NAME" ','
                #print_url_param 'key' "${KEY_VENDOR}/${KEY_NAME}" ','
                print_url_param 'url' "$DATA_HASH" ','
                print_url_param 'content' "$DATA_CONTENT"
                echo "}"
            done
        done
    fi
done
