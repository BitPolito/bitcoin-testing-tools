ARG OS=ubuntu
ARG OS_VER=focal
FROM ${OS}:${OS_VER} as os-base

# Set TimeZone
ENV TIMEZONE=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone

# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq && apt-get install -qq -y \
    gnupg git curl nano xxd jq libffi-dev libpq-dev \
    software-properties-common

RUN add-apt-repository ppa:deadsnakes/ppa

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install -qq -y \
    python3.10 python3.10-distutils python3-pip

ENV LNBITS_VER="0.10.9"

RUN pip3 install --upgrade pip && \
    pip3 install poetry && \
    pip3 install wheel

RUN cd /root && \
    git --depth=1 --branch v${LNBITS_VER} clone https://github.com/lnbits/lnbits.git

RUN mkdir -p /root/lnbits/data

RUN cd /root/lnbits && \
    poetry env use python3.10 && \
    poetry install --only main

COPY .env /root/lnbits
RUN chmod 600 /root/lnbits/.env
COPY wait-for-bitcoind.sh /usr/local/bin
RUN chmod +x /usr/local/bin/wait-for-bitcoind.sh
COPY run-lnbits.sh /usr/local/bin
RUN chmod +x /usr/local/bin/run-lnbits.sh

ENV LNBITS_PORT="7000"
ENV LNBITS_HOST="0.0.0.0"

EXPOSE ${LNBITS_PORT}

ENTRYPOINT ["/usr/local/bin/wait-for-bitcoind.sh"]
CMD ["/usr/local/bin/run-lnbits.sh"]
