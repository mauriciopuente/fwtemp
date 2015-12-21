#!/bin/bash

#temp=$(networksetup -listallnetworkservices | grep -i -E "eth|thun|wi")

#echo " ----------------------------------------------- "
#echo " "
#echo "These are the Network Interfaces on this Computer: "$temp
#echo " "
#echo " ----------------------------------------------- "
#echo " "


#for i in $temp
#do
#	networksetup -setautoproxyurl '${i}' http://ls.zebras.net/macbook.pac
#done


#networksetup -setautoproxyurl Ethernet http://ls.zebras.net/macbook.pac
networksetup -setautoproxyurl 'Thunderbolt Ethernet' http://ls.zebras.net/macbook.pac
networksetup -setautoproxyurl 'Wi-Fi' http://ls.zebras.net/macbook.pac
networksetup -setautoproxyurl 'Ethernet' http://ls.zebras.net/macbook.pac
