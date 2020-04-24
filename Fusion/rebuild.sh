#!/bin/bash
#set -e


SECONDS=0


buildFolder="$HOME/arcobobo-build"
outFolder="$HOME/arcobobo-Out/Fusion"

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
