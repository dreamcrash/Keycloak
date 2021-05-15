#!/bin/bash

set -e
set -u -o pipefail 


if [[ $# -ne 6 ]]; then
        echo "Wrong number of parameters">&2
	echo "Usage: $0 <Keycloak IP> <Admin User Name> <Admin Password> <Realm Name> <IDP alias> <Roler Mapper Name>">&2
        exit 1
fi

KEYCLOAK_IP="$1"
ADMIN_USERNAME="$2"
ADMIN_PASSWORD="$3"
REALM_NAME="$4"
IDP_ALIAS="$5"
ROLE_MAPPER_NAME="$6"
SCRIPT_DIR="$(dirname "$0")"

ROLE_MAPPERS=$($SCRIPT_DIR/getIdentityProviderRoleMappers.sh "$KEYCLOAK_IP" "$ADMIN_USERNAME" "$ADMIN_PASSWORD" "$REALM_NAME" "$IDP_ALIAS")
ROLE_MAPPER_ID="$(echo $ROLE_MAPPERS | jq -r ".[] | select(.name==\"$ROLE_MAPPER_NAME\") | .id")"

if [ "$ROLE_MAPPER_ID" == "" ]; then
     echo "Role Mapper ID does not exist" >&2
     exit 1 
fi

$SCRIPT_DIR/deleteIdentityProviderRoleMapperByID.sh "$KEYCLOAK_IP" "$ADMIN_USERNAME" "$ADMIN_PASSWORD" "$REALM_NAME" "$IDP_ALIAS" "$ROLE_MAPPER_ID"


