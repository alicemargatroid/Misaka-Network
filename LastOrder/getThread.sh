#!/usr/bin/env bash

# Come on, give us at least one argument
if [ $# -eq 0 ]; then
    echo "No arguments supplied; please supply at least one thread"
    exit 1
fi

start=0
cache=""

while IFS=: read field_name field_contents
do
    # Strip leading white space
    field_name="${field_name#"${field_name%%[![:space:]]*}"}"
    field_contents="${field_contents#"${field_contents%%[![:space:]]*}"}"

    # 4chan jams everything into a giant array for some reason; [ signifies the start
    if [[ "$field_contents" == "[" ]]; then
        start=1
        continue
    fi

    # Ignore everything before start
    if [[ $start -eq 0 ]]; then
        continue
    fi

    # ] signifies the end of the giant array; stop when past it
    if [[ "$field_name" == "]" ]]; then
         break
    fi 

    # { means start of the post, reset cache and start bundling!
    if [[ "$field_name" == "{" ]]; then
        cache=""
        continue
    fi

    # } means end of the post, output post!
    if [[ "$field_name" == "}," || "$field_name" == "}" ]]; then
        echo "$cache"
        continue
    fi

    cache="$cache$field_name:$field_contents"

done < <(curl -sL http://a.4cdn.org/b/thread/742807737.json | jq -M .)
