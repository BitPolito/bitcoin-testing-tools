#!/bin/bash
set -Eeuo pipefail

# Define mining constants
CLI="bitcoin-cli -datadir=/bitcoind"
MINER="/bitcoind/contrib/signet/miner"
GRIND="bitcoin-util grind"
MINING_DESC=$(cli listdescriptors | jq -r ".descriptors | .[4].desc")

if [ -f "/bitcoind/nbits_calibration.txt" ]; then
    NBITS=`cat /bitcoind/nbits_calibration.txt`
else
    echo "Waiting for difficulty calibration..."
    NBITS=`$MINER calibrate --grind-cmd="$GRIND" --seconds=600 | grep -oP 'nbits=\K[a-f0-9]+'`
    echo "The number of bits is: $NBITS"
    echo $NBITS > /bitcoind/nbits_calibration.txt
fi

while echo "Start mining... ";
do
    CURRBLOCK=$(bitcoin-cli -datadir=/bitcoind getblockcount)
    echo "Current blockcount: ${CURRBLOCK}"
    if [ $CURRBLOCK -le 100 ]; then 
        $MINER --cli="$CLI" generate --grind-cmd="$GRIND" --min-nbits --descriptor=$MINING_DESC --max-blocks=101
        echo "Balance:" `bitcoin-cli -datadir=/bitcoind getbalance`
    fi
    $MINER --cli="$CLI" generate --grind-cmd="$GRIND" --nbits=$NBITS --descriptor=$MINING_DESC --poisson --ongoing
done

# If loop is interrupted, stop bitcoind
until bitcoin-cli -datadir=/bitcoind -rpcwait stop  > /dev/null 2>&1
do
    echo -n "."
    sleep 1
done

