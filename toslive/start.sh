#!/bin/bash

# This is a simple script to build an iso image. It prepares the build directory and then starts the build

version=$(cat version.txt)
iso_version=$(date +%Y.%m.%d)
iso_azerty=$(echo toslinux-"$iso_version"-x86_64_azerty.iso | tr '.' '-')
            
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
        if [[ "$2" == "-a" ]]; then
            cp out/toslinux*.iso images/client/$iso_azerty
            mv out/toslinux*.iso out/toslive-azerty.iso
        else
            cp out/toslinux*.iso images/client/
            mv out/toslinux*.iso out/toslive.iso
        fi
    fi

    if [[ "$1" == "-s" ]]; then
        if [[ "$2" == "-a" ]]; then
            cp out/toslinux*.iso images/server/$iso_azerty
            mv out/toslinux*.iso out/tosserver-azerty.iso
        else
            cp out/toslinux*.iso images/server/
            mv out/toslinux*.iso out/tosserver.iso
        fi  
    fi

}

if [[ "$2" == "-a" ]]; then
    sed -i 's;azerty="0";azerty="1";' airootfs/root/customize_airootfs.sh
else
    sed -i 's;azerty="1";azerty="0";' airootfs/root/customize_airootfs.sh
fi

if [[ "$1" == "-g" ]]; then
    sed -i 's;gui="0";gui="1";' airootfs/root/customize_airootfs.sh
    sed -i -r 's;version=".*";version="'$version'";' airootfs/root/customize_airootfs.sh
    cp packages.x86_64_client packages.x86_64
    build $1
fi

if [[ "$1" == "-s" ]]; then
    sed -i 's;gui="1";gui="0";' airootfs/root/customize_airootfs.sh
    sed -i -r 's;version=".*";version="'$version'";' airootfs/root/customize_airootfs.sh
    cp packages.x86_64_server packages.x86_64
    build $1 
fi


if [[ "$1" == "-h" ]]; then
        echo "-h | help message"
        echo "-s | compile iso in server mode"
        echo "-g | compile iso in gui mode "
        echo "-a | compile iso with azerty as keyboard layout (works with both -s and -g) This option must be the last option specified "
        exit 0
fi
