#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <video_url> <title> <privacy_level>"
  exit 1
fi

VIDEO_URL="$1"
TITLE="$2"
PRIVACY_LEVEL="$3"

: "${TIKTOK_ACCESS_TOKEN:?Set TIKTOK_ACCESS_TOKEN first}"

INIT_RESPONSE=$(curl -sS -X POST "https://open.tiktokapis.com/v2/post/publish/video/init/" \
  -H "Authorization: Bearer $TIKTOK_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"post_info\":{\"title\":\"$TITLE\",\"privacy_level\":\"$PRIVACY_LEVEL\"},\"source_info\":{\"source\":\"PULL_FROM_URL\",\"video_url\":\"$VIDEO_URL\"}}")

echo "$INIT_RESPONSE"
