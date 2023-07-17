# Use the official Node.js image as the base image
FROM node:20

ENV RTL_VER="0.14.0"

RUN apt-get update && apt-get install -y git nano curl gpg jq
RUN curl https://keybase.io/suheb/pgp_keys.asc | gpg --import
RUN git clone https://github.com/Ride-The-Lightning/RTL.git

COPY rtl-entrypoint.sh /RTL
RUN chmod +x /RTL/rtl-entrypoint.sh
COPY wait-for-bitcoind.sh /RTL
RUN chmod +x /RTL/wait-for-bitcoind.sh

WORKDIR /RTL
EXPOSE 3000

ENTRYPOINT [ "/RTL/rtl-entrypoint.sh" ]

CMD [ "node", "rtl" ]
