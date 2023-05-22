#!/bin/bash
set -Eeuo pipefail

echo "===================================="
echo "BITCOIN CONF:"
echo
if [[ -f "/bitcoind/bitcoin.conf" ]]; then
    cat "/bitcoind/bitcoin.conf"
fi
echo "===================================="
# Executing CMD
exec "$@"

