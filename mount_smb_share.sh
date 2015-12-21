#!/bin/bash

currentUser=$( ls -l /dev/console | awk '{print $3}' )

userHome=$( dscl . read /Users/$currentUser NFSHomeDirectory | awk '{print $NF}' )

#echo "$currentUser"
#echo "$userHome"



# Create the Share folder in the User's Desktop:
echo " "
echo "------------------------------------------------"
echo "Creating the Directory on the User's Desktop... "
echo "------------------------------------------------"

if [ -d $userHome/Desktop/win_share ]

	then
        echo "The Directory is there, not creating one."
	else
		cd $userHome/Desktop
		mkdir win_share
fi

# Mounting the SMB share:

echo " "
echo "* Please type the username : "
read name
echo "---------------------------"

echo " "
echo "* Please type the password : "
read -s pass 
echo "---------------------------"

echo " "
echo "Mounting the Windows Share ... "

#mount -t smbfs //admin:filewave@10.1.3.175/ShareTest $userHome/Desktop/win_share

# Change the IP address and Shared folder for the ones on you need: 

mount -t smbfs //$name:$pass@10.1.3.175/ShareTest $userHome/Desktop/win_share