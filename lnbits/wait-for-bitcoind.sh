#!/bin/bash
set -Eeuo pipefail

echo Waiting for bitcoind to start...
until curl --silent --user bitcoin:bitcoin --data-binary '{"jsonrpc": "1.0", "id": "lnbits", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://localhost:38332/ | jq -e ".result.blocks > 100" > /dev/null 2>&1
do
    echo -n "."
    sleep 1
done

echo Waiting for bitcoind to be fund...
until curl --silent --user bitcoin:bitcoin --data-binary '{"jsonrpc": "1.0", "id": "lnbits", "method": "getbalance", "params": ["*", 1]}' -H 'content-type: text/plain;' http://localhost:38332/ | jq -e ".result > 0" > /dev/null 2>&1
do
    echo -n "."
    sleep 1
done

echo Wait for lightningd to start...
while true; do
    if echo $(ls /lightningd) | grep -q "signet"; then
        if echo $(ls /lightningd/signet) | grep -q "lightning-rpc"; then
            echo "'lightning-rpc' created."
            break
        fi
    fi
    sleep 1
done

exec "$@"

