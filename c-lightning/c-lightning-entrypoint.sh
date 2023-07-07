#!/bin/bash
set -Eeuo pipefail

# Move conf to /lightningd
if [ -f "/data/config" ]; then
    mv /data/config /lightningd/config
    ln -s /lightningd /root/.lightning
    # If not is assumed that the config is already in /lightningd
fi

# Install plugins first if not already installed
CLN_REST=false
while read -r line
do
    # Check line by line
    if [[ "$line" == *"# cln-rest-plugin"* ]]; then
        echo "'cln-rest-plugin' already present in config"
        CLN_REST=true
    fi
done < "/lightningd/config"

if [ "$CLN_REST" = false ]; then
    echo "Installing 'cln-rest-plugin'..."
    source /usr/local/bin/cln-rest-plugin.sh
fi

# Wait for bitcoind to be ready
source /usr/local/bin/wait-for-bitcoind.sh

echo Starting c-lightning...
lightningd --lightning-dir=/lightningd --daemon

until lightning-cli --lightning-dir=/lightningd getinfo > /dev/null 2>&1
do
    sleep 1
done
echo "Startup complete"
sleep 2

if [ $(lightning-cli listfunds | jq -r ".outputs" | jq "length <= 0") ]; then
    echo "Funding c-lightning wallet"
    source /usr/local/bin/fund-c-lightning.sh
else
    echo "c-lightning already funded."
fi

exec "$@"
