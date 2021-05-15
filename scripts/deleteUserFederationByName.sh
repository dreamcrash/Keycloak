#!/bin/bash

set -e
set -u -o pipefail 

if [[ $# -ne 5 ]]; then
        echo "Wrong number of parameters">&2
	echo "Usage: $0 <Keycloak IP> <Admin User Name> <Admin Password> <Realm Name> <User Federation Name>">&2
        exit 1
fi

KEYCLOAK_IP="$1"
ADMIN_USERNAME="$2"
ADMIN_PASSWORD="$3"
REALM_NAME="$4"
USER_FEDERATION_NAME="$5"
SCRIPT_DIR="$(dirname "$0")"

ADMIN_TOKEN="$($SCRIPT_DIR/getAdminToken.sh "$KEYCLOAK_IP" "$ADMIN_USERNAME" "$ADMIN_PASSWORD")"
ACCESS_TOKEN="$(echo $ADMIN_TOKEN | jq -r .access_token)"

USER_FEDERATION_ID="$($SCRIPT_DIR/getUserFederationByName.sh "$KEYCLOAK_IP" "$ADMIN_USERNAME" "$ADMIN_PASSWORD" "$REALM_NAME" "$USER_FEDERATION_NAME" | jq -r .[0].id)"

curl -k -sS 	-X DELETE "https://$KEYCLOAK_IP/auth/admin/realms/$REALM_NAME/components/$USER_FEDERATION_ID" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer $ACCESS_TOKEN"


$SCRIPT_DIR/logoutAdminSession.sh "$KEYCLOAK_IP" "$ADMIN_TOKEN"
