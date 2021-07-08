#!/bin/bash

if [[ "$1" == "-h" ]]; then
  echo "-h | help message"
  echo "-s | run server iso in qemu"
  echo "-t | run TDE iso in qemu"
  echo "-u | run it in UEFI mode"
  exit 0
fi

TDE="1"
SERVER="0"
OPTS=""

# TODO: verify that QEMU is installed, and when UEFI is enabled that edk2-ovmf is installed

while [[ "$1" != "" ]]; do
    case "$1" in
        "-s")
            SERVER="1"
            TDE=""
            shift
        ;;
        "-t")
            TDE="1"
            SERVER=""
            shift
        ;;
        "-u")
            OPTS="$OPTS -u"
            shift
        ;;
        **)
            echo "Unknown option $1"
            shift
        ;;
    esac
done

if [[ "$TDE" == "1" ]]; then
    ISO="out/toslive-awesome.iso"
elif [[ "$SERVER" == "1" ]]; then
    ISO="out/tosserver.iso"
fi

run_archiso $OPTS -i "$ISO"

exit 0