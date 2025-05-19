import os
import random
import textwrap
from io import BytesIO

import numpy as np
import requests
from PIL import Image, ImageDraw, ImageFont, ImageEnhance

# ================================
# Parameter Configuration
# ================================
FONT_PATH = '/usr/share/fonts/truetype/hack/Hack-Regular.ttf'
FONT_SIZE = 35
MAX_WIDTH = 30
LINE_SPACING = 20
BACKGROUND_COLOR = (0, 0, 0)
TEXT_COLOR = (255, 255, 255)
OPACITY = 0.6
BRIGHTNESS_FACTOR = 0.3
CONTRAST_FACTOR = 1.5
SEARCH_TERMS = ['nature', 'city', 'ocean', 'landscape', 'mountains']
PHRASES_FILE = 'phrases.txt'
OUTPUT_FILE = 'result.png'
PIXABAY_API_KEY = 'YOUR-PIXABAY-API-KEY'


def get_random_image_url(api_key, search_terms):
    """Get a random image URL from Pixabay."""
    term = random.choice(search_terms)
    url = (
        f"https://pixabay.com/api/?key={api_key}"
        f"&q={term}&image_type=photo"
    )
    response = requests.get(url)
    response.raise_for_status()
    hits = response.json().get('hits', [])
    if not hits:
        raise ValueError("No images found for the search terms.")
    return random.choice(hits)['largeImageURL']


def download_image(url):
    """Download an image and return it as a PIL object."""
    response = requests.get(url)
    response.raise_for_status()
    return Image.open(BytesIO(response.content)).convert('RGBA')


def adjust_image(image, brightness_factor, contrast_factor):
    """Adjust the brightness and contrast of an image."""
    enhancer_brightness = ImageEnhance.Brightness(image)
    image = enhancer_brightness.enhance(brightness_factor)
    enhancer_contrast = ImageEnhance.Contrast(image)
    image = enhancer_contrast.enhance(contrast_factor)
    return image


def get_random_phrase(file_path):
    """Get a random phrase from a file."""
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")
    with open(file_path, 'r', encoding='utf-8') as file:
        phrases = [line.strip() for line in file if line.strip()]
    if not phrases:
        raise ValueError("The phrases file is empty.")
    return random.choice(phrases)


def create_text_image(text, font, image_size, max_width, color, line_spacing):
    """Create an image with centered and wrapped text."""
    lines = textwrap.wrap(text, width=max_width)
    # Calculate total height
    draw_dummy = ImageDraw.Draw(Image.new('RGBA', (1, 1)))
    line_heights = [draw_dummy.textbbox((0, 0), line, font=font)[3] for line in lines]
    total_height = sum(line_heights) + line_spacing * (len(lines) - 1)
    text_image = Image.new('RGBA', image_size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(text_image)
    y = (image_size[1] - total_height) // 2
    for line, lh in zip(lines, line_heights):
        line_width = draw.textlength(line, font=font)
        x = (image_size[0] - int(line_width)) // 2
        draw.text((x, y), line, fill=color, font=font)
        y += lh + line_spacing
    return text_image


def blend_with_opacity(background, overlay, opacity):
    """Blend two images with a given opacity for the overlay."""
    overlay = overlay.copy()
    alpha = overlay.split()[-1]
    alpha = ImageEnhance.Brightness(alpha).enhance(opacity)
    overlay.putalpha(alpha)
    return Image.alpha_composite(background, overlay)


def main():
    try:
        # 1. Download a random background image
        image_url = get_random_image_url(PIXABAY_API_KEY, SEARCH_TERMS)
        background = download_image(image_url)

        # 2. Adjust brightness and contrast
        background = adjust_image(background, BRIGHTNESS_FACTOR, CONTRAST_FACTOR)

        # 3. Get a random phrase
        phrase = get_random_phrase(PHRASES_FILE)

        # 4. Load font
        font = ImageFont.truetype(FONT_PATH, size=FONT_SIZE)

        # 5. Create centered text image
        text_img = create_text_image(
            phrase, font, background.size, MAX_WIDTH, TEXT_COLOR, LINE_SPACING
        )

        # 6. Blend text with background using opacity
        result = blend_with_opacity(background, text_img, OPACITY)

        # 7. Save and show result
        result.save(OUTPUT_FILE)
        result.show()
        print(f"Image generated and saved as {OUTPUT_FILE}")

    except Exception as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    main()
