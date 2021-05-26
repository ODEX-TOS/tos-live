#!/bin/bash

# Get the gpg expiry date
gpg --list-key "$GPG_REPO_KEY" | head -n1 | grep -Eo "expires: ([0-9]+-[0-9]+-[0-9]+)" > arch/gpg-date.txt
