rm -rf arch
mkdir arch

yay -Syu python-sphinx rust cargo

git clone https://aur.archlinux.org/polybar-git.git polybar
cd polybar
makepkg
cd ../
cp polybar/polybar-git-* arch
repo-add arch/repo.db.tar.gz polybar/polybar-git-*

git clone https://aur.archlinux.org/ccat.git ccat
cd ccat
makepkg
cd ../
cp ccat/ccat-* arch
repo-add arch/repo.db.tar.gz ccat/ccat-*

git clone https://aur.archlinux.org/i3lock-next-git.git i3lock
cd i3lock
makepkg
cd ../
cp i3lock/i3lock-next-git-* arch
repo-add arch/repo.db.tar.gz i3lock/i3lock-next-git-*

git clone https://aur.archlinux.org/lsd-git.git lsd
cd lsd
makepkg
cd ../
cp lsd/lsd-* arch
repo-add arch/repo.db.tar.gz lsd/lsd-*

git clone https://aur.archlinux.org/visual-studio-code-insiders.git vs
cd vs
makepkg
cd ../
cp vs/visual-studio-code-insiders* arch
repo-add arch/repo.db.tar.gz vs/visual-studio-code-insiders-*.pkg.tar.xz

git clone https://aur.archlinux.org/r8152-dkms.git r8
cd r8
makepkg
cd ../
cp r8/r8152-dkms-* arch
repo-add arch/repo.db.tar.gz r8/r8152-dkms-*

git clone https://aur.archlinux.org/i3lock-color.git color
cd color
makepkg
cd ../
cp color/i3lock-color-* arch
repo-add arch/repo.db.tar.gz color/i3lock-color-*

git clone https://aur.archlinux.org/nerd-fonts-complete.git font
cd font
makepkg
cd ../
cp font/nerd-fonts-complete-* arch
repo-add arch/repo.db.tar.gz font/nerd-fonts-complete-*

git clone https://aur.archlinux.org/siji-git.git font2
cd font2
makepkg
cd ../
cp font2/siji-git-* arch
repo-add arch/repo.db.tar.gz font2/siji-git-*


git clone https://aur.archlinux.org/ttf-symbola.git font3 
cd font3
makepkg
cd ../
cp font3/ttf-symbola-* arch
repo-add arch/repo.db.tar.gz font3/ttf-symbola-*
