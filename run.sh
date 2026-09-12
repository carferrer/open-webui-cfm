#!/usr/bin/env bash
set -e

CONFIG_PATH="/data/options.json"

echo "-----------------------------------------------------------"
echo " Open WebUI CFM"
echo "-----------------------------------------------------------"

# -----------------------------------------------------------
# Leer configuración de Home Assistant
# -----------------------------------------------------------

WEBUI_AUTH=$(jq -r '.webui_auth // true' "${CONFIG_PATH}")
OLLAMA_BASE_URL=$(jq -r '.ollama_base_url // empty' "${CONFIG_PATH}")

# -----------------------------------------------------------
# Directorio persistente
# -----------------------------------------------------------

mkdir -p /data/open-webui

export DATA_DIR="/data/open-webui"

# -----------------------------------------------------------
# Autenticación Open WebUI
# -----------------------------------------------------------

export WEBUI_AUTH="${WEBUI_AUTH}"

# -----------------------------------------------------------
# Secret persistente
# -----------------------------------------------------------

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

# -----------------------------------------------------------
# Ollama
# -----------------------------------------------------------

if [ -n "${OLLAMA_BASE_URL}" ]; then
    export OLLAMA_BASE_URL="${OLLAMA_BASE_URL}"

    echo "Ollama endpoint: ${OLLAMA_BASE_URL}"
else
    echo "Ollama endpoint: not configured"
fi

# -----------------------------------------------------------
# Open WebUI
# -----------------------------------------------------------

echo "DATA_DIR: ${DATA_DIR}"
echo "WEBUI_AUTH: ${WEBUI_AUTH}"
echo "Starting Open WebUI..."

cd /app/backend

exec bash start.sh
