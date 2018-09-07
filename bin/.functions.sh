#!/bin/bash
#SCRIPT_PATH=`dirname $0`
#ABSOLUTE_PATH=`readlink -m ${SCRIPT_PATH}`
#ROOT_PATH=`readlink -m ${ABSOLUTE_PATH}/..`

#KEY_PATH="${ROOT_PATH}/keys"

#DATA_PATH="${ROOT_PATH}/data"
#DATA_METAFILE='meta.txt'
#DATA_FILE='data.txt'

#DATA_ACTION="$1"
#DATA_NAME="$2"
#KEY_NAME="$3"

#DATA_FULLPATH="$DATA_PATH/$DATA_NAME"
#DATA_CRYPTED="${DATA_FULLPATH}/.crypted"

#case "$DATA_ACTION" in
    #e|encrypt)
        #DATA_ACTION_PARAM='e'
        #;;
    #d|decrypt)
        #DATA_ACTION_PARAM='d'
        #;;
#esac

#if [ ! -d "$DATA_FULLPATH" ]; then
    #echo "Data path: $DATA_FULLPATH not found!"
    #exit 1
#fi

#source "${DATA_FULLPATH}/${DATA_METAFILE}"

#if [ ! -f "${DATA_FULLPATH}/${DATA_FILE}" ]; then
    #echo "Data file: ${DATA_FULLPATH}/${DATA_FILE} not found!"
    #exit 1
#fi

function hash_str {
    local str="$1"
    local key="$(cat $2|tr -d '\n')"

    echo -n "$1" |
        openssl enc \
            -e \
            -aes-256-cbc \
            -a \
            -nosalt \
            -k "$2"
}

function unhash_str {
    local str="$1"
    local key="$(cat $2|tr -d '\n')"

    echo "$1" |
        openssl enc \
            -d \
            -aes-256-cbc \
            -a \
            -nosalt \
            -k "$2"
}

function decrypt_meta {
    local meta="$1"
    local key="$2"

    cat "$meta"
    echo '------------------------------------------------------------------------'
    source "$meta"
    print_meta_param 'DATA_HASH' "$(unhash_str "$DATA_HASH" "$key")"
    print_meta_param 'DATA_CONTENT' "$(unhash_str "$DATA_CONTENT" "$key")"
}

function print_meta_param {
    echo "${1}='$2'"
}

function generate_data_hash {
    DATA_HASH="$(hash_str "$DATA_NAME/$KEY_VENDOR" "$KEY_PATH/$KEY_VENDOR/$KEY_NAME" | tr -d '\n')"
}

function create_crypted_meta {
    (
    print_meta_param 'DATA_HASH' $(hash_str "$DATA_NAME/$KEY_VENDOR" "$KEY_PATH/$KEY_VENDOR/$KEY_NAME" | tr -d '\n')
    print_meta_param 'DATA_CONTENT' $(hash_str "$(cat ${DATA_FULLPATH}/${DATA_FILE})" "$KEY_PATH/$KEY_VENDOR/$KEY_NAME" | tr -d '\n')
    )> "$DATA_CRYPTED/$KEY_VENDOR/$KEY_NAME.txt"
}
