#!/usr/bin/env bash

# Make a troll flags directory
mkdir -p trollflags

# Generate a two letter country code
for x in {a..z}
do
    for y in {a..z}
    do
        # Grab a gif based on the country code
        curl -sL http://s.4cdn.org/image/country/troll/$x$y.gif > trollflags/$x$y.gif

        # If it contains 404, it's an invalid file
	if [[ -n $(grep "404 Not Found" trollflags/$x$y.gif) ]]; then
            rm -rf "trollflags/$x$y.gif"
        fi
    done
done

