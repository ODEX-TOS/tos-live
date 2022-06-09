#!/bin/bash

source ~/.profile

# In case people want to use the deprecated tde desktop
printf "xrdb ~/.Xresources\nexec env XDG_CURRENT_DESKTOP=TDE tde" > /root/.xinitrc

if [[ -f "/root/tos" ]]; then
  rm /root/tos
fi

# prepend backend="xrender" to compton.conf
[[ -f "/etc/xdg/tde/configuration/picom.conf" ]] && sed -i 's/"glx";/"xrender";/g' /etc/xdg/tde/configuration/picom.conf
[[ -f "/root/.config/picom.conf" ]] && sed -i 's/"glx";/"xrender";/g' /root/.config/picom.conf
# disable vsync in the config file
[[ -f "/root/.config/picom.conf" ]] && sed -i 's/vsync = true/vsync = false/g' /root/.config/picom.conf

if [[ -f "/etc/mkinitcpio.d/linux.preset" ]]; then
  rm /etc/mkinitcpio.d/linux.preset
fi

# custom version of theme file
mkdir -p /root/.config/tos
printf "on\ntime=1800\nfull=false\n/usr/share/backgrounds/tos/default.jpg\n" > /root/.config/tos/theme

~/.automated_script.sh

# Ensure the gdm settings are applied in /etc/dconf/db/gdm.d
dconf update 

if [[ "$(tty)" == '/dev/tty1' && "$(command -v gnome-shell)" != "" ]]; then
  for i in seq 1 10; do
   echo "Starting wayland server attempt: $i"
   dbus-run-session -- gnome-shell --display-server --wayland
  done

  echo "Tried to start wayland server 10 times. Dropping to TTY."
  echo "Create a bug ticket here: https://github.com/ODEX-TOS/tos-live/issues"
elif [[ $(tty) == '/dev/tty1' && "$(command -v startx)" != '' ]]; then
    for i in seq 1 10; do
        startx
    done
fi
