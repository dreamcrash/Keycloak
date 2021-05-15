#!/bin/bash

set -e
set -u -o pipefail 

KEYCLOAK_IP="$1"
REALM_NAME="$2"

CERTIFICATE="$(curl -k -sS https://$KEYCLOAK_IP/auth/realms/$REALM_NAME/protocol/openid-connect/certs | jq -r .keys[0].x5c[0])"
cat <<EOF > x5c-cert-formated.pem
-----BEGIN CERTIFICATE-----
$CERTIFICATE
-----END CERTIFICATE-----
EOF
cat x5c-cert-formated.pem
rm x5c-cert-formated.pem
