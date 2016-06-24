#!/bin/sh
export udids=$1
scr='removeAppPortal.py'

/bin/cat <<EOM >$scr
from ios.apn import send_apn_to_devices
from ios.command_queue import CommandQueue
from ios.models import MDMUser
from ios.ios_commands import create_command_from_request_type
from filewave.fw_util.helpers import get_locale_aware_datetime_now, LockingStrategy
import os
import csv
from apple.activationlock.activationlock import ActivationLock, ActivationLockRemovalError,\
    ActivationLockByPassCodeNotRetrieved



#udids = set()

## read file and get unique udids
#with open(filepath, "r") as f:
#    udids = {udid.strip() for udid in f}


with open('/tmp/udids.csv', 'rb') as f:
    reader = csv.reader(f)
    my_list = list(reader)

print my_list

udids = [j[0] for j in my_list]


for user in MDMUser.get_users_and_command_queue(device_ids=udids,
                locking=LockingStrategy.FOR_UPDATE_OF_COMMAND_QUEUE,
                exclude_users=True
            ):
    udid = user.mdm_client.udid
    for i,j in my_list:
        if udid == i:
            print "Add Set Name Command device with udid %s" % udid
            cq = CommandQueue(user)
            cq.create_set_device_name_command(new_name=j,)
            cq.sync_to_db()


if udids:
    print "Send apns"
    send_apn_to_devices(udids=udids)
EOM

echo "execfile('removeAppPortal.py')" | /usr/local/filewave/python/bin/python /usr/local/filewave/django/manage.pyc shell
