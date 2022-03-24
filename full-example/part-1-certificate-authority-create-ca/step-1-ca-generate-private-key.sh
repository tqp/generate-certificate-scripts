#!/bin/bash

# Step 1 : The CA Generates a Private Key
mkdir -p certificates # Make the certificates directory, if it doesn't already exist.
winpty openssl genrsa -des3 -out certificates/ca.key 4096