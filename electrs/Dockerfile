ARG OS=ubuntu
ARG OS_VER=focal
FROM ${OS}:${OS_VER} as electrum-server

# Set TimeZone
ENV TIMEZONE=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq && apt-get install -qq -y \
    nano curl gpg jq openssl git cargo clang cmake

ARG ELECTRS_VERSION="0.9.13"
RUN mkdir -p /electrum

RUN cd /electrum && \
    git clone --depth=1 --branch v${ELECTRS_VERSION} https://github.com/romanz/electrs.git

# Verify signs
RUN cd /electrum/electrs && \
    curl https://romanzey.de/pgp.txt | gpg --import && \
    git verify-tag v${ELECTRS_VERSION}

# Build electrs
RUN cd /electrum/electrs && \
    cargo build --locked --release && \
    install -m 0755 -o root -g root -t /usr/local/bin /electrum/electrs/target/release/electrs

COPY electrs /electrum
COPY electrs-entrypoint.sh /usr/local/bin
COPY wait-for-bitcoind.sh /usr/local/bin
RUN chmod +x /usr/local/bin/electrs-entrypoint.sh
RUN chmod +x /usr/local/bin/wait-for-bitcoind.sh

EXPOSE 60601
ENTRYPOINT ["/usr/local/bin/electrs-entrypoint.sh"]

WORKDIR /root/electrs
CMD ["electrs", "--conf", "/electrum/electrs.conf"]
