#!/bin/bash

myuptime=$( uptime | sed 's/,/    /g' | sed 's/:/ /g' | sed 's/\./ /g' )
echo $myuptime


