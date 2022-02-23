# Basic Scripts
These are basic scripts that can be used to "Create Your Own SSL Certificate Authority for Local HTTPS Development".  

These scripts are adapted from instructions that can be found here:  
https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/

## Update and Run the Scripts

### Setup

#### step_1_create_target_directory.sh
* Create a target directory called "certificates", if it doesn't exist already.  
`mkdir -p certificates`

### Create the Certificate Authority

#### step_2_ca_generate_private_key.sh
* Generate the private key to become a local CA.  
`winpty openssl genrsa -des3 -out certificates/ca.key 2048`

#### step_3_ca_generate_root_certificate.sh
* Generate a root certificate.  
`winpty openssl req -x509 -new -nodes -key certificates/ca.key -sha256 -days 1825 -out certificates/ca.pem`

#### step_4_copy_pem_to_crt.sh
* Copy the .pem file to be a .crt file.  
`cp certificates/ca.pem certificates/ca.crt`

### Generate the CA-Signed Certificates for the Servers
The default configuration file is "server-01.ext". You'll want to modify this file to match the information for your  
server (in particular, the DNS entries). I'd recommend creating a ".ext" file for each server you want to generate  
a certificate for. It will be used in th last step.

#### step_5_cert_generate_private_key.sh
* Generate a private key for the server.  
* Remember to update "server-01" to the name of your server.  
`winpty openssl genrsa -out certificates/server-01.key 2048`

#### step_6_cert_create_csr.sh
* Create a Certificate Signing Request (CSR) for the server.
* Remember to update "server-01" to the name of your server.  
`winpty openssl req -new -key certificates/server-01.key -out certificates/server-01.csr`

#### step_7_cert_create_certificate.sh
* Create the certificate.
* Remember to update "server-01" to the name of your server.  
`winpty openssl x509 -req -in certificates/server-01.csr -CA certificates/ca.pem -CAkey certificates/ca.key -CAcreateserial -out certificates/server-01.crt -days 825 -sha256 -extfile server-01.ext`
