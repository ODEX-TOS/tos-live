<h1 align="center">Welcome to zsh-load 👋</h1>

### 🏠 [Homepage](https://tos.pbfp.xyz)

## explanation
zsh-load is a small framework that you can add to zsh (or other shells) that automatically executes multiple shell scripts when starting a shell.
The framework has a specific layout for specific purposes.

* load
  * all shell files in load will be executed after oh-my-zsh is loaded
* load/preload
  * all shell files in preload will be executed before oh-my-zsh is loaded

The reason preload exists is to setup the execution of another framework.

## Install
Clone this directory inside `oh-my-zsh` homedir

Add the following lines to your .zshrc

```sh
# These variables should be in the .profile file
export ZSH_LOAD=$ZSH/load
export ZSH_PRELOAD=$ZSH_LOAD/preload

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
```

To setup the effect of `load` and `preload` do the following in your `.zshrc`

```sh
#load every script that needs to load before the oh my zsh framework
load $ZSH_PRELOAD

#load the oh my zsh framework
source $ZSH/oh-my-zsh.sh

#load every other script after the oh my zsh framework (thus we can use its functions)
load $ZSH_LOAD
```

A demo .zshrc file is provided in the repo

## Usage
Simply add shell files to both directories `load or preload` in order for them to executed during shell launch


## Author

👤 **Tom Meyers**

* Github: [@F0xedb](https://github.com/F0xedb)

## Show your support

Give a ⭐️ if this project helped you!

---

