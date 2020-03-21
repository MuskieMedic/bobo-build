#!/bin/bash
#set -e
SECONDS=0

buildFolder="$HOME/bobo-build"
betweenfolder="$HOME/BOBOLINUX"
outFolder="$HOME/BOBOLINUX/xfce"




echo
echo "################################################################## "
tput setaf 2;echo "Phase 1 : clean up and download the latest ArcoLinux Bobo ISO from github";tput sgr0
echo "################################################################## "
echo
echo "Deleting the work folder if one exists"
[ -d work ] && rm -rf work
echo "Deleting the build folder if one exists - takes some time"
[ -d $buildFolder ] && sudo rm -rf $buildFolder
echo "Git cloning files and folder to work folder"
git clone https://github.com/PeterDauwe/bobo-iso work

echo
echo "################################################################## "
tput setaf 2;echo "Phase 2 : Getting the latest versions for some important files";tput sgr0
echo "################################################################## "
echo
echo "Removing the old packages.x86_64 file from work folder"
rm work/archiso/packages.x86_64
echo "Copying the new packages.x86_64 file"
cp -f archiso/packages.x86_64 work/archiso/packages.x86_64
cp -f archiso/packages.bobo work/archiso/packages.bobo
echo

echo "################################################################## "
tput setaf 2;echo "Phase 4 : Checking if archiso is installed";tput sgr0
echo "################################################################## "
echo

package="archiso"

#----------------------------------------------------------------------------------

#checking if application is already installed or else install with aur helpers
if pacman -Qi $package &> /dev/null; then

		echo "################################################################"
		echo "################## "$package" is already installed"
		echo "################################################################"

else

	#checking which helper is installed
	if pacman -Qi yay &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with yay"
		echo "################################################################"
		yay -S --noconfirm $package

	elif pacman -Qi trizen &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with trizen"
		echo "################################################################"
		trizen -S --noconfirm --needed --noedit $package

	fi

	# Just checking if installation was successful
	if pacman -Qi $package &> /dev/null; then

		echo "################################################################"
		echo "#########  "$package" has been installed"
		echo "################################################################"

	else

		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		echo "!!!!!!!!!  "$package" has NOT been installed"
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		exit 1
	fi

fi

echo
echo "################################################################## "
tput setaf 2;echo "Phase 5 : Moving files to build folder";tput sgr0
echo "################################################################## "
echo

echo "Copying files and folder to build folder as root"
sudo mkdir $buildFolder
sudo cp -r work/* $buildFolder

sudo chmod 750 ~/bobo-build/archiso/airootfs/etc/sudoers.d
sudo chmod 750 ~/bobo-build/archiso/airootfs/etc/polkit-1/rules.d
sudo chgrp polkitd ~/bobo-build/archiso/airootfs/etc/polkit-1/rules.d

echo "Deleting the work folder if one exists - clean up"
[ -d work ] && rm -rf work

cd $buildFolder/archiso


echo
echo "################################################################## "
tput setaf 2;echo "Phase 6 : Cleaning the cache";tput sgr0
echo "################################################################## "
echo

yes | sudo pacman -Scc

echo
echo "################################################################## "
tput setaf 2;echo "Phase 7 : Build ISO";tput sgr0
echo "################################################################## "
echo

sudo ./build-xfce.sh -v

echo
echo "################################################################## "
tput setaf 2;echo "Phase 8 : Moving the iso to out folder";tput sgr0
echo "################################################################## "
echo

[ -d $betweenfolder ] || mkdir $betweenfolder
[ -d $outFolder ] || mkdir $outFolder

cp $buildFolder/archiso/out/arco* $outFolder


if (( $SECONDS > 3600 )) ; then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $hours hour(s), $minutes minute(s) and $seconds second(s)" 
elif (( $SECONDS > 60 )) ; then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $minutes minute(s) and $seconds second(s)"
else
    echo "Completed in $SECONDS seconds"
fi
echo
echo "################################################################## "
tput setaf 2;echo "Phase 9 : Making sure we start with a clean slate next time";tput sgr0
echo "################################################################## "
echo
echo "Deleting the build folder if one exists - takes some time"
[ -d $buildFolder ] && sudo rm -rf $buildFolder
