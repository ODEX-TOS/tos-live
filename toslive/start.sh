#!/bin/bash

# This is a simple script to build an iso image. It prepares the build directory and then starts the build
if [[ ! -f version.txt ]]; then
  ./version_builder.sh
fi
version=$(cat version.txt)
iso_version=$(date +%Y.%m.%d)
iso_azerty=$(echo toslinux-"$iso_version"-x86_64_azerty | tr '.' '-')
iso_normal=$(echo toslinux-"$iso_version"-x86_64 | tr '.' '-')
append=""

function build() {
  # Install needed dependencies
  if [[ "$(which mkarchiso)" != "/usr/bin/mkarchiso" ]]; then
    yay -Syu archiso || exit 1
  fi
  # do a complete remove of the working directory since we are building 2 different version in it
  rm -rf work

  ./build.sh -v || exit 1

  if [[ ! -d "images/server" ]]; then
    mkdir -p images/server
  fi

  if [[ ! -d "images/client" ]]; then
    mkdir -p images/client
  fi

  if [[ ! -d "images/kde" ]]; then
    mkdir -p images/kde
  fi

  if [[ ! -d "images/awesome" ]]; then
    mkdir -p images/awesome
  fi

  if [[ "$1" == "-g" ]]; then
    if [[ "$2" == "-a" ]]; then
      cp out/toslinux*.iso images/client/"$iso_azerty""$append".iso
      mv out/toslinux*.iso out/toslive-azerty.iso
    else
      cp out/toslinux*.iso images/client/"$iso_normal""$append".iso
      mv out/toslinux*.iso out/toslive.iso
    fi
  fi

  if [[ "$1" == "-k" ]]; then
    if [[ "$2" == "-a" ]]; then
      cp out/toslinux*.iso images/kde/"$iso_azerty""$append".iso
      mv out/toslinux*.iso out/toslive-kde-azerty.iso
    else
      cp out/toslinux*.iso images/kde/"$iso_normal""$append".iso
      mv out/toslinux*.iso out/toslive-kde.iso
    fi
  fi

  if [[ "$1" == "-awesome" ]]; then
    if [[ "$2" == "-a" ]]; then
      cp out/toslinux*.iso images/awesome/"$iso_azerty""$append".iso
      mv out/toslinux*.iso out/toslive-awesome-azerty.iso
    else
      cp out/toslinux*.iso images/awesome/"$iso_normal""$append".iso
      mv out/toslinux*.iso out/toslive-awesome.iso
    fi
  fi

  if [[ "$1" == "-s" ]]; then
    if [[ "$2" == "-a" ]]; then
      cp out/toslinux*.iso images/server/"$iso_azerty""$append".iso
      mv out/toslinux*.iso out/tosserver-azerty.iso
    else
      cp out/toslinux*.iso images/server/"$iso_normal""$append".iso
      mv out/toslinux*.iso out/tosserver.iso
    fi
  fi

}

if [[ "$1" == "-g" ]]; then
  cp customize_airootfs.sh_client airootfs/root/customize_airootfs.sh || exit 1
elif [[ "$1" == "-s" ]]; then
  cp customize_airootfs.sh_server airootfs/root/customize_airootfs.sh || exit 1
elif [[ "$1" == "-k" ]]; then
  cp customize_airootfs.sh_kde airootfs/root/customize_airootfs.sh || exit 1
elif [[ "$1" == "-awesome" ]]; then
  cp customize_airootfs.sh_awesome airootfs/root/customize_airootfs.sh || exit 1
fi

if [[ "$2" == "-a" ]]; then
  sed -i 's;azerty="0";azerty="1";' airootfs/root/customize_airootfs.sh || exit 1
else
  append="$2"
  sed -i 's;azerty="1";azerty="0";' airootfs/root/customize_airootfs.sh || exit 1
fi

if [[ "$3" != "" ]]; then
  append="$3"
fi
echo "$append"

if [[ "$1" == "-g" ]]; then
  sed -i 's;gui="0";gui="1";' airootfs/root/customize_airootfs.sh
  sed -i -r 's;version=".*";version="'"$version"'";' airootfs/root/customize_airootfs.sh
  cp packages.x86_64_client packages.x86_64
  build "$1" "$2"
fi

if [[ "$1" == "-k" ]]; then
  sed -i 's;gui="0";gui="1";' airootfs/root/customize_airootfs.sh
  sed -i -r 's;version=".*";version="'"$version"'";' airootfs/root/customize_airootfs.sh
  cp packages.x86_64_kde packages.x86_64
  build "$1" "$2"
fi

if [[ "$1" == "-awesome" ]]; then
  sed -i 's;gui="0";gui="1";' airootfs/root/customize_airootfs.sh
  sed -i -r 's;version=".*";version="'"$version"'";' airootfs/root/customize_airootfs.sh
  cp packages.x86_64_awesome packages.x86_64
  build "$1" "$2"
fi

if [[ "$1" == "-s" ]]; then
  sed -i 's;gui="1";gui="0";' airootfs/root/customize_airootfs.sh
  sed -i -r 's;version=".*";version="'"$version"'";' airootfs/root/customize_airootfs.sh
  cp packages.x86_64_server packages.x86_64
  build "$1" "$2"
fi

if [[ "$1" == "-h" ]]; then
  echo "-h | help message"
  echo "-s | compile iso in server mode"
  echo "-g | compile iso in gui mode "
  echo "-k | compile iso in kde mode "
  echo "-a | compile iso with azerty as keyboard layout (works with both -s and -g) This option must be the last option specified "
  exit 0
fi
