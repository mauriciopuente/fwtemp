#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

echo "Deleting User Directories for 1* and 2* ..."

rm -rf /Users/1*
rm -rf /Users/2*

echo "Done Deleting User Directories for 1* and 2* ..."
