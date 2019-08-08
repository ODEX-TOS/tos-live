#!/bin/bash

commit=$(git rev-list --count HEAD)
version=$(cat version-edit.txt)
echo "$version"-"$commit" > version.txt
