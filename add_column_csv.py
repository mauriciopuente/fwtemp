import csv
import datetime
import os

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

timestp = year+"/"+month+"/"+day+"/"+hora+":"+minuto+":"+segundo

files = []

for filename in os.listdir('/Users/admin/Desktop/win_share'):
    if filename.endswith(".csv"):
        print str(filename)
        files.append('/Users/admin/Desktop/win_share/'+str(filename))

for i in files:
    print i
    with open(i,'r') as csvinput:
        with open(i.replace('.csv', '_timestp.csv'), 'w') as csvoutput:
            writer = csv.writer(csvoutput, lineterminator='\n')
            reader = csv.reader(csvinput)

            all = []
            row = next(reader)
            row.append(str(timestp))
            all.append(row)

            for row in reader:
                row.append(str(timestp))
                all.append(row)

            writer.writerows(all)