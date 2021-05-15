#!/bin/bash

set -e
set -u -o pipefail 

if [[ $# -ne 5 ]]; then
        echo "Wrong number of parameters">&2
        echo "Usage: $0 <Keycloak IP> <Realm Name> <Client ID> <Client Secret> <Token>">&2
        exit 1
fi

KEYCLOAK_ID="$1"
REALM_NAME="$2"
CLIENT_ID="$3"
CLIENT_SECRET="$4"
TOKEN="$5"
REFRESH_TOKEN=$(echo $TOKEN | jq -r .refresh_token)


curl -k -X POST "https://$KEYCLOAK_ID/auth/realms/$REALM_NAME/protocol/openid-connect/logout" \
	-H "Content-Type: application/x-www-form-urlencoded" \
	-d client_id=$CLIENT_ID \
	-d client_secret=$CLIENT_SECRET \
	-d refresh_token=$REFRESH_TOKEN
