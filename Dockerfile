#BUILD THE SERVER IMAGE
FROM --platform=linux/amd64 cm2network/steamcmd:root

RUN dpkg --add-architecture i386 && \
    mkdir -pm755 /etc/apt/keyrings && \
    apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && \
    wget -qO /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -qNP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources && \
    apt-get update && apt-get install -y --install-recommends winehq-stable && \
    apt-get install -y --no-install-recommends \
    gettext-base \
    procps \
    jq \
    winbind \
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

RUN mkdir -p /home/steam/server-files && \
    chmod +x /home/steam/server/*.sh

WORKDIR /home/steam/server

HEALTHCHECK --start-period=5m \
            CMD pgrep "wine" > /dev/null || exit 1

ENTRYPOINT ["/home/steam/server/init.sh"]
