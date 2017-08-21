#!/usr/bin/env bash

# Come on, give us at least one argument
if [ $# -eq 0 ]; then
    echo "No arguments supplied; please supply at least one board name"
    exit 1
fi

# Check all arguments to make sure they are valid
invalid_board=$(./isValidBoardNames.sh $@)
if [ $? -eq 1 ]; then
    echo "$invalid_board is an invalid board name"
    exit 1
fi

# Create a name to redirect headers to
header_file=$(mktemp -u)

# Declare an associative array to store Last-Modified data
declare -A last_modified

# Declare an associative array to store last post a thread contained
declare -A last_post

# Start main loop
while true
do
  # Grab each board one by one
  for board in "$@"
  do

    # If we have no Last-Modified data, set it to 0 and watch curl struggle to use it
    if [[ ! -v last_modified["$board"] ]]; then
      last_modified["$board"]=0
    fi

    # Last modified, put into a string to avoid rewrite issues
    LAST=${last_modified["$board"]}

    # Grab all threads one by one
    while IFS=, read thread_num modified_since; do

      # If we have no Last-Modified data for the thread, set it to 0
      if [[ ! -v last_modified["$board-$thread_num"] ]]; then
        last_modified["$board-$thread-num"]=0
      fi

      # If Last-Modified hasn't changed, keep on walkin'
      if [[ last_modified["$board-$thread_num"] -eq $modified_since ]]; then
        continue
      fi

      echo "Time to update!"
      #thread=$(curl -sL http://a.4cdn.org/$board/thread/$thread_num.json)

      last_modified["$board-$thread_num"]=$modified_since

    # Get all threads on board from catalog, in reverse order
    done < <(curl -sL -z "$LAST" -D "$header_file" http://a.4cdn.org/$board/threads.json | jq -M . |  grep -e "no" -e "last_modified" | tr -d ' ' | cut -d ':' -f2 | paste -d "" - -)

    # Grep the Last-Modified field out of the catalog grab
    last_modified["$board"]=$(grep "Last-Modified" "$header_file" | cut -d ' ' -f 2-)

    # Delete our temporary file so we can reuse it
    rm "$header_file"

    echo "$board checked!"
    sleep 5
  done
done
