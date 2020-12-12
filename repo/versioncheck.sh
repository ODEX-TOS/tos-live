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

# Simple utility to check common packages shared with arch linux/AUR but converted to tos
# It checks for the latest versions of upstream and simply prints them. Thus we know which PKGBUILDS to update

# Append package name to the base url to retrieve the html
community_url="https://git.archlinux.org/svntogit/community.git/plain/trunk/PKGBUILD?h=packages/"
core_url="https://git.archlinux.org/svntogit/packages.git/plain/trunk/PKGBUILD?h=packages/"
extra_url="https://git.archlinux.org/svntogit/packages.git/plain/trunk/PKGBUILD?h=packages/"
aur_url="https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h="

LOG_ERROR="\033[0;31m[ERROR]\033[0m "
LOG_INFO="\033[0;33m[INFO]\033[0m "

function log {
    echo -e "$@"
}

# functions to handle a specific package based on its url
function get {
    html=$(curl -s $1)
    # retreive variables in a safe manner
    eval $(source "$item";
            echo version="$pkgver";
            echo release="$pkgrel")
    version=$(printf "%s" "$html" | grep "pkgver=") # grep the current version in tos repo
    release=$(printf "%s" "$html" | grep "pkgrel=") # grep the current release in the tos repo
    if ! cat "$4" | grep -q "# SILENT: on"; then
        if [[ "$version" != "$2" && "$release" != "$3" ]]; then
            log "$LOG_INFO" "$4: should be updated - $1"
        fi
    fi
}

# get all packages in the BUILD directory
# The build directory contains all modified PKGBUILDS and patches
# We only search for versions in this script.

for item in BUILD/PKGBUILD*; do
        # retreive variables in a safe manner
        eval $(source "$item";
                echo version="$pkgver";
                echo release="$pkgrel";
                echo pkgname="$pkgname")
        name=$(printf "$pkgname" | cut -d= -f2 | sed 's:-tos::g' | sed "s:'::g") # Get the package name
        # check if the first name is 
        # Get the PKGBUILD from the arch repo, try each repo type until a succesfull match is found
        if curl -s "$core_url"$name | grep -E -q "^pkgname="; then
                get "$core_url"$name "$version" "$release" "$item"
        elif curl -s "$community_url"$name | grep -E -q "^pkgname="; then
                get "$community_url"$name "$version" "$release" "$item"
        elif curl -s "$extra_url"$name | grep -E -q "^pkgname="; then
                get "$extra_url"$name "$version" "$release" "$item"
        elif curl -s "$aur_url"$name | grep -E -q "^pkgname="; then
                get "$aur_url"$name "$version" "$release" "$item"
        else
                if [[ "$1" != "-s" && "$1" != "--silent" ]]; then
                    log "$LOG_ERROR" "Cannot find $name in any repo (detected in file $(basename $item))"
                fi
        fi
done

