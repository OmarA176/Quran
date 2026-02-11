#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 4 ]]; then
  echo "Usage: $0 <image_path> <audio_path> <ayah_text> <output_path> [font_path]"
  exit 1
fi

IMAGE_PATH="$1"
AUDIO_PATH="$2"
AYAH_TEXT="$3"
OUTPUT_PATH="$4"
FONT_PATH="${5:-/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf}"

mkdir -p "$(dirname "$OUTPUT_PATH")"

AUDIO_DURATION=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$AUDIO_PATH")

ffmpeg -y \
  -loop 1 -i "$IMAGE_PATH" \
  -i "$AUDIO_PATH" \
  -filter_complex "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,zoompan=z='min(zoom+0.0008,1.10)':d=1:s=1080x1920:fps=30,eq=contrast=1.05:saturation=1.10,format=yuv420p[v]; \
                   [1:a]aecho=0.6:0.3:1000:0.08,volume=1.2[a]" \
  -map "[v]" -map "[a]" \
  -t "$AUDIO_DURATION" \
  -c:v libx264 -preset medium -crf 21 \
  -c:a aac -b:a 192k \
  -r 30 \
  -vf "drawtext=fontfile=$FONT_PATH:text='$AYAH_TEXT':fontcolor=white:fontsize=54:borderw=4:bordercolor=black@0.65:line_spacing=18:x=(w-text_w)/2:y=h*0.80" \
  "$OUTPUT_PATH"

echo "$OUTPUT_PATH"
