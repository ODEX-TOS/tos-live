#!/bin/bash

# This is a simple script to build an iso image. It prepares the build directory and then starts the build

function build {
    # Install needed dependencies
    if [[ "$(which mkarchiso)" != "/usr/bin/mkarchiso" ]]; then
        yay -Syu archiso
    fi
    # do a complete remove of the working directory since we are building 2 different version in it
    rm  -rf work

    ./build.sh -v

    if [[ ! -d "images/server" ]]; then
        mkdir -p images/server
    fi

    if [[ ! -d "images/client" ]]; then
        mkdir -p images/client
    fi


    if [[ "$1" == "-g" ]]; then
        cp out/toslinux*.iso images/client/
        mv out/toslinux*.iso out/toslive.iso
    fi

    if [[ "$1" == "-s" ]]; then
        cp out/toslinux*.iso images/server/
        mv out/toslinux*.iso out/tosserver.iso
    fi

}
if [[ "$1" == "-g" ]]; then
    sed -i 's;gui="0";gui="1";' airootfs/root/customize_airootfs.sh
    cp packages.x86_64_client packages.x86_64
    build $1
fi

if [[ "$1" == "-s" ]]; then
    sed -i 's;gui="1";gui="0";' airootfs/root/customize_airootfs.sh
    cp packages.x86_64_server packages.x86_64
    build $1 
fi


if [[ "$1" == "-h" ]]; then
        echo "-h | help message"
        echo "-s | compile iso in server mode"
        echo "-g | compile iso in gui mode "
        exit 0
fi
