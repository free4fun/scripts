#!/bin/bash

# Enhanced PDF Merger Script
# Author: Mauricio Sosa Giri <free4fun@riseup.net>
# License: GNU GPL v3.0 or later

# Check for required argument
if [ $# -eq 0 ]; then
    echo "Please provide the directory containing the PDF files."
    echo "Usage: $0 <directory>"
    exit 1
fi

TARGET_DIR="$1"

# Check if directory exists and is accessible
if [ ! -d "$TARGET_DIR" ]; then
    echo "Directory '$TARGET_DIR' does not exist or is not accessible."
    exit 1
fi

# Check if pdftk is installed
if ! command -v pdftk &> /dev/null; then
    echo "pdftk is not installed. Please install it to continue."
    exit 1
fi

# Find PDF files (case-insensitive), sort them, and check if any found
PDF_FILES=()
while IFS= read -r -d $'\0' file; do
    PDF_FILES+=("$file")
done < <(find "$TARGET_DIR" -maxdepth 1 -type f \( -iname "*.pdf" \) -print0 | sort -z)

if [ ${#PDF_FILES[@]} -eq 0 ]; then
    echo "No PDF files found in the specified directory."
    exit 1
fi

# Ask for output filename
read -p "Enter the name for the merged PDF (without .pdf extension) [default: merged]: " OUT_NAME
OUT_NAME=${OUT_NAME:-merged}
OUT_FILE="$TARGET_DIR/$OUT_NAME.pdf"

# Merge PDFs using pdftk
if pdftk "${PDF_FILES[@]}" cat output "$OUT_FILE"; then
    echo "All PDFs have been successfully merged into '$OUT_FILE'"
else
    echo "An error occurred during PDF merging."
    exit 1
fi
