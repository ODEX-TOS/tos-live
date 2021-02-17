#!/usr/bin/env bash

# MIT License
# 
# Copyright (c) 2020 Tom Meyers
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

# shellcheck disable=SC2086,SC1090


# This file will prepare and install all software needed for the custom tos repo.
# You have to ability to install custom software, fonts and even the latest kernel version

# NOTE: For building tos-installer-cli and tos-installer-gui you will need tos-backend-api as a dependency

# ENUM VARIABLES
NO_ABORT_FLAG="^# NO_ABORT" # this flag must be present in order to not abort the build when something goes wrong
# END ENUM VARIABLES

# change this to the gpg key of your mail address
GPG_EMAIL="tom@odex.be"

GPG_REPO_KEY="${GPG_REPO_KEY:-}"

# WARN: Do not commit a password into version control!
# GPG_PASS="" # set this in your env or directly here.
# make sure to load the profile even if we are doing this in a custom environment
source ~/.profile
DEFAULT_PWD="$(pwd)"


if [[ "$GPG_PASS" == "" && "$1" != "-h" ]]; then
	echo "NO GPG password set please resolve"
	sleep 5
fi

if [[ "$GPG_REPO_KEY" == "" ]]; then
    echo "No repo key found! Please set the GPG_REPO_KEY env variable to the correct key"
fi

if [[ ! -d arch ]]; then
	mkdir arch
fi

#yay -Syu --noconfirm python-sphinx rust cargo asp pacman-contrib i3lock-color-git dkms xorg-xset unzip asciidoc docbook-xsl pythonqt 
#sudo pip install pyboost

# Wait until the repo loc has been lifted
# $1 is the repo name $2 is the directory location of the database
function addToRepo() {
	# wait for the lock file to dissapear
	while [[ -f "$1".lck ]]; do
		sleep 1
	done
	loc=$(pwd)
	cd "$2" || exit 1
	if [[ "$3" == "" ]]; then
		repo-add --verify --sign --key "$GPG_REPO_KEY" "$1" ./*.pkg.tar.???
	else
		repo-add --verify --sign --key "$GPG_REPO_KEY" "$1" "./$3"*.pkg.tar.???
	fi
	cd "$loc" || exit 1

}


function installbuilds() {
	for package in BUILD/PKGBUILD*; do
		    dir=$(echo "$package" | cut -d_ -f2)
		    if [[ -d "$dir" ]]; then
			    rm -rf "$dir"
		    fi
		    mkdir "$dir"
		    cp "$package" "$dir/PKGBUILD"
		    cp BUILD/*.patch "$dir"
            if [[ -d "BUILD/$dir" ]]; then
                    cp -r "BUILD/$dir/"* "$dir"
            fi
		    cd "$dir" || exit 1
			if grep -q -E "$NO_ABORT_FLAG" "PKGBUILD"; then
		    	makepkg --sign --key "$GPG_REPO_KEY" -s --noconfirm || echo "[ERROR] Build of $package failed. Continuing build..."
			else
				makepkg --sign --key "$GPG_REPO_KEY" -s --noconfirm || exit 1
			fi
		    cp -- *.pkg.tar.* ../arch
		    cd ../ || exit 1
	done
    cd "$DEFAULT_PWD" || exit 1
}

# $1 is the url $2 is the installdir $3 is the package name
function installpackage() {
	if [[ -d "$2" ]]; then
		rm -rf "$2"
	fi
	git clone "$1" "$2"
    loc=$(pwd)
	cd "$2" || exit 1 
	if [[ "$4" == "no-exit" ]]; then
		makepkg -s --sign --key "$GPG_REPO_KEY" --noconfirm
	else
		makepkg -s --sign -f --key "$GPG_REPO_KEY" --noconfirm || exit 1
	fi
	rm "$loc"/arch/$3*.pkg.tar.*
    ls $3*.pkg.tar.*
    sleep 1
	cp $3*.pkg.tar.* "$loc"/arch
	cd "$loc" || exit 1
}

function updateKernelConf() {
    if [[ -f "$DEFAULT_PWD/kernel.conf" ]]; then
       	while IFS="" read -r p || [ -n "$p" ]
		do
  			printf '%s\n' "$p" >> config
            printf 'Setting kernel param: %s\n' "$p"
		done < "$DEFAULT_PWD/"kernel.conf 
    else
        echo "$DEFAULT_PWD/kernel.conf not found, skipping kernel modification"
    fi
}

function changePKGBUILD() {
	# Set the package version
	pkgver=$(curl -sf https://raw.githubusercontent.com/ODEX-TOS/linux/tos-latest/.PKGVER)
	extraversion="-"$(head -n7 PKGBUILD | tail -n1 | cut -d= -f2 | cut -d- -f2)
	# uncomment the next line if you don't want this build to be the default
	sed -i 's;pkgbase=linux;pkgbase=linux-tos;' PKGBUILD
	sed -i 's;CONFIG_DEFAULT_HOSTNAME="archlinux";CONFIG_DEFAULT_HOSTNAME="toslinux";' config
    
    updateKernelConf

	sed -i 's;msg2 "Setting config...";sed -i "s:EXTRAVERSION = '$extraversion':EXTRAVERSION = -TOS:" Makefile\n msg2 "Setting config...";' PKGBUILD
	sed -i 's;: ${_kernelname:=-ARCH};: ${_kernelname:=-TOS};' PKGBUILD
	# shellcheck disable=SC2016
    sed -i 's;$_srcname::git+https://git.archlinux.org/linux.git?signed#tag=$_srctag;$_srcname::git+https://github.com/ODEX-TOS/linux.git#branch=tos-latest;g' PKGBUILD

	sed -i 's;pkgver=.*;pkgver='$pkgver';' PKGBUILD

    sed -i 's;KBUILD_BUILD_HOST=archlinux;KBUILD_BUILD_HOST=toslinux;g' PKGBUILD
    sed -i 's;sphinx-workaround.patch;;g' PKGBUILD

	if [[ "$1" == "" ]]; then
		read -r -p "how many cores do you wish to use for compilation?" cores
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
	cd kernel || exit 1
	asp update linux
	asp checkout linux
	cd linux/repos/core-x86_64 || exit 1

	changePKGBUILD "$1"

	updpkgsums
	gpg --recv-keys A5E9288C4FA415FA # in order to verify the package
	makepkg -s --sign --key "$GPG_REPO_KEY" --noconfirm || exit 1
	rm -rf "$DEFAULT_PWD"/arch/linux-tos*.pkg.tar.*
	cp linux-tos*.pkg.tar.* "$DEFAULT_PWD"/arch
	addToRepo tos.db.tar.gz "$DEFAULT_PWD"/arch/ linux-tos
	cd "$DEFAULT_PWD" || exit 1

}

# go to the project root
function populatedb {
    # change depending on the repo name
    cd "$DEFAULT_PWD"/arch || exit 1
	addToRepo tos.db.tar.gz . || exit 1
    cd "$DEFAULT_PWD" || exit 1
}


# this function will build all packages from a given package file eg packages.conf
# supply the config file as the first argument
function buildpackages {
    if [[ "$1" == "" ]]; then
        printf "supply a config file to the buildpackages function\n"
        exit 1
    fi
    if [[ ! -f "$1" ]]; then
        printf "%s is a non existing file. Cannot decode packages to build\n" "$1"
        exit 1
    fi
    # file exists at this point
    OLD="$IFS"
    IFS=$'\n'
    for line in $(sed -e 's:#.*::g' -e '/^\s*$/d' "$1" | tr -s ' ' ); do # sanitize the file
        url="$( printf "%s" $line | cut -d ' ' -f1)" 
        dir="$( printf "%s" $line | cut -d ' ' -f2)" 
        glob="$( printf "%s" $line | cut -d ' ' -f3)" 
        abortcode="$( printf "%s" $line | cut -d ' ' -f4)" 
        installpackage "$url" "$dir" "$glob" "$abortcode"
    done
    IFS="$OLD"
}

# generate the ISO checksum and gpg sig
function secureISO {
	if [[ ! "$(command -v sha256sum)" ]]; then
		echo "cannot generate checksum of $1. You should have sha256sum installed"
		return
	fi
	if [[ ! "$(command -v gpg)" ]]; then
		echo "GNU gpg should be installed on your system and have a valid key."
		return
	fi
	sha256sum "$1" > "$1".sha256
	sed -i 's/arch\///g' "$1".sha256
	# accept all user input for overriding files
	gpg --yes --pinentry-mode loopback --detach-sign --passphrase "$GPG_PASS" --default-key "$GPG_EMAIL" -o "$1".gpg "$1"
}

function rebuildRepoDB {
    cd "$DEFAULT_PWD" || exit 1
	addToRepo tos.db.tar.gz arch/
}

function printHelp {
    echo -e "$(basename $0) USAGE: -(aBfhkpPru)"
    echo -e ""
    echo -e "OPTIONS:"
    echo -e "\t-a \t\t\t Combination of the -P and -B options"
    echo -e "\t-B \t\t\t Build all custom packages in the repo/BUILD/ directory"
    echo -e "\t-f \t\t\t Build all font packages in the fonts.conf file"
    echo -e "\t-h \t\t\t Show this help page"
    echo -e "\t-k <build cpu cores>\t Build the linux kernel"
    echo -e "\t-p <dir>\t\t Build the package found in <dir>"
    echo -e "\t-P \t\t\t Build all packages found in packages.conf"
    echo -e "\t-u \t\t\t Upload all iso images found to the repo"
    echo -e "\t-r \t\t\t Rebuild the repo database from all present packages"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        printHelp
        exit 0
fi

if [[ "$1" == "-r" ]]; then
        rebuildRepoDB
        exit 0
fi

if [[ "$1" == "-p" ]]; then
        cd "$2" || exit 1
        # remove all subdirectories
        # these will conflict with rebuilds
        find . -mindepth 1 -maxdepth 1 -type d -print0 | xargs -0 rm -R
		makepkg -s -f --sign --key "$GPG_REPO_KEY" || exit 1
        cp ./*.pkg.tar.* $DEFAULT_PWD"/arch" || exit 1
        addToRepo tos.db.tar.gz "$DEFAULT_PWD"/arch || exit 1
        exit 0
fi

if [[ "$1" == "" ]]; then
    read -r -p "Do you want to install default packages? (y/N)" default
fi
if [[ "$default" == "y" || "$1" == "-a" ]]; then

    buildpackages "packages.conf"
    installbuilds
    populatedb
fi
if [[ "$default" == "y" || "$1" == "-P" ]]; then

    buildpackages "packages.conf"
    populatedb
fi
if [[ "$default" == "y" || "$1" == "-B" ]]; then

    installbuilds
    populatedb
fi
if [[ "$1" == "" ]]; then
	read -r -p "Do you want to install fonts? (y/N)" fonts
fi
if [[ "$fonts" == "y" || "$1" == "-f" ]]; then
    buildpackages "fonts.conf"
    populatedb
fi
if [[ "$1" == "" ]]; then
    read -r -p "Do you want to install the latest kernel? (y/N)" kernel
fi
if [[ "$kernel" == "y" || "$1" == "-k" ]]; then
    installlinux "$2"
    populatedb
fi

# Only ask to update toslive if an image has been build
if [[ -f "../toslive/out/toslive.iso" ]]; then
	if [[ "$1" == "" ]]; then
		read -r -p "Do you want to include toslive? (y/N)" toslive
	fi
	if [[ "$toslive" == "y" || "$1" == "-u" ]]; then
		cp ../toslive/out/toslive.iso arch/toslive.iso
		secureISO arch/toslive.iso
	fi
fi

if [[ -f "../toslive/out/tosserver.iso" ]]; then
	if [[ "$1" == "" ]]; then
		read -r -p "Do you want to include tosserver? (y/N)" toslive
	fi
	if [[ "$toslive" == "y" || "$1" == "-u" ]]; then
		cp ../toslive/out/tosserver.iso arch/tosserver.iso
		secureISO arch/tosserver.iso
	fi
fi

if [[ -f "../toslive/out/toslive-azerty.iso" ]]; then
	if [[ "$1" == "" ]]; then
		read -r -p "Do you want to include toslive azerty edition? (y/N)" toslive
	fi
	if [[ "$toslive" == "y" || "$1" == "-u" ]]; then
		cp ../toslive/out/toslive-azerty.iso arch/toslive-azerty.iso
		secureISO arch/toslive-azerty.iso
	fi
fi

if [[ -f "../toslive/out/tosserver-azerty.iso" ]]; then
	if [[ "$1" == "" ]]; then
		read -r -p "Do you want to include tosserver azerty edition? (y/N)" toslive
	fi
	if [[ "$toslive" == "y" || "$1" == "-u" ]]; then
		cp ../toslive/out/tosserver-azerty.iso arch/tosserver-azerty.iso
		secureISO arch/tosserver-azerty.iso
	fi
fi
if [[ -f "../toslive/out/toslive-awesome-azerty.iso" ]]; then
	if [[ "$1" == "" ]]; then
		read -r -p "Do you want to include toslive awesome azerty edition? (y/N)" toslive
	fi
	if [[ "$toslive" == "y" || "$1" == "-u" ]]; then
		cp ../toslive/out/toslive-awesome-azerty.iso arch/toslive-awesome-azerty.iso
		secureISO arch/toslive-awesome-azerty.iso
	fi
fi
if [[ -f "../toslive/out/toslive-awesome.iso" ]]; then
	if [[ "$1" == "" ]]; then
		read -r -p "Do you want to include toslive awesome edition? (y/N)" toslive
	fi
	if [[ "$toslive" == "y" || "$1" == "-u" ]]; then
		cp ../toslive/out/toslive-awesome.iso arch/toslive-awesome.iso
		secureISO arch/toslive-awesome.iso
	fi
fi
cp index.html arch/

./genpackagelist.sh

