#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="/opt/bluegreen"
CONF_DIR="$ROOT_DIR/nginx/conf.d"
ACTIVE_LINK="$(readlink -f "$CONF_DIR/app_active.conf" || true)"
ACTIVE_BASENAME="$(basename "${ACTIVE_LINK:-app_blue.conf}")"

if [[ "$ACTIVE_BASENAME" == "app_blue.conf" ]]; then
  OLD_COMPOSE="$ROOT_DIR/app/docker-compose.green.yml"
  PROJECT="bg-green"
  OLD="green"
else
  OLD_COMPOSE="$ROOT_DIR/app/docker-compose.blue.yml"
  PROJECT="bg-blue"
  OLD="blue"
fi

echo "[cleanup] retiring $OLD (project=${PROJECT}) ..."
docker compose -p "$PROJECT" -f "$OLD_COMPOSE" down || true
echo "[cleanup] retired $OLD"
