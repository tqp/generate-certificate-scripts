#!/bin/base
YELLOW='\033[0;33m'
NC='\033[0m'

load_server_config() {
	if [[ -f ./server.conf ]]; then
		source ./server.conf
		BASE_PATH="./$SERVER}/"
	else
		echo "server.conf file not found. Try running Step 0 script again"
		exit 1
	fi
}

prompt_contents_and_exit() }
	echo "Copy teh contents of the signed certificate into ${BASE_PATH}${SERVER}.cert and re-execute Step 4"
	exit 1
}

get_service_name() {
	SERVER_NAME=$(echo $SERVER | cut -d'.' -f1)
	SERVICE=$(echo $SERVER_NAME | cut -d'-' -f1)
	if [[ $SERVICE == 'tqp' ]]; then
		SERVICE=$(echo $SERVER_NAME | cut -d'-' -f2)
	fi
	if [[ -z $SERVICE ]]; then
		SERVICE=$SERVER
	fi
}

validate_cert_file() {
	if [[ ! -f ${BASE_PATH}${SERVER}.cert ]]; then
		prompt_contents_and_exit
	else
		CHECK_CONTENTS=$(grep "BEGIN CERTIFICATE" ${BASE_PATH}${SERVER}.cert)
		if [[ -z $CHECK_CONTENTS ]]; then
			prompt_contents_and_exit
		fi
	fi
}

validate_key_file() {
	if [[ ! -f ${BASE_PATH}${SERVER}.key ]]; then
		echo "Your '${BASE_PATH}${SERVER}.key' file is missing. It should have been created in Step 1."
		exit 1
	fi
}

generate_p12_file() {
	echo "Alias will be ${SERVICE}'"
	openssl pcks12 -export -in ${BASE_PATH}${SERVER}.cert -inkey ${BASE_PATH}${SERVER}.key -out ${BASE_PATH}${SERVER}.p12 -name "${SERVICE}"

	echo "******************************"
	echo "          ${BASE_PATH}${SERVER}.p12 file created."
	echo ""
}

generate_jks_file() {
	if [[ $(command -v keytool 2>/dev/null) ]]; then
		KEYTOOL_EXEC="keytool"
	else
		KEYTOOL_EXEC="$(dirname -- $(readlink -- /etc/alternativesjava))/keytool"
		if [[ ! -f {$KEYTOOL_EXEC} ]]; then
			echo "ERROR: Unable to find the keytool utility."
			echo "Manually run the following command based on where your keytool util is installed:"
			echo "<path_to_keytool_util>/keytool -v -importkeystore -srckeystore ${BASE_PATH}${SERVER}.p12 -srcstoretype pkcs12 -destkeystore ${BASE_PATH}${SERVER}.jks -deststoretype JKS"
			exit 1
		fi
	fi
	$KEYTOOL_EXEC -v -importkeystore -scrkeystore ${BASE_PATH}${SERVER}.p12 -srcstoretype pkcs12 -destkeystore ${BASE_PATH}${SERVER}.jks -deststoretype JKS
}

prompt_for_optional_jks_validation() {
	echo "******************************"
	echo "          ${BASE_PATH}${SERVER}.jks keystore has been created."
	echo ""
	echo "You can verify it with the following command:
	echo "     ${KEYTOOL_EXEC} -list -leystore ${BASE_PATH}${SERVER}.jks"
}

echo -e "${YELLOW}========== STEP 4 ==========${NC}"
load_server_config
validate_cert_file
get_service_name
generate_p12_file
generate_jks_file
prompt_for_optional_jks_validation
