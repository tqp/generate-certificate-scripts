#!/bin/bash

echo "Generate the private key to become a local CA."
winpty openssl genrsa -des3 -out certificates/ca.key 2048
