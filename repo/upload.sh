#!/bin/bash

# This script will take the content of arch/* and upload it to the TOS server.
if [[ "$1" != "-y" ]]; then
  read -p "Only upload if this is a full repo otherwise the repo database is wrong"
fi
rsync -rl arch root@pbfp.xyz:/root/repo/
