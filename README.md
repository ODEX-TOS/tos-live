```
 ________  ________  ________  ___  ________  _________  ________
|\   ____\|\   ____\|\   __  \|\  \|\   __  \|\___   ___\\   ____\
\ \  \___|\ \  \___|\ \  \|\  \ \  \ \  \|\  \|___ \  \_\ \  \___|_
 \ \_____  \ \  \    \ \   _  _\ \  \ \   ____\   \ \  \ \ \_____  \
  \|____|\  \ \  \____\ \  \\  \\ \  \ \  \___|    \ \  \ \|____|\  \
    ____\_\  \ \_______\ \__\\ _\\ \__\ \__\        \ \__\  ____\_\  \
   |\_________\|_______|\|__|\|__|\|__|\|__|         \|__| |\_________\
   \|_________|                                            \|_________|

```

# helper scripts

[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/built-by-developers.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/you-didnt-ask-for-this.svg)](https://forthebadge.com)

> This repo contains the build for TOS (Tom OS live iso)

## Prerequesite

- archiso

### Install
```
$ sudo pacman -Syu archiso
```

## Explanation

- airootfs
    - airootfs contains the bare build of our root file system
    - airootfs/root is the root directory (of the user root)
    - comstomize_airootfs.sh will be executed during the build on a chrooted environment
- packages.x86_64
    - This file contains all the preinstalled packages necessary for this live iso to work
- work
    - This directory contains the filesystem after all the packages are installed and all scripts are executed
- out
    - This directory contains our build output (the iso file)

## usage

clone this repo and cd into it
```
sudo start.sh
```

after running the above script you will have a working iso located in the out directory.
Now you need to burn it onto a cd/dvd/usb

The drive you need can be found using the following command
```
lsblk
```
Now burn it of= should contain the path to said drive
```
sudo dd if=out/*.iso of=/dev/sd<drive>
```

