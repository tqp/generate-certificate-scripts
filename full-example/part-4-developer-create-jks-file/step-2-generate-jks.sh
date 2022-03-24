#!/bin/bash

# Step 2: Generate a JKS File
keytool -v -importkeystore -srckeystore ./certificates/server-01.p12 -srcstoretype pkcs12 -destkeystore ./certificates/server-01.jks -deststoretype JKS

# Convert the generated JKS file from JKS format to the industry standard PKCS12 format.
keytool -importkeystore -srckeystore ./certificates/server-01.jks -destkeystore ./certificates/server-01.jks -deststoretype pkcs12