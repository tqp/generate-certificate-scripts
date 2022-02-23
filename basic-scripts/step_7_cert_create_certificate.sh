#!/bin/bash

echo "Create the certificate."
winpty openssl x509 -req -in certificates/server-01.csr -CA certificates/ca.pem -CAkey certificates/ca.key -CAcreateserial -out certificates/server-01.crt -days 825 -sha256 -extfile server-01.ext
