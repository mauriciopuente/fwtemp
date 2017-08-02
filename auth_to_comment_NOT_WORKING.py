#!/usr/local/filewave/python/bin/python
# Mauricio Puente Cadena
# March 06 2017
# ---------------------------------------------------

import sys,os
import psycopg2


#Connecting to the DB
try:
    connection = psycopg2.connect("dbname=mdm user=django")
except:
    print "I am unable to connect to the database"
    print "This script must be run on the server where the filewave server is installed"
    print "Please verify that 'postmaster' processes are running and try again"

mark = connection.cursor()


statement2 = '''update admin.user_clone_group set comment = b.auth_username from generic_genericclient b, admin.user_clone_group a where a.serial_or_mac = b.serial_number'''


mark.execute(statement2)

# Commit the change
connection.commit()

# Close the db connection
connection.close()
