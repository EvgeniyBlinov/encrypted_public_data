#!/bin/bash
SCRIPT_PATH=`dirname $0`
ABSOLUTE_PATH=`readlink -m ${SCRIPT_PATH}`
ROOT_PATH=`readlink -m ${ABSOLUTE_PATH}/..`

KEY_PATH="${ROOT_PATH}/keys"

DATA_PATH="${ROOT_PATH}/data"
DATA_METAFILE='meta.txt'
DATA_FILE='data.txt'

NGINX_URL_PREFIX='data'
NGINX_SERVER_NAME="$1"

if [ -n "$NGINX_SERVER_NAME" ]; then
    NGINX_SERVER_NAME="server_name ${NGINX_SERVER_NAME};"
fi

function print_url_param {
    echo -n "${1}: \"${2}\"${3} "
}

cat <<EOF
server {
    listen 80;
    $NGINX_SERVER_NAME

    location /robots.txt {return 200 "User-agent: *\nDisallow: /${NGINX_URL_PREFIX}/\n";}

EOF

for DATA_NAME in `ls -1 $DATA_PATH`; do
    DATA_FULLPATH="$DATA_PATH/$DATA_NAME"
    source "${DATA_FULLPATH}/${DATA_METAFILE}"
    if [ 1 -eq "$DATA_ACTIVE" ]; then
        DATA_CRYPTED="${DATA_FULLPATH}/.crypted"
        for KEY_VENDOR in `ls -1 $DATA_CRYPTED`; do
            for KEY_NAME in `ls -1 $DATA_CRYPTED/$KEY_VENDOR`; do
                source "$DATA_CRYPTED/$KEY_VENDOR/$KEY_NAME"
                KEY_NAME=${KEY_NAME%%.txt}

cat <<EOF
    location /${NGINX_URL_PREFIX}/${DATA_HASH} {
        add_header Content-Type text/plain;
        return 200 '${DATA_CONTENT}';
    }

EOF

            done
        done
    fi
done

echo '}'
