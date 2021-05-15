#!/bin/bash
#Adapted from https://gist.github.com/justindav1s/7acedea1e4f1678f13c46db811b92134

function padBase64  {
    STR=$1
    MOD=$((${#STR}%4))
    if [ $MOD -eq 1 ]; then
       STR="${STR}="
    elif [ $MOD -gt 1 ]; then
       STR="${STR}=="
    fi
    echo ${STR}
}

ACCESS_TOKEN=$1
PUBLIC_KEY=$2

if [[ $# -ne 2 ]]; then
        echo "Wrong number of parameters"
        echo "Usage: $0 <Access Token> <Public Key>"
        exit 1
fi

HEADERPAYLOAD_BASE64="$(echo ${ACCESS_TOKEN} | cut -d"." -f1-2)"
echo -n $HEADERPAYLOAD_BASE64 > HEADERPAYLOAD_BASE64.txt

SIGNATURE_BASE64="$(echo ${ACCESS_TOKEN} | cut -d"." -f3)"
SIGNATURE_BASE64="$(padBase64 ${SIGNATURE_BASE64})"


echo -n $SIGNATURE_BASE64 \
| perl -ne 'tr|-_|+/|; print "$1\n" while length>76 and s/(.{0,76})//; print' \
| openssl enc -base64 -d > sig.dat

PUBLIC_KEY="$(echo -n $PUBLIC_KEY | perl -ne 'tr|-_|+/|; print "$1\n" while length>76 and s/(.{0,76})//; print')"

cat <<EOF > key.pem
-----BEGIN PUBLIC KEY-----
$PUBLIC_KEY
-----END PUBLIC KEY-----
EOF

openssl dgst -sha256 -verify key.pem -signature sig.dat HEADERPAYLOAD_BASE64.txt

#rm x5c-cert-formated.pem
rm key.pem
rm sig.dat
rm HEADERPAYLOAD_BASE64.txt
