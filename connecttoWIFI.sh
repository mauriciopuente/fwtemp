#!/bin/bash

exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

interface=$( networksetup -listallhardwareports | grep -i -A 1 "Wi-Fi" | grep -v "Hardware" | awk {'print $2'} )

networksetup -removepreferredwirelessnetwork $interface "FileWave USA"

networksetup -addpreferredwirelessnetworkatindex $interface "FileWave USA" 0 WPA2 Indy1175Creek

#Join Wi-Fi network
networksetup -setairportnetwork $interface "FileWave USA" Indy1175Creek


#Create a Wi-Fi network profile
#networksetup -addpreferredwirelessnetworkatindex en0 SSID_OF_NETWORK INDEX_NUMBER SECURITY_OF_WIRELESS_NETWORK WIRELESS_NETWORK_PASSPHRASE

#Delete a Wi-Fi network profile
#networksetup -removepreferredwirelessnetwork en0 SSID_OF_NETWORK

#Remove all stored Wi-Fi network profiles
#networksetup -removeallpreferredwirelessnetworks en0