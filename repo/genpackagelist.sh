#!/bin/bash

# This file generates the package list html file.

repo="tos"
url="https://repo.pbfp.xyz"
infourl="https://tos.pbfp.xyz"
workdir="arch"
packages=$(pacman -Sl tos | tr " " "|" | cut -d\| -f 2)

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
            <th>Description</th>
        </tr>

EOF


for package in $packages; do
 desc=$(pacman -Ss $package | head -n2 | tail -n1)
 printf "\t\t<tr>\n" >> $file
 printf "\t\t\t<td>$package</td>\n" >> $file
 printf "\t\t\t<td>$desc</td>\n" >> $file
 printf "\t\t</tr>\n" >> $file
done

printf "\t\t</table>\n" >> $file

printf "\n\t<a href=\"$infourl\">More info</a>\n" >> $file

printf "\t</body>\n</html>" >> $file
