#!/bin/bash

# Print help with optional message
print_help()
{
    if [ "$@" ]; then
        echo "$@"
    fi

cat <<EOF
    Usage: $0 [OPTION]...
    Make a post to 4chan with optional arguments

    Feature switches:
    --cookie, -p	Cookies to pass in	(required)
    --thread, -t        Thread to post in       (required)
    --board, -b		Board to post to	(default b)

    --comment, -c       Comment to post 	(optional)
    --email, -e		Email to post		(optional)
    --file, -f		File to post		(optional)

EOF

    exit 1
}

# Test if getopt will actually work
getopt --test > /dev/null
if [[ $? != 4 ]]; then
    print_help "getopt too old!"
fi

# Short and long versions of our arguments
short_args=p:t:b:c:e:f:
long_args=cookie:,thread:,board:,comment:,email:,file:

# Have getopt parse our command line
ARGS=$(getopt -o $short_args --long $long_args -n "$0" -- "$@")

# If it fails, print help
if [[ $? != 0 ]]; then
    print_help
fi

# Pretty much required arguments
COOKIE="UNKNOWN"
THREAD="UNKNOWN"
BOARD="b"

# Optional arguments
COMMENT=""
EMAIL=""
FILE=""

# Evaluate what GETOPT gives to us, so we can use the current shells command line
eval set -- "$ARGS"

# Loop through all pre-parsed arguments
while true
do
    case "$1" in
        -p|--cookie)    COOKIE=$2;  shift 2;;

        -t|--thread)    THREAD=$2;  shift 2;;
        -b|--board)     BOARD=$2;   shift 2;;

        -c|--comment)   COMMENT=$2; shift 2;;
        -e|--email)     EMAIL=$2;   shift 2;;
        -f|--file)      FILE=$2;    shift 2;;

        --)             shift; break;;
        -h|--help)      print_help;;
        *)              print_help "Internal error!";;
    esac
done

# Make sure we have a thread
if [[ "$THREAD" == "UNKNOWN" ]] ; then
    print_help
fi

# We need a cookie for 4chan pass or captcha
if [[ "$COOKIE" == "UNKNOWN" ]] ; then
    print_help
fi

# Make the post
OUTPUT=$(curl "https://sys.4chan.org/$BOARD/post" \
    -H "Cookie: $COOKIE" \
    --form "mode=regist" \
    --form "resto=$THREAD" \
    --form "email=$EMAIL" \
    --form "com=$COMMENT" \
    --form "upfile=@$FILE" --silent | grep "Post successful!")

# If we don't have any output, the post wasn't successful
if [ -z "$OUTPUT" ]; then
    exit 1
fi
