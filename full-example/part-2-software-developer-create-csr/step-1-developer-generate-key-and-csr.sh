#!/bin/bash

#Step 1: The Software Developer Generates a Private Key (.key) and a Certificate Signing Request (.csr)
mkdir -p certificates # Make the certificates directory, if it doesn't already exist.
winpty openssl req -new -sha256 -nodes -out certificates/server-01.csr -newkey rsa:4096 -keyout certificates/server-01.key