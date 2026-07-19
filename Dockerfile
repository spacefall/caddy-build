ARG CADDY_VERSION
FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build \
    --with github.com/mholt/caddy-l4 \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddyserver/transform-encoder \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/hslatman/caddy-crowdsec-bouncer/http \
    --with github.com/hslatman/caddy-crowdsec-bouncer/layer4 \
    --with github.com/hslatman/caddy-crowdsec-bouncer/appsec \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2

# Image starts here
FROM scratch

EXPOSE 80 443 2019
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

WORKDIR /

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=builder /usr/bin/caddy /bin/caddy

ENTRYPOINT ["/bin/caddy"]

CMD ["docker-proxy"]