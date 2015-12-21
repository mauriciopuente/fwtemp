#!/usr/bin/expect -f
#spawn ssh admin@10.1.10.17
spawn rsync -av /testfolder admin@10.1.10.17:/tmp
expect "assword:"
send "filewave\r"
interact
