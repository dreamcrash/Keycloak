#!/bin/bash
#Get Public Key

set -e
set -u -o pipefail

if [[ $# -ne 2 ]]; then
        echo "Wrong number of parameters">&2
        echo "Usage: $0 <Keycloak IP> <Realm Name>">&2
        exit 1
fi

KEYCLOAK_IP="$1"
REALM_NAME="$2"

curl -k -sS https://$KEYCLOAK_IP/auth/realms/$REALM_NAME | jq -r .public_key
