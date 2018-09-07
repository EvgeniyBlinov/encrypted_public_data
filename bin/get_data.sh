#!/bin/bash
SCRIPT_PATH=`dirname $0`
ABSOLUTE_PATH=`readlink -m ${SCRIPT_PATH}`
ROOT_PATH=`readlink -m ${ABSOLUTE_PATH}/..`

KEY_PATH="${ROOT_PATH}/keys"

DATA_PATH="${ROOT_PATH}/data"
DECRYPTED_DATA_PATH="${ROOT_PATH}/.decrypted_data"
DATA_METAFILE='meta.txt'
DATA_FILE='data.txt'

NGINX_URL_PREFIX='data'

DATA_NAME="$1"
[ -z "$DATA_NAME" ] &&
    echo "DATA_NAME is empty!" && exit 1

source $ROOT_PATH/.env
source $ABSOLUTE_PATH/.functions.sh

mkdir -p "$DECRYPTED_DATA_PATH"

for KEY_VENDOR in `ls -1 $KEY_PATH`; do
    for KEY_NAME in `ls -1 $KEY_PATH/$KEY_VENDOR | grep -v '.pub'`; do
        mkdir -p "$DECRYPTED_DATA_PATH/$KEY_VENDOR/$DATA_NAME"
        generate_data_hash
        echo curl "${EPD_PROTO}://${EPD_HOST}:${EPD_PORT}/${NGINX_URL_PREFIX}/${DATA_HASH}"
        DATA_CONTENT="$(curl -s ${EPD_PROTO}://${EPD_HOST}:${EPD_PORT}/${NGINX_URL_PREFIX}/${DATA_HASH} 2>/dev/null)"
        DECRYPTED_DATA_FILE="$DECRYPTED_DATA_PATH/$KEY_VENDOR/$DATA_NAME/data.txt"

        DATA_UNHASHED="$(unhash_str "$DATA_CONTENT" "$KEY_PATH/$KEY_VENDOR/$KEY_NAME" 2>/dev/null)"

        [ -n "$DATA_UNHASHED" ] &&
            [ ! -f "$DECRYPTED_DATA_FILE" ] &&
                echo "$DATA_UNHASHED" > "$DECRYPTED_DATA_FILE"
    done
done
