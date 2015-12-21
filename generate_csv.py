#!/usr/bin/env python
# encoding: utf-8

import datetime
import psycopg2

from itertools import izip

now = datetime.datetime.now()

year = now.year
year = str(year)

month = now.month
month = str(month)

day = now.day
day = str(day)

hora = now.hour
hora = str(hora)

minuto = now.minute
minuto = str(minuto)

segundo = now.second
segundo = str(segundo)

archivo = "Filewave_"+year+"_"+month+"_"+day+"__"+hora+"_"+minuto+"_"+segundo+"."+"csv"

f = open(archivo, "a")
 

## ===========================================================================


def ipairs(seq):
        it = iter(seq)
        return izip(it, it)
        

def chunker(iterable, chunksize):
    return zip(*[iter(iterable)]*chunksize)
        

try:
    connection = psycopg2.connect("dbname=mdm user=django")
except:
    print "I am unable to connect to the database"

mark = connection.cursor()


k = 0
statement = """
            select serial_number, filewave_client_name
            from generic_genericclient
            """
mark.execute(statement)
record = mark.fetchall()

pos = 0
for i in record:
        temp=list(chunker(i,2))        # [1,2,3,4] --> [(1,2),(3,4)]
        for p in temp:
                f.write(p[0]+","+p[1])
                f.write("\n")
f.close()

# pos = 0
# for i in record:
#         temp=list(chunker(i,2))        # [1,2,3,4] --> [(1,2),(3,4)]
#         for p in temp:
#                 for j in p:
#                         j = str(j)
#                         f.write(j + ",")
#                 f.write("\n")
# f.close()



## ========================================================================================





