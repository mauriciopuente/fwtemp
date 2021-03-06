#!/usr/bin/env python
# encoding: utf-8

import datetime
import psycopg2
import sys

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

archivo = "Filewave_"+year+"_"+month+"_"+day+"__"+hora+"_"+minuto+"_"+segundo+"."+"txt"

f = open(archivo, "a")
 

## ===========================================================================


def ipairs(seq):
        it = iter(seq)
        return izip(it, it)
        

try:
    connection = psycopg2.connect("dbname=mdm user=django")
except:
    print "I am unable to connect to the database"

mark = connection.cursor()


k = 0
statement = """
            select device_name, serial_number
            from generic_genericclient
            """
mark.execute(statement)
record = mark.fetchall()

pos = 0
for i in record:
        temp=list(ipairs(i))        # [1,2,3,4] --> [(1,2),(3,4)]
        for p in temp:
                for j in p:
                        j = str(j)
                        f.write(j + "\t")
                f.write("\n")
f.close()





## ========================================================================================





