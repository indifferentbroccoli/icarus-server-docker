#BUILD THE SERVER IMAGE
FROM --platform=linux/amd64 cm2network/steamcmd:root

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y --no-install-recommends \
    gettext-base=0.21-12 \
    procps=2:4.0.2-3 \
    jq=1.6-2.1+deb12u1 \
    wine \
    wine32:i386 \
    wine64 \
    xvfb \
    xauth \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

LABEL maintainer="support@indifferentbroccoli.com" \
      name="indifferentbroccoli/icarus-server-docker" \
      github="https://github.com/indifferentbroccoli/icarus-server-docker" \
      dockerhub="https://hub.docker.com/r/indifferentbroccoli/icarus-server-docker"

ENV HOME=/home/steam \
    CONFIG_DIR=/icarus-config \
    DEFAULT_PORT=17777 \
    QUERY_PORT=27015 \
    SERVER_NAME=icarus-server \
    MAX_PLAYERS=8 \
    MULTIHOME="" \
    UPDATE_ON_START=true

COPY ./scripts /home/steam/server/

COPY branding /branding

RUN mkdir -p /home/steam/server-files /home/steam/server-data && \
    chmod +x /home/steam/server/*.sh

WORKDIR /home/steam/server

HEALTHCHECK --start-period=5m \
            CMD pgrep "wine" > /dev/null || exit 1

ENTRYPOINT ["/home/steam/server/init.sh"]
