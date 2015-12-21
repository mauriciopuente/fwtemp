import plistlib
import os

from ios.models import Profiles
from os.path import expanduser

home = expanduser("~")

i = 1

for p in Profiles.objects.all():
    try:
        profile = plistlib.readPlistFromString(p.plist_profile)
        name = "%s.mobileconfig" % profile['PayloadIdentifier']
    except:
        name = "binary_profile_%d" % i
        i = i +1
    out_path = os.path.join(home, name)
    print "save profile to ", out_path
    with open(out_path, "w+") as f:
        f.write(p.plist_profile)
