#!/usr/bin/env bash
set -euo pipefail
TARGET="${1:-}"
if [[ "$TARGET" != "green" && "$TARGET" != "blue" ]]; then
  echo "Usage: $0 [green|blue]"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "$0")/.."; pwd)"
CONF_DIR="$ROOT_DIR/nginx/conf.d"

# conf.d 디렉터리 안에서 상대링크를 "원자적"으로 교체
cd "$CONF_DIR"
NEW="app_active.conf.new"
if [[ "$TARGET" == "green" ]]; then
  ln -sfn app_green.conf "$NEW"
else
  ln -sfn app_blue.conf  "$NEW"
fi
mv -Tf "$NEW" app_active.conf

# 컨테이너 내부에서 문법 체크 후 리로드
docker exec edge-nginx nginx -t
docker exec edge-nginx nginx -s reload
echo "[switch] traffic -> $TARGET"
