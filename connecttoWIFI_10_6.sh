#!/bin/bash

exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

interface=$( networksetup -listallhardwareports | grep -i -A 1 "Wi-Fi" | grep -v "Hardware" | awk {'print $2'} )

networksetup -removepreferredwirelessnetwork $interface "FileWave USA"

networksetup -addpreferredwirelessnetworkatindex $interface "FileWave USA" 0 WPA2 Indy1175Creek

networksetup -setnetworkserviceenabled AirPort off
sleep 2
networksetup -setnetworkserviceenabled AirPort on