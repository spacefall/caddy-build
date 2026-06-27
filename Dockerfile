FROM dhi.io/golang:1.25-debian13-dev AS builder

RUN CGO_ENABLED=0 go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

WORKDIR /build
RUN xcaddy build \
    --with github.com/mholt/caddy-l4 \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddyserver/transform-encoder \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/porech/caddy-maxmind-geolocation \
    --with github.com/hslatman/caddy-crowdsec-bouncer/http \
    --with github.com/hslatman/caddy-crowdsec-bouncer/layer4 \
    --with github.com/hslatman/caddy-crowdsec-bouncer/appsec 

FROM dhi.io/caddy:2
COPY --from=builder /build/caddy /usr/local/bin/caddy
