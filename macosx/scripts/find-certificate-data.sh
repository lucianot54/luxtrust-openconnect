#!/bin/sh

P11_CONFIG_CERT=$(p11tool --list-all | grep -B 3 'User Cert Auth' | grep -B 1 "X.509 Certificate (RSA-2048)" | head -n 1 | sed 's/[[:space:]]*URL: //g')
P11_CONFIG_PKEY=$(echo $P11_CONFIG_CERT | sed 's/cert/private/g' )
cat <<EOT > .config
P11_CONFIG_CERT=$P11_CONFIG_CERT
P11_CONFIG_PKEY=$P11_CONFIG_PKEY
EOT