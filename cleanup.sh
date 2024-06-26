#!/bin/sh

set -e

TMP="${RUNNER_TEMP:-/tmp}/pbolt"

echo "cleaning up"
rm -frv ${TMP}
