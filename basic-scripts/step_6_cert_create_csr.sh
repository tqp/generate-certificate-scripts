#!/bin/bash

echo "Create a Certificate Signing Request (CSR) for the server."
winpty openssl req -new -key certificates/server-01.key -out certificates/server-01.csr
