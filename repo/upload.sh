#!/bin/bash

# This script will take the content of arch/* and upload it to the TOS server.

read -p "Only upload if this is a full repo otherwise the repo database is wrong"
rsync -rl arch root@pbfp.xyz:/root/repo/
