#!/usr/bin/env bash

# Make sure we get at least one argument
if [ "$#" -ne 1 ]; then
    echo "Please specify ONE board"
    exit 1
fi

# Make sure the board name only contains alphanumerics
if [[ "$1" =~ [^a-zA-Z0-9] ]]; then
    echo "Invalid board name"
    exit 1
fi

# First argument is stored in $1, used to specify board name
curl -L http://a.4cdn.org/$1/threads.json | jq -M . | grep "no" | cut -d ':' -f2 | cut -c2- | rev | cut -c2- | rev
