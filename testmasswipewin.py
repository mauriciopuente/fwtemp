from ios.apn import send_apn_to_devices
from ios.command_queue import CommandQueue
from ios.models import MDMUser
from ios.ios_commands import create_command_from_request_type
from filewave.fw_util.helpers import get_locale_aware_datetime_now, LockingStrategy
import os
import csv
from apple.activationlock.activationlock import ActivationLock, ActivationLockRemovalError,\
    ActivationLockByPassCodeNotRetrieved

import psycopg2


#Connecting to the DB
try:
    connection = psycopg2.connect("dbname=mdm user=django")
except:
    print("I am unable to connect to the database")
    print("This script must be run on the server where the filewave server is installed")
    print("Please verify that 'postmaster' processes are running and try again")

mark = connection.cursor()


# On windows this command has to be run as a raw string. Example open(r'C:\tmp\udids.txt', 'rt') as f:
with open(r'C:\fwtemp\udids.txt', 'rt') as f:
    reader = csv.reader(f)
    my_list = list(reader)

print(my_list)

udids = [j[0] for j in my_list]

#udids = set()

print(udids)

for user in MDMUser.get_users_and_command_queue(device_ids=udids,
                locking=LockingStrategy.FOR_UPDATE_OF_COMMAND_QUEUE,
                exclude_users=True
            ):
    udid = user.mdm_client.udid
    for i in udids:
        if udid == i:
            print ("Add Wipe command to device with udid %s" % udid)
            cq = CommandQueue(user)
            cq.create_command_in_queue("EraseDevice")
            cq.sync_to_db()
            try:
                print ("Remove Activation Lock for device.")
                ActivationLock.remove_activation_lock(udid)
            except ActivationLockRemovalError as e:
                print ("Error contacting Apple Service : %s" %  e.message)
            except ActivationLockByPassCodeNotRetrieved:
                print ("No valid ActivationLock Bypass Code")
if udids:
    print ("Send apns")
    send_apn_to_devices(udids=udids)