#!/bin/bash

/Volumes/OS\ X\ Base\ System/Applications/Utilities/Firmware\ Password\ Utility.app/Contents/Resources/setregproptool -c;

if [ $? -eq 1 ]; then echo "Firmware password not set."

else echo "Firmware password set."

fi

exit 0
