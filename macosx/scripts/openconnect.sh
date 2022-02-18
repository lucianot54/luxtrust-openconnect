#!/bin/bash

if test -f ".config"; then
  export $(cat .config | xargs)
else
    sh ./find-certificate-data.sh
fi

if test -z "$P11_CONFIG_CERT" 
then
    sh ./find-certificate-data.sh
    export $(cat .config | xargs)
fi

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Debug mode
#openconnect \
#--disable-ipv6 --printcookie --dump-http-traffic -v --gnutls-debug=99 \
#--script 'vpn-slice 10.0.0.0/8' \
#--protocol=anyconnect --authgroup=Certificat \
#-c $P11_CONFIG_CERT \
#-k $P11_CONFIG_PKEY \
#https://xxx.xxxx.lu

openconnect \
--protocol=anyconnect --authgroup=Certificat \
-c $P11_CONFIG_CERT \
-k $P11_CONFIG_PKEY \
https://xxx.xxxx.lu