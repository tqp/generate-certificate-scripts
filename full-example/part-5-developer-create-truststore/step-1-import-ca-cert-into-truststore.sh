#!/bin/bash

# Step 1: Import the server's certificate to the client's trust store.
keytool -import -file ./certificates/ca.crt -alias server-01 -keystore server-01.truststore.jks