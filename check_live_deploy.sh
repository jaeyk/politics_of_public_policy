#!/bin/bash
set -euo pipefail

BASE_URL="${1:-https://jaeyk.github.io/politics_of_public_policy}"
PAGE_PATH="${2:-/}"
ASSET_PATH="${3:-/misc/combined_blackboard_image2.png}"

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
PAGE_URL="${BASE_URL%/}${PAGE_PATH}"
ASSET_URL="${BASE_URL%/}${ASSET_PATH}"
TMP_HTML="$(mktemp)"

echo "[1/5] Verify source reference in index.qmd"
if ! rg -n "combined_blackboard_image2\\.png" "$ROOT_DIR/index.qmd" >/dev/null; then
  echo "FAIL: index.qmd does not reference combined_blackboard_image2.png"
  exit 1
fi

echo "[2/5] Verify rendered reference in docs/index.html"
if ! rg -n "combined_blackboard_image2\\.png" "$ROOT_DIR/docs/index.html" >/dev/null; then
  echo "FAIL: docs/index.html does not reference combined_blackboard_image2.png"
  exit 1
fi

echo "[3/5] Verify local deployed asset exists in docs/"
if [ ! -f "$ROOT_DIR/docs/misc/combined_blackboard_image2.png" ]; then
  echo "FAIL: docs/misc/combined_blackboard_image2.png is missing"
  exit 1
fi

echo "[4/5] Verify live homepage HTML contains image reference"
curl -fsSL "$PAGE_URL" > "$TMP_HTML"
if ! rg -n "combined_blackboard_image2\\.png" "$TMP_HTML" >/dev/null; then
  echo "FAIL: Live page HTML does not contain combined_blackboard_image2.png"
  rm -f "$TMP_HTML"
  exit 1
fi

echo "[5/5] Verify live asset returns 200"
ASSET_CODE="$(curl -s -o /dev/null -w "%{http_code}" "$ASSET_URL")"
if [ "$ASSET_CODE" != "200" ]; then
  echo "FAIL: Live asset returned HTTP $ASSET_CODE at $ASSET_URL"
  rm -f "$TMP_HTML"
  exit 1
fi

rm -f "$TMP_HTML"
echo "PASS: Live deployment is serving the expected homepage figure."
