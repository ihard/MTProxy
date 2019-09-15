FROM debian:buster as builder

WORKDIR /src/mtproto-proxy
COPY . .

RUN apt-get update && apt-get -y install git curl build-essential libssl-dev zlib1g-dev

RUN make

FROM debian:buster-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl ca-certificates iproute2 xxd && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt

EXPOSE 443 2398
VOLUME /data
WORKDIR /data

COPY --from=builder /src/mtproto-proxy/objs/bin/mtproto-proxy /usr/local/bin
COPY --from=builder /src/mtproto-proxy/docker-entrypoint.sh /

ENTRYPOINT /docker-entrypoint.sh
