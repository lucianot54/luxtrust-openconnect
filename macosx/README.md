# Scripts
- build-patch.sh
    - Clone, patch and build the app
- find-certificate-data.sh
    - Finds certificat and privatekey pkcs11:model
- openconnect.sh
    - openconnect with certificat configuration

# Instalation


- Install xcodebuild
``` Optional
sudo xcodebuild -license accept # OPTIONAL
```
- Install OpenSC
``` 
https://github.com/OpenSC/OpenSC/wiki
https://github.com/OpenSC/OpenSC/releases/download/0.22.0/OpenSC-0.22.0.dmg
```

- Install openconnect and update libgnutls
```
brew install openconnect
mv /usr/local/Cellar/gnutls/3.6.16/lib/libgnutls.30.dylib /usr/local/Cellar/gnutls/3.6.16/lib/libgnutls.30.dylib.bak
cp ./bin/libgnutls.30-002-fix.dylib /usr/local/Cellar/gnutls/3.6.16/lib/libgnutls.30.dylib
sudo mkdir /etc/gnutls
sudo bash -c 'cat << EOF > /etc/gnutls/pkcs11.conf
load=/Library/OpenSC/lib/opensc-pkcs11.so
EOF'
brew install vpn-slice
sudo vpn-slice --self-test
```

# Build/Debug and install
```
./build-patch.sh
mv /usr/local/Cellar/gnutls/3.6.16/lib/libgnutls.30.dylib /usr/local/Cellar/gnutls/3.6.16/lib/libgnutls.30.dylib.bak
ln -s "$PWD/gnutls-3.6.16/lib/.libs/libgnutls.30.dylib" /usr/local/Cellar/gnutls/3.6.16/lib/libgnutls.30.dylib
```

# Restore original lib
```
mv /usr/local/Cellar/gnutls/3.6.16/lib/libgnutls.30.dylib.bak /usr/local/Cellar/gnutls/3.6.16/lib/libgnutls.30.dylib
```

OR
```
brew reinstall gnutls
```


tls-sig.c
```
// FIX to force RSA-SHA1 algorithm with CA LuxTrust Global Qualified CA 3" 
	gnutls_x509_crt_t x509;
	char issuerCN[MAX_DN];
	size_t issuerCN_size;

	// Init x509
	ret = gnutls_x509_crt_init(&x509);
	if (ret < 0)
		gnutls_assert_val(ret);
	// Import pcert to x509
	ret = gnutls_x509_crt_import(x509, &cert->cert.data, GNUTLS_X509_FMT_DER);
	if (ret < 0)
		gnutls_assert_val(ret);
	// Find the issuer CN
	//  
	ret = gnutls_x509_crt_get_issuer_dn_by_oid(x509, GNUTLS_OID_X520_COMMON_NAME, 0, 0, issuerCN, &issuerCN_size);
	if (ret < 0)
		gnutls_assert_val(ret);

	if (strcmp(issuerCN, "LuxTrust Global Qualified CA 3") == 0)
	{
		sign_algo = GNUTLS_SIGN_RSA_SHA1;
	}else{
		sign_algo = _gnutls_session_get_sign_algo(session, cert, pkey, 1, GNUTLS_KX_UNKNOWN);
	}
```