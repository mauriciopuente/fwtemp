#!/bin/bash

# Author: r.purves@arts.ac.uk
# Version 1.0 : 18-10-2013 - Initial version
# Version 1.1 : 29-10-2013 - Moved Recovery HD mount/dismount into their own functions for easy access
# Version 1.2 : 29-10-2013 - OS Version checking because Recovery path changes

# Changes by FW Mike Jans mikej@filewave.com
# Version 1.3 : 09-09-2014 - Added Support for Yosemite, added Information for Client Logfile
# Version 1.4 : 01-10-2014 - Parameter fixes & Adding bless command to prevent inability to boot

# Set up path variables for easy access and change

PathDiskOne='/Volumes/Mac OS X Base System'
PathDiskTwo='/Volumes/OS X Base System'

toolpath='Applications/Utilities/Firmware Password Utility.app/Contents/Resources/setregproptool'
recoverydmg='/Volumes/Recovery HD/com.apple.recovery.boot/BaseSystem.dmg'
recoverydiskname="Recovery HD"

# Set up working variables from info passed to the script

# This will determine how the script functions.
# Accepted inputs are as follows:
# initial	- This will install the first EFI password on the system. This requires the security mode to be supplied.
# change	- This will change the EFI password as long as the correct old password is supplied.
# remove	- This will remove the EFI password as long as the correct old password is supplied.
operatingmode=$1

# Get password details in the next two variables
fwpassnew=$3
fwpassold=$4 

# Get the security mode. Required for the "initial" operating mode.
# Acceptable inputs are as follows:
# full		- This will require password entry on every boot
# command	- This only requires password entry if boot picker is invoked with alt key.
fwmode=$2

# Which OS is this running on?

getXver=$( sw_vers -productVersion | awk -F. '{print $2}' )

# Ok now let's set up the functions in bash to open and close the recovery partition.

function openrecovery {
	if [ ${getXver} -eq 8 ];
		then
			/usr/sbin/diskutil mount "$recoverydiskname"
			/usr/bin/hdiutil attach -quiet -nobrowse "$recoverydmg"
      echo "FileWave Firmware Password Status: OK, Recoverydisk Opened " >> /var/log/fwcld.log
		elif [ ${getXver} -eq 9 ]
		then
			/usr/sbin/diskutil mount "$recoverydiskname"
			/usr/bin/hdiutil attach -quiet -nobrowse "$recoverydmg"
      echo "FileWave Firmware Password Status: OK, Recoverydisk Opened " >> /var/log/fwcld.log
		elif [ ${getXver} -eq 10 ] || [ ${getXver} -eq 11 ]
		then
			/usr/sbin/diskutil mount "$recoverydiskname"
			/usr/bin/hdiutil attach -quiet -nobrowse "$recoverydmg"
      echo "FileWave Firmware Password Status: OK, Recoverydisk Opened " >> /var/log/fwcld.log
		else
			echo "FileWave Firmware Password Error: Sorry something went wrong with your os! "${getXver} >> /var/log/fwcld.log
			exit 1
	fi
}

function closerecovery {
	if [ ${getXver} -eq 8 ];
		then
			/usr/bin/hdiutil detach "$PathDiskOne"
			/usr/sbin/diskutil unmount "$recoverydiskname"
      echo "FileWave Firmware Password Status: OK, Recoverydisk Closed " >> /var/log/fwcld.log
		elif [ ${getXver} -eq 9 ]
		then
			/usr/bin/hdiutil detach "$PathDiskTwo"
			/usr/sbin/diskutil unmount "$recoverydiskname"
      echo "FileWave Firmware Password Status: OK, Recoverydisk Closed " >> /var/log/fwcld.log
		elif [ ${getXver} -eq 10 ] || [ ${getXver} -eq 11 ]
		then
			/usr/bin/hdiutil detach "$PathDiskTwo"
			/usr/sbin/diskutil unmount "$recoverydiskname"
      echo "FileWave Firmware Password Status: OK, Recoverydisk Closed " >> /var/log/fwcld.log
		else
			echo "FileWave Firmware Password Error: There is a problem with your OS Version, needs to be 10.8-10.10! "${getXver} >> /var/log/fwcld.log
			exit 1
	fi
}

# First of all, check the OS to see if this is supported or not. Less than 10.8 is not supported.

if [[ ${getXver} -lt 8 ]];
then
	echo "FileWave Firmware Password Error: Sorry OS is to old for a FW password" >> /var/log/fwcld.log
	exit 1
fi

# Now depending on specified mode, sanity check and run the appropriate commands

case "$operatingmode" in

	initial)
		# Check to see if the security mode has been specified properly. Exit if not as command will fail.

		if [[ "$fwmode" == "" ]]; then
			echo "FileWave Firmware Password Error: Missing security mode in policy. e.g. full" >> /var/log/fwcld.log
			exit 1
		fi		
		
		if [[ "$fwmode" != "full" && "$fwmode" != "command" ]]; then
			echo "FileWave Firmware Password Error: Incorrect security mode specified in policy. e.g. full" >> /var/log/fwcld.log
			exit 1
		fi				

		# Bless the current Startup Volume and set it as Boot Volume to prevent inability to locate startup volume
		bless --mount / --setBoot

		# Mount the Recovery partition

		openrecovery
					
		# Enable the EFI password

		if [ ${getXver} -eq 8 ];
			then
			"$PathDiskOne/$toolpath" -c;
			if [ $? -eq 1 ]; then 
				echo "Firmware password not set. Setting it now ... " >> /var/log/fwcld.log
				"$PathDiskOne/$toolpath" -p $fwpassnew -m $fwmode
				echo "FileWave Firmware Password Status: FirmWare Password set correctly " >> /var/log/fwcld.log
			else echo "Firmware password previously set." >> /var/log/fwcld.log
			fi

		elif [ ${getXver} -eq 9 ]
			then
			"$PathDiskTwo/$toolpath" -c;
			if [ $? -eq 1 ]; then 
				echo "Firmware password not set. Setting it now ... " >> /var/log/fwcld.log
				"$PathDiskTwo/$toolpath" -p $fwpassnew -m $fwmode
				echo "FileWave Firmware Password Status: FirmWare Password set correctly " >> /var/log/fwcld.log
			else echo "Firmware password previously set." >> /var/log/fwcld.log
			fi
			
		elif [ ${getXver} -eq 10 ] || [ ${getXver} -eq 11 ]
			then
			"$PathDiskTwo/$toolpath" -c;
			if [ $? -eq 1 ]; then 
				echo "Firmware password not set. Setting it now ... " >> /var/log/fwcld.log
				"$PathDiskTwo/$toolpath" -p $fwpassnew -m $fwmode
				echo "FileWave Firmware Password Status: FirmWare Password set correctly " >> /var/log/fwcld.log
			else echo "Firmware password previously set." >> /var/log/fwcld.log
			fi
		
		else
			echo "FileWave Firmware Password Error: setregproptool: I've no idea what this OS version is! "${getXver} >> /var/log/fwcld.log
			exit 1
		fi
		
		# Unmount the Recovery partition
		
		closerecovery

	;;
	
	change)
		# Check if new password has been specified properly.
		
		if [[ "$fwpassnew" == "" ]]; then
			echo "FileWave Firmware Password Error: Missing new password in policy." >> /var/log/fwcld.log
			exit 1
		fi			

		# Check if old password has been specified properly.
		
		if [[ "$fwpassold" == "" ]]; then
      echo "FileWave Firmware Password Error: Missing old password in policy." >> /var/log/fwcld.log
			exit 1
		fi			

		# Check to see if the security mode has been specified properly. Exit if not as command will fail.

		if [[ "$fwmode" == "" ]]; then
      echo "FileWave Firmware Password Error: Missing security mode in policy. e.g. full" >> /var/log/fwcld.log
			exit 1
		fi		
		
		if [[ "$fwmode" != "full" && "$fwmode" != "command" ]]; then
      echo "FileWave Firmware Password Error: Incorrect security mode specified in policy. e.g. full" >> /var/log/fwcld.log
			exit 1
		fi	

		# Mount the Recovery partition

		openrecovery

		# Change the EFI password

		if [ ${getXver} -eq 8 ];
			then
				"$PathDiskOne/$toolpath" -m $fwmode -p $fwpassnew -o $fwpassold
        echo "FileWave Firmware Password Status: Firmware Password change OK" >> /var/log/fwcld.log
			elif [ ${getXver} -eq 9 ]
			then
				"$PathDiskTwo/$toolpath" -m $fwmode -p $fwpassnew -o $fwpassold
        echo "FileWave Firmware Password Status: Firmware Password change OK" >> /var/log/fwcld.log
			elif [ ${getXver} -eq 10 ] || [ ${getXver} -eq 11 ]
			then
				"$PathDiskTwo/$toolpath" -m $fwmode -p $fwpassnew -o $fwpassold
        echo "FileWave Firmware Password Status: Firmware Password change OK" >> /var/log/fwcld.log
			else
        echo "FileWave Firmware Password Error: setregproptool: Tool version different from os! "${getXver} >> /var/log/fwcld.log
				exit 1
		fi
		
		# Unmount the Recovery partition
		
		closerecovery
		
	;;
	
	remove)
		# Check if old password has been specified properly.
		
		if [[ "$fwpassold" == "" ]]; then
      echo "FileWave Firmware Password Error: Missing old password in policy." >> /var/log/fwcld.log
			exit 1
		fi				

		# Mount the Recovery partition

		openrecovery
	
		# Remove the EFI password

		if [ ${getXver} -eq 8 ];
			then
				"$PathDiskOne/$toolpath" -d -o $fwpassold
        echo "FileWave Firmware Password Status: Firmware Password removed OK" >> /var/log/fwcld.log
			elif [ ${getXver} -eq 9 ]
			then
				"$PathDiskTwo/$toolpath" -d -o $fwpassold
        echo "FileWave Firmware Password Status: Firmware Password removed OK" >> /var/log/fwcld.log
			elif [ ${getXver} -eq 10 ] || [ ${getXver} -eq 11 ]
			then
				"$PathDiskTwo/$toolpath" -d -o $fwpassold
        echo "FileWave Firmware Password Status: Firmware Password removed OK" >> /var/log/fwcld.log
			else
        echo "FileWave Firmware Password Error: setregproptool: I've no idea what this OS version is! "${getXver} >> /var/log/fwcld.log
				exit 1
		fi
		
		# Unmount the Recovery partition
		
		closerecovery
			
	;;
	
	*)
		# This should only activate if the operating mode hasn't been specified properly.
    echo "FileWave Firmware Password Error: Incorrect operating mode specified in policy. e.g. initial, change or remove" >> /var/log/fwcld.log
	;;
esac

# All done!

exit 0