ARG OS=ubuntu
ARG OS_VER=focal
FROM ${OS}:${OS_VER} as os-base

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq && \
    apt-get -y install nano && \
    apt-get install -y bc && \
    apt-get install -yqq \
    curl unzip jq bash-completion \
    
FROM os-base as bitcoind-install

ARG BITCOIND_VER=24.0.1
ARG BITCOIN_FILE=bitcoin-${BITCOIND_VER}-x86_64-linux-gnu.tar.gz
# Install Bitcoin Core binaries and libraries
RUN cd /tmp && \
	curl -# -sLO https://bitcoincore.org/bin/bitcoin-core-${BITCOIND_VER}/${BITCOIN_FILE} && \
	curl -# -sLO https://bitcoincore.org/bin/bitcoin-core-${BITCOIND_VER}/SHA256SUMS
	
# Verify the integrity of the binaries
RUN cd /tmp && grep "${BITCOIN_FILE}" SHA256SUMS | sha256sum -c -

RUN cd /tmp && \
	tar -zxf bitcoin-${BITCOIND_VER}-x86_64-linux-gnu.tar.gz && \
	cd bitcoin-${BITCOIND_VER} && \
	install -vD bin/* /usr/bin && \
	install -vD lib/* /usr/lib && \
	cd /tmp && \
	rm bitcoin-${BITCOIND_VER}-x86_64-linux-gnu.tar.gz && \
	rm -rf bitcoin-${BITCOIND_VER}

# bash completion for bitcoind and bitcoin-cli
ENV GH_URL https://raw.githubusercontent.com/bitcoin/bitcoin/master
ENV BC /usr/share/bash-completion/completions
ADD $GH_URL/contrib/completions/bash/bitcoin-cli.bash-completion $BC/bitcoin-cli
ADD $GH_URL/contrib/completions/bash/bitcoind.bash-completion $BC/bitcoind
ADD $GH_URL/contrib/completions/bash/bitcoin-tx.bash-completion $BC/bitcoin-tx

# Copy bitcoind configuration directory
COPY bitcoind /bitcoind

RUN ln -s /bitcoind /root/.

COPY cli /usr/local/bin
COPY bashrc /root/.bashrc

RUN chmod +x /usr/local/bin/cli

# bitcoind P2P
EXPOSE 38333/tcp
# bitcoind regtest RPC
EXPOSE 38332/tcp
# zmqpubrawblock
EXPOSE 28332/tcp
# zmqpubrawtx
EXPOSE 28333/tcp

WORKDIR /bitcoind

# Start mining on custom signet
CMD ["bitcoind -datadir=/bitcoind -daemon"]

