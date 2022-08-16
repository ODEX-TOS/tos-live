#!/bin/bash

if [[ "$1" == "-h" ]]; then
  echo "-h | help message"
  echo "-s | run server iso in qemu"
  echo "-t | run TDE iso in qemu"
  echo "-u | run it in UEFI mode"
  echo "-c | create the iso from scratch"
  exit 0
fi

TDE="1"
SERVER="0"
CREATE="0"
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
        "-c")
            CREATE="1"
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
    [[ "$CREATE" == "1" ]] && ( sudo ./start.sh -awesome || exit 1 )
elif [[ "$SERVER" == "1" ]]; then
    ISO="out/tosserver.iso"
    [[ "$CREATE" == "1" ]] && ( sudo ./start.sh -s || exit 1 )
fi

run_archiso $OPTS -i "$ISO"

exit 0
