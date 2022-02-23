#!/bin/bash

NEXT_SCRIPT="./step_3_verify_csr.sh"
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

generate_csr_file() {
	openssl req -new -sha256 -nodes -out ${BASE_PATH}${SERVER}.csr -newkey rsa:4096 -keyout ${BASE_PATH}${SERVER}.key -config <(cat ${SERVER_DETIALS})
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
		echo "Please execute Step 1 to create a template that you can edit."
		exit 1
	fi
}

validate_target_server() {
	if [[ ! -z "$SERVER" ]]; then
		echo "Is '$SERVER' the target server? y/n"
		read ans
		if [[ ! $ans == "Y" && ! $ans == "y" ]]; then
			prompt_for_server
		fi
	else
		prompt_for_server
	fi
	write_server_config
}

move_to_next_step() {
	$NEXT_SCRIPT
}

echo -e "${YELLOW}========== STEP 2 ==========${NC}"
load_server_config
check_for_existing_csr
check_for_server_details_file
generate_csr_file
move_to_next_step