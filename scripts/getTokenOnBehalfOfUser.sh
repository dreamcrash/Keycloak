#!/bin/bash

set -e
set -u -o pipefail 



if [[ $# -ne 5 ]]; then
        echo "Wrong number of parameters">&2
        echo "Usage: $0 <Keycloak IP> <Realm Name> <Client ID> <User Name> <User Password>">&2
        exit 1
fi

KEYCLOAK_IP="$1"
REALM_NAME="$2"
CLIENT_ID="$3"
USER_NAME="$4"
USER_PASSWORD="$5"
SCRIPT_DIR="$(dirname "$0")"

curl -k -sS 	-X POST	-d "client_id=$CLIENT_ID" \
			-d "username=$USER_NAME" \
			-d "password=$USER_PASSWORD" \
			-d "grant_type=password" \
			 "https://$KEYCLOAK_IP/auth/realms/$REALM_NAME/protocol/openid-connect/token"
