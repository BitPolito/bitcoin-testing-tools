#!/bin/bash
set -Eeuo pipefail

# Move bitcoin.conf to /bitcoind
if [ -f "/data/bitcoin.conf" ]; then
    mv /data/bitcoin.conf /bitcoind/bitcoin.conf
    ln -s /bitcoind /root/.
    # If not is assumed that the bitcoin.conf is already in /bitcoind
fi


echo "Starting bitcoind..."
bitcoind -datadir=/bitcoind -daemon 2>&1 > /dev/null

# Wait for bitcoind startup
until bitcoin-cli -datadir=/bitcoind -rpcwait getblockchaininfo | jq -e ".blocks > 0" > /dev/null 2>&1
do
    echo -n "."
    sleep 1
done
echo "bitcoind started."
echo "===================================="

# Get the signet magic string from bitcoind debug logs
if [ -f "/bitcoind/sig_magic.txt" ]; then
    # If the file exists, check if the magic string is the same
    echo "Signet magic: $(cat /bitcoind/sig_magic.txt)"
else
    # If the file doesn't exist, create it
    SIG_MAGIC=`cat /bitcoind/signet/debug.log | grep -oP 'Signet derived magic \(message start\): \K[a-f0-9]+'`
    echo $SIG_MAGIC > /bitcoind/sig_magic.txt
fi


# If wallet that already exists, load, so don't fail if it does,
# just load the existing wallet:
WALLET=$(ls /bitcoind/signet/wallets -1 | head -1 | tail -1)
if [ -f /bitcoind/signet/wallets/$WALLET/wallet.dat ]; then
    echo "================================================"
    echo "Loading the main wallet:"
    echo $WALLET
    bitcoin-cli -datadir=/bitcoind loadwallet "$WALLET" 2>&1 >/dev/null
    echo "Bitcoin core wallet \"$WALLET\" loaded."
    echo "================================================"
else
    echo "================================================"
    echo "Creating the main wallet:"
    bitcoin-cli -datadir=/bitcoind -named createwallet wallet_name="main_wallet" descriptors=true 2>&1 > /dev/null
    echo "Bitcoin core wallet \"main_wallet\" created."
    echo "================================================"
fi

# Fund the node
CURR_BAL=$(bitcoin-cli -datadir=/bitcoind -rpcwait getbalance)
result=$(awk -v num="$CURR_BAL" 'BEGIN { if (num >= 0 && num < 0.4) print "true"; else print "false" }')
if [ "$result" == "true" ]; then
    source /usr/local/bin/fund-bitcoind.sh
else
    echo "bitcoind already funded."
fi

exec "$@"

