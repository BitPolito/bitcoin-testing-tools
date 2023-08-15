FROM python:3.10-slim-bullseye

RUN apt-get clean
RUN apt-get update
RUN apt-get install -y curl pkg-config build-essential  apt-utils wget git jq nano

# Install poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

ENV LNBITS_VER="0.10.9"

WORKDIR /app

RUN git clone --depth=1 --branch ${LNBITS_VER} https://github.com/lnbits/lnbits.git
RUN mkdir -p /app/lnbits/data

RUN cd /app/lnbits && poetry install --only main

COPY .env /app/lnbits
RUN chmod 600 /app/lnbits/.env
COPY wait-for-bitcoind.sh /app
RUN chmod +x /app/wait-for-bitcoind.sh

ENV LNBITS_PORT="7000"
ENV LNBITS_HOST="0.0.0.0"

ENTRYPOINT ["/app/wait-for-bitcoind.sh"]
CMD ["sh", "-c", "cd /app/lnbits && poetry run lnbits --port $LNBITS_PORT --host $LNBITS_HOST"]