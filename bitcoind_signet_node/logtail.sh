#!/bin/bash
set -Eeuo pipefail

# Show bitcoind log from beginning and follow
touch /bitcoind/signet/debug.log
tail -n +1 -f /bitcoind/signet/debug.log || true
