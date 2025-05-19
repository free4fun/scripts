import segno
from PIL import Image, ImageDraw, ImageFilter

def generate_qr_code(data, logo_path, output_path):
    # Create the QR code with segno (without rendering it yet)
    qr = segno.make(data, error='H')

    # Export to PNG image with transparent background
    temp_qr_path = 'temp_qr_default.png'
    scale = 40
    qr.save(temp_qr_path, scale=scale, dark='#FFF', light='#00000000')

    # Load the generated QR image
    qr_img = Image.open(temp_qr_path).convert("RGBA")
    qr_width, qr_height = qr_img.size

    # Create the final image with a black background
    final_img = Image.new("RGBA", (qr_width, qr_height), (0, 0, 0, 255))
    final_img.paste(qr_img, (0, 0), qr_img)

    # Create a layer to draw the rounded blocks
    draw_layer = Image.new("RGBA", (qr_width, qr_height), (0, 0, 0, 255))
    draw = ImageDraw.Draw(draw_layer)

    # Color settings
    color_1 = "#69A5C8"  # Cobalt Blue
    color_2 = "#D89440"  # Pale Orange
    block_size = int(scale)

    # Margins where the Finder Patterns are positioned
    margin = block_size * 4

    # Finder Patterns coordinates
    finder_pattern_coords = [
        (margin, margin),
        (qr_width - margin - 7 * block_size, margin),
        (margin, qr_height - margin - 7 * block_size)
    ]

    # Draw Finder Patterns correctly
    for coord in finder_pattern_coords:
        x0, y0 = coord

        # Draw cobalt blue border (7x7)
        for y in range(7):
            for x in range(7):
                box = (x0 + x * block_size, y0 + y * block_size,
                       x0 + (x + 1) * block_size, y0 + (y + 1) * block_size)

                if (x in [0, 6] or y in [0, 6]):  # Draw only the border
                    draw.rectangle(box, fill=color_2)  # Cobalt Blue
                elif (2 <= x <= 4 and 2 <= y <= 4):  # Draw 3x3 center in orange
                    draw.rectangle(box, fill=color_1)  # Pale Orange
                # DO NOT COLOR the rest (intermediate area), leave black or transparent

    # Draw rounded blocks over the rest of the QR code (pale orange)
    for y in range(0, qr_height, block_size):
        for x in range(0, qr_width, block_size):
            if any((x >= coord[0] and x < coord[0] + 7 * block_size and
                    y >= coord[1] and y < coord[1] + 7 * block_size) for coord in finder_pattern_coords):
                continue  # Skip Finder Pattern areas

            box = (x, y, x + block_size, y + block_size)
            block = qr_img.crop(box)

            if block.getbbox():
                draw.rectangle(box, fill=color_1)

    # Apply additional smoothing to the rounded blocks layer
    draw_layer = draw_layer.filter(ImageFilter.SMOOTH_MORE)

    # Apply blur to smooth the edges
    draw_layer = draw_layer.filter(ImageFilter.GaussianBlur(radius=3.0))  # Adjust radius as needed

    # Create the gradient layer
    gradient_layer = Image.new("RGBA", (qr_width, qr_height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(gradient_layer)

    # Center coordinates
    center_x, center_y = qr_width // 2, qr_height // 2
    max_radius = int(min(qr_width, qr_height) // 3)

    # Draw the actual radial gradient
    for y in range(qr_height):
        for x in range(qr_width):
            # Calculate distance from center
            dx = x - center_x
            dy = y - center_y
            distance = (dx ** 2 + dy ** 2) ** 0.5

            # Calculate opacity based on distance
            opacity = max(0, int(200 - (distance / max_radius) * 200 ))  # Starts at 200 and decreases
            if opacity > 0:  # If there's any opacity, draw the pixel
                gradient_layer.putpixel((x, y), (216, 148, 64, opacity))  # Pale Orange

    # Soft blur to smooth the gradient edges
    gradient_layer = gradient_layer.filter(ImageFilter.GaussianBlur(radius=30))

    # Combine the rounded blocks layer with the final image
    final_img = Image.alpha_composite(final_img, draw_layer)

    # Apply the gradient with transparency to the black background
    combined = Image.alpha_composite(final_img, gradient_layer)

    # Blend both images with an opacity factor to make the gradient more subtle
    final_img = Image.blend(final_img, combined, alpha=0.5)  # Adjust 'alpha' for more/less transparency

    # Open the logo and round it
    logo = Image.open(logo_path).convert("RGBA")
    logo_size = int(qr_width * 0.25)
    logo = logo.resize((logo_size, logo_size), Image.LANCZOS)

    # Paste the logo in the center of the QR Code
    pos = ((qr_width - logo_size) // 2, (qr_height - logo_size) // 2)
    final_img.paste(logo, pos, logo)

    # Save the final image
    final_img.save(output_path, format="PNG")
    print(f"✅ QR Code saved to {output_path}")

if __name__ == "__main__":
    data = "https://example.com"
    logo_path = "default_logo.png"  # Default PNG image
    output_path = "qr_code_default.png"
    generate_qr_code(data, logo_path, output_path)
