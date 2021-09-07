#!/usr/bin/env bash

# MIT License
# 
# Copyright (c) 2020 Tom Meyers
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

DB="tos.db.tar.gz"
TESTING_URL="https://testing.odex.be"
PROD_URL="https://repo.odex.be"

GPG_REPO_KEY="${GPG_REPO_KEY:-}"
if [[ "$GPG_REPO_KEY" == "" ]]; then
    echo "No repo key found! Please set the GPG_REPO_KEY env variable to the correct key"
fi


# Populate the variable DB_LIST with all files that are present in the database
function getDBList() {
  loc=$(mktemp -d)
  cp arch/"$DB" "$loc"
  tar -xzf "$loc/$DB" -C "$loc"
  # shellcheck disable=SC2044
  for file in $(find "$loc" -iname "desc"); do
    DB_LIST="$DB_LIST $(grep -A1 "%FILENAME%" "$file" | tail -n1)"
  done

  rm -rf "$loc"
}

# Populate the variable ARCH_LIST with all packages found in the arch directory
function getArchList() {
  # shellcheck disable=SC2044
  for location in $(find arch -iname "*.tar.zst"); do
    file="$(basename "$location")"
    ARCH_LIST="$ARCH_LIST $file"
  done
}

function addToRepo() {
    repo-add -p --verify --sign --key "$GPG_REPO_KEY" "arch/tos.db.tar.gz" "$1"
}

# try to find $1 in the testing repo and add it here, if it is not found then find it in the production repo, if it is still not found then we should abort and manual intervention is required
# set the resolved variable to "1" if found "0" otherwise
function resolve() {
    echo "$1 is missing trying to resolve it"
    resolved="0"
    curl "$TESTING_URL/$1" --output "arch/$1"
    curl "$TESTING_URL/$1.sig" --output "arch/$1.sig"
    if [[ -f "arch/$1" ]]; then
        echo "$1 found in the testing repo"
        resolved="1"
        addToRepo "arch/$1"
        return
    fi

    # fallback to normal repo
    curl "$PROD_URL/$1" --output "arch/$1"
    curl "$PROD_URL/$1.sig" --output "arch/$1.sig"
    if [[ -f "arch/$1" ]]; then
        echo "$1 found in the prod repo"
        resolved="1"
        addToRepo "arch/$1"
        return
    fi
}

getDBList
getArchList

# loop over the database list check if it exists in the ARCH_LIST
# if it doesn't exists that means we will be uploading something broken
for db_entry in $DB_LIST; do
  if ! echo "$ARCH_LIST" | grep -q "$db_entry"; then
    resolve "$db_entry"
    if [[ "$resolved" != "1" ]]; then
        echo "$db_entry not found"
        EXITCODE="1"
    fi
  fi
done

exit $EXITCODE
