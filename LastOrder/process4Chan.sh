#!/usr/bin/env bash

# Come on, give us at least one argument
if [ $# -eq 0 ];then
    echo "No arguments supplied; please supply at least one board name"
    exit 1
fi

# Check all arguments to make sure they are valid
invalid_board=$(./isValidBoardNames.sh $@)
if [ $? -eq 1 ]; then
    echo "$invalid_board is invalid"
    exit 1
fi

# Start main loop, grabbing all boards one by one
while true
do

    echo "Loop"
    sleep 1
done

# PROTOTYPE, grabbing a single board
# Create a name to redirect headers to
header_file=$(mktemp -u)

# We'll start If-Modified-Since right now, then grep it out of the header_file later
if_modified_since=$(date +%a,\ %e\ %b\ %Y\ %H:%M:%S\ GMT)

# Grab all threads one by one
while IFS=, read thread_url last_modified; do

	thread=$(curl -sL http://a.4cdn.org/b/thread/$thread_url.json)

# Get all threads on board from catalog
done < <(curl -sL -z "$if_modified_since" -D "$header_file" http://a.4cdn.org/b/threads.json | jq -M . |  grep -e "no" -e "last_modified" | tr -d ' ' | cut -d ':' -f2 | paste -d "" - -)

# Grep the Last-Modified field out of the catalog grab
if_modified_since=$(grep "Last-Modified" "$header_file" | cut -d ' ' -f 2-)
rm "$header_file"

echo "ALL DONE"

