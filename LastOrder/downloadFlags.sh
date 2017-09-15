#!/usr/bin/env bash

# Make a flags directory
mkdir -p flags

# Generate a two letter country code
for x in {a..z}
do
    for y in {a..z}
    do
        # Grab a gif based on the country code
        curl -sL http://s.4cdn.org/image/country/$x$y.gif > flags/$x$y.gif

        # If it contains 404, it's an invalid file
	if [[ -n $(grep "404 Not Found" flags/$x$y.gif) ]]; then
            rm -rf "flags/$x$y.gif"
        fi
    done
done

