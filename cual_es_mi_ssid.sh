#!/bin/bash

wifi=$( networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/,/Ethernet/' | awk 'NR==2' | cut -d " " -f 2 )

ssid=$( networksetup -getairportnetwork $wifi | cut -c24- )

echo $ssid



