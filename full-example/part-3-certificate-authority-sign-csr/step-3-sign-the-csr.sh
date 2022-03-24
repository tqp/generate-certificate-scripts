#!/bin/bash

# Step 2: Sign the CSR File
winpty openssl ca -config ca.conf -notext -out ./source/server-01.pem.crt -infiles ./source/server-01.csr