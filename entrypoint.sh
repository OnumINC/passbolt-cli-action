#!/bin/sh

set -e

PASSBOLT_CLI="/usr/local/bin/go-passbolt-cli"
TMP="${RUNNER_TEMP:-/tmp}/pbolt"

if [[ -z "${INPUT_ARGS}" ]]; then
	echo "ERROR! No args were provided."
	exit 255
fi

if [[ -z "${INPUT_PASSBOLT_URL}" ]]; then
	echo "ERROR! No passbolt URL was provided."
	exit 255
fi

if [[ -z "${INPUT_PASSWORD}" ]]; then
	echo "ERROR! No user password was provided."
	exit 255
fi

if [[ -z "${INPUT_PRIVATEKEY}" ]]; then
	echo "ERROR! No user private key string was provided."
	exit 255
fi

# Temp dir must exist
mkdir -p ${TMP}
TMPF=$(mktemp -p ${TMP})

# Configure passbolt CLI
${PASSBOLT_CLI} configure --serverAddress "${INPUT_PASSBOLT_URL}" --userPassword "${INPUT_PASSWORD}" --userPrivateKey "${INPUT_PRIVATEKEY}" >/dev/null 2>&1

if [ $? -ne 0 ]; then
	echo "ERROR: Failed to configure passbolt CLI"
	exit 255
fi

# set input args as script parameters
set -- ${INPUT_ARGS}

# Call cli with args
${PASSBOLT_CLI} $@ >>${TMPF}

# https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions#multiline-strings
# multiline GITHUB_OUTPUT
echo "out<<PBOLTEOF1" >>${GITHUB_OUTPUT}
cat ${TMPF} >>${GITHUB_OUTPUT}
echo "PBOLTEOF1" >>${GITHUB_OUTPUT}

# base64 output
echo "outb64<<PBOLTEOF2" >>${GITHUB_OUTPUT}
cat ${TMPF} >>${GITHUB_OUTPUT}
echo "PBOLTEOF2" >>${GITHUB_OUTPUT}
