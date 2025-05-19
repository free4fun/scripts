#!/bin/bash

# Check for ffmpeg dependency at the very beginning
if ! command -v ffmpeg >/dev/null 2>&1; then
  echo -e "\033[0;31mffmpeg is required but not installed. Aborting.\033[0m"
  exit 1
fi

# Configurable variables
INPUT_DIR="."            # Change this if you need to specify another root directory
OUTPUT_DIR="converted"
AUDIO_FILTER="asetrate=44100*0.66,aresample=44100,atempo=1.2,atempo=0.9,afftdn,equalizer=f=3000:t=q:w=1:g=5,equalizer=f=200:t=q:w=1:g=-5"

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Enable recursive globbing and nullglob
shopt -s globstar nullglob

# Counters
success=0
fail=0

# Find and process .mp3 files
found_any=false
for input_file in "$INPUT_DIR"/**/*.mp3; do
  if [[ ! -e "$input_file" ]]; then
    continue
  fi

  found_any=true

  # Normalize base name
  base_name=$(basename "$input_file" .mp3)
  safe_name=$(echo "$base_name" | sed 's/[^a-zA-Z0-9_-]/_/g')

  # Replicate subdirectory structure
  relative_path=$(dirname "${input_file#$INPUT_DIR/}")
  output_subdir="$OUTPUT_DIR/$relative_path"
  mkdir -p "$output_subdir"

  # Paths
  temp_wav="$output_subdir/${safe_name}_temp.wav"
  output_mp3="$output_subdir/${safe_name}.mp3"

  echo -e "${YELLOW}Processing:${NC} $input_file"

  # Convert to WAV
  if ! ffmpeg -y -loglevel error -i "$input_file" "$temp_wav"; then
    echo -e "${RED}Failed to convert to WAV:${NC} $input_file"
    ((fail++))
    continue
  fi

  # Apply filters and convert to MP3
  if ffmpeg -y -loglevel error -i "$temp_wav" -af "$AUDIO_FILTER" "$output_mp3"; then
    echo -e "${GREEN}Processed successfully:${NC} $output_mp3"
    ((success++))
  else
    echo -e "${RED}Failed to process:${NC} $input_file"
    ((fail++))
  fi

  # Remove temporary WAV file
  rm -f "$temp_wav"
done

if ! $found_any; then
  echo -e "${RED}No .mp3 files found in $INPUT_DIR.${NC}"
  exit 1
fi

echo -e "${GREEN}Done.${NC} Files processed: $success. Errors: $fail."
