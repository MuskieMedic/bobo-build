#!/bin/bash
#set -e
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
SECONDS=0

buildFolder="$HOME/ArcoBobo-build"
outFolder="$HOME/ArcoBobo-OUT/XFCE"

desktop="xfce"

#build.sh
oldname1="iso_name=arcobobo"
newname1="iso_name=arcobobo-$desktop"

oldname2='iso_label="arcobobo'
newname2='iso_label="arcobobo-'$desktop

#os-release
oldname3='NAME="ArcoBobo"'
newname3='NAME=ArcoBobo-'$desktop

oldname4='ID=ArcoBobo'
newname4='ID=ArcoBobo-'$desktop

#lsb-release
oldname5='DISTRIB_ID=ArcoBobo'
newname5='DISTRIB_ID=ArcoBobo-'$desktop

oldname6='DISTRIB_DESCRIPTION="ArcoBobo"'
newname6='DISTRIB_DESCRIPTION=ArcoBobo-'$desktop

#hostname
oldname7='ArcoBobo'
newname7='ArcoBobo-'$desktop

#hosts
oldname8='ArcoBobo'
newname8='ArcoBobo-'$desktop

echo
echo "################################################################## "
tput setaf 2;echo "Phase 1 : clean up and download the latest ArcoLinux Bobo ISO from github";tput sgr0
echo "################################################################## "
echo
echo "Deleting the work folder if one exists"
[ -d ../work ] && rm -rf ../work
echo "Deleting the build folder if one exists - takes some time"
[ -d $buildFolder ] && sudo rm -rf $buildFolder
echo "Git cloning files and folder to work folder"
git clone https://github.com/PeterDauwe/bobo-iso ../work

echo
echo "################################################################## "
tput setaf 2;echo "Phase 2 : Getting the latest versions for some important files";tput sgr0
echo "################################################################## "
echo
echo "Removing the old packages.x86_64 file from work folder"
rm ../work/archiso/packages.x86_64
echo "Copying the new packages.x86_64 file"
cp -f archiso/packages.x86_64 ../work/archiso/packages.x86_64
cp -f archiso/packages.bobo ../work/archiso/packages.bobo
echo
echo "################################################################## "
tput setaf 2;echo "Phase 3 : Renaming the ArcoLinux iso";tput sgr0
echo "################################################################## "
echo
echo "Renaming to "$newname1
echo "Renaming to "$newname2
echo
sed -i 's/'$oldname1'/'$newname1'/g' ../work/archiso/build-bspwm.sh
sed -i 's/'$oldname2'/'$newname2'/g' ../work/archiso/build-bspwm.sh
sed -i 's/'$oldname3'/'$newname3'/g' ../work/archiso/airootfs/etc/os-release
sed -i 's/'$oldname4'/'$newname4'/g' ../work/archiso/airootfs/etc/os-release
sed -i 's/'$oldname5'/'$newname5'/g' ../work/archiso/airootfs/etc/lsb-release
sed -i 's/'$oldname6'/'$newname6'/g' ../work/archiso/airootfs/etc/lsb-release
sed -i 's/'$oldname7'/'$newname7'/g' ../work/archiso/airootfs/etc/hostname
sed -i 's/'$oldname8'/'$newname8'/g' ../work/archiso/airootfs/etc/hosts

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
sudo cp -r ../work/* $buildFolder

sudo chmod 750 ~/ArcoBobo-build/archiso/airootfs/etc/sudoers.d
sudo chmod 750 ~/ArcoBobo-build/archiso/airootfs/etc/polkit-1/rules.d
sudo chgrp polkitd ~/ArcoBobo-build/archiso/airootfs/etc/polkit-1/rules.d

echo "Deleting the work folder if one exists - clean up"
[ -d ../work ] && rm -rf ../work

cd $buildFolder/archiso


echo
echo "################################################################## "
tput setaf 2;echo "Phase 6 : Cleaning the cache";tput sgr0
echo "################################################################## "
echo

yes | sudo pacman -Scc

echo
echo "################################################################## "
tput setaf 2;echo "Phase 7 : Building the iso";tput sgr0
echo "################################################################## "
echo

sudo ./build-xfce.sh -v

echo
echo "################################################################## "
tput setaf 2;echo "Phase 8 : Moving the iso to out folder";tput sgr0
echo "################################################################## "
echo

[ -d $outFolder ] || mkdir -p $outFolder
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
