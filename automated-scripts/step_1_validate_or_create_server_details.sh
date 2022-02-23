#!/bin/bash

NEXT_SCRIPT="./step_2_generate_csr.sh"
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
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

create_server_details_file() {
	echo "Creating server details file"
	SERVER_NAME=$(echo $SERVER | cut -d'.' -f1)
	SERVICE=$(echo $SERVER_NAME | cut -d'-' -f1)
	if [[ $SERVICE == 'tqp' ]]; then
		SERVICE=$(echo $SERVER_NAME | cut -d'-' -f2)
	fi


IFS=
DETAILS_CONTENTS=$(cat <<EOF_DETAILS
[req]
default_bits = 4096
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn
[ dn ]
C=US
ST=Virginia
L=McLean
O=RI
OU=Software
emailAddress=tpowers@ridgelineintl.com
CN = prod.${SERVICE}
[ req_ext ]
subjectAltName = @alt_names
[ alt_names ]
DNS.1 = ${SERVER}
DNS.2 = localhost
EOF_DETAILS
)
	echo $DETAILS_CONTENTS > ${SERVER_DETAILS}
}

check_for_existing_csr() {
	if [[ -f ${BASE_PATH}${SERVER}.csr ]]; then
		echo "A ${BASE_PATH}${SERVER}.csr file already exists. Would you like to create a new one and overwrite the old? y/n"
		read ans
		if [[ $ans != "Y" && $ans != "y" ]]; then
			exit 1
		fi
	fi
}

check_for_server_details_file() {
	SERVER_DETAILS=${BASE_PATH}${SERVER}_details.txt
	if [[ ! -f ${SERVER_DETAILS} ]]; then
		echo "The '${SERVER_DETAILS}' file does not exist."
		echo "Would you like to create a default version you can modify? y/n"
		read ans
		if [ ${ans} != "Y" ] && [ ${ans} != "y" ]; then
			echo "Okay. Bye."
			exit 0
			else
			create_server_details_file
		fi
	fi
}

verify_server_details_file() {
	echo -e "********** ${SERVER_DETAILS} **********${GREEN}"
	cat ${SERVER_DETAILS}
	echo -e "${NC}******************************"
	echo "If the above '${SERVER_DETAILS}' looks correct, the script will procede to the next step, otherwise, edit the file and then procede."
}

move_to_next_step() {
	echo "Is the file correct? y/n"
	read ans
	if [[ $ans == "Y" || $ans == "y" ]]; then
		$NEXT_SCRIPT
	else
		echo ""
		echo "Edit the file then run: ${NEXT_SCRIPT}"
		echo ""
		echo "vi ${SERVER_DETAILS}"
		echo ""
	fi
}

echo -e "${YELLOW}========== STEP 1 ==========${NC}"
load_server_config
check_for_existing_csr
check_for_server_details_file
verify_server_details_file
move_to_next_step
