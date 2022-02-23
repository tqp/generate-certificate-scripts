#!/bin/bash

print "Generate a private key for the server."
winpty openssl genrsa -out certificates/server-01.key 2048
