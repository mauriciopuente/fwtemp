#!/bin/bash


exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

networksetup -removepreferredwirelessnetwork en0 "FileWave USA"

networksetup -addpreferredwirelessnetworkatindex en1 "FileWave Guest" 0 WPA2 welcome2indy

networksetup -setnetworkserviceenabled AirPort off
sleep 2
networksetup -setnetworkserviceenabled AirPort on

#networksetup -addpreferredwirelessnetworkatindex en1 "FileWave Guest" 0 WPA2 welcome2indy
