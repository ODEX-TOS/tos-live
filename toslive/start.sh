#!/bin/bash

# MIT License
#
# Copyright (c) 2019 Meyers Tom
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# This is a simple script to build an iso image. It prepares the build directory and then starts the build
./version_builder.sh
version=$(cat airootfs/etc/version.txt)
iso_version=$(date +%Y.%m.%d)
iso_normal=$(echo toslinux-"$iso_version"-x86_64 | tr '.' '-')
append=""

function build() {
  # Install needed dependencies
  if [[ "$(which mkarchiso)" != "/usr/bin/mkarchiso" ]]; then
    yay -Syu archiso || exit 1
  fi
  
  if ! yay -Q | grep -q mkinitcpio-archiso; then
    yay -Syu mkinitcpio-archiso || exit 1
  fi

  # do a complete remove of the working directory since we are building multiple different version using it
  rm -rf work || exit 1

  mkarchiso -v . || exit 1

  if [[ ! -d "images/server" ]]; then
    mkdir -p images/server
  fi

  if [[ ! -d "images/awesome" ]]; then
    mkdir -p images/awesome
  fi

  if [[ "$1" == "-awesome" ]]; then
    cp out/toslinux*.iso images/awesome/"$iso_normal""$append".iso
    mv out/toslinux*.iso out/toslive-awesome.iso
  fi

  if [[ "$1" == "-s" ]]; then
    cp out/toslinux*.iso images/server/"$iso_normal""$append".iso
    mv out/toslinux*.iso out/tosserver.iso
  fi

}

if [[ "$1" == "-h" ]]; then
  echo "-h | help message"
  echo "-s | compile iso in server mode"
  echo "-awesome | compile iso in awesome mode "
  exit 0
fi

if [[ "$1" == "-s" ]]; then
  cp customize_airootfs.sh_server airootfs/root/customize_airootfs.sh || exit 1
elif [[ "$1" == "-awesome" ]]; then
  cp customize_airootfs.sh_awesome airootfs/root/customize_airootfs.sh || exit 1
fi

if [[ "$2" == "-a" ]]; then
  sed -i 's;azerty="0";azerty="1";' airootfs/root/customize_airootfs.sh || exit 1
else
  append="$2"
fi

if [[ "$3" != "" ]]; then
  append="$3"
fi
echo "$append"

if [[ "$1" == "-awesome" ]]; then
  sed -i -r 's;version=".*";version="'"$version"'";' airootfs/root/customize_airootfs.sh
  cp packages.x86_64_awesome packages.x86_64
  build "$1" "$2"
fi

if [[ "$1" == "-s" ]]; then
  sed -i -r 's;version=".*";version="'"$version"'";' airootfs/root/customize_airootfs.sh
  cp packages.x86_64_server packages.x86_64
  build "$1" "$2"
fi
