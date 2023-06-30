#!/bin/bash

# run-in-node: Run a command inside a docker container, using the bash shell
function run-in-node () {
    docker exec "$1" /bin/bash -c "${@:2}"
}

CLN_ONION=`run-in-node c-lightning 'cli getinfo | jq -r ".address[].address"'`
CLN_REST=`run-in-node tor 'cat /var/lib/tor/hidden_service_cln_rest/hostname'`
CLN_MACAROON=`run-in-node c-lightning 'xxd -ps -u -c 1000 /lightningd/cln-plugins/c-lightning-REST-0.10.1/certs/access.macaroon'`
CLN_ID=`run-in-node c-lightning 'cli getinfo | jq -r ".id"'`

echo "String for connecting to c-lightning REST API to ZEUS app:"
REST_STR="c-lightning-rest://http://${CLN_REST}:8080?&macaroon=${CLN_MACAROON}&protocol=http"
echo $REST_STR
echo ""

echo "String to give to your peers to connect to your node:"
ID_STR="${CLN_ID}@${CLN_ONION}:39735"
echo $ID_STR

# Get QR codes to scan
curl -so "ZeusControl.png"  "https://api.qrserver.com/v1/create-qr-code/?data=$(jq -s -R -r @uri <<< "$REST_STR")&format=png&size=512x512&margin=10"
curl -so "peerID.png" "https://api.qrserver.com/v1/create-qr-code/?data=$(jq -s -R -r @uri <<< "$ID_STR")&format=png&size=512x512&margin=10"
