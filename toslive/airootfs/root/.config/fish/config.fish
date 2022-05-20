set fish_greeting ""

if status is-interactive
    # Commands to run in interactive sessions can go here
    neofetch
    
    if test -f "/etc/grc.fish";
        source /etc/grc.fish
    end
end
test -f (command -v lsd) &&alias ls="lsd"
