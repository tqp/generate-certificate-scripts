#!/bin/bash

NEXT_SCRIPT="step_4_create_keystore_from_signed_cert.sh"
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

load_server_config() {
	if [[ -f ./server.conf ]]; then
		source ./server.conf
		BASE_PATH="./${SERVER}/"
	else
		echo "server.conf file not found. Try running Step 0 script again."
		exit 1
	fi
}

verify_csr() {
	if [[ -f ${BASE_PATH}${SERVER}.csr ]]; then
		echo "Key sections:"
		openssl req -text -noout -in ${BASE_PATH}${SERVER}.csr | egrep -i --color=auto "DNS:|CN|Subject:"
	else
		echo "The ${SERVER}.csr file does not exist. Please execute Step 1 first."
		exit 1
	fi
}

get_alt_dns_names() {
	echo ""
	echo "Alternate DNS entries: "
	ALT_DNS="$(grep DNS ${BASE_PATH}${SERVER}_details.txt | awk -vORS=, '{ print $3 }' | sed 's/,$/\n/')"
	echo -e ${BLUE} ${ALT_DNS} ${NC}
}

print_csr() {
	echo ""
	echo -e "CSR Contents:${GREEN}"
	cat "${BASE_PATH}${SERVER}.csr"
	echo -e ${NC}
}

echo -e "${YELLOW}========== STEP 4 ==========${NC}"

load_server_config
verify_csr
get_alt_dns_names
print_csr

echo ""
echo "If your .csr is correct, (Portions of your Certificate Request '${SERVER}.csr' are above.)"
echo "Then you need to submit your '${SERVER}.csr and it will get signed."
echo "When you ahve your signed certificate back, "
echo -e "place the contents in the '${SERVER}.cert' file and then run:${GREEN} ${NEXT_SCRIPT} ${NC}"
if [[ ! -f ${BASE_PATH}${SERVER}.cert ]]; then
	echo '<Replace this with the contents of signed certificate.>' > ${BASE_PATH}${SERVER}.cert
fi
echo "ls -l ${BASE_PATH}"
ls -l --color=auto ${BASE_PATH}