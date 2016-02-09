#!/usr/bin/env python
import base64
import sys
print "Authorization:", base64.encodestring(sys.argv[1])
