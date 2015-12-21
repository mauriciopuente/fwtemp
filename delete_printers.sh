#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

/usr/bin/profiles -Df

printers=('mcx_0 mcx_1 mcx_2 mcx_3 mcx_4 mcx_5 mcx_6 mcx_7 mcx_8 mcx_9 mcx_10 mcx_11 mcx_12 mcx_13')

for i in $printers
do

	echo "Deleting Printer:" ${i}
	lpadmin -x ${i} 
	
done

