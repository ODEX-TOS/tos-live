#!/bin/bash

# This file generates the package list html file.

repo="tos"
url="https://repo.pbfp.xyz"
infourl="https://tos.pbfp.xyz"
workdir="arch"
packages=$(pacman -Sl tos | tr " " "|" | cut -d\| -f 2)
packageversion=$(pacman -Sl tos | tr " " "|" | cut -d\| -f 3)

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
        </tr>

EOF


for package in $packages; do
 info=$(pacman -Si $package)
 desc=$(echo "$info" | head -n4 | tail -n1 | cut -d: -f2)
 vers=$(echo "$info" | head -n3 | tail -n1 | cut -d: -f2)
 download=$(echo "$info" | tail -n5 | head -n1 | cut -d: -f2)
 printf "\t\t<tr>\n" >> $file
 printf "\t\t\t<td>$package</td>\n" >> $file
 printf "\t\t\t<td>$vers</td>\n" >> $file
 printf "\t\t\t<td>$desc</td>\n" >> $file
 printf "\t\t\t<td>$download</td>\n" >> $file
 printf "\t\t</tr>\n" >> $file
done

printf "\t\t</table>\n" >> $file

printf "\n\t<a href=\"$infourl\">More info</a>\n" >> $file

printf "\t</body>\n</html>" >> $file
