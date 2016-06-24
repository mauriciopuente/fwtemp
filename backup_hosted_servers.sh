#!/bin/bash

########################## Backups from Hosted Servers ##################################################
#
# This script does the following:
#
#
# 1. Copies from Hosted costumers their backup folders to a local directory.
#
#
#########################################################################################################

echo "========================================================================="
echo ""
echo " This script saves the Hosted servers backups locally on this computer"
echo ""
echo " Data will be saved on /tmp"
echo ""
echo " Log will be saved in /tmp/hostedservers.log"
echo ""
echo "========================================================================="


servers=('greenbrier.filewave.com queenbee.filewave.com lca.filewave.com allsaints.filewave.com oa.filewave.com blessedtrinity.filewave.com patins.filewave.com')

#servers=('greenbrier.filewave.com queenbee.filewave.com')

for i in $servers
do

	echo "Copying from Server:" ${i} #>> /tmp/hostedservers.log

    if [ ! -d /tmp/${i} ]

        then
            echo "The Directory for ${i} is not there, creating one..."
            mkdir /tmp/${i}
            scp -i /Users/admin/Documents/fw-customers.pem -r root@${i}:/tmp/fwbackup /tmp/${i}/ #>> /tmp/hostedservers.log
        else
            rsync --delete -azvv -e "ssh -i /Users/admin/Documents/fw-customers.pem" root@${i}:/tmp/fwbackup /tmp/${i}
            #scp -i /Users/admin/Documents/fw-customers.pem -r root@${i}:/tmp/fwbackup /tmp/${i}/ #>> /tmp/hostedservers.log
    fi

	#scp -i /Users/admin/Documents/fw-customers.pem -r root@${i}:/tmp/fwbackup /tmp/ >> /tmp/hostedservers.log
    echo "Done copying from Server" ${i}

done