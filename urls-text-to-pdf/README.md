# Enhanced Public Domain URLs to PDF Script

**Author:** Mauricio Sosa Giri (<free4fun@riseup.net>)
**License:** GNU General Public License v3.0 or later

---

## Overview

This Bash script extracts readable content from a list of strictly public domain URLs (such as Project Gutenberg books) and compiles the cleaned text into a single PDF file. The script is robust, checks all dependencies, and ensures that the output is consistently formatted and free from encoding issues.

---

## Features

1. **Strict Public Domain Sources:** URLs are verified to be in the public domain.
2. **Dependency Checking:** Automatically verifies the presence of required tools (`curl`, `pandoc`, `iconv`). Uses `lynx`, `w3m`, or `pup` if available for enhanced extraction.
3. **Text Extraction:** Extracts main readable content from each URL, with fallback strategies for maximum compatibility.
4. **Content Cleaning:** Converts all text to ASCII to avoid encoding problems in the final PDF.
5. **Clear Source Separation:** Each source is clearly marked in the merged document.
6. **Robust Error Handling:** Skips inaccessible URLs and notifies the user.
7. **No LaTeX Dependency:** Uses HTML-based PDF generation to avoid common LaTeX errors.
8. **Automatic Cleanup:** Removes all temporary files after processing.

---

## Requirements

- **Operating System:** Linux, macOS, or any UNIX-like system with Bash.
- **Dependencies:**
  - `curl`
  - `pandoc`
  - `iconv`
  - (Optional for better extraction) `lynx`, `w3m`, or `pup`
  - (Optional for better PDF rendering) `wkhtmltopdf`

  ---

## Usage

1. **Make the script executable:**
```bash
chmod +x urls-text-to-pdf.sh
```

2. **Edit the script (optional):**
  Modify the `URLS` array at the top of the script to include your own strictly public domain URLs.

3. **Run the script:**
```bash
./urls-text-to-pdf.sh
```

The script will:
  - Extract and clean text from each URL.
  - Merge all content into a single PDF named `output.pdf` in the current directory.

---

## Example

```
$ ./urls-text-to-pdf.sh
Processing: https://www.gutenberg.org/files/11/11-h/11-h.htm
Processing: https://www.gutenberg.org/files/1342/1342-h/1342-h.htm
Processing: https://www.gutenberg.org/files/2600/2600-h/2600-h.htm
Processing: https://www.gutenberg.org/files/1661/1661-h/1661-h.htm
PDF saved as output.pdf
```

---

## Error Handling

- If a required dependency is missing, the script will notify you and exit.
- If a URL is inaccessible or text extraction fails, you will see a warning; processing continues for other URLs.
- If no text is extracted, the script will exit with an error.
- All temporary files are cleaned up automatically.

---

## License

This script is licensed under the GNU General Public License v3.0 or later.
See [LICENSE](https://www.gnu.org/licenses/gpl-3.0.html) for details.

---

## Disclaimer

- Only use URLs that are strictly public domain to respect copyright laws.
- The author is not responsible for misuse or for content extracted from sources outside the public domain.
