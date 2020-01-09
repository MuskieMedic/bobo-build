#!/bin/bash
#set -e

buildFolder="$HOME/ArcoHefftor-build"
outFolder="$HOME/ArcoHefftor-Out"

cd $buildFolder/archiso

echo
echo "################################################################## "
tput setaf 2;echo "Phase 7 : Build ISO";tput sgr0
echo "################################################################## "
echo

sudo ./build.sh -v

echo
echo "################################################################## "
tput setaf 2;echo "Phase 8 : Moving the iso to out folder";tput sgr0
echo "################################################################## "
echo

[ -d $outFolder ] || mkdir $outFolder
cp $buildFolder/archiso/out/arcolinux* $outFolder

echo
echo "################################################################## "
tput setaf 2;echo "Phase 9 : Making sure we start with a clean slate next time";tput sgr0
echo "################################################################## "
echo
echo "Deleting the build folder if one exists - takes some time"
[ -d $buildFolder ] && sudo rm -rf $buildFolder
