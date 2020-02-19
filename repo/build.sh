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

# This file will prepare and install all software needed for the custom tos repo.
# You have to ability to install custom software, fonts and even the latest kernel version

# NOTE: For building tos-installer-cli and tos-installer-gui you will need tos-backend-api as a dependency

if [[ ! -d arch ]]; then
	mkdir arch
fi

#yay -Syu --noconfirm python-sphinx rust cargo asp pacman-contrib i3lock-color-git dkms xorg-xset unzip asciidoc docbook-xsl pythonqt 
#sudo pip install pyboost


function installbuilds() {
	for package in BUILD/PKGBUILD*; do
		    dir=$(echo "$package" | cut -d_ -f2)
		    if [[ -d "$dir" ]]; then
			    rm -rf "$dir"
		    fi
		    mkdir "$dir"
		    cp "$package" "$dir/PKGBUILD"
		    cp BUILD/*.patch "$dir"
		    cd "$dir" || exit 1
		    makepkg --skippgpcheck -s --noconfirm || exit 1
		    cp *.pkg.tar.* ../arch
		    repo-add ../arch/tos.db.tar.gz *.pkg.tar.*
		    cd ../ || exit 1
	done
}

# $1 is the url $2 is the installdir $3 is the package name
function installpackage() {
	if [[ -d "$2" ]]; then
		rm -rf "$2"
	fi
	git clone $1 $2
	cd $2
	if [[ "$4" == "no-exit" ]]; then
		makepkg -s --skippgpcheck
	else
		makepkg -s --skippgpcheck || exit 1
	fi
	rm ../arch/$3*.pkg.tar.*
    ls $3*.pkg.tar.*
    sleep 10
	cp $3*.pkg.tar.* ../arch
	repo-add ../arch/tos.db.tar.gz $3*.pkg.tar.*
	cd ../
}

function changePKGBUILD() {
	# Set the package version
	pkgver=$(head -n7 PKGBUILD | tail -n1 | cut -d= -f2 | sed 's/arch/tos/' | tr '-' '.')
	extraversion="-"$(head -n7 PKGBUILD | tail -n1 | cut -d= -f2 | cut -d- -f2)
	# uncomment the next line if you don't want this build to be the default
	sed -i 's;pkgbase=linux;pkgbase=linux-tos;' PKGBUILD
	sed -i 's;CONFIG_DEFAULT_HOSTNAME="archlinux";CONFIG_DEFAULT_HOSTNAME="toslinux";' config
	sed -i 's;# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set;CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y;g' config
	sed -i 's;msg2 "Setting config...";sed -i "s:EXTRAVERSION = '$extraversion':EXTRAVERSION = -TOS:" Makefile\n msg2 "Setting config...";' PKGBUILD
	sed -i 's;: ${_kernelname:=-ARCH};: ${_kernelname:=-TOS};' PKGBUILD
    sed -i 's;$_srcname::git+https://git.archlinux.org/linux.git?signed#tag=$_srctag;$_srcname::git+https://github.com/ODEX-TOS/linux.git#branch=tos-latest;g' PKGBUILD

	sed -i 's;pkgver=${_srcver//-/.};pkgver='$pkgver';' PKGBUILD
	if [[ "$1" == "" ]]; then
		read -p "how many cores do you wish to use for compilation?" cores
	else
		cores="$1"
	fi
	sed -i 's:make bzImage modules htmldocs:make -j'$cores' bzImage modules htmldocs:' PKGBUILD
	sed -i 's;archlinux;toslinux;' PKGBUILD

}

function installlinux() {
	if [[ -d kernel ]]; then
		rm -rf kernel
	fi
	mkdir kernel
	cd kernel
	asp update linux
	asp checkout linux
	cd linux/repos/core-x86_64

	changePKGBUILD "$1"

	updpkgsums
	gpg --recv-keys A5E9288C4FA415FA # in order to verify the package
	makepkg -s --skippgpcheck
	rm -rf ../../../../arch/linux-tos*.pkg.tar.*
	repo-add ../../../../arch/tos.db.tar.gz linux-tos*.pkg.tar.*
	cp linux-tos*.pkg.tar.* ../../../../arch
	cd ../../../../

}

function populatedb {
    # change depending on the repo name
    cd arch || exit 1
    repo-add tos.db.tar.gz *.pkg.tar.* || exit 1
    cd ../ || exit 1
}


# this function will build all packages from a given package file eg packages.conf
# supply the config file as the first argument
function buildpackages {
    if [[ "$1" == "" ]]; then
        printf "supply a config file to the buildpackages function\n"
        exit 1
    fi
    if [[ ! -f "$1" ]]; then
        printf "$1 is a non existing file. Cannot decode packages to build\n"
        exit 1
    fi
    # file exists at this point
    OLD="$IFS"
    IFS=$'\n'
    for line in $(sed -e 's:#.*::g' -e '/^\s*$/d' "$1" | tr -s ' ' ); do # sanitize the file
        url="$( printf $line | cut -d ' ' -f1)" 
        dir="$( printf $line | cut -d ' ' -f2)" 
        glob="$( printf $line | cut -d ' ' -f3)" 
        abortcode="$( printf $line | cut -d ' ' -f4)" 
        installpackage "$url" "$dir" "$glob" "$abortcode"
    done
    IFS="$OLD"
}

if [[ "$1" == "" ]]; then
    read -p "Do you want to install default packages? (y/N)" default
fi
if [[ "$default" == "y" || "$1" == "-a" ]]; then

    buildpackages "packages.conf"
    installbuilds
    populatedb
fi
if [[ "$1" == "" ]]; then
	read -p "Do you want to install fonts? (y/N)" fonts
fi
if [[ "$fonts" == "y" || "$1" == "-f" ]]; then
    buildpackages "fonts.conf"
    populatedb
fi
if [[ "$1" == "" ]]; then
    read -p "Do you want to install the latest kernel? (y/N)" kernel
fi
if [[ "$kernel" == "y" || "$1" == "-k" ]]; then
    installlinux "$2"
    populatedb
fi

# Only ask to update toslive if an image has been build
if [[ -f "../toslive/out/toslive.iso" ]]; then
	if [[ "$1" == "" ]]; then
		read -p "Do you want to include toslive? (y/N)" toslive
	fi
	if [[ "$toslive" == "y" || "$1" == "-u" ]]; then
		cp ../toslive/out/toslive.iso arch/toslive.iso
	fi
fi

if [[ -f "../toslive/out/tosserver.iso" ]]; then
	if [[ "$1" == "" ]]; then
		read -p "Do you want to include tosserver? (y/N)" toslive
	fi
	if [[ "$toslive" == "y" || "$1" == "-u" ]]; then
		cp ../toslive/out/tosserver.iso arch/tosserver.iso
	fi
fi

if [[ -f "../toslive/out/toslive-azerty.iso" ]]; then
	if [[ "$1" == "" ]]; then
		read -p "Do you want to include toslive azerty edition? (y/N)" toslive
	fi
	if [[ "$toslive" == "y" || "$1" == "-u" ]]; then
		cp ../toslive/out/toslive-azerty.iso arch/toslive-azerty.iso
	fi
fi

if [[ -f "../toslive/out/tosserver-azerty.iso" ]]; then
	if [[ "$1" == "" ]]; then
		read -p "Do you want to include tosserver azerty edition? (y/N)" toslive
	fi
	if [[ "$toslive" == "y" || "$1" == "-u" ]]; then
		cp ../toslive/out/tosserver-azerty.iso arch/tosserver-azerty.iso
	fi
fi
if [[ -f "../toslive/out/toslive-awesome-azerty.iso" ]]; then
	if [[ "$1" == "" ]]; then
		read -p "Do you want to include toslive awesome azerty edition? (y/N)" toslive
	fi
	if [[ "$toslive" == "y" || "$1" == "-u" ]]; then
		cp ../toslive/out/toslive-awesome-azerty.iso arch/toslive-awesome-azerty.iso
	fi
fi
if [[ -f "../toslive/out/toslive-awesome.iso" ]]; then
	if [[ "$1" == "" ]]; then
		read -p "Do you want to include toslive awesome edition? (y/N)" toslive
	fi
	if [[ "$toslive" == "y" || "$1" == "-u" ]]; then
		cp ../toslive/out/toslive-awesome.iso arch/toslive-awesome.iso
	fi
fi
cp index.html arch/

./genpackagelist.sh

