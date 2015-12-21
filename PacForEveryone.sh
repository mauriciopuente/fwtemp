#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log


temp=$(ls /Users | grep -v ".localized" | grep -v "Shared")

echo " ----------------------------------------------- "
echo " "
echo "These are the users on this Computer: "$temp
echo " "
echo " ----------------------------------------------- "
echo " "



for i in $temp
do

	sudo -u ${i} networksetup -setautoproxyurl 'Thunderbolt Ethernet' http://rocket.newpal.k12.in.us/pac/tier1/pac/proxy.pac
	sudo -u ${i} networksetup -setautoproxyurl 'Wi-Fi' http://rocket.newpal.k12.in.us/pac/tier1/pac/proxy.pac
	sudo -u ${i} networksetup -setautoproxyurl 'Ethernet' http://rocket.newpal.k12.in.us/pac/tier1/pac/proxy.pac
	
done

#sudo networksetup -setautoproxyurl "Wi-Fi" "http://rocket.newpal.k12.in.us/pac/tier1/pac/proxy.pac"

