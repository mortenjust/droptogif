#!/bin/bash

thisdir=$1
filepath=$2 # changed to $2 since $1 now contains the working folder
#fps=$3
#filter=$4
#magickoptions=$5
#alphaColor=$6

#echo "mj.getsize running!"
#echo "$ffmpeg" -i "$filepath" 2>&1 | grep Stream

ffmpeg=$thisdir/ffmpeg
"$ffmpeg" -i "$filepath" 2>&1 | grep Stream