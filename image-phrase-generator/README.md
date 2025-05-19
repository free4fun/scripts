# Image Quote Generator

**Author:** Mauricio Sosa Giri
**Email:** free4fun@riseup.net

A Python script that creates beautiful quote images by overlaying random inspirational text on high-quality background photos from Pixabay.

---

## Features

- Automatically downloads random background images based on nature themes
- Applies professional image adjustments (brightness, contrast)
- Centers and wraps text with proper spacing
- Maintains text readability with opacity control
- Clean, modular code structure following best practices

---

## Requirements

- Python 3.6+
- Pillow (PIL Fork)
- Requests
- NumPy

---

## Installation

1. Clone this repository or download the script
2. Install the required dependencies:

```bash
pip install pillow requests numpy
```

3. Make sure you have a `frases.txt` file in the same directory with your quotes (one per line)
4. Ensure the Hack font is installed or modify the `FONT_PATH` constant to use a different font

---

## Usage

Simply run the script:

```bash
python image_quote_generator.py
```

The script will:
1. Connect to Pixabay API and download a random image
2. Adjust the image brightness and contrast
3. Select a random quote from your `frases.txt` file
4. Create a new image with the quote centered on the background
5. Save the result as `result.png` and display it

---

## Configuration

You can easily customize the script by modifying the constants at the top:

```python
FONT_PATH = '/usr/share/fonts/truetype/hack/Hack-Regular.ttf'  # Path to your font
FONT_SIZE = 35                                                 # Text size
MAX_WIDTH = 30                                                 # Characters per line
LINE_SPACING = 20                                              # Space between lines
TEXT_COLOR = (255, 255, 255)                                   # White text
OPACITY = 0.6                                                  # Text opacity
BRIGHTNESS_FACTOR = 0.3                                        # Background dimming
CONTRAST_FACTOR = 1.5                                          # Background contrast
SEARCH_TERMS = ['nature', 'city', 'ocean', 'landscape']        # Image search terms
```

---

## API Key

The script uses a Pixabay API key. If you need to use your own:
1. Register at [Pixabay](https://pixabay.com/api/docs/)
2. Get your API key
3. Replace the `PIXABAY_API_KEY` value in the script

---

## Error Handling

The script includes comprehensive error handling for:
- API connection issues
- Image download problems
- Missing font or quotes file
- Empty quotes file

---

## License

This script is licensed under the GNU Affero General Public License v3.0 or later.
See [LICENSE](LICENSE) for details.
