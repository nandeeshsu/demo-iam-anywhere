#!/bin/bash

#Create CA private key
openssl genrsa -out MyAWSCA.key 4096

#Create CA certificate with above generated private key
openssl req -new -x509 -days 3650 -key MyAWSCA.key -out MyAWSCA.pem -extensions v3_ca -config ./openssl.cnf

#Create onpremise Private key for On-Premises VM. Specific to onpremise machine who wants to access to AWS
openssl genrsa -out onpremise.key 4096

#Create onpremise CSR using the above generated onpremise private key - Certificate Signing Request for On-Premises VM who wants to access AWS
openssl req -new -key onpremise.key -out onpremise.csr -config ./openssl.cnf

#onpremise version 3 extension config
cat > onpremise.ext<<EOF
basicConstraints = CA:FALSE
authorityKeyIdentifier = keyid,issuer
keyUsage = nonRepudiation, digitalSignature, keyEncipherment, dataEncipherment
EOF

#Create onpremise certificate - end entity certificate for a specific on-premises vm/server
openssl x509 -req -in onpremise.csr -CA MyAWSCA.pem -CAkey MyAWSCA.key -CAcreateserial -out onpremise.pem -days 3650 -sha256 -extfile onpremise.ext
