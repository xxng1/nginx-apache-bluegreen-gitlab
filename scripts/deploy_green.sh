#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="/opt/bluegreen"
CONF_DIR="$ROOT_DIR/nginx/conf.d"
ACTIVE_LINK="$(readlink -f "$CONF_DIR/app_active.conf" || true)"
ACTIVE_BASENAME="$(basename "${ACTIVE_LINK:-app_blue.conf}")"

if [[ "$ACTIVE_BASENAME" == "app_blue.conf" ]]; then
  IDLE="green"
  COMPOSE="$ROOT_DIR/app/docker-compose.green.yml"
  PROJECT="bg-green"
  HEALTH_URL="http://localhost:8081/_green/"
else
  IDLE="blue"
  COMPOSE="$ROOT_DIR/app/docker-compose.blue.yml"
  PROJECT="bg-blue"
  HEALTH_URL="http://localhost:8081/_blue/"
fi

echo "[deploy] active=${ACTIVE_BASENAME} -> deploy to idle=${IDLE} (project=${PROJECT})"

docker compose -p "$PROJECT" -f "$COMPOSE" pull
docker compose -p "$PROJECT" -f "$COMPOSE" up -d

# idle 슬롯 헬스 확인(최대 60초)
for i in {1..30}; do
  if curl -fsS "$HEALTH_URL" >/dev/null; then
    echo "[deploy] ${IDLE} slot healthy."
    exit 0
  fi
  echo "[deploy] waiting ${IDLE} health... ($i/30)"
  sleep 2
done

echo "[deploy] ${IDLE} slot health check FAILED"
exit 1
