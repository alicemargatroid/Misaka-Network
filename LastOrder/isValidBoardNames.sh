#!/usr/bin/env bash

# We need at least one argument!
if [ $# -eq 0 ]; then
    echo "No arguments supplied; please supply at least one board name"
    exit 1
fi

VALID=$(curl -sL http://a.4cdn.org/boards.json | jq -M . | grep "\"board\":" | cut -d':' -f2 | tr -d ' [:punct:]')
POSSIBLE=$(echo "$@" | tr ' ' '\n' | sort -u)

OUTPUT=$(comm -23 <(echo "$POSSIBLE") <(echo "$VALID") | tr '\n' ',' | sed 's/.$//')

if [[ -z "$OUTPUT" ]]; then
    exit 0
fi

echo "$OUTPUT"
exit 1
