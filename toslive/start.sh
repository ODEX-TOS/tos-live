#!/bin/bash

# This is a simple script to build an iso image. It prepares the build directory and then starts the build

# Install needed dependencies
if [[ "$(which mkarchiso)" != "/usr/bin/mkarchiso" ]]; then
    yay -Syu archiso
fi

rm -v work/build.make_*

./build.sh -v

if [[ ! -d "images" ]]; then
        mkdir images
fi

cp out/*.iso images/

mv out/*.iso out/toslive.iso
