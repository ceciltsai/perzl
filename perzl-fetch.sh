#!/bin/bash

RPM=$1
DEP=$(echo $1 | sed s/rpm/deps/)
FOLDER=$(echo $1 | sed s/.rpm//)

read -p "AIX version you want? > [AIX 72/71/61/53] " VER
if [[ $VER -eq "61" || $VER -eq "71" || $VER -eq "72" || $VER -eq "53" ]]; then
    DL_URL="http://www.oss4aix.org/download/rpmdb/deplists/aix${VER}/"
else
    echo "not support version, quit"
    exit 0
fi

wget $DL_URL/$DEP -q
cat $DEP
read -p "      will be downloaded, preess Y to proceed (Y/N): " ANS
if [[ $ANS != [yY] ]]; then 
    rm $DEP
    exit 0
fi

mkdir ./$FOLDER ; cd $FOLDER
wget http://www.oss4aix.org/download/everything/RPMS/$RPM -q --show-progress
wget -B http://www.oss4aix.org/download/everything/RPMS/ -i ../$DEP -q --show-progress

cd ..
env COPYFILE_DISABLE=true /usr/bin/tar -zpcf aix${VER}_${RPM}.tar.gz $FOLDER
rm $DEP ; rm -rf ./$FOLDER 


