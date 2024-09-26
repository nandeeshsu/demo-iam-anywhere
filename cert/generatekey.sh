#!/bin/bash

#Create CA private key
openssl genrsa -out MyCA.key 4096

#Create CA certificate
openssl req -new -x509 -days 3650 -key MyCA.key -out MyCA.pem -extensions v3_ca -config ./openssl.cnf

#Create client key
openssl genrsa -out client.key 4096

#Create client CSR
openssl req -new -key client.key -out client.csr -config ./openssl.cnf

#Client version 3 extension config
cat > client.ext<<EOF
basicConstraints = CA:FALSE
authorityKeyIdentifier = keyid,issuer
keyUsage = nonRepudiation, digitalSignature, keyEncipherment, dataEncipherment
EOF

#Create Client certificate
openssl x509 -req -in client.csr -CA MyCA.pem -CAkey MyCA.key -CAcreateserial -out client.pem -days 3650 -sha256 -extfile client.ext