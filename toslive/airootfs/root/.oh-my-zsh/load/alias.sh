#!/bin/bash
#generates aliases in the form of 1 (go to dir 1), 2 (go to dir 2 etc) to see a list of dirst use d
for code ({0..20}) ; do alias $code="cd -$code"; done  && alias d='dirs -v' && for code ({0..20}) ; do alias r$code="popd -$code"; done	


alias password='echo $(head -c 100 /dev/urandom | base64 | head -c 12)'

if [[ "$(command -v ccat)" != "" ]]; then
    alias cat='ccat'
fi

if [[ "$(which lsd)" == "/usr/bin/lsd" ]]; then
    alias ls='lsd'
fi

alias pdf='zathura'
alias md='typora'
alias neoshot="neofetch | sed -r 's:Public IP.*[0-9a-f]{2}:Public IP\: Blurred for screenshot purpose:'"
alias cpu="cat /proc/stat | grep 'cpu ' | awk '{print (\$2+\$3+\$4)/(\$2+\$3+\$4+\$5+\$6+\$7+\$8+\$9+\$10+\$11)*100 \"% usage\"}'"
alias ram="free -h | grep 'Mem:' | awk '{print \$3 \"/\" \$2}'"
alias disk="df -h | grep '/dev/.* ' | awk '{print \$1, \$5, (\$2)}'"


# Place more aliases here if you need them

