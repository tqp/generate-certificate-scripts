#!/bin/bash

# Step 1: Generate a PKCS12 File
winpty openssl pkcs12 -export -in ./certificates/server-01.pem.crt -inkey ./certificates./server-01.key -out ./certificates/server-01.p12 -name server-01