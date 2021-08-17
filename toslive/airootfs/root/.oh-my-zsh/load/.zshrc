# .zshrc file
# If you want to add ENV variable please add them to the ~/.profile file

if [[ "$(tty)" == "/dev/tty1" ]]; then
    source ~/.profile
    source swayfig.sh
fi

function load() {
  for script in $(ls $1)
  do
    LOC=$1"/"$script
    if [ -f $LOC ]; then
      #only load a file that is an sh extentions
      if [[ $LOC == *.sh ]]; then
        . $LOC
      fi
    fi
  done
}

#load every script that needs to load before the oh my zsh framework
load $ZSH_PRELOAD

#load the oh my zsh framework
source $ZSH/oh-my-zsh.sh

#load every other script after the oh my zsh framework (thus we can use its functions) 
load $ZSH_LOAD

#print neofetch a terminal information tool
neofetch
