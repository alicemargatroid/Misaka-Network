#!/usr/bin/env bash

if [ -z "$1" ] ; then
    echo "get4chanPassToken.sh <id> <pin>"
    echo "- Missing id"
    exit 1
fi
ID=$1

if [ -z "$2" ] ; then
    echo "get4chanPassToken.sh <id> <pin>"
    echo "- Missing pin"
    exit 1
fi
PIN=$2

TOKEN=$(curl 'https://sys.4chan.org/auth' \
    -H 'Origin: https://sys.4chan.org' \
    -H 'Cache-Control: max-age=0' \
    -H 'Referer: https://sys.4chan.org/auth' \
    --form "act=do_login" \
    --form "id=$ID" \
    --form "pin=$PIN" \
    --silent --output /dev/null --cookie-jar - | grep pass_id | cut -d$'\t' -f7)

echo "pass_id=$TOKEN; pass_enabled=1;"

