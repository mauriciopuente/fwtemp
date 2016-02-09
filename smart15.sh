#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

/Library/Application\ Support/SMART\ Technologies/ activationwizard.app/Contents/MacOS/activationwizard
--puid education_bundle --uipack education_bundle --m=4 --v=3 --pks "[NC-2ADAG-ANCPI-2FTEH-S6AAA-AAA]" --a
