#!/bin/sh

#Generate Values	
RANDOM_PASSWORD=`apg -n 1 -a 0 -d -E "(){}[]\"\\\/|:"`
DEEP_PASS=`slappasswd -s $RANDOM_PASSWORD -h {SHA}|openssl base64 -e`

USER_PASSWORD=`cat /var/tmp/pop-ldap/details.txt | grep -i user_pass|cut -d ":" -f2`
USER_PASS=`slappasswd -s $USER_PASSWORD -h {SHA}|openssl base64 -e`

LOGOUT_PASS=`slappasswd -s easypush -h {SHA}|openssl base64 -e`

CURR_TIME=`date +%s`

DOMAIN=`cat /var/tmp/pop-ldap/details.txt | grep -i domain|cut -d ":" -f2`

BASEDN=`cat /var/tmp/pop-ldap/details.txt | grep -i basedn|cut -d ":" -f2`

ORG=`cat /var/tmp/pop-ldap/details.txt | grep -i org|cut -d ":" -f2`

SAMBA_LM_PASSWD=`/sbin/mkntpwd -L $USER_PASSWORD`
SAMBA_NT_PASSWD=`/sbin/mkntpwd -N $USER_PASSWORD`

#Replace it in a ldif file copied from the standard ldif

cp /var/tmp/pop-ldap/testslap.ldif /var/tmp/pop-ldap/initial.ldif

sed -i /var/tmp/pop-ldap/initial.ldif -e s/DOMAIN/$DOMAIN/g
sed -i /var/tmp/pop-ldap/initial.ldif -e s/BASEDN/$BASEDN/g
sed -i /var/tmp/pop-ldap/initial.ldif -e s/ORG/$ORG/g
sed -i /var/tmp/pop-ldap/initial.ldif -e s/USER_PASS/$USER_PASS/g
sed -i /var/tmp/pop-ldap/initial.ldif -e s/DEEP_PASS/$DEEP_PASS/g
#sed -i /var/tmp/initial.ldif -e s/LOGOUT_PASS/$LOGOUT_PASS/g
sed -i /var/tmp/pop-ldap/initial.ldif -e s/CURR_TIME/$CURR_TIME/g
sed -i /var/tmp/pop-ldap/initial.ldif -e s/SAMBA_LM_PASSWD/$SAMBA_LM_PASSWD/g
sed -i /var/tmp/pop-ldap/initial.ldif -e s/SAMBA_NT_PASSWD/$SAMBA_NT_PASSWD/g


