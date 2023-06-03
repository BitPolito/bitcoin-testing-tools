#!/bin/bash
set -Eeuo pipefail

source /usr/local/bin/wait-for-bitcoind.sh

SIG_MAGIC=`cat /bitcoind/sig_magic.txt`

echo "signet_magic = \"${SIG_MAGIC}\"" >> "/electrum/electrs.conf"
cat "/electrum/electrs.conf"

exec "$@"
