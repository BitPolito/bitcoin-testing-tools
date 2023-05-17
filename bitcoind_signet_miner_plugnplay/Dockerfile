ARG OS=ubuntu
ARG OS_VER=focal
FROM ${OS}:${OS_VER} as os-base

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq && \
    apt-get -y install nano && \
    apt-get install -y net-tools && \
    apt-get install -y nmap && \
    apt-get install -y bc && \
    apt-get install -yqq gpg \
    curl unzip jq bash-completion \
    git \
    python3 \
    python3-pip \
    python3-setuptools && \
    pip install argparse requests cryptography pipreqs

FROM os-base as bitcoind-install

# Install bitcoind
COPY bitcoind-download.sh /usr/local/bin
RUN chmod +x /usr/local/bin/bitcoind-download.sh
RUN bitcoind-download.sh

# Install runtime scripts, bash-completion and configuration files

# bash completion for bitcoind and bitcoin-cli
ENV GH_URL https://raw.githubusercontent.com/bitcoin/bitcoin/master
ENV BC /usr/share/bash-completion/completions
ADD $GH_URL/contrib/completions/bash/bitcoin-cli.bash-completion $BC/bitcoin-cli
ADD $GH_URL/contrib/completions/bash/bitcoind.bash-completion $BC/bitcoind
ADD $GH_URL/contrib/completions/bash/bitcoin-tx.bash-completion $BC/bitcoin-tx

# Copy bitcoind configuration directory
COPY bitcoind /bitcoind

RUN ln -s /bitcoind /root/.

# Getting script for signet
# https://github.com/bitcoin/bitcoin/tree/master/contrib/signet
ADD $GH_URL/contrib/signet/getcoins.py /bitcoind/contrib/signet/getcoins.py
ADD $GH_URL/contrib/signet/miner /bitcoind/contrib/signet/miner
RUN chmod +x /bitcoind/contrib/signet/miner

# Copy support scripts
COPY download-minig-framework.sh /usr/local/bin
RUN chmod +x /usr/local/bin/download-minig-framework.sh
RUN download-minig-framework.sh "test/functional/test_framework" "/bitcoind/test/functional/test_framework"
RUN download-minig-framework.sh "contrib/signet" "/bitcoind/contrib/signet"

COPY cli /usr/local/bin
COPY bashrc /root/.bashrc

COPY bitcoind-entrypoint.sh /usr/local/bin
COPY mine.sh /usr/local/bin
RUN chmod +x /usr/local/bin/cli
RUN chmod +x /usr/local/bin/bitcoind-entrypoint.sh
RUN chmod +x /usr/local/bin/mine.sh

RUN pipreqs /bitcoind/test/functional/test_framework
RUN pip install -r /bitcoind/test/functional/test_framework/requirements.txt

# bitcoind P2P
EXPOSE 38333/tcp
# bitcoind regtest RPC
EXPOSE 38332/tcp
# zmqpubrawblock
EXPOSE 28332/tcp
# zmqpubrawtx
EXPOSE 28333/tcp

WORKDIR /bitcoind
ENTRYPOINT ["/usr/local/bin/bitcoind-entrypoint.sh"]

# Start mining on custom signet
CMD ["/usr/local/bin/mine.sh"]

