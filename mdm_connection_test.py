#!/usr/bin/env python
# encoding: utf-8

import datetime
import psycopg2
import sys


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

archivo = "ServiAutos_"+year+"_"+month+"_"+day+"__"+hora+"_"+minuto+"_"+segundo+"."+"txt"

f = open(archivo, "a")
 

## ===========================================================================



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
for i in record:
    for j in i:
        j = str(j)
        f.write(j + "\n")
f.close()



## ========================================================================================





