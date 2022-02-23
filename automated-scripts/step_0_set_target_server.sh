#!/bin/bash

NEXT_SCRIPT="./step_1_validate_or_create_server_details.sh"
YELLOW='\033[0;33m'
NC='\033[0m'

load_server_config() {
	if [[ -f ./server.conf ]]; then
		source ./server.conf
	fi
}

prompt_for_server() {
	echo "What is the target server?"
	read SERVER
}

write_server_config() {
	echo SERVER=$SERVER > ./server.conf
	if [[ ! -d ./${SERVER} ]]; then
		mkdir ./${SERVER}
	fi
	echo "You may proceed to Step 2"
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
echo -e "${YELLOW}========== STEP 0 ==========${NC}"

load_server_config
validate_target_server
move_to_next_step