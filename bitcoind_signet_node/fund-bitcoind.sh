#!/bin/bash

# Bitcoin faucet .onion address
FAUCET_URL=bitcoindfaucetonionaddress.onion
ADDR=`cli getnewaddress`


RESPONSE=`curl --socks5-hostname localhost:9050 "${FAUCET_URL}:5050/faucet?address=${ADDR}"`

if [[ $RESPONSE == *"Success"* ]]; then
    echo "Node funded!"
else
    echo "Failed to fund node: $RESPONSE"
fi
