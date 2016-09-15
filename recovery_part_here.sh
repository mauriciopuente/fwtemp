#!/bin/bash

diskutil list | grep -i "recovery hd" &> /dev/null

if [ $? == 0 ]; then echo "Recovery Partition OK"

else echo "There is NOT a recovery partition here !!!"

fi

exit 0
