#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.."; pwd)"
CONF_DIR="$ROOT_DIR/nginx/conf.d"
ACTIVE_LINK="$(readlink -f "$CONF_DIR/app_active.conf" || true)"
ACTIVE_BASENAME="$(basename "${ACTIVE_LINK:-app_blue.conf}")"

if [[ "$ACTIVE_BASENAME" == "app_blue.conf" ]]; then
  TARGET="green"
else
  TARGET="blue"
fi

"$ROOT_DIR/scripts/switch_traffic.sh" "$TARGET"
echo "[rollback] switched back to $TARGET"
