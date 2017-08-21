#!/usr/bin/env bash

if [ $# -eq 0 ];then
    echo "No arguments supplied; please supply at least one board name"
    exit 1
fi

# Create associative array so we can look up the board names
declare -A board_names

# Read all the board names into the board_names associative array
while read board_name
do
    # Set each board name into our board_names associative array
    board_names["$board_name"]="$board_name"

# Actually call out to 4chan and grab all the boards
done < <(curl -sL http://a.4cdn.org/boards.json | jq -M . | grep "\"board\":" | cut -d':' -f2 | tr -d ' [:punct:]')

# Check all arguments against our board_names
for arg in "$@"
do
    [[ ! -v board_names["$arg"] ]] && echo "$arg is not a valid board" && exit 1
done

# All boards valid!
exit 0
