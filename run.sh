#!/usr/bin/env bash
set -e

CONFIG_PATH="/data/options.json"

echo "-----------------------------------------------------------"
echo " Open WebUI CFM"
echo "-----------------------------------------------------------"

WEBUI_AUTH="$(jq -r '.webui_auth // true' "${CONFIG_PATH}")"
OLLAMA_BASE_URL="$(jq -r '.ollama_base_url // empty' "${CONFIG_PATH}")"
WEBUI_URL="$(jq -r '.webui_url // empty' "${CONFIG_PATH}")"
CORS_ALLOW_ORIGIN="$(jq -r '.cors_allow_origin // empty' "${CONFIG_PATH}")"

mkdir -p /data/open-webui

export DATA_DIR="/data/open-webui"
export WEBUI_AUTH="${WEBUI_AUTH}"

SECRET_FILE="/data/webui_secret_key"

if [ ! -f "${SECRET_FILE}" ]; then
    echo "Generating WEBUI_SECRET_KEY..."

    python3 - <<'PY' > "${SECRET_FILE}"
import secrets
print(secrets.token_hex(32))
PY

    chmod 600 "${SECRET_FILE}"
fi

export WEBUI_SECRET_KEY="$(cat "${SECRET_FILE}")"

if [ -n "${OLLAMA_BASE_URL}" ]; then
    export OLLAMA_BASE_URL="${OLLAMA_BASE_URL}"
else
    unset OLLAMA_BASE_URL
fi

if [ -n "${WEBUI_URL}" ]; then
    export WEBUI_URL="${WEBUI_URL}"
fi

if [ -n "${CORS_ALLOW_ORIGIN}" ]; then
    export CORS_ALLOW_ORIGIN="${CORS_ALLOW_ORIGIN}"
fi

echo "DATA_DIR: ${DATA_DIR}"
echo "WEBUI_AUTH: ${WEBUI_AUTH}"
echo "WEBUI_URL: ${WEBUI_URL}"
echo "CORS_ALLOW_ORIGIN: ${CORS_ALLOW_ORIGIN}"
echo "Starting Open WebUI..."

cd /app/backend

exec bash start.sh
