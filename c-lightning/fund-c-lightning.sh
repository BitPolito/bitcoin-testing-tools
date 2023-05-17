#!/bin/bash
set -Eeuo pipefail

# Generate a new receiving address for c-lightning wallet
address=$(lightning-cli --lightning-dir=/lightningd newaddr | jq '.bech32' -r)

# Ask Bitcoin Core to send 10 BTC to the address, using JSON-RPC call
until bitcoin-cli \
    --rpcuser=bitcoin \
    --rpcpassword=bitcoin \
    --rpcconnect=localhost:38332 \
    --signet \
    sendtoaddress ${address} 10 "funding c-lightning"
do
	sleep 1;
	echo Retrying funding...
done
