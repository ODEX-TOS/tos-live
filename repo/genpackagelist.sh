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

# This file generates the package list html file.

repo="tos"
url="https://repo.odex.be"
infourl="https://tos.odex.be"
workdir="arch"
packages=$(pacman -Sl tos | tr " " "|" | cut -d\| -f 2)
packageversion=$(pacman -Sl tos | tr " " "|" | cut -d\| -f 3)
EXT="xz"

file="$workdir/list.html"

cat <<-EOF > "$file"
<html>
    <head>
        <title>TOS packages</title>
        <style>
        table {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        td, th {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        tr:nth-child(even) {
            background-color: #dddddd;
        }
        a {
            background-color: #542cb7;
            color: white;
            padding: 5px 15px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            border-radius: 5px;
            margin-top: 10px;
        }
        </style>
    </head>
    <body>
    <h1>Packages</h1>
    <table>
        <tr>
            <th>Name</th>
            <th>Version</th>
            <th>Description</th>
            <th>Download size</th>
            <th>Package link</th>
        </tr>

EOF


for package in $packages; do
 echo "Scanning $package"
 info=$(pacman -Si $package)
 desc=$(echo "$info" | head -n4 | tail -n1 | cut -d: -f2)
 vers=$(echo "$info" | head -n3 | tail -n1 | cut -d: -f2 | sed -E 's/ +//g')
 download=$(echo "$info" | tail -n5 | head -n1 | cut -d: -f2 | sed -E 's/ +//g')
 link="$package-$vers.pkg.tar.$EXT"
 printf "\t\t<tr>\n" >> $file
 printf "\t\t\t<td>$package</td>\n" >> $file
 printf "\t\t\t<td>$vers</td>\n" >> $file
 printf "\t\t\t<td>$desc</td>\n" >> $file
 printf "\t\t\t<td>$download</td>\n" >> $file
 printf "\t\t\t<td><a href='$link' >file</a></td>\n" >> $file
 printf "\t\t</tr>\n" >> $file
done

printf "\t\t</table>\n" >> $file

printf "\n\t<a href=\"$infourl\">More info</a>\n" >> $file

printf "\t</body>\n</html>" >> $file

