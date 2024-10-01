#!/bin/bash

#Create CA private key
openssl genrsa -out MyCA.key 4096

#Create CA certificate with above generated private key
openssl req -new -x509 -days 3650 -key MyCA.key -out MyCA.pem -extensions v3_ca -config ./openssl.cnf

#Create client Private key for On-Premises VM. Specific to client machine who wants to access to AWS
openssl genrsa -out client.key 4096

#Create client CSR using the above generated client private key - Certificate Signing Request for On-Premises VM who wants to access AWS
openssl req -new -key client.key -out client.csr -config ./openssl.cnf

#Client version 3 extension config
cat > client.ext<<EOF
basicConstraints = CA:FALSE
authorityKeyIdentifier = keyid,issuer
keyUsage = nonRepudiation, digitalSignature, keyEncipherment, dataEncipherment
EOF

#Create Client certificate - end entity certificate for a specific on-premises vm/server
openssl x509 -req -in client.csr -CA MyCA.pem -CAkey MyCA.key -CAcreateserial -out client.pem -days 3650 -sha256 -extfile client.ext