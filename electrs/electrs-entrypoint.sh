#!/bin/bash
set -Eeuo pipefail

source /usr/local/bin/wait-for-bitcoind.sh

SIG_MAGIC=`cat /bitcoind/sig_magic.txt`
SIGNETMAGIC=true

while read -r line
do
    # Check line by line
    if [[ "$line" == *"signet_magic ="* ]]; then
        SIGNETMAGIC=false
    fi
done < "/electrum/electrs.conf"

if [ $SIGNETMAGIC = false ]; then
    echo "'signet_magic' already present in electrs.conf"
else
    echo "signet_magic = \"${SIG_MAGIC}\"" >> "/electrum/electrs.conf"
fi
cat "/electrum/electrs.conf"

exec "$@"
