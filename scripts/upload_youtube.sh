#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <video_path> <title> <description>"
  exit 1
fi

VIDEO_PATH="$1"
TITLE="$2"
DESCRIPTION="$3"

: "${YOUTUBE_ACCESS_TOKEN:?Set YOUTUBE_ACCESS_TOKEN first}"
: "${YOUTUBE_CATEGORY_ID:=22}"
: "${YOUTUBE_PRIVACY:=public}"

METADATA=$(cat <<JSON
{
  "snippet": {
    "title": "$TITLE",
    "description": "$DESCRIPTION",
    "categoryId": "$YOUTUBE_CATEGORY_ID"
  },
  "status": {
    "privacyStatus": "$YOUTUBE_PRIVACY",
    "selfDeclaredMadeForKids": false
  }
}
JSON
)

UPLOAD_URL=$(curl -sS -X POST \
  'https://www.googleapis.com/upload/youtube/v3/videos?uploadType=resumable&part=snippet,status' \
  -H "Authorization: Bearer $YOUTUBE_ACCESS_TOKEN" \
  -H 'Content-Type: application/json; charset=UTF-8' \
  -H 'X-Upload-Content-Type: video/mp4' \
  -d "$METADATA" -D - | awk '/^location:/ {print $2}' | tr -d '\r')

if [[ -z "$UPLOAD_URL" ]]; then
  echo "Failed to create YouTube resumable upload session"
  exit 1
fi

curl -sS -X PUT "$UPLOAD_URL" \
  -H 'Content-Type: video/mp4' \
  --data-binary "@$VIDEO_PATH"
