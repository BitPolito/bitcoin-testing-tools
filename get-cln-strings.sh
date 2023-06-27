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
echo "c-lightning-rest://http://${CLN_REST}:8080?&macaroon=${CLN_MACAROON}&protocol=http"
echo ""

echo "String to give to your peers to connect to your node:"
echo "${CLN_ID}@${CLN_ONION}:39735"

