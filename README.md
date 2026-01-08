<!-- markdownlint-disable-next-line -->
![marketing_assets_banner](https://github.com/user-attachments/assets/b8b4ae5c-06bb-46a7-8d94-903a04595036)
[![GitHub License](https://img.shields.io/github/license/indifferentbroccoli/icarus-server-docker?style=for-the-badge&color=6aa84f)](https://github.com/indifferentbroccoli/icarus-server-docker/blob/main/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/indifferentbroccoli/icarus-server-docker?style=for-the-badge&color=6aa84f)](https://github.com/indifferentbroccoli/icarus-server-docker/releases)
[![GitHub Repo stars](https://img.shields.io/github/stars/indifferentbroccoli/icarus-server-docker?style=for-the-badge&color=6aa84f)](https://github.com/indifferentbroccoli/icarus-server-docker)
[![Docker Pulls](https://img.shields.io/docker/pulls/indifferentbroccoli/icarus-server-docker?style=for-the-badge&color=6aa84f)](https://hub.docker.com/r/indifferentbroccoli/icarus-server-docker)

Game server hosting

Fast RAM, high-speed internet

Eat lag for breakfast

[Try our game server hosting!](https://indifferentbroccoli.com/icarus-server-hosting)

## Icarus Dedicated Server Docker

Docker container for running an Icarus Dedicated Server using Wine on Linux.

## Quick Start

Copy the .env.example file to a new file called .env. Then use either `docker compose` or `docker run`

### Docker Compose

1. Copy the environment file:
```bash
cp .env.example .env
```

2. Edit `.env` with your configuration (set your PUID/PGID and server settings)

3. Start the server:
```bash
docker compose up -d
```

### Docker Run

```bash
docker run -d \
    --restart unless-stopped \
    --name icarus \
    --stop-timeout 30 \
    -p 17777:17777/udp \
    -p 27015:27015/udp \
    --env-file .env \
    -v ./server-files:/home/steam/server-files \
    -v ./server-data:/home/steam/server-data \
    icarus-server-docker
```

## Configuration

Edit your `.env` file to configure these options:

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | - | **Required** - User ID for file permissions |
| `PGID` | - | **Required** - Group ID for file permissions |
| `DEFAULT_PORT` | 17777 | Game port |
| `QUERY_PORT` | 27015 | Query port for server browser |
| `MULTIHOME` | - | Bind to specific IP address |
| `SERVER_NAME` | icarus-server | Server name in browser |
| `MAX_PLAYERS` | 8 | Maximum players (1-8) |
| `UPDATE_ON_START` | true | Update server files on container start |
| `RESUME_PROSPECT` | - | Set to "true" to automatically resume last prospect |
| `LOAD_PROSPECT` | - | Prospect name to load on startup |
| `CREATE_PROSPECT` | - | Create new prospect: "ProspectType Difficulty Hardcore SaveName" |
| `USER_DIR` | - | Custom base directory for Saved/ files (overrides default server-data volume) |
| `SAVED_DIR_SUFFIX` | - | Append suffix to Saved/ directory name |
| `LOG_PATH` | - | Custom log path relative to Saved/Logs/ |
| `ABS_LOG_PATH` | - | Absolute log path |

**Create Prospect Example:**
```bash
CREATE_PROSPECT="Tier1_Forest_Recon_0 3 false MyProspect"
```
- ProspectType: Internal prospect name (see [Prospect Names](https://github.com/RocketWerkz/IcarusDedicatedServer/wiki/Prospect-Names))
- Difficulty: 1 (easy) to 4 (extreme)
- Hardcore: true/false (disable respawns)
- SaveName: Name for this prospect save

## Ports

Make sure these ports are forwarded on your router/firewall:
- `17777/udp`  Game port
- `27015/udp`  Query

For more information and instructions specific to your router, visit [portforward.com](https://portforward.com/).

## Volumes

- `./server-files:/home/steam/server-files` - Server installation files
- `./server-data:/home/steam/server-data` - Save data, configs, and logs


## Network Error 65
This error may occur when first creating a world in-game. Simply rejoin the server and it should work normally. This is a known issue with the initial world generation.


## Resources

- [Server Setup Guide](https://github.com/RocketWerkz/IcarusDedicatedServer/wiki/Server-Setup)
- [Server Config & Launch Parameters](https://github.com/RocketWerkz/IcarusDedicatedServer/wiki/Server-Config-&-Launch-Parameters)
- [Prospect Names](https://github.com/RocketWerkz/IcarusDedicatedServer/wiki/Prospect-Names)
