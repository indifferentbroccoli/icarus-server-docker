#!/bin/bash
# shellcheck source=scripts/functions.sh
source "/home/steam/server/functions.sh"

SERVER_FILES="/home/steam/server-files"

cd "$SERVER_FILES" || exit

LogAction "Starting Icarus Dedicated Server"

# Set defaults if not provided
DEFAULT_PORT="${DEFAULT_PORT:-17777}"
QUERY_PORT="${QUERY_PORT:-27015}"
SERVER_NAME="${SERVER_NAME:-icarus-server}"
MAX_PLAYERS="${MAX_PLAYERS:-8}"

SERVER_EXEC="$SERVER_FILES/Icarus/Binaries/Win64/IcarusServer-Win64-Shipping.exe"

if [ ! -f "$SERVER_EXEC" ]; then
    LogError "Could not find server executable at: $SERVER_EXEC"
    LogError "Directory contents:"
    ls -laR "$SERVER_FILES/"
    exit 1
fi

LogInfo "Found server executable: ${SERVER_EXEC}"
LogInfo "Server starting on port ${DEFAULT_PORT}"
LogInfo "Query port: ${QUERY_PORT}"
LogInfo "Server name: ${SERVER_NAME}"
LogInfo "Max players: ${MAX_PLAYERS}"

# Configure Wine for large memory allocation
export WINEPREFIX="${WINEPREFIX:-$HOME/.wine}"
export WINEARCH="${WINEARCH:-win64}"
export WINEDEBUG="${WINEDEBUG:-fixme-all}"

# Bootstrap Wine if not already initialized
if [ ! -f "$WINEPREFIX/system.reg" ]; then
    LogInfo "Initializing Wine prefix..."
    winecfg -v win10 >/dev/null 2>&1
    wineboot --init >/dev/null 2>&1
    LogInfo "Wine initialized: $(wine --version)"
fi


# Build the startup command with Wine and xvfb
STARTUP_CMD="xvfb-run --auto-servernum wine ${SERVER_EXEC} -Log -PORT=${DEFAULT_PORT} -QueryPort=${QUERY_PORT} -SteamServerName=\"${SERVER_NAME}\" -MaxPlayers=${MAX_PLAYERS}"

# Add multihome if specified
if [ -n "${MULTIHOME}" ]; then
    STARTUP_CMD="${STARTUP_CMD} -MULTIHOME=${MULTIHOME}"
fi

# Add prospect management commands
if [ -n "${RESUME_PROSPECT}" ]; then
    LogInfo "ResumeProspect enabled"
    STARTUP_CMD="${STARTUP_CMD} -ResumeProspect"
fi

if [ -n "${LOAD_PROSPECT}" ]; then
    LogInfo "Loading prospect: ${LOAD_PROSPECT}"
    STARTUP_CMD="${STARTUP_CMD} -LoadProspect=${LOAD_PROSPECT}"
fi

if [ -n "${CREATE_PROSPECT}" ]; then
    LogInfo "Creating prospect: ${CREATE_PROSPECT}"
    STARTUP_CMD="${STARTUP_CMD} -CreateProspect=\"${CREATE_PROSPECT}\""
fi

# Add advanced directory options
if [ -n "${USER_DIR}" ]; then
    LogInfo "Using custom UserDir: ${USER_DIR}"
    STARTUP_CMD="${STARTUP_CMD} -UserDir=${USER_DIR}"
fi

if [ -n "${SAVED_DIR_SUFFIX}" ]; then
    LogInfo "Using saved directory suffix: ${SAVED_DIR_SUFFIX}"
    STARTUP_CMD="${STARTUP_CMD} -saveddirsuffix=${SAVED_DIR_SUFFIX}"
fi

# Add logging options
if [ -n "${LOG_PATH}" ]; then
    LogInfo "Using custom log path: ${LOG_PATH}"
    STARTUP_CMD="${STARTUP_CMD} -LOG=${LOG_PATH}"
fi

if [ -n "${ABS_LOG_PATH}" ]; then
    LogInfo "Using absolute log path: ${ABS_LOG_PATH}"
    STARTUP_CMD="${STARTUP_CMD} -ABSLOG=${ABS_LOG_PATH}"
fi

LogInfo "Starting with Wine..."

# Start the server
eval "$STARTUP_CMD"
