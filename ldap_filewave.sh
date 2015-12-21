#!/bin/bash

#Are you root?
if [ ! $(whoami) == "root" ] ; then
        echo "Script must be run as root"
        exit 1
fi

fwcontrol server stop
printf '<Location /ios/enroll>\n'\
'# This is an example of ldap based user auth\n'\
'	AuthType Basic\n'\
'	AuthBasicProvider ldap\n'\
'	AuthName "Enroll IOS Device"\n'\
'	AuthLDAPURL "ldap://10.1.10.225:389/cn=Users,dc=in,dc=filewave,dc=us?sAMAccountName"\n'\
'	Require valid-user\n'\
'# If you need to bind to the ldap server, use these lines\n'\
'	AuthLDAPBindDN "cn=fwadmin,cn=users,dc=in,dc=filewave,dc=us"\n'\
'	AuthLDAPBindPassword "filewave"\n'\
'	LDAPReferrals Off\n'\
'</Location>\n'\
'<Location /ios/device_enrollment_profile>\n'\
'# This is an example of ldap based user auth\n'\
'	AuthType Basic\n'\
'	AuthBasicProvider ldap\n'\
'	AuthName "Enroll IOS Device"\n'\
'	AuthLDAPURL "ldap://10.1.10.225:389/cn=Users,dc=in,dc=filewave,dc=us?sAMAccountName"\n'\
'	Require valid-user\n'\
'   ErrorDocument 401 "Enrollment credentials are needed."\n'\
'# If you need to bind to the ldap server, use these lines\n'\
'	AuthLDAPBindDN "cn=fwadmin,cn=users,dc=in,dc=filewave,dc=us"\n'\
'	AuthLDAPBindPassword "filewave"\n'\
'	LDAPReferrals Off\n'\
'</Location>\n'\
'<Location /ios/dep_enrollment_profile>\n'\
'# This is an example of ldap based user auth\n'\
'	AuthType Basic\n'\
'	AuthBasicProvider ldap\n'\
'	AuthName "Enroll IOS Device"\n'\
'	AuthLDAPURL "ldap://10.1.10.225:389/cn=Users,dc=in,dc=filewave,dc=us?sAMAccountName"\n'\
'	Require valid-user\n'\
'   ErrorDocument 401 "Enrollment credentials are needed."\n'\
'# If you need to bind to the ldap server, use these lines\n'\
'	AuthLDAPBindDN "cn=fwadmin,cn=users,dc=in,dc=filewave,dc=us"\n'\
'	AuthLDAPBindPassword "filewave"\n'\
'	LDAPReferrals Off\n'\
'</Location>\n'\
'<Location /android/enroll>\n'\
'# This is an example of ldap based user auth\n'\
'	AuthType Basic\n'\
'	AuthBasicProvider ldap\n'\
'	AuthName "Enroll Android Device"\n'\
'	AuthLDAPURL "ldap://10.1.10.225:389/cn=Users,dc=in,dc=filewave,dc=us?sAMAccountName"\n'\
'	Require valid-user\n'\
'# If you need to bind to the ldap server, use these lines\n'\
'	AuthLDAPBindDN "cn=fwadmin,cn=users,dc=in,dc=filewave,dc=us"\n'\
'	AuthLDAPBindPassword "filewave"\n'\
'	LDAPReferrals Off\n'\
'</Location>\n'\
'<Location /android/project_number>\n'\
'# This is an example of ldap based user auth\n'\
'	AuthType Basic\n'\
'	AuthBasicProvider ldap\n'\
'	AuthName "Google Cloud Messaging configuration"\n'\
'	AuthLDAPURL "ldap://10.1.10.225:389/cn=Users,dc=in,dc=filewave,dc=us?sAMAccountName"\n'\
'	Require valid-user\n'\
'# If you need to bind to the ldap server, use these lines\n'\
'	AuthLDAPBindDN "cn=fwadmin,cn=users,dc=in,dc=filewave,dc=us"\n'\
'	AuthLDAPBindPassword "filewave"\n'\
'	LDAPReferrals Off\n'\
'</Location>\n' > fwwds_ldap_auth.conf
cp fwwds_ldap_auth.conf /usr/local/filewave/apache/conf/mdm_auth.conf
rm -rf fwwds_ldap_auth.conf
fwcontrol server start
