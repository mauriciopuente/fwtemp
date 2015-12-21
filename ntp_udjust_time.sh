#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log


# Set the time zone
#/usr/sbin/systemsetup -settimezone $TimeZone

# Available time Zones:
#/usr/sbin/systemsetup listtimezones

# Primary Time server
#TimeServer1=XXXXXXX

# Secondary Time server
#TimeServer2=XXXXXXX

# Tertiary Time Server for Levi Strauss Macs, used outside of School's network
TimeServer3=time.apple.com

# Activate the primary time server. Set the primary network server with systemsetup
/usr/sbin/systemsetup -setnetworktimeserver $TimeServer3

# Add the secondary time server
#echo "server $TimeServer2" >> /etc/ntp.conf

# Add the tertiary time server
#echo "server $TimeServer1" >> /etc/ntp.conf

# Enables the OS X to set its clock using the network time server
/usr/sbin/systemsetup -setusingnetworktime on