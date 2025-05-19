# Enhanced Video Converter

**Author:** Mauricio Sosa Giri
**Email:** free4fun@riseup.net

---

## Overview

This is a professional and robust Bash script for batch converting video files in a given directory to a user-selected output format.
- **All supported video files** (`mp4`, `mkv`, `avi`, `mov`, `webm`) in the input directory are automatically detected and converted.
- Converted files are saved in a `converted` subfolder inside the input directory.
- The script displays the progress percentage for each video during the conversion process.

---

## Features

- **Automatic detection** of all supported video files (no need to specify extension).
- **Interactive selection** of output video format (`mp4`, `webm`, `mkv`, `mov`, `avi`).
- **Progress indicator** for each file.
- **Skips** files that have already been converted.
- **Robust error handling** and input validation.
- **No dependencies** besides `ffmpeg`, `awk`, and `ffprobe` (usually included with ffmpeg).

---

## Requirements

- Bash (recommended: 4.x or newer)
- [ffmpeg](https://ffmpeg.org/)
- awk (standard in most Unix/Linux systems)
- ffprobe (included with ffmpeg)

---

## Usage

1. **Make the script executable:**
 ```bash
  chmod +x enhanced-video-converter-v4.sh
```

2. **Run the script:**
```bash
  ./enhanced-video-converter-v4.sh
```

3. **Follow the interactive prompts:**
  - Enter the input directory (press Enter for your home directory).
  - Choose the output format (press Enter for default: `mp4`).
  - The script will convert all supported video files, showing progress for each.

4. **Converted files** will appear in the `converted` subfolder of your input directory.

---

## Example

```
$ ./enhanced-video-converter-v4.sh
Enter the input directory (default: $HOME): /home/user/Videos
Found 3 video file(s) in '/home/user/Videos' to convert:
  - sample1.mkv
  - sample2.avi
  - sample3.webm
Supported output formats:
  [1] webm
  [2] mp4
  [3] mkv
  [4] mov
  [5] avi
Choose output format [default: mp4]:
Converting all supported video files from '/home/user/Videos' to 'mp4' in '/home/user/Videos/converted'...
Converting: /home/user/Videos/sample1.mkv -> /home/user/Videos/converted/sample1.mp4
Progress: 100%
File converted: /home/user/Videos/converted/sample1.mp4
...
Batch conversion completed.
```

---

## Notes

- The script will **skip** files if the converted output already exists.
- Only the specified output format will be used for all conversions in the batch.
- If you encounter errors related to `ffmpeg` or `ffprobe`, ensure they are properly installed and accessible in your system's PATH.

---

## License

This script is licensed under the GNU Affero General Public License v3.0 or later.
See [LICENSE](LICENSE) for details.
