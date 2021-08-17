#!/bin/bash
function minpower () {
        sudo cpupower frequency-set -u 400MHz #max freq
        sudo cpupower frequency-set -d 400MHz #min freq
        sudo cpupower frequency-set -g powersave # powersave between min and max
}

function maxpower () {
        sudo cpupower frequency-set -u 4GHz #max freq
        sudo cpupower frequency-set -d 400MHz #min freq
        sudo cpupower frequency-set -g performance # powersave between min and max
}


function avgpower () {
        sudo cpupower frequency-set -u 4GHz #max freq
        sudo cpupower frequency-set -d 400MHz #min freq
        sudo cpupower frequency-set -g powersave # powersave between min and max
}


#terminal based calculator
= () {
    local IFS=' '
    local calc="$*"
    # Uncomment the below for (p → +) and (x → *)
    #calc="${calc//p/+}"
    #calc="${calc//x/*}"
    printf '%s\n quit' "$calc" | gcalccmd | sed 's:^> ::g'
}

#Put the current command to the background
function background () { exec "$@" &> /dev/null &}

#determin file type and extract it fast
function extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }