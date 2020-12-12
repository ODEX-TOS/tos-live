#!/bin/bash

# MIT License
#
# Copyright (c) 2019 Meyers Tom
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

getDBList
getArchList

# loop over the database list check if it exists in the ARCH_LIST
# if it doesn't exists that means we will be uploading something broken
for db_entry in $DB_LIST; do
  if ! echo "$ARCH_LIST" | grep -q "$db_entry"; then
    echo "$db_entry not found"
    EXITCODE="1"
  fi
done

exit $EXITCODE
