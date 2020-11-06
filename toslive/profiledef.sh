#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="toslinux"
iso_label="TOS_$(date +%Y%m)"
iso_publisher="TOS Linux <https://tos.odex.be>"
iso_application="TOS Linux Live/Rescue CD"
iso_version="$(date +%Y.%m.%d)"
install_dir="tos"
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
