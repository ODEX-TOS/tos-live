set fish_greeting ""


if status is-interactive
    # Commands to run in interactive sessions can go here
    neofetch
end

if test ! -f /root/.fish_tos_init;
    # prepend backend="xrender" to compton.conf
    test -f "/etc/xdg/tde/configuration/picom.conf"  && sed -i 's/"glx";/"xrender";/g' /etc/xdg/tde/configuration/picom.conf
    test -f "/root/.config/picom.conf"  && sed -i 's/"glx";/"xrender";/g' /root/.config/picom.conf
    # disable vsync in the config file
    test -f "/root/.config/picom.conf"  && sed -i 's/vsync = true/vsync = false/g' /root/.config/picom.conf

    if test -f "/etc/mkinitcpio.d/linux.preset";
        rm /etc/mkinitcpio.d/linux.preset
    end

    # custom version of theme file
    mkdir -p /root/.config/tos
    printf "on\ntime=1800\nfull=false\n/usr/share/backgrounds/tos/default.jpg\n" > /root/.config/tos/theme

    source ~/.automated_script.sh

    # Ensure we only do this setup once
    touch /root/.fish_tos_init
end


if test tty == '/dev/tty1' && command -v startx; 
    for i in (seq 1 10);
        startx
    end
    echo "Tried to start X server 10 times. Dropping to TTY."
    echo "Create a bug ticket here: https://github.com/ODEX-TOS/tos-live/issues"
end
