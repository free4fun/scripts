# Batch MP3 Audio Processor

This Bash script recursively processes all `.mp3` files in a specified root directory (including subdirectories), applies audio filters using `ffmpeg`, and saves the processed files in a mirrored folder structure under an output directory.

## Features

- **Dependency Check:** Verifies that `ffmpeg` is installed at the very beginning.
- **Recursive Processing:** Finds and processes all `.mp3` files in the input directory and its subdirectories.
- **Audio Normalization:** Applies customizable audio filters to each file.
- **Output Structure:** Replicates the original folder structure in the output directory.
- **Safe Filenames:** Normalizes filenames to avoid problematic characters.
- **Clear Feedback:** Uses color-coded messages and provides a summary of successes and errors.

## Requirements

- [ffmpeg](https://ffmpeg.org/) installed and available in your system's PATH.
- Bash shell (Linux, macOS, or Windows Subsystem for Linux).

## Usage

1. **Place the script in your desired directory.**

2. **Configure variables (optional):**
   - `INPUT_DIR`: The root directory to search for `.mp3` files (default: current directory).
   - `OUTPUT_DIR`: The directory where processed files will be saved (default: `converted`).

3. **Make the script executable:**
   ```bash
   chmod +x process_mp3s.sh
   ```

4. **Run the script:**
   ```bash
   ./process_mp3s.sh
   ```

   The script will process all `.mp3` files it finds, applying the defined filter chain, and output the results into the specified directory.

## Customization

- **Audio Filter:**  
  You can modify the `AUDIO_FILTER` variable at the top of the script to apply different processing chains. The default is:
  ```
  asetrate=44100*0.66,aresample=44100,atempo=1.2,atempo=0.9,afftdn,equalizer=f=3000:t=q:w=1:g=5,equalizer=f=200:t=q:w=1:g=-5
  ```

## Output

- Processed files are saved as `.mp3` in the `converted` directory (or your specified output directory), preserving the original subdirectory structure.
- The script prints a summary of the number of files processed and any errors encountered.

## Example

If your folder structure is:
```
/music
  /album1
    song1.mp3
    song2.mp3
  /album2
    track1.mp3
```
After running the script, you will get:
```
/converted
  /album1
    song1.mp3
    song2.mp3
  /album2
    track1.mp3
```

## License

This script is released under the MIT License.
