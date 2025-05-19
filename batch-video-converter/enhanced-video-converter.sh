#!/usr/bin/env bash
# Enhanced Batch Video Converter Script v4
# Author: Mauricio Sosa Giri <free4fun@riseup.net>
# Features:
#   - Converts all supported video files (any extension) in the input directory
#   - Output directory is always a subfolder of the input directory
#   - Shows conversion progress percentage for each video
#   - Robust input validation and user prompts

set -euo pipefail

# Supported output formats and recommended ffmpeg options
declare -A FORMAT_OPTS=(
  [webm]="-c:v libvpx-vp9 -b:v 0 -crf 30 -c:a libopus"
  [mp4]="-c:v libx264 -preset slow -crf 22 -c:a aac -b:a 192k"
  [mkv]="-c:v libx265 -preset medium -crf 28 -c:a copy"
  [mov]="-c:v prores_ks -profile:v 3 -c:a pcm_s16le"
  [avi]="-c:v mpeg4 -qscale:v 5 -c:a mp3 -b:a 192k"
)

# List of supported input video extensions (case-insensitive)
SUPPORTED_EXTS="mp4|mkv|avi|mov|webm"

error() {
  echo "Error: $1" >&2
  exit 1
}

command -v ffmpeg >/dev/null 2>&1 || error "ffmpeg is not installed. Please install it and try again."
command -v awk >/dev/null 2>&1 || error "awk is required for progress display."

# Prompt for input directory
read -rp "Enter the input directory (default: \$HOME): " input_dir
input_dir="${input_dir:-$HOME}"
[[ -d "$input_dir" ]] || error "Directory '$input_dir' does not exist or is not accessible."

# Set output directory as a subfolder of the input directory
output_dir="$input_dir/converted"
mkdir -p "$output_dir"

# Find all supported video files (case-insensitive)
mapfile -t video_files < <(find "$input_dir" -maxdepth 1 -type f -regextype posix-egrep -iregex ".*\.($SUPPORTED_EXTS)$" | sort)

if [ ${#video_files[@]} -eq 0 ]; then
  error "No supported video files found in '$input_dir'."
fi

echo "Found ${#video_files[@]} video file(s) in '$input_dir' to convert:"

for f in "${video_files[@]}"; do
  echo "  - $(basename "$f")"
done

# List supported output formats
echo "Supported output formats:"
formats=()
i=1
for fmt in "${!FORMAT_OPTS[@]}"; do
  echo "  [$i] $fmt"
  formats+=("$fmt")
  ((i++))
done

# Prompt for output format (default: mp4 if available, otherwise first format)
default_fmt="mp4"
if [[ ! " ${formats[@]} " =~ " mp4 " ]]; then
  default_fmt="${formats[0]}"
fi

while true; do
  read -rp "Choose output format [default: $default_fmt]: " output_fmt
  output_fmt="${output_fmt,,}"
  if [[ -z "$output_fmt" ]]; then
    output_fmt="$default_fmt"
  fi
  if [[ -n "${FORMAT_OPTS[$output_fmt]+x}" ]]; then
    break
  else
    echo "Invalid format. Please choose from: ${formats[*]}"
  fi
done

echo "Converting all supported video files from '$input_dir' to '$output_fmt' in '$output_dir'..."

shopt -s nullglob
shopt -s nocaseglob

for input_file in "${video_files[@]}"; do
  filename="$(basename "$input_file")"
  output_file="$output_dir/${filename%.*}.$output_fmt"
  if [ -e "$output_file" ]; then
    echo "Skipping '$output_file' (already exists)."
    continue
  fi

  # Get duration in seconds
  duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input_file")
  duration=${duration%.*}
  duration=${duration:-0}

  echo "Converting: $input_file -> $output_file"
  # Run ffmpeg and parse progress
  ffmpeg -hide_banner -y -i "$input_file" ${FORMAT_OPTS[$output_fmt]} -progress - -nostats "$output_file" 2>&1 | \
  awk -v dur="$duration" '
    BEGIN { pct=0 }
    /out_time_ms/ {
      split($0, a, "=")
      ms=a[2]
      sec=int(ms/1000000)
      if (dur > 0) {
        pct=int((sec/dur)*100)
        if (pct>100) pct=100
        printf "\rProgress: %d%%", pct
        fflush()
      }
    }
    END { print "\rProgress: 100%" }
  '
  echo "File converted: $output_file"
done

shopt -u nullglob
shopt -u nocaseglob

echo "Batch conversion completed."
