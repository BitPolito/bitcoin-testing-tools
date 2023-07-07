#!/bin/bash
set -Eeuo pipefail
echo $LNBITS_HOST:$LNBITS_PORT
cd /root/lnbits/ && poetry run lnbits --port $LNBITS_PORT --host $LNBITS_HOST --debug