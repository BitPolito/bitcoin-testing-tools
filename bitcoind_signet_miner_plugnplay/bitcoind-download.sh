#!/bin/bash

# Executables
BITCOIND_VER="24.0.1"

# Get the machine architecture
architecture=$(uname -m)

# Check the architecture and print the corresponding message
case $architecture in
  x86_64)
    BITCOIN_FILE="bitcoin-${BITCOIND_VER}-x86_64-linux-gnu.tar.gz"
    echo "Installing Bitcoin Core ${BITCOIND_VER} for x86_64"
    ;;
  aarch64)
    BITCOIN_FILE="bitcoin-${BITCOIND_VER}-aarch64-linux-gnu.tar.gz"
    echo "Installing Bitcoin Core ${BITCOIND_VER} for aarch64"
    ;;
esac

# Install Bitcoin Core binaries and libraries
cd /tmp && \
curl -# -sLO https://bitcoincore.org/bin/bitcoin-core-${BITCOIND_VER}/${BITCOIN_FILE} && \
curl -# -sLO https://bitcoincore.org/bin/bitcoin-core-${BITCOIND_VER}/SHA256SUMS

# Verify the integrity of the binaries
# TODO: add gpg verification on SHA256SUMS

cd /tmp && grep "${BITCOIN_FILE}" SHA256SUMS | sha256sum -c -

cd /tmp && \
tar -zxf ${BITCOIN_FILE} && \
cd bitcoin-${BITCOIND_VER} && \
install -vD bin/* /usr/bin && \
install -vD lib/* /usr/lib && \
cd /tmp && \
rm ${BITCOIN_FILE} && \
rm -rf bitcoin-${BITCOIND_VER}
