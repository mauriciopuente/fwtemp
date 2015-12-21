#!/bin/bash

temp=$(dscl . list /Users | grep -v ^_.*)

echo " ----------------------------------------------- "
echo " "
echo "These are the users on this Computer: "$temp
echo " "
echo " ----------------------------------------------- "
echo " "

echo "We will look for the Extension in the following places:"
for i in $temp
do
	echo "/Users/${i}/Library/Application Support/Google/Chrome/Default/Web Applications/_crx_omghfjlpggmjjaagoclmmobgdodcjboh/Default omghfjlpggmjjaagoclmmobgdodcjboh.app"
done 
echo " "
echo " ----------------------------------------------- "
echo " "

for i in $temp
do
	echo "Loooking for the Extension here:"
        echo "/Users/${i}/Library/Application Support/Google/Chrome/Default/Web Applications/_crx_omghfjlpggmjjaagoclmmobgdodcjboh/Default omghfjlpggmjjaagoclmmobgdodcjboh.app"
	if [ -f /Users/${i}/Library/Application\ Support/Google/Chrome/Default/Web\ Applications/_crx_omghfjlpggmjjaagoclmmobgdodcjboh/Default\ omghfjlpggmjjaagoclmmobgdodcjboh.app ]

	then
        	echo "Yes, The Extension is there"
		echo "Deleting Extension ... "
		sudo rm -rf /Users/${i}/Library/Application\ Support/Google/Chrome/Default/Web\ Applications/_crx_omghfjlpggmjjaagoclmmobgdodcjboh/Default\ omghfjlpggmjjaagoclmmobgdodcjboh.app
		echo ""
	else
        	echo "Extension not found!"
		echo "Doing nothing ... "
		echo ""
	fi
done