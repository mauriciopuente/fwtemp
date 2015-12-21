#!/bin/bash

echo ""
echo "#################################################"
echo 'This script will let you set a Static IP address' 
echo 'on your FileWave Booster Appliance'
echo 'Please change settings using the following menu'
echo "#################################################"
echo ""


# Static IP configuration

select option in "ip_address" "net_mask" "gateway" "verify_changes" "save_quit" "quit"
do
	case $option in
		ip_address) echo 'Please enter the static IP address for this appliance : '
			read ipaddress;;
		net_mask) echo 'Please enter the Subnet Mask for this appliance : '
			read subnetmask;;
		gateway) echo 'Please enter the GATEWAY for this appliance : '
			read gateway;;
		verify_changes) echo 'IP Address :	'$ipaddress
						echo 'Net Mask :	'$subnetmask
						echo 'GateWay :	'$gateway;;
		save_quit) 	cp /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/BAK_ifcfg-eth0_BAK

					cd /etc/sysconfig/network-scripts

					# Backing Up ifcfg-eth1
					awk '/BOOTPROTO/ {print "BOOTPROTO=none"; next} /./' ifcfg-eth0 > ifcfg-eth0_NEW
					mv -f ifcfg-eth0_NEW ifcfg-eth0
					
					echo 'IPADDR='$ipaddress >> /etc/sysconfig/network-scripts/ifcfg-eth0
					echo 'NETMASK='$subnetmask >> /etc/sysconfig/network-scripts/ifcfg-eth0
					echo 'GATEWAY='$gateway >> /etc/sysconfig/network
					echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
					
					/etc/init.d/network restart
					break;;
					
		quit) break;;
					
		*) echo 'I do not understand that option, please try again!';;
					
	esac
done



