#!/bin/bash

echo "Creating new Linode using Stackscript."
read -p "Hostname: " HOSTNAME
read -s -p "Password: " PASSWORD
echo ""
echo "Reading configuration variables from .env file."

LABEL=$HOSTNAME

# Import environment variables
set -o allexport
source .env
set +o allexport

# Create new linode
linode-cli linodes create --label "${LABEL}" \
                          --region "${REGION}" \
                          --stackscript_id "${STACKSCRIPT_ID}" \
                          --stackscript_data '{ "SCRIPT_HOSTNAME":"'"${HOSTNAME}"'", "SCRIPT_USERNAME":"'"${USERNAME}"'", "SCRIPT_PASSWORD":"'"${PASSWORD}"'", "SCRIPT_IGNOREIP":"'"${IGNOREIP}"'", "SCRIPT_SSHKEY":"'"${SSHKEY}"'" }' \
                          --image "${IMAGE}" \
                          --type "${PLAN}" \
                          --root_pass "${PASSWORD}"
