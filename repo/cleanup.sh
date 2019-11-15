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

# $@ should be a list of items. We will delete all of them except for the last entry
# in other words sort the files you wish to delete 
function clean {
        for i in ${@} ; do
                if [[ ! "${@: -1}" == "$i" ]]; then
                        echo "$i"
                        rm "$i"
                fi
        done
}

# all files to sort and only keep the last one

clean $(ls arch/i3-gaps-tos* | sort)

clean $(ls arch/installer-backend* | sort)

clean $(ls arch/installer-gui* | sort)
clean $(ls arch/installer-cli* | sort)
clean $(ls arch/installer-3* | sort)

clean $(ls arch/linux-tos-5* | sort)
clean $(ls arch/linux-tos-docs* | sort)
clean $(ls arch/linux-tos-headers* | sort)

clean $(ls arch/readme-generator-git* | sort)
clean $(ls arch/shunit-git* | sort)

clean $(ls arch/st-tos* | sort)
clean $(ls arch/visual-studio-code-insiders* | sort)

clean $(ls arch/tos-tools* | sort)

clean $(ls arch/polybar-git-3.4.0.* | sort)
clean $(ls arch/mcmojave-circle-icon-theme-git-* | sort)

clean $(ls arch/tos-grub-theme-r* | sort)

clean $(ls arch/skel-* | sort)

clean $(ls arch/awesome-tos-* | sort)


