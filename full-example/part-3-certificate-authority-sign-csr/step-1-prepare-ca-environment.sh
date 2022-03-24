#!/bin/bash

# Create "ca" directory
mkdir -p ./ca/private
mkdir -p ./ca/certs
mkdir -p ./ca/newcerts
mkdir -p ./source
touch ./ca/index.txt
touch ./ca/serial
echo $(date '+%Y%m%d') > ./ca/serial #Uses today's date in YYYYMMDD format as the serisl