#!/usr/bin/env bash
# Rakazo rejects a request whose Origin is not in its trusted list, so the LAN address
# has to appear in WEB_ORIGIN / BETTER_AUTH_URL / API_URL, not just RAKAZO_HOST.
set -Eeuo pipefail
cd /mnt/e/projecte/rakazo

lan="${1:-192.168.66.247}"
origin="http://${lan}:5173"

set_key() {
  local key="$1" value="$2"
  if grep -qE "^${key}=" .env; then
    sed -i "s|^${key}=.*|${key}=${value}|" .env
  else
    printf '%s=%s\n' "$key" "$value" >> .env
  fi
}

set_key WEB_ORIGIN "$origin"
set_key BETTER_AUTH_URL "$origin"
set_key API_URL "$origin"

grep -nE '^(WEB_ORIGIN|BETTER_AUTH_URL|API_URL|RAKAZO_HOST|SIGNUPS_ENABLED)=' .env
