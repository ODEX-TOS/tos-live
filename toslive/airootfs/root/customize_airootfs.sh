#!/bin/bash

set -e -u

gui="1"
version="v0.2.4"
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
sed -i 's/#\(nl_BE\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf
loadkeys be-latin1



systemctl enable pacman-init.service choose-mirror.service
systemctl set-default multi-user.target
systemctl enable NetworkManager

if [[ $(ping -c1 1.1.1.1 | grep "0% packet loss") == "" ]]; then
        wifi-menu
fi

cd
if [[ "$gui" == "1" ]]; then
    curl https://raw.githubusercontent.com/F0xedb/helper-scripts/master/dialogarchinstall -o /root/dialogarchinstall
    chmod +x /root/dialogarchinstall

    if [[ ! -d /root/st ]]; then
        git clone https://github.com/F0xedb/sucklessterminal /root/st
    fi

    if [[ ! -d /root/i3 ]]; then
        git clone https://www.github.com/F0xedb/i3 i3
    fi

    cd /root/st
    make && make install
    cd ../
    rm -rf st


    cd /root/i3

    autoreconf --force --install
    rm -rf build/
    mkdir -p build && cd build/

    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
    make
    sudo make install
    cd
    rm -rf /root/i3
fi

rm -rf /root/bin
rm -rf /root/.config
rm -rf .oh-my-zsh
git clone https://github.com/F0xedb/helper-scripts.git /root/bin
## Refactor code should remove if using master
cd /root/bin
git checkout refactor
## End refactor code
git clone https://github.com/F0xedb/dotfiles /root/.config
mv /root/.config/.vimrc /root
mv /root/.config/.Xresources /root
if [[ "$gui" == "1" ]]; then
    mkdir -p /root/.mozilla/firefox/tos.default
    cp /root/.config/tos/profiles.ini /root/.mozilla/firefox/profiles.ini
    cp -r /root/.config/tos/tos-firefox/* /root/.mozilla/firefox/tos.default
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions.git /root/.oh-my-zsh/custom/plugins/zsh-completions


git clone https://github.com/F0xedb/zsh-load /root/.oh-my-zsh/load
curl https://raw.githubusercontent.com/F0xedb/tos-live/refactor/_tos > /root/.oh-my-zsh/custom/plugins/zsh-completions/src/_tos

curl https://raw.githubusercontent.com/F0xedb/dotfiles/master/.zshrc | sed '/^PATH/d' | sed '/^export PATH=\/home\/zeus/d' | sed '/export PATH=$HOME/d' > /root/.zshrc


echo "loadkeys be-latin1" >> /root/.zshrc
echo "PATH=/root:/root/bin:\$PATH" >> /root/.zshrc
echo "loadkeys be-latin1" >> /root/.bashrc
echo "PATH=/root:/root/bin\$PATH" >> /root/.bashrc
sed -i -r 's:^neofetch:echo "TOS - '$version'"\nneofetch:' /root/.zshrc
echo "echo \"TOS - $version\"" >> /root/.bashrc

git clone https://github.com/denysdovhan/spaceship-prompt.git "/root/.oh-my-zsh/custom/themes/spaceship-prompt"
ln -s "/root/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "/root/.oh-my-zsh/custom/themes/spaceship.zsh-theme"

if [[ "$gui" == "1" ]]; then
    printf "\nif [[ \$(tty) == '/dev/tty1' ]]; then\n startx\n fi" >> /root/.zshrc
    printf "\nif [[ \$(tty) == '/dev/tty1' ]]; then\n startx\n fi" >> /root/.bashrc

    rm -rf /root/Pictures
    git clone https://github.com/F0xedb/Pictures /root/Pictures
    printf "xrdb ~/.Xresources\nexec i3" > /root/.xinitrc
fi
rm -rf /root/.vim
mkdir -p /root/.vim/colors
touch /root/.vim /root/.vim/colors/badwolf.vim
curl https://bitbucket.org/sjl/badwolf/raw/tip/colors/badwolf.vim > ~/.vim/colors/badwolf.vim

if [[ "$gui" == "1" ]]; then
    sed -i 's;$HOME /home/zeus;$HOME /root;' ~/.config/i3/config
fi

rm -rf /etc/issue /etc/os-release
echo "TOS Linux" > /etc/issue
printf 'NAME="Tos Linux"
PRETTY_NAME="Tos Linux"
ID=tos
BUILD_ID=rolling
ANSI_COLOR="0;36"
HOME_URL="https://tos.pbfp.xyz/"
LOGO=toslinux' > /etc/os-release

