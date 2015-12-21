#!/bin/bash

crontab -u admin -e
line="0 7,11,15,20 * * * purge"
(crontab -u admin -l; echo "$line" ) | crontab -u admin -

