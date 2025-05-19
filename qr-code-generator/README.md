# Stylish QR Code Generator

**Author:** Mauricio Sosa Giri
**Email:** free4fun@riseup.net

A Python script to generate visually enhanced QR codes with custom colors, radial gradients, and a centered logo.  
The script uses the `segno` library for QR code generation and the `Pillow` library for advanced image processing.

---

## Features

- **High error correction** QR codes (level H)
- Customizable colors for QR modules and finder patterns
- Smooth radial gradient background for a modern look
- Centered logo support (with transparency)
- Anti-aliased and blurred effects for smooth visuals
- Fully automated: just set your link and logo image

---

## Requirements

- Python 3.7 or later
- [segno](https://pypi.org/project/segno/)
- [Pillow](https://pypi.org/project/Pillow/)

Install dependencies with:

```bash
pip install segno Pillow
```

---

## Usage

1. Place your logo PNG file in the same directory as the script and name it `default_logo.png` (or change the filename in the script).
2. Run the script:

```bash
python qr_generator.py
```

By default, the script will:

- Encode the URL `https://example.com`
- Use `default_logo.png` as the logo
- Output the final QR image as `qr_code_default.png`

To use your own data or logo, edit these lines at the bottom of the script:

```python
data = "https://example.com"
logo_path = "default_logo.png"
output_path = "qr_code_default.png"
```

---

## Output Example

The script generates a PNG file with:

- A black background
- Colored and blurred QR blocks
- Radial orange gradient
- Centered, resized logo

---

## Customization

- **Colors:**  
  Change the values of `color_1` and `color_2` in the script for your preferred palette.
- **Logo size:**  
  Adjust `logo_size = int(qr_width * 0.25)` for a larger or smaller logo.
- **Gradient strength:**  
  Change the `radius` parameter in the `GaussianBlur` calls.
- **Data:**  
  Set any string or URL for the QR code in the `data` variable.

---

## License

This script is licensed under the GNU General Public License v3.0 or later.
See [LICENSE](https://www.gnu.org/licenses/gpl-3.0.html) for details.
