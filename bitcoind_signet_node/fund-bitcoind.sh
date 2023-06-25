#!/bin/bash

# Bitcoin faucet .onion address
FAUCET_URL=djhldxysczvhrq4sq44one5xglcktj52g7un2664q646uw7rvabbynyd.onion
ADDR=`cli getnewaddress`


RESPONSE=`curl --socks5-hostname localhost:9050 "${FAUCET_URL}:5050/faucet?address=${ADDR}"`

if [[ $RESPONSE == *"Success"* ]]; then
    echo "Node funded!"
else
    echo "Failed to fund node: $RESPONSE"
fi
