#!/bin/bash
#SCRIPT_PATH=`dirname $0`
#ABSOLUTE_PATH=`readlink -m ${SCRIPT_PATH}`
#ROOT_PATH=`readlink -m ${ABSOLUTE_PATH}/..`

function hash_str {
    local str="$1"
    local key="$(cat $2|tr -d '\n')"

    echo -n "$str" |
        openssl enc \
            -e \
            -aes-256-cbc \
            -a \
            -nosalt \
            -k "$key"
}

function unhash_str {
    local str="$1"
    local key="$(cat $2|tr -d '\n')"

    echo "$str" |
        openssl enc \
            -d \
            -aes-256-cbc \
            -a \
            -nosalt \
            -k "$key"
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
    echo hash_str "$DATA_NAME/$KEY_VENDOR" "$KEY_PATH/$KEY_VENDOR/$KEY_NAME"
    DATA_HASH="$(hash_str "$DATA_NAME/$KEY_VENDOR" "$KEY_PATH/$KEY_VENDOR/$KEY_NAME" | tr -d '\n')"
}

function create_crypted_meta {
    (
    print_meta_param 'DATA_HASH' $(hash_str "$DATA_NAME/$KEY_VENDOR" "$KEY_PATH/$KEY_VENDOR/$KEY_NAME" | tr -d '\n')
    print_meta_param 'DATA_CONTENT' $(hash_str "$(cat ${DATA_FULLPATH}/${DATA_FILE})" "$KEY_PATH/$KEY_VENDOR/$KEY_NAME" | tr -d '\n')
    )> "$DATA_CRYPTED/$KEY_VENDOR/$KEY_NAME.txt"
}
