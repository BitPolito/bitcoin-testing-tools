#!/bin/bash
set -Eeuo pipefail

echo Waiting for bitcoind to mine blocks...
until curl --silent --user bitcoin:bitcoin --data-binary '{"jsonrpc": "1.0", "id": "electrs", "method": "getblockcount", "params": []}' -H 'content-type: text/plain;' http://localhost:38332/ | jq -e ".result > 10" > /dev/null 2>&1
do
    echo -n "."
    sleep 1
done
