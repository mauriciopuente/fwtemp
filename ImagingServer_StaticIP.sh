#!/bin/bash

echo ""
echo "#################################################"
echo 'This script will let you set a Static IP address' 
echo 'on your FileWave Imaging Appliance'
echo 'Please change settings using the following menu'
echo "#################################################"
echo ""


# Add the following content to /sbin/ifup-local

cd /sbin
touch ifup-local
echo 'if [ "$1" == "eth1" ] ; then' >> ifup-local
echo 'export reason=BOUND' >> ifup-local
echo '/imaging/scripts/bin/dhclient-up-down-hooks' >> ifup-local
echo 'fi' >> ifup-local


# Add the following content to /sbin/ifdown-local

touch ifdown-local
echo 'if [ "$1" == "eth1" ] ; then' >> ifdown-local
echo 'export reason=STOP' >> ifdown-local
echo '/imaging/scripts/bin/dhclient-up-down-hooks' >> ifdown-local
echo 'fi' >> ifdown-local


# Make both files executable

chmod a+x /sbin/if*-local


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
		save_quit) 	cp /etc/sysconfig/network-scripts/ifcfg-eth1 /etc/sysconfig/network-scripts/BAK_ifcfg-eth1_BAK

					cd /etc/sysconfig/network-scripts

					# Backing Up ifcfg-eth1
					awk '/BOOTPROTO/ {print "BOOTPROTO=none"; next} /./' ifcfg-eth1 > ifcfg-eth1_NEW
					mv -f ifcfg-eth1_NEW ifcfg-eth1
					
					echo 'IPADDR='$ipaddress >> /etc/sysconfig/network-scripts/ifcfg-eth1
					echo 'NETMASK='$subnetmask >> /etc/sysconfig/network-scripts/ifcfg-eth1
					echo 'GATEWAY='$gateway >> /etc/sysconfig/network
					echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
					
					/etc/init.d/network restart
					break;;
					
		quit) break;;
					
		*) echo 'I do not understand that option, please try again!';;
					
	esac
done



