#!/bin/bash

# Bitcoin faucet .onion address
BITCOIN_MINER_URL="0.0.0.0"
SIGNETCHALLENGE="00000000signetofminernode"
FAUCET_URL="bitcoindfaucetonionaddress.onion"

sed -i "s/signetchallenge=00000000signetofminernode/signetchallenge=$SIGNETCHALLENGE/" ./bitcoind_signet_node/bitcoind/bitcoin.conf
sed -i "s/seednode=0.0.0.0:38333/seednode=$BITCOIN_MINER_URL:38333/" ./bitcoind_signet_node/bitcoind/bitcoin.conf
sed -i "s/addnode=0.0.0.0:38333/addnode=$BITCOIN_MINER_URL:38333/" ./bitcoind_signet_node/bitcoind/bitcoin.conf
sed -i "s/FAUCET_URL=bitcoindfaucetonionaddress.onion/FAUCET_URL=$FAUCET_URL/" ./bitcoind_signet_node/fund-bitcoind.sh
