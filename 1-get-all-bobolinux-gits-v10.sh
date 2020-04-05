#!/bin/bash
#
##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	Erik Dubois
# Website 	: 	http://www.erikdubois.be
##################################################################################################################
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

echo "This updates the existing githubs"
echo "Fill the array with the original folders first"

# use ls -d */ > list to get the list of the created githubs and copy/paste in

directories=(
arcolinux-welcome-app/
bobo-betterlockscreen-cache/
bobo-bibata-cursors/
bobo-bspwm/
bobo-bspwm-calamares-config/
bobo-bspwm-config/
bobo-bspwm-dconf/
bobo-bspwm-local/
bobo-build/
bobo-candy-icons/
bobo-cinnamon/
bobo-cinnamon-calamares-config/
bobo-cinnamon-config/
bobo-cinnamon-dconf/
bobo-cinnamon-root/
bobo-conky/
bobo-flat-remix-theme/
bobo-gimp/
bobo-grub-theme-vimix/
bobo-hlwm/
bobo-hlwm-calamares-config/
bobo-hlwm-config/
bobo-hlwm-dconf/
bobo-i3-calamares-config/
bobo-i3wm/
bobo-i3wm-config/
bobo-i3wm-dconf/
bobo-iso/
bobo-juno-themes/
bobo-kashmir-blue-theme/
bobo-lightdm-gtk-greeter/
bobo-lightdm-gtk-greeter-settings/
bobo-mac-theme/
bobo-pkgbuild/
bobo-plank/
bobo-plank-top/
bobo-polybar/
bobo-ranger-config/
bobo-repo/
bobo-root/
bobo-system-installation/
bobo-tela-blue-icons/
bobo-test-build/
bobo-test-repo/
bobo-variety/
bobo-wallpapers/
bobo-xfce/
bobo-xfce-bspwm-calamares-config/
bobo-xfce-calamares-config/
bobo-xfce-config/
bobo-xfce-dconf/
bobo-xfce-local/
bobo-xfce4-panel-profiles/
)

count=0

for name in "${directories[@]}"; do
	count=$[count+1]
	tput setaf 1;echo "Github "$count;tput sgr0;
	# if there is no folder then make one
	git clone https://github.com/PeterDauwe/$name
	echo "#################################################"
	echo "################  "$(basename `pwd`)" done"
	echo "#################################################"
done
