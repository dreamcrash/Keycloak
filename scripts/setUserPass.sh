#!/bin/bash

set -e
set -u -o pipefail 

if [[ $# -ne 6 ]]; then
        echo "Wrong number of parameters">&2
        echo "Usage: $0 <Keycloak IP> <Admin User Name> <Admin Password> <User Realm> <Username> <User pass>">&2
        exit 1
fi

KEYCLOAK_IP="$1"
ADMIN_USERNAME="$2"
ADMIN_PASSWORD="$3"
USER_REALM="$4"
USERNAME="$5"
USER_PASS="$6"
JSON_DATA='{"credentials":[{"type":"password","value":"'"$USER_PASS"'"}]}'
SCRIPT_DIR="$(dirname "$0")"


ADMIN_TOKEN="$($SCRIPT_DIR/getAdminToken.sh "$KEYCLOAK_IP" "$ADMIN_USERNAME" "$ADMIN_PASSWORD")"
ACCESS_TOKEN="$(echo $ADMIN_TOKEN | jq -r .access_token)"

USER_ID="$(curl -k -sS -X GET "https://$KEYCLOAK_IP/auth/admin/realms/$USER_REALM/users/?username=$USERNAME" \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer $ACCESS_TOKEN" | jq -r .[0].id)"

curl -k -sS -X PUT "https://$KEYCLOAK_IP/auth/admin/realms/$USER_REALM/users/$USER_ID" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $ACCESS_TOKEN" \
        -d $JSON_DATA


$SCRIPT_DIR/logoutAdminSession.sh "$KEYCLOAK_IP" "$ADMIN_TOKEN"





