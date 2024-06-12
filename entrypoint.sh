#!/bin/sh

set -e

PASSBOLT_CLI="/usr/local/bin/go-passbolt-cli"

if [[ -z "${INPUTS_ARGS}" ]]; then
	echo "ERROR! No args were provided."
	exit 255
fi

if [[ -z "${INPUTS_PASSBOLT_URL}" ]]; then
	echo "ERROR! No passbolt URL was provided."
	exit 255
fi

if [[ -z "${INPUTS_PASSWORD}" ]]; then
	echo "ERROR! No user password was provided."
	exit 255
fi

if [[ -z "${INPUTS_PRIVATEKEY}" ]]; then
	echo "ERROR! No user private key string was provided."
	exit 255
fi

# Configure passbolt CLI
${PASSBOLT_CLI} --serverAddress "${INPUTS_PASSBOLT_URL}" --userPassword "${INPUTS_PASSWORD}" --userPrivateKey "${INPUTS_PRIVATEKEY}" >/dev/null 2>&1

if [ $? -ne 0 ]; then
	echo "ERROR: Failed to configure passbolt CLI"
	exit 255
fi

# Call cli with args
${PASSBOLT_CLI} "${INPUT_ARGS}"
