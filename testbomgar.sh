#!/bin/bash

hdiutil attach -mountpoint /Volumes/bomgar /Users/admin/Documents/bomgar-scc-w0idc30xgf7hx6g1ge5iixddzh6jf7wzgxj55ygc40jc90.dmg

sleep 5

cp -R "/Volumes/bomgar/Double-Click To Start Support Session.app" /Applications
