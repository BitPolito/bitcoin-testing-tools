#!/bin/bash

# Executables
CL_VER=22.11.1

# Import signing keys
curl https://raw.githubusercontent.com/ElementsProject/lightning/master/contrib/keys/cdecker.txt | gpg --import
curl https://raw.githubusercontent.com/ElementsProject/lightning/master/contrib/keys/niftynei.txt | gpg --import
curl https://raw.githubusercontent.com/ElementsProject/lightning/master/contrib/keys/rustyrussell.txt | gpg --import


# Get the machine architecture
architecture=$(uname -m)

# Check the architecture and print the corresponding message
case $architecture in
  x86_64)
    CL_FILE=clightning-v${CL_VER}-Ubuntu-20.04.tar.xz
    echo "Installing Core-Lightning ${CL_VER} for x86_64"
    cd /tmp && \
    curl -# -sLO https://github.com/ElementsProject/lightning/releases/download/v${CL_VER}/${CL_FILE}
    curl -# -sLO https://github.com/ElementsProject/lightning/releases/download/v${CL_VER}/SHA256SUMS
    curl -# -sLO https://github.com/ElementsProject/lightning/releases/download/v${CL_VER}/SHA256SUMS.asc

    gpg --verify /tmp/SHA256SUMS.asc && \
    cd /tmp && grep "${CL_FILE}" /tmp/SHA256SUMS | sha256sum -c -
    cd / && tar -xvf /tmp/${CL_FILE}

    ;;
  aarch64)
    echo "Executables not available for Core-Lightning ${CL_VER} for aarch64"
    echo "Compiling the source code..."

    cd /tmp && \
    git clone https://github.com/ElementsProject/lightning.git && \
    git fetch --all --tags && \
    git reset --hard v${CL_VER} && \
    git verify-tag v${CL_VER} && \
    ./configure --enable-experimental-features && \
    make

    ;;
esac
