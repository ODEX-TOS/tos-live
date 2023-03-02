#!/bin/bash

if [[ -z "$GPG_REPO_KEY" ]]; then
    source ~/.profile
fi

# Get the gpg expiry date
res=$(gpg --list-key "$GPG_REPO_KEY" | head -n1 | grep -Eo "expires: ([0-9]+-[0-9]+-[0-9]+)")

if [[ -n "$res" ]]; then
	echo "$res" > "arch/gpg-date.txt"
fi

gpg --export --armor "$GPG_REPO_KEY" > "arch/public.gpg"
