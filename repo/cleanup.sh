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
# in other words grep '.zst$' | sort the files you wish to delete 
function clean {
        for i in ${@} ; do
                if [[ ! "${@: -1}" == "$i" ]]; then
                        echo "$i"
                        rm "$i"
			# also remove package signatures
			if [[ -f "$i".sig ]]; then
				rm "$i".sig
			fi
                fi
        done
}

# all files to grep '.zst$' | sort and only keep the last one

clean $(ls arch/i3-gaps-tos* | grep '.zst$' | sort)

clean $(ls arch/installer-backend* | grep '.zst$' | sort)

clean $(ls arch/installer-gui* | grep '.zst$' | sort)
clean $(ls arch/installer-cli* | grep '.zst$' | sort)
clean $(ls arch/installer-3* | grep '.zst$' | sort)

clean $(ls arch/linux-tos-5* | grep '.zst$' | sort)
clean $(ls arch/linux-tos-docs* | grep '.zst$' | sort)
clean $(ls arch/linux-tos-headers* | grep '.zst$' | sort)

clean $(ls arch/readme-generator-git* | grep '.zst$' | sort)
clean $(ls arch/shunit-git* | grep '.zst$' | sort)

clean $(ls arch/st-tos* | grep '.zst$' | sort)
clean $(ls arch/visual-studio-code-insiders* | grep '.zst$' | sort)

clean $(ls arch/tos-tools* | grep '.zst$' | sort)

clean $(ls arch/polybar-git-3.4.0.* | grep '.zst$' | sort)
clean $(ls arch/mcmojave-circle-icon-theme-git-* | grep '.zst$' | sort)

clean $(ls arch/tos-grub-theme-r* | grep '.zst$' | sort)

clean $(ls arch/skel-* | grep '.zst$' | sort)

clean $(ls arch/awesome-tos-* | grep '.zst$' | sort)

clean $(ls arch/picom-tryone-tos-* | grep '.zst$' | sort)

clean $(ls arch/tos-base-2-* | grep '.zst$' | sort)
clean $(ls arch/tos-base-desktop-* | grep '.zst$' | sort)
clean $(ls arch/tos-build-system-* | grep '.zst$' | sort)

clean $(ls arch/rofi-tos-* | grep '.zst$' | sort)
clean $(ls arch/pkgstats-* | grep '.zst$' | sort)
clean $(ls arch/psi-notify-* | grep '.zst$' | sort)
clean $(ls arch/otf-san-francisco-* | grep '.zst$' | sort)
clean $(ls arch/nerd-fonts-complete-* | grep '.zst$' | sort)
clean $(ls arch/libinput-gestures-tos-* | grep '.zst$' | sort)

clean $(ls arch/kernel-module-hook-* | grep '.zst$' | sort)
clean $(ls arch/filesystem-* | grep '.zst$' | sort)
clean $(ls arch/ckbcomp-tos-* | grep '.zst$' | sort)
