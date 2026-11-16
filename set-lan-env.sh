#!/usr/bin/env bash
# Point Rakazo at the LAN: the web port answers every interface, links use the PC's address.
set -Eeuo pipefail
cd /mnt/e/projecte/rakazo

set_key() {
  local key="$1" value="$2"
  if grep -qE "^${key}=" .env; then
    sed -i "s|^${key}=.*|${key}=${value}|" .env
  else
    printf '%s=%s\n' "$key" "$value" >> .env
  fi
}

set_key RAKAZO_WEB_BIND 0.0.0.0
set_key RAKAZO_HOST 192.168.66.247

grep -nE '^(RAKAZO_WEB_BIND|RAKAZO_HOST|RAKAZO_WEB_PORT|RAKAZO_API_PORT)=' .env
