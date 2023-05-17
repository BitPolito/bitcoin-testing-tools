ARG OS=ubuntu
ARG OS_VER=focal
FROM ${OS}:${OS_VER} as os-base

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq && apt-get install -yqq \
    libpq-dev curl unzip jq bash-completion gpg xz-utils \
    nmap nano autoconf automake build-essential git libtool libgmp-dev libsqlite3-dev \
    zlib1g-dev libsodium-dev

FROM os-base as cln-install

# Get bitcoin-cli
# Install bitcoind
COPY bitcoind-download.sh /usr/local/bin
RUN chmod +x /usr/local/bin/bitcoind-download.sh
RUN bitcoind-download.sh

# Set CL_VER ENV from ARG
ARG CL_VER=23.02
ENV CL_VER=${CL_VER}
ARG CL_FILE=clightning-v${CL_VER}-Ubuntu-20.04.tar.xz
 
RUN cd /tmp && \
    curl -# -sLO https://github.com/ElementsProject/lightning/releases/download/v${CL_VER}/${CL_FILE}

# Verify developer signatures. The `gpg --verify` command will print a
# couple of warnings about the key not being trusted. That's ok. The
# important part is that it doesn't error and reports "Good
# signature".

# Public Keys of Rusty Russel, Christian Decker, and Alex Myers
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 15EE8D6CAB0E7F0CF999BFCBD9200E6CD1ADB8F1 B7C4BE81184FC203D52C35C51416D83DC4F0E86D 23A00AFC66BCD5FF9ED5DC4F8F55EE750D950E3E
ADD https://raw.githubusercontent.com/ElementsProject/lightning/master/contrib/keys/cdecker.txt /tmp/cdecker.txt
ADD https://raw.githubusercontent.com/ElementsProject/lightning/master/contrib/keys/niftynei.txt /tmp/niftynei.txt
ADD https://raw.githubusercontent.com/ElementsProject/lightning/master/contrib/keys/rustyrussell.txt /tmp/rustyrussell.txt
RUN gpg --import /tmp/cdecker.txt /tmp/niftynei.txt /tmp/rustyrussell.txt


ADD https://github.com/ElementsProject/lightning/releases/download/v${CL_VER}/SHA256SUMS /tmp/SHA256SUMS
ADD https://github.com/ElementsProject/lightning/releases/download/v${CL_VER}/SHA256SUMS.asc /tmp/SHA256SUMS.asc


RUN gpg --verify /tmp/SHA256SUMS.asc && \
    cd /tmp && grep "${CL_FILE}" SHA256SUMS | sha256sum -c -

RUN tar -xvf /tmp/${CL_FILE}

ADD https://raw.githubusercontent.com/ElementsProject/lightning/master/contrib/lightning-cli.bash-completion /usr/share/bash-completion/completions/lightning-cli

COPY lightningd /lightningd
WORKDIR /lightningd
RUN ln -s /lightningd /root/.lightning

COPY bashrc /root/.bashrc
COPY c-lightning-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/c-lightning-entrypoint.sh
COPY fund-c-lightning.sh /usr/local/bin
RUN chmod +x /usr/local/bin/fund-c-lightning.sh
COPY logtail.sh /usr/local/bin
RUN chmod +x /usr/local/bin/logtail.sh
COPY wait-for-bitcoind.sh /usr/local/bin
RUN chmod +x /usr/local/bin/wait-for-bitcoind.sh
COPY cli /usr/local/bin
RUN chmod +x /usr/local/bin/cli

EXPOSE 9735 9835
ENTRYPOINT ["/usr/local/bin/c-lightning-entrypoint.sh"]

# Show logs from beginning and keep following
CMD ["/usr/local/bin/logtail.sh"]
