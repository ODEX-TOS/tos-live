#!/bin/bash

# Simple utility to check common packages shared with arch linux/AUR but converted to tos
# It checks for the latest versions of upstream and simply prints them. Thus we know which PKGBUILDS to update

# Append package name to the base url to retrieve the html
community_url="https://git.archlinux.org/svntogit/community.git/plain/trunk/PKGBUILD?h=packages/"
core_url="https://git.archlinux.org/svntogit/packages.git/plain/trunk/PKGBUILD?h=packages/"
extra_url="https://git.archlinux.org/svntogit/packages.git/plain/trunk/PKGBUILD?h=packages/"
aur_url="https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h="


# functions to handle a specific package based on its url
function get {
    html=$(curl -s $1)
    version=$(printf "%s" "$html" | grep "pkgver=") # grep the current version in tos repo
    release=$(printf "%s" "$html" | grep "pkgrel=") # grep the current release in the tos repo
    if ! cat "$4" | grep -q "# SILENT: on"; then
        if [[ "$version" != "$2" && "$release" != "$3" ]]; then
            printf "$4: should be updated - $1\n"
        fi
    fi
}

# get all packages in the BUILD directory
# The build directory contains all modified PKGBUILDS and patches
# We only search for versions in this script.

for item in BUILD/PKGBUILD*; do
        version=$(grep "pkgver=" "$item") # grep the current version in tos repo
        release=$(grep "pkgrel=" "$item") # grep the current release in the tos repo
        name=$(grep -E "^pkgname=" "$item" | cut -d= -f2 | sed 's:-tos::g' | sed "s:'::g") # Get the package name
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
                    echo "Cannot find $name in any repo"
                fi
        fi
done
