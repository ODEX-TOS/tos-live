
# Installation requirements
if ! pacman -Q | grep -q pop-shell-git; then
	sudo yay -Syu gdm haveged cups  gnome-shell-extension-blur-my-shell gnome-shell-extension-desktop-icons-ng gnome-shell-extension-clipboard-indicator gnome-shell-extension-dash-to-dock gnome-shell-extension-net-speed gnome-shell-extension-pop-shell-git gnome gnome-extras --noconfirm
fi

# stop lightdm and start gdm on next boot

sudo systemctl disable lightdm
sudo systemctl enable gdm

# start haveged so gnome can boot up more quickly
sudo systemctl enable --now haveged
sudo systemctl enable --now cups


# Configure extentions

# gnome-shell-extension-blur-my-shell
gnome-extensions enable blur-my-shell@aunetx

# gnome-shell-extension-pop-shell-git
gnome-extensions enable pop-shell@system76.com 

# gnome-shell-extension-clipboard-indicator
gnome-extensions enable clipboard-indicator@tudmotu.com

# gnome-shell-extension-net-speed
gnome-extensions enable netspeed@alynx.one

# gnome-shell-extension-dash-to-dock
gnome-extensions enable ubuntu-dock@ubuntu.com

# gnome-shell-extension-desktop-icons-ng
gnome-extensions enable ding@rastersoft.com

# TODO: COnfigure keybindings and settings of the extentions
# settings options are stored in org.gnome.shell.extensions.*



# Blur-my-shell disable dash-to-dock
gsettings set org.gnome.shell.extensions.blur-my-shell dash-to-dock-blur "false"

# pop shell
gsettings set org.gnome.shell.extensions.pop-shell focus-down "['<Super>Down']"
gsettings set org.gnome.shell.extensions.pop-shell focus-left "['<Super>Left']"
gsettings set org.gnome.shell.extensions.pop-shell focus-right "['<Super>Right']"
gsettings set org.gnome.shell.extensions.pop-shell focus-up "['<Super>Up']"
gsettings set org.gnome.shell.extensions.pop-shell hint-color-rgba 'rgb(206,108,251)'
gsettings set org.gnome.shell.extensions.pop-shell show-title 'false'
gsettings set org.gnome.shell.extensions.pop-shell smart-gaps 'true'
gsettings set org.gnome.shell.extensions.pop-shell snap-to-grid 'true'
gsettings set org.gnome.shell.extensions.pop-shell active-hint 'false'
gsettings set org.gnome.shell.extensions.pop-shell tile-by-default 'true'
gsettings set org.gnome.shell.extensions.pop-shell tile-by-default 'true'
gsettings set org.gnome.shell.extensions.pop-shell gap-inner '2'
gsettings set org.gnome.shell.extensions.pop-shell gap-outer '2'
gsettings set org.gnome.shell.extensions.pop-shell tile-enter "['<Super>backslash']"
gsettings set org.gnome.shell.extensions.pop-shell toggle-floating "['<Super>c']"
gsettings set org.gnome.shell.extensions.pop-shell toggle-stacking-global "['<Shift><Control><Alt><Super>s']"
gsettings set org.gnome.shell.extensions.pop-shell activate-launcher "['<Super>slash']"
gsettings set org.gnome.shell.extensions.pop-shell toggle-tiling "['<Super>y']"
gsettings set org.gnome.shell.extensions.pop-shell tile-swap-down "['<Control><Super>Down']" 
gsettings set org.gnome.shell.extensions.pop-shell tile-swap-left "['<Control><Super>Left']"
gsettings set org.gnome.shell.extensions.pop-shell tile-swap-right "['<Control><Super>Right']"
gsettings set org.gnome.shell.extensions.pop-shell tile-swap-up "['<Control><Super>Up']"

# dash-to-dock
gsettings set org.gnome.shell.extensions.dash-to-dock activate-single-window "true"
gsettings set org.gnome.shell.extensions.dash-to-dock animate-show-apps "true"
gsettings set org.gnome.shell.extensions.dash-to-dock apply-glossy-effect "true"
gsettings set org.gnome.shell.extensions.dash-to-dock autohide "true"
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity "0.8"

# clipboard-indicator
gsettings set org.gnome.shell.extensions.clipboard-indicator strip-text "true"
gsettings set org.gnome.shell.extensions.clipboard-indicator toggle-menu "['<Super>u']"

# setup keybindings
for i in {1..9}; do
	gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-"$i" "['<Super><Shift>$i']"
	gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-"$i" "['<Super>$i']"
done

# Open search
gsettings set org.gnome.settings-daemon.plugins.media-keys search "['<Super>d']"
# Open settings
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>s']"
# Kill window
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
# Open notification center
gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>x']"

# TODO: Fullscreen application

# Lock device
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l']"

# Audio player settings
gsettings set org.gnome.settings-daemon.plugins.media-keys next "['<Super>n']"
gsettings set org.gnome.settings-daemon.plugins.media-keys play  "['<Super>t']"
gsettings set org.gnome.settings-daemon.plugins.media-keys previous  "['<Super>l']"


gsettings set org.gnome.desktop.notifications show-in-lock-screen "true"
gsettings set org.gnome.desktop.wm.preferences num-workspaces "9"


# Set the background image
gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/gnome/blobs-l.svg"
gsettings set org.gnome.desktop.background picture-uri-dark "file:///usr/share/backgrounds/gnome/blobs-d.svg"


# Custome keybinding
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/','/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Launch Terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "gnome-terminal"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super><Return>"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Launch Emoji's"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "gnome-characters"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>M"

