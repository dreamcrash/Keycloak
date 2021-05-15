#!/bin/bash

set -e
set -u -o pipefail

if [[ $# -ne 5 ]]; then
        echo "Wrong number of parameters">&2
        echo "Usage: $0 <Keycloak IP> <Realm Name> <Client ID> <Client Secret> <Access Token>">&2
        exit 1
fi

KEYCLOAK_IP="$1"
REALM_NAME="$2"
CLIENT_ID="$3"
CLIENT_SECRET="$4"
ACCESS_TOKEN="$5"

INTROSPECT_TOKEN=$(curl -k -sS "https://$KEYCLOAK_IP/auth/realms/$REALM_NAME/protocol/openid-connect/token/introspect" \
			-d "client_id=$CLIENT_ID" \
			-d "client_secret=$CLIENT_SECRET" \
			-d "token=$ACCESS_TOKEN")
			
echo $INTROSPECT_TOKEN | jq -r .active
