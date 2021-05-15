#!/bin/bash

set -e
set -u -o pipefail

if [[ $# -ne 4 ]]; then
        echo "Wrong number of parameters">&2
	echo "Usage: $0 <Keycloak IP> <Admin User Name> <Admin Password> <Realm Json Data>">&2
        exit 1
fi

KEYCLOAK_IP="$1"
ADMIN_USERNAME="$2"
ADMIN_PASSWORD="$3"
REALM_JSON_DATA="$4"
SCRIPT_DIR="$(dirname "$0")"


ADMIN_TOKEN="$($SCRIPT_DIR/getAdminToken.sh "$KEYCLOAK_IP" "$ADMIN_USERNAME" "$ADMIN_PASSWORD")"
ACCESS_TOKEN="$(echo $ADMIN_TOKEN | jq -r .access_token)"

realmName=$(echo $REALM_JSON_DATA | jq -r .realm)
echo "<------- { Create Realm : ===> '$realmName' } ------->"
curl -k -sS -X POST "https://$KEYCLOAK_IP/auth/admin/realms" \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer $ACCESS_TOKEN" \
		-d "$REALM_JSON_DATA"

$SCRIPT_DIR/logoutAdminSession.sh "$KEYCLOAK_IP" "$ADMIN_TOKEN"
