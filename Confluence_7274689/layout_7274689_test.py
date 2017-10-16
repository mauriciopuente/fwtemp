#!/usr/local/filewave/python/bin/python

import os
import psycopg2


def addItem(cursor, id, name, state, serialormac, parentid, type):
    ##type = 13
    if state == 1:
        flags = 32
        status = 1
    else:
        flags = 0
        status = None

    cursor.execute('''INSERT into admin.user_clone_group\
                   (id, type, name, comment, parent_id, date_created, date_modified, flags, state, serial_or_mac)\
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)\
                   RETURNING id''',
                   (id, type, name, name, parentid, 0, 0, flags, state, serialormac))
    id = cursor.fetchone()[0]
    print (id)

    cursor.execute('''INSERT into admin.user (name, ucg_id, status, state, serial_or_mac, new_user_flag, model_version)\
                   VALUES (%s, %s, %s, %s, %s, 0, 123)''',
                   (name, id, status, state, serialormac))

    return id


def cloneItem(cursor, id, parentid, originalid):
    type = 15
    flags = 0
    state = 3
    managementmode = 0


    cursor.execute('''INSERT into admin.user_clone_group\
                   (id, parent_id,type,original_id,state,flags,management_mode)\
                   VALUES (%s, %s, %s, %s, %s, %s, %s)''',
                   (id, parentid, type, originalid, state, flags, managementmode))



conn = psycopg2.connect("dbname='mdm' user='django' host='localhost' password='filewave'")

cur = conn.cursor()

## Create Macs group at root level:
addItem(cur, 211, "MACs", 3, "", 99, 14)
## Create Macs in Macs group root level:
addItem(cur, 212, "MAC-01", 0, "C02LH69SF5V7", 211, 13)
addItem(cur, 213, "MAC-02", 0, "C02LH69SF5V8", 211, 13)
addItem(cur, 214, "MAC-03", 0, "C02LH69SF5V9", 211, 13)


## Create Wins group at root level:
addItem(cur, 215, "WINs", 3, "", 99, 14)
## Create Wins in Wins group root level:
addItem(cur, 216, "WIN-01", 0, "00:0C:29:22:A7:7A", 215, 13)
addItem(cur, 217, "WIN-02", 0, "00:0C:29:22:A7:7B", 215, 13)


## Create Clones group at root level:
addItem(cur, 230, "Clones", 3, "", 99, 14)

## Create MAC-Clones group within the Clones group:
addItem(cur, 231, "MAC-Clones", 3, "", 230, 14)
## Clone the Macs into the MAC-Clones group:
cloneItem(cur, 232, 231, 212)
cloneItem(cur, 233, 231, 213)
cloneItem(cur, 234, 231, 214)


## Create MAC-Clones group within the Clones group:
addItem(cur, 237, "WIN-Clones", 3, "", 230, 14)
## Clone the Macs into the MAC-Clones group:
cloneItem(cur, 238, 237, 216)
cloneItem(cur, 239, 237, 217)



##lastID = addItem(cur, 503, "nottracked", 3, "C02LH69SF5V9", 99, 13)

conn.commit()
conn.close()
