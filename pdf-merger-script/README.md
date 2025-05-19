# Enhanced PDF Merger Script

**Author:** Mauricio Sosa Giri (<free4fun@riseup.net>)  
**License:** GNU Affero General Public License v3.0 or later

---

## Overview

This Bash script allows you to merge all PDF files in a specified directory into a single PDF file. It is interactive, robust, and validates all inputs. The script ensures compatibility with filenames containing spaces or special characters, and prompts for the output file name.

---

## Features

1. **Directory Validation:** Checks if the provided directory exists and is accessible.
2. **Dependency Check:** Verifies that `pdftk` is installed before proceeding.
3. **Case-Insensitive PDF Search:** Finds all `.pdf` or `.PDF` files in the directory.
4. **Safe Handling:** Supports filenames with spaces and special characters.
5. **Sorted Merge:** Merges PDF files in sorted order.
6. **Interactive Output Naming:** Prompts for the output filename (default: `merged.pdf`).
7. **No Temporary Files:** Uses in-memory file lists for merging.
8. **Clear User Feedback:** Provides informative messages and error handling.

---

## Requirements

- **Operating System:** Linux, macOS, or any UNIX-like system with Bash.
- **Dependencies:**  
  - [`pdftk`](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) (install via your package manager, e.g. `sudo apt install pdftk`)
  - `find`, `sort` (standard UNIX utilities)

---

## Usage

1. **Make the script executable:**
   ```bash
   chmod +x pdf_merge.sh
   ```

2. **Run the script with the target directory as argument:**
   ```bash
   ./pdf_merge.sh /path/to/your/pdf_directory
   ```

3. **Follow the prompt to specify the output file name.**  
   Press Enter to use the default name `merged.pdf`.

---

## Example

```
$ ./pdf_merge.sh ./documents
Enter the name for the merged PDF (without .pdf extension) [default: merged]:
All PDFs have been successfully merged into './documents/merged.pdf'
```

---

## Error Handling

- If the directory does not exist or is inaccessible, the script will exit with an error.
- If `pdftk` is not installed, the script will notify you and exit.
- If no PDF files are found, you will be informed.
- If merging fails, an error message will be displayed.

---

## License

This script is licensed under the GNU Affero General Public License v3.0 or later.  
See [LICENSE](LICENSE) for details.

---

## Disclaimer

- Use this script only on directories you have permission to access.
- Ensure you have the right to merge the PDFs in the target directory.

