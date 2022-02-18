#!/bin/sh
wget https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.16.tar.xz
tar -xf gnutls-3.6.16.tar.xz
cd gnutls-3.6.16
git apply --directory gnutls-gnutls-3.6.16/ /0001-fix-luxTrust-openconnect.patch 
./configure
make