#!/bin/bash

set -o allexport
source .env
set +o allexport

linode-cli linodes create --label "${LABEL}" \
                          --region "${REGION}" \
                          --root_pass "${PASSWORD}" \
                          --stackscript_id "${STACKSCRIPT_ID}" \
                          --stackscript_data '{ "HOST":"$HOST", "USERNAME":"$USERNAME", "PASSWORD":"$PASSWORD", "IGNOREIP":"$IGNOREIP", "SSHKEY":"$SSHKEY"}' \
                          --image "${IMAGE}" \
                          --type "${PLAN}"
