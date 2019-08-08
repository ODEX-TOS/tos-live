#!/bin/bash

# Build the current version based on the amount of commits. It makes sure the version is always unique
commit=$(git rev-list --count HEAD)
version=$(cat version-edit.txt)
echo "$version"-"$commit" > version.txt
