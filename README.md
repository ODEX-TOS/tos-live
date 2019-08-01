```
 ,--.--------.   _,.---._      ,-,--.  
/==/,  -   , -\,-.' , -  `.  ,-.'-  _\ 
\==\.-.  - ,-./==/_,  ,  - \/==/_ ,_.' 
 `--`\==\- \ |==|   .=.     \==\  \    
      \==\_ \|==|_ : ;=:  - |\==\ -\   
      |==|- ||==| , '='     |_\==\ ,\  
      |==|, | \==\ -    ,_ //==/\/ _ | 
      /==/ -/  '.='. -   .' \==\ - , / 
      `--`--`    `--`--''    `--`---' 

```

# TOS Live

[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/built-by-developers.svg)](https://forthebadge.com)
[![forthebadge](https://forthebadge.com/images/badges/you-didnt-ask-for-this.svg)](https://forthebadge.com)

> This repo contains the build for TOS (Tom OS live iso)

## Prerequisite

- archiso

### Install
```
$ sudo pacman -Syu archiso
```

## Explanation

- airootfs
    - airootfs contains the bare build of our root file system
    - airootfs/root is the root directory (of the user root)
    - cumstomize_airootfs.sh will be executed during the build on a chrooted environment
- packages.x86_64_client
    - This file contains all the preinstalled packages necessary for this live iso to work (desktop variant)
- packages.x86_64_server
    - This file contains all the preinstalled packages necessary for this live iso to work (server variant)
- work
    - This directory contains the file system after all the packages are installed and all scripts are executed
- out
    - This directory contains our build output (the iso file)

## usage

clone this repo and cd into it

Before building the iso you have to setup a custom repo and point towards it inside the pacman.conf file
```
cd $rootdir/repo
bash build.sh # this will build all packages and add it to the local repo located in $rootdir/repo/arch/*
```

Now you can start generating a html file containing all packages in the repo
```
./genpackagelist.sh
```

Now you have to add the local repo in the pacman.conf
In this file you will have a section

```
[tos]
 SigLevel = Optional TrustAll
 Server = file:///home/zetta/tos/repo/arch/
```
Alternativly you can use the prebuild repo provided by us
```
[tos]
 SigLevel = Optional TrustAll
 Server = https://repo.pbfp.xyz
```
Change the file with Server = file:// to point towards $rootdir/repo/arch


```
sudo start.sh -g # build graphical iso
sudo start -s # build server iso
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
