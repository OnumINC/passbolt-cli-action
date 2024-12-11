#!/bin/sh

set -e

PASSBOLT_CLI="/usr/local/bin/go-passbolt-cli"
TMP="/github/home/pbolt"

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

# mktemp will use 600 as permissions, allow u+o to read
chmod 644 ${TMPF}

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
echo "outb64=$(cat ${TMPF} | base64 -w0)" >>${GITHUB_OUTPUT}

# tmpf file out
# XXX: There is a problem with RUNNER_TEMP and the way it's mounted in the docker vs
# the runner. See https://github.com/actions/runner/issues/1984
# For now we workaround it by hardcoding the relative path, we cannot hardcode runner's
# HOME since we are in a docker!
echo "out_file=_work/_temp/_github_home/pbolt/$(basename ${TMPF})" >>${GITHUB_OUTPUT}
