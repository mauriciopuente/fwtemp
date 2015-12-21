#!/bin/bash
#USER=admin

export RSYNC_PASSWORD=filewave

rsync -av /testfolder admin@10.1.10.17:/

