#!/bin/bash
# Create new Linode using Stackscript.
#
# Usage:
#   ./deploy.sh 
#
# Include extra configuration variables in .env file.

echo "Creating new Linode using Stackscript."
read -p "Hostname: " HOSTNAME
read -s -p "Password: " PASSWORD
echo ""

LABEL=$HOSTNAME

# Import environment variables
set -o allexport
source .env
set +o allexport

echo ""
echo "Reading configuration variables from .env file:"
echo "Hostname:       $HOSTNAME"
echo "Label:          $LABEL"
echo "Username:       $USERNAME"
if [[ -n $SSHKEY ]]; then
    echo "SSH key:        yes"
else
    echo "SSH key:        no"
fi
if [[ -n $IGNOREIP ]]; then
    echo "Ignore IP:      $IGNOREIP"
else
    echo "Ignore IP:      no"
fi
echo "StackScript ID: $STACKSCRIPT_ID"
echo "Region:         $REGION"
echo "Image:          $IMAGE"
echo "Plan:           $PLAN"
echo ""

# Create new linode
linode-cli linodes create --label "${LABEL}" \
                          --region "${REGION}" \
                          --stackscript_id "${STACKSCRIPT_ID}" \
                          --stackscript_data '{ "SCRIPT_HOSTNAME":"'"${HOSTNAME}"'", "SCRIPT_USERNAME":"'"${USERNAME}"'", "SCRIPT_PASSWORD":"'"${PASSWORD}"'", "SCRIPT_IGNOREIP":"'"${IGNOREIP}"'", "SCRIPT_SSHKEY":"'"${SSHKEY}"'" }' \
                          --image "${IMAGE}" \
                          --type "${PLAN}" \
                          --root_pass "${PASSWORD}"
