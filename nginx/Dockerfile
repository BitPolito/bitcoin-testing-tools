ARG OS=nginx
FROM ${OS} as electrum-server

# Create self-signed SSL/TLS certificate
RUN openssl req -x509 -nodes -newkey rsa:4096 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/CN=localhost" -days 3650 && \
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak && \
    mkdir -p /etc/nginx/streams-enabled

COPY nginx.conf /etc/nginx
COPY electrs-reverse-proxy.conf /etc/nginx/streams-enabled

EXPOSE 60602

# WORKDIR /root
# CMD ["nginx", "-g", "daemon off;"]
