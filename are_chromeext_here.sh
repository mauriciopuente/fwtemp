#!/bin/bash

temp=$(ls /Users | grep -v ".localized" | grep -v "Shared")

for i in $temp
do

#echo "The user is --> ${i}"
if [ "$(ls -A /Users/${i}/Library/Application\ Support/Google/Chrome/Default/Extensions)" ]; then
	echo "Not Empty"
fi
done


#if [ "$(ls -A /Users/admin/Library/Application\ Support/Google/Chrome/Default/Extensions)" ]; then
