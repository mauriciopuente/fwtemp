#!/usr/local/filewave/python/bin/python
# Mauricio Puente Cadena
# June 2016
# ---------------------------------------------------

import sys,os
import psycopg2


#Connecting to the DB
try:
    connection = psycopg2.connect("dbname=mdm user=django")
except:
    print ("I am unable to connect to the database")
    print ("This script must be run on the server where the filewave server is installed")
    print ("Please verify that 'postmaster' processes are running and try again")

mark = connection.cursor()


statement = """
            select last_connected, unique_machine_id from admin.user where unique_machine_id in (select unique_machine_id from admin.user group by unique_machine_id having (count(unique_machine_id) > 1)) order by unique_machine_id
            """

mark.execute(statement)

result = mark.fetchall()

d = {}
d2 = {}


print ("\nThis is the initial list :\n",result)

for i,j in result:
    if not j in d.keys():
        d[j] = [i]
    elif j in d.keys():
        d[j].append(i)

print ("\n\nThis is the Dictionary :\n",d)


for k,v in d.items():
    if not k in d2:
        v.remove(max(v))
        d2[k] = v

print ("\n\nThis is the Dictionary without the MAX date:\n",d2)


statement2 = '''update admin.user_clone_group set comment = 'OLD DUPLICATE' where id = (select ucg_id from admin.user a where unique_machine_id = '%s' and last_connected = %d limit 1)'''

for k,v in d2.items():
    for i in v:
        mark.execute(statement2 %(k,i))

# Commit the change
connection.commit()

# Close the db connection
connection.close()
