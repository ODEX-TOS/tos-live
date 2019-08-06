#!/bin/bash

# This file will prepare and install all software needed for the custom tos repo.
# You have to ability to install custom software, fonts and even the latest kernel version
# TODO: don't remove and rebuild all the software. just remove and rebuild the requested software

if [[ ! -d arch ]];then
    mkdir arch
fi


yes | yay -Syu python-sphinx rust cargo asp pacman-contrib i3lock-color dkms xorg-xset unzip

# $1 is the url $2 is the installdir $3 is the package name
function installpackage {
    if [[ -d "$2" ]]; then
            rm -rf "$2"
    fi
    git clone $1 $2
    cd $2
    makepkg
    rm ../arch/$3*.pkg.tar.xz
    cp $3*.pkg.tar.xz ../arch
    repo-add ../arch/tos.db.tar.gz $3*.pkg.tar.xz
    cd ../
}

function changePKGBUILD {
    # Set the package version
    pkgver=$(head -n7 PKGBUILD | tail -n1 | cut -d= -f2 | sed 's/arch/tos/' | tr '-' '.')
    extraversion="-"$(head -n7 PKGBUILD | tail -n1 | cut -d= -f2 | cut -d- -f2)
    # uncomment the next line if you don't want this build to be the default
    sed -i 's;pkgbase=linux;pkgbase=linux-tos;' PKGBUILD
    sed -i 's;CONFIG_DEFAULT_HOSTNAME="archlinux";CONFIG_DEFAULT_HOSTNAME="toslinux";' config
    sed -i 's;msg2 "Setting config...";sed -i "s:EXTRAVERSION = '$extraversion':EXTRAVERSION = -TOS:" Makefile\n msg2 "Setting config...";' PKGBUILD
    sed -i 's;: ${_kernelname:=-ARCH};: ${_kernelname:=-TOS};' PKGBUILD
    
    sed -i 's;pkgver=${_srcver//-/.};pkgver='$pkgver';' PKGBUILD
    if [[ "$1" == "" ]]; then
        read -p "how many cores do you wish to use for compilation?" cores
    else
        cores="$2"
    fi
    sed -i 's:make bzImage modules htmldocs:make -j'$cores' bzImage modules htmldocs:' PKGBUILD

}

function installlinux {
    if [[ -d kernel ]]; then
        rm -rf kernel
    fi
    mkdir kernel
    cd kernel
    asp update linux
    asp checkout linux
    cd linux/repos/core-x86_64
    
    changePKGBUILD    

    updpkgsums
    gpg --recv-keys A5E9288C4FA415FA # in order to verify the package
    makepkg -s
    rm -rf ../../../../arch/linux-tos*.pkg.tar.xz
    repo-add ../../../../arch/tos.db.tar.gz linux-tos*.pkg.tar.xz
    cp linux-tos*.pkg.tar.xz ../../../../arch
    cd ../../../../

}

function changefirefox {
    sed -i 's;;;' PKGBUILD
    sed -i 's;pkgname=firefox-developer-edition;pkgname=firefox-developer-edition-tos;' PKGBUILD
    sed -i "s;replaces=('firefox-developer');replaces=('firefox-developer' 'firefox-developer-edition');" PKGBUILD
    sed -i 's;"$pkgname".desktop;firefox-developer-edition.desktop;' PKGBUILD
    sed -i 's;export MOZ_TELEMETRY_REPORTING=1;;' PKGBUILD
    sed -i 's;=archlinux;=toslinux;' PKGBUILD
    sed -i 's;archlinux=;toslinux=;' PKGBUILD
    sed -i 's;Arch Linux;Tos Linux;' PKGBUILD
    # TODO: curl the custom css here
    sed -i 's:pref("extensions.shownSelectionUI", true);:pref("extensions.shownSelectionUI", true);\npref("toolkit.legacyUserProfileCustomizations.stylesheets", true);:' PKGBUILD

}

function installfirefoxdev {
    if [[ -d firefox ]]; then
            rm -rf firefox
    fi
    mkdir firefox && cd firefox
    asp update firefox-developer-edition
    asp checkout firefox-developer-edition
    cd firefox-developer-edition/repos/cummunity-x86_64

    changefirefox

    updpkgsums
    gpg --recv-keys F1A6668FBB7D572E
    rm -rf ../../../../arch/firefox*.pkg.tar.xz
    repo-add ../../../../arch/tos.db.tar.gz firefox*.pkg.tar.xz
    cp  firefox*.pkg.tar.xz ../../../../arch
    cd ../../../../
    
}
if [[ "$1" == "" ]]; then
    read -p "Do you want to install default packages? (y/N)" default
fi
if [[ "$default" == "y" || "$1" == "-a" ]]; then
    installpackage https://aur.archlinux.org/polybar-git.git polybar polybar-git-

    installpackage https://aur.archlinux.org/ccat.git ccat ccat-

    installpackage https://aur.archlinux.org/i3lock-next-git.git i3lock i3lock-next-git

    #installpackage https://aur.archlinux.org/lsd-git.git lsd lsd-

    installpackage https://aur.archlinux.org/visual-studio-code-insiders.git vs visual-studio-code-insiders

    installpackage https://aur.archlinux.org/r8152-dkms.git r8 r8152-dkms-

    installpackage https://aur.archlinux.org/i3lock-color.git color i3lock-color-
fi
if [[ "$1" == "" ]]; then
    read -p "Do you want to install fonts? (y/N)" fonts
fi
if [[ "$fonts" == "y" || "$1" == "-f" ]]; then
    installpackage https://aur.archlinux.org/nerd-fonts-complete.git font nerd-fonts-complete-

    installpackage https://aur.archlinux.org/siji-git.git font2 siji-git-

    installpackage https://aur.archlinux.org/ttf-symbola.git font3 ttf-symbola-
fi
if [[ "$1" == "" ]]; then
    read -p "Do you want to install the latest kernel? (y/N)" kernel
fi
if [[ "$kernel" == "y" || "$1" == "-k" ]]; then
    installlinux
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
cp index.html arch/

./genpackagelist.sh
