#!/bin/bash

if [[ "$1" == "-g" ]]; then
    sed -i 's;gui="0";gui="1";' airootfs/root/customize_airootfs.sh
    cp packages.x86_64_client packages.X86_64
fi

if [[ "$1" == "-s" ]]; then
    sed -i 's;gui="1";gui="O";' airootfs/root/customize_airootfs.sh
    cp packages.x86_64_server packages.X86_64
fi


if [[ "$1" == "-h" ]]; then
        echo "-h | help message"
        echo "-s | compile iso in server mode"
        echo "-g | compile iso in gui mode "
fi

rm -v work/build.make_*

./build.sh -v
