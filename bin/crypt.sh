#!/bin/bash
SCRIPT_PATH=`dirname $0`
ABSOLUTE_PATH=`readlink -m ${SCRIPT_PATH}`
ROOT_PATH=`readlink -m ${ABSOLUTE_PATH}/..`

KEY_PATH="${ROOT_PATH}/keys"

DATA_PATH="${ROOT_PATH}/data"
DATA_METAFILE='meta.txt'
DATA_FILE='data.txt'

DATA_ACTION="$1"
DATA_NAME="$2"
KEY_NAME="$3"

DATA_FULLPATH="$DATA_PATH/$DATA_NAME"
DATA_CRYPTED="${DATA_FULLPATH}/.crypted"

case "$DATA_ACTION" in
    e|encrypt)
        DATA_ACTION_PARAM='e'
        ;;
    d|decrypt)
        DATA_ACTION_PARAM='d'
        ;;
esac

if [ ! -d "$DATA_FULLPATH" ]; then
    echo "Data path: $DATA_FULLPATH not found!"
    exit 1
fi

source "${DATA_FULLPATH}/${DATA_METAFILE}"

if [ ! -f "${DATA_FULLPATH}/${DATA_FILE}" ]; then
    echo "Data file: ${DATA_FULLPATH}/${DATA_FILE} not found!"
    exit 1
fi


source $ABSOLUTE_PATH/.functions.sh

mkdir -p "$DATA_CRYPTED"

if [ "$DATA_ACTION_PARAM" == "e" ]; then
    for KEY_VENDOR in `ls -1 $KEY_PATH`; do
        for KEY_NAME in `ls -1 $KEY_PATH/$KEY_VENDOR | grep -v '.pub'`; do
            mkdir -p "$DATA_CRYPTED/$KEY_VENDOR"
            create_crypted_meta
        done
    done
else
    KEY_RELATIVE_PATH="${KEY_NAME##$(dirname $(dirname $KEY_NAME))/}"
    decrypt_meta "${DATA_CRYPTED}/${KEY_RELATIVE_PATH}.txt" "${KEY_PATH}/${KEY_RELATIVE_PATH}"
fi
