#!/bin/bash

set -e
set -u -o pipefail

if [[ $# -ne 3 ]]; then
        echo "Wrong number of parameters">&2
	echo "Usage: $0 <Keycloak IP> <Admin User Name> <Admin Password>">&2
        exit 1
fi

KEYCLOAK_IP="$1"
ADMIN_NAME="$2"
ADMIN_PASSWORD="$3"

curl -k -sS     -d "client_id=admin-cli" \
                -d "username=$ADMIN_NAME" \
                -d "password=$ADMIN_PASSWORD" \
                -d "grant_type=password" \
                "https://$KEYCLOAK_IP/auth/realms/master/protocol/openid-connect/token"
