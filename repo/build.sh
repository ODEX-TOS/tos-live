rm -rf arch
mkdir arch

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
repo-add arch/repo.db.tar.gz vs/visual-studio-code-insiders-*

git clone https://aur.archlinux.org/r8152-dkms.git r8
cd r8
makepkg
cd ../
cp r8/r8152-dkms-* arch
repo-add arch/repo.db.tar.gz r8/r8152-dkms*

git clone https://aur.archlinux.org/i3lock-color.git color
cd color
makepkg
cd ../
cp color/i3lock-color-* arch
repo-add arch/repo.db.tar.gz color/i3lock-color-*
