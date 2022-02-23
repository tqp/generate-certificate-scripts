#!/bin/bash

echo "Generate a root certificate."
winpty openssl req -x509 -new -nodes -key certificates/ca.key -sha256 -days 1825 -out certificates/ca.pem
