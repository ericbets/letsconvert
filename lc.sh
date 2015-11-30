#!/bin/sh
DOMAIN=$1
FULLCHAIN=$2
PRIVKEY=$3
STOREPASS=$4
OUTDIR=$5

if [ "$#" -ne 5 ];
then
	echo `basename "$0"` domain.tld fullchain.pem privkey.pem password outdir
else
	keytool -import -alias $DOMAIN -keystore $DOMAIN.jks -file $FULLCHAIN -storepass $STOREPASS -noprompt
	openssl pkcs12 -export -in $FULLCHAIN -inkey $PRIVKEY -password pass:$STOREPASS > $DOMAIN-server.p12
	keytool -importkeystore -srckeystore $DOMAIN-server.p12 -destkeystore $DOMAIN.jks -srcstoretype pkcs12 -storepass $STOREPASS -srcstorepass $STOREPASS
	rm $DOMAIN-server.p12
	mv $DOMAIN.jks $OUTDIR
fi
