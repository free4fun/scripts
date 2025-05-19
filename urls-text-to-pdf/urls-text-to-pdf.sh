#!/bin/bash
# urls-text-to-pdf.sh
# Extracts readable content from a list of strictly public domain URLs and generates a single PDF.
# Author: Mauricio Sosa Giri <free4fun@riseup.net>
# License: GNU GPL v3.0 or later

set -euo pipefail

# === CONFIGURATION ===
URLS=(
  "https://www.gutenberg.org/files/11/11-h/11-h.htm"       # Alice's Adventures in Wonderland (public domain)
  "https://www.gutenberg.org/files/1342/1342-h/1342-h.htm" # Pride and Prejudice (public domain)
  "https://www.gutenberg.org/files/2600/2600-h/2600-h.htm" # War and Peace (public domain)
  "https://www.gutenberg.org/files/1661/1661-h/1661-h.htm" # The Adventures of Sherlock Holmes (public domain)
)
OUTPUT_PDF="output.pdf"
TEMP_DIR="$(mktemp -d)"
MERGED_TXT="$TEMP_DIR/merged.txt"

# === DEPENDENCY CHECK ===
function check_dep() {
  for cmd in "$@"; do
    if ! command -v "$cmd" &>/dev/null; then
      echo "Missing dependency: $cmd" >&2
      exit 1
    fi
  done
}
check_dep curl pandoc iconv

# === TEXT EXTRACTION ===
function extract_text() {
  local url="$1"
  local outfile="$2"
  if command -v lynx &>/dev/null; then
    lynx -dump -nolist "$url" | iconv -c -t utf-8 > "$outfile"
  elif command -v w3m &>/dev/null; then
    w3m -dump "$url" | iconv -c -t utf-8 > "$outfile"
  elif command -v pup &>/dev/null; then
    curl -s "$url" | pup 'body text{}' | iconv -c -t utf-8 > "$outfile"
  else
    # Fallback: very basic HTML stripping
    curl -s "$url" | sed -e 's/<[^>]*>//g' | iconv -c -t utf-8 > "$outfile"
  fi
}

# === TEXT CLEANING ===
function clean_text() {
  # Remove problematic characters and normalize to ASCII
  iconv -f utf-8 -t ascii//TRANSLIT "$1" | tr -cd '\11\12\15\40-\176' > "$2"
}

# === MAIN PROCESS ===
: > "$MERGED_TXT"
for url in "${URLS[@]}"; do
  echo "Processing: $url"
  TMP_TXT="$TEMP_DIR/$(echo "$url" | md5sum | cut -c1-10).txt"
  if curl -Is --connect-timeout 10 "$url" | head -1 | grep -q '200'; then
    if extract_text "$url" "$TMP_TXT" && [ -s "$TMP_TXT" ]; then
      {
        echo "========================================"
        echo "Source: $url"
        echo "========================================"
        clean_text "$TMP_TXT" "$TMP_TXT.cleaned"
        cat "$TMP_TXT.cleaned"
        echo -e "\n"
      } >> "$MERGED_TXT"
    else
      echo "Warning: Failed to extract text from $url"
    fi
  else
    echo "Warning: URL not accessible: $url"
  fi
done

# === PDF GENERATION ===
if [ ! -s "$MERGED_TXT" ]; then
  echo "Error: No text extracted from the URLs." >&2
  exit 2
fi

# Always use HTML backend to avoid LaTeX issues
pandoc "$MERGED_TXT" -f markdown -t html -o "$TEMP_DIR/output.html"
if command -v wkhtmltopdf &>/dev/null; then
  wkhtmltopdf "$TEMP_DIR/output.html" "$OUTPUT_PDF"
  echo "PDF saved as $OUTPUT_PDF"
else
  # Pandoc can export PDF using HTML backend if wkhtmltopdf is not present
  pandoc "$TEMP_DIR/output.html" -o "$OUTPUT_PDF"
  echo "PDF saved as $OUTPUT_PDF (via Pandoc HTML backend)"
fi

# Cleanup
rm -rf "$TEMP_DIR"
