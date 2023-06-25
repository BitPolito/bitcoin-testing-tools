#!/bin/bash
set -Eeuo pipefail

source /usr/local/bin/fund-bitcoind.sh

echo "===================================="
echo "BITCOIN CONF:"
echo
if [[ -f "/bitcoind/bitcoin.conf" ]]; then
    cat "/bitcoind/bitcoin.conf"
fi
echo "===================================="
# Executing CMD
exec "$@"

