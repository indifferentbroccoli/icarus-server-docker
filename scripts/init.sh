#!/bin/bash
# shellcheck source=scripts/functions.sh
source "/home/steam/server/functions.sh"

LogAction "Set file permissions"

# if the user has not defined a PUID and PGID, throw an error and exit
if [ -z "${PUID}" ] || [ -z "${PGID}" ]; then
    LogError "PUID and PGID not set. Please set these in the environment variables."
    exit 1
else
    usermod -o -u "${PUID}" steam
    groupmod -o -g "${PGID}" steam
fi

chown -R steam:steam /home/steam/server-files /home/steam/server-data /home/steam/

cat /branding

if [ "${UPDATE_ON_START:-true}" = "true" ]; then
    install
else
    LogWarn "UPDATE_ON_START is set to false, skipping server update from Steam"
fi

# shellcheck disable=SC2317
term_handler() {
    if ! shutdown_server; then
        # Force shutdown if graceful shutdown fails
        kill -SIGTERM "$(pidof wine-preloader)"
    fi
    tail --pid="$killpid" -f 2>/dev/null
}

trap 'term_handler' SIGTERM

export DEFAULT_PORT
export QUERY_PORT
export SERVER_NAME
export MAX_PLAYERS
export MULTIHOME
export RESUME_PROSPECT
export LOAD_PROSPECT
export CREATE_PROSPECT
export USER_DIR
export SAVED_DIR_SUFFIX
export LOG_PATH
export ABS_LOG_PATH

# Start the server as steam user
su - steam -c "cd /home/steam/server && DEFAULT_PORT='${DEFAULT_PORT}' QUERY_PORT='${QUERY_PORT}' SERVER_NAME='${SERVER_NAME}' MAX_PLAYERS='${MAX_PLAYERS}' MULTIHOME='${MULTIHOME}' RESUME_PROSPECT='${RESUME_PROSPECT}' LOAD_PROSPECT='${LOAD_PROSPECT}' CREATE_PROSPECT='${CREATE_PROSPECT}' USER_DIR='${USER_DIR}' SAVED_DIR_SUFFIX='${SAVED_DIR_SUFFIX}' LOG_PATH='${LOG_PATH}' ABS_LOG_PATH='${ABS_LOG_PATH}' ./start.sh" &

# Process ID of su
killpid="$!"
wait "$killpid"
