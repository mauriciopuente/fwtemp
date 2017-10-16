#!/usr/local/filewave/python/bin/python

import os
import psycopg2


def addClient(cursor, name, state):
    type = 13
    if state == 1:
        flags = 32
        status = 1
    else:
        flags = 0
        status = None

    cursor.execute('''INSERT into admin.user_clone_group\
                   (type, name, comment, parent_id, date_created, date_modified, flags, state)\
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s)\
                   RETURNING id''',
                   (type, name, name, 99, 0, 0, flags, state))
    id = cursor.fetchone()[0]
    print (id)

    cursor.execute('''INSERT into admin.user (name, ucg_id, status, state, new_user_flag, model_version)\
                   VALUES (%s, %s, %s, %s, 0, 123)''',
                   (name, id, status, state))

    return id


conn = psycopg2.connect("dbname='mdm' user='django' host='localhost' password='filewave'")

cur = conn.cursor()

addClient(cur, "normal", 0)
addClient(cur, "archived", 1)
addClient(cur, "missing", 2)
lastID = addClient(cur, "nottracked", 3)

conn.commit()
conn.close()
