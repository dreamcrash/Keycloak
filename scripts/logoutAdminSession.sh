#!/bin/bash

set -e
set -u -o pipefail 

KEYCLOAK_IP="$1"
TOKEN="$2"

if [[ $# -ne 2 ]]; then
        echo "Wrong number of parameters">&2
	echo "Usage: $0 <Keycloak IP> <Token>">&2
        exit 1
fi


ACCESS_TOKEN=$(echo $TOKEN | jq -r .access_token)
SESSION_STATE=$(echo $TOKEN | jq -r .session_state)

curl -k -sS 	-X DELETE "https://$KEYCLOAK_IP/auth/admin/realms/master/sessions/$SESSION_STATE" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer $ACCESS_TOKEN"
