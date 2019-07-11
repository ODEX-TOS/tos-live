rm -rf arch
mkdir arch

yay -Syu python-sphinx rust cargo asp

# $1 is the url $2 is the installdir $3 is the package name
function installpackage {
    git clone $1 $2
    cd $2
    makepkg
    cp $3*.pkg.tar.xz ../arch
    repo-add ../arch/repo.db.tar.gz $3*.pkg.tar.xz
    cd ../
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
    sed -i 's;pkgbase=linux;pkgbase=linux-tos;'
    gpg --recv-keys A5E9288C4FA415FA # in order to verify the package
    # This step will take a long time
    makepkg -s
    #Voila the kernel is build
    repo-add kernel*.pkg.tar.xz ../../../../arch/repo.db.tar.gz
    cp kernel*.pkg.tar.xz ../../../../arch
    cd ../../../../

}

installpackage https://aur.archlinux.org/polybar-git.git polybar polybar-git-

installpackage https://aur.archlinux.org/ccat.git ccat ccat-

installpackage https://aur.archlinux.org/i3lock-next-git.git i3lock i3lock-next-git

installpackage https://aur.archlinux.org/lsd-git.git lsd lsd-

installpackage https://aur.archlinux.org/visual-studio-code-insiders.git vs visual-studio-code-insiders

installpackage https://aur.archlinux.org/r8152-dkms.git r8 r8152-dkms-

installpackage https://aur.archlinux.org/i3lock-color.git color i3lock-color-

installpackage https://aur.archlinux.org/nerd-fonts-complete.git font nerd-fonts-complete-

installpackage https://aur.archlinux.org/siji-git.git font2 siji-git-

installpackage https://aur.archlinux.org/ttf-symbola.git font3 tff-symbola-

installlinux