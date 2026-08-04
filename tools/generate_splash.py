"""
Premium 2048 Splash Screen Generator
-------------------------------------
Edit the values in the CONFIG section below, then run:
    python tools/generate_splash.py

After editing, also copy to Android drawable folders:
    python tools/generate_splash.py --copy
"""

import sys
import shutil
import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

# ============================================
#  CONFIG — Edit these values
# ============================================

# Canvas
WIDTH = 1080
HEIGHT = 2400
BG_COLOR = "#121212"                    # Deep charcoal background

# 4x4 Grid (subtle background grid)
GRID_VISIBLE = True                     # Set False to hide grid
GRID_CELL_SIZE = 120                    # Size of each cell
GRID_GAP = 12                           # Gap between cells
GRID_COLOR = "#1E1E1E"                  # Cell fill color
GRID_OUTLINE = "#2A2A2A"                # Cell border color
GRID_OFFSET_Y = -40                     # Vertical offset from center

# Golden 2048 Tile
TILE_SIZE = 320                         # Tile size in pixels
TILE_RADIUS = 36                        # Corner radius
TILE_COLOR = "#E8A800"                  # Base gold color
TILE_GRADIENT_TOP_R = 255               # Gradient top Red (0-255)
TILE_GRADIENT_TOP_G = 210               # Gradient top Green
TILE_GRADIENT_TOP_B = 0                 # Gradient top Blue
TILE_GRADIENT_BOTTOM_R = 215            # Gradient bottom Red
TILE_GRADIENT_BOTTOM_G = 160            # Gradient bottom Green
TILE_GRADIENT_BOTTOM_B = 10             # Gradient bottom Blue

# Tile Shadows
SHADOW_LAYERS = 20                      # Number of shadow layers
SHADOW_COLOR = "#000000"                # Shadow color

# Tile Glass Effect
INNER_HIGHLIGHT_LAYERS = 12             # Glass edge highlight layers
GLASS_REFLECTION_RADIUS = 80           # Top-left reflection size
GLASS_REFLECTION_ALPHA = 40            # Reflection intensity (0-255)

# Radial Glow (behind tile)
GLOW_RADIUS = 500                      # Glow radius in pixels
GLOW_BLUR = 60                         # Gaussian blur amount
GLOW_COLOR_R = 255                     # Glow color Red
GLOW_COLOR_G = 215                     # Glow color Green
GLOW_COLOR_B = 0                       # Glow color Blue
GLOW_MAX_ALPHA = 25                    # Max glow opacity (0-255)

# Outer Glow Ring (around tile)
OUTER_GLOW_LAYERS = 40                 # Ring layer count
OUTER_GLOW_MAX_ALPHA = 15              # Ring max opacity

# "2048" Text
TEXT = "2048"
TEXT_FONT_SIZE = 120
TEXT_COLOR = "#FFFFFF"
TEXT_SHADOW_COLOR = "#8B6914"
TEXT_SHADOW_OFFSET_X = 2
TEXT_SHADOW_OFFSET_Y = 4

# ============================================
#  END CONFIG
# ============================================


def hex_to_rgb(hex_color):
    h = hex_color.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))


def generate_splash():
    img = Image.new('RGB', (WIDTH, HEIGHT), BG_COLOR)
    draw = ImageDraw.Draw(img)

    cx, cy = WIDTH // 2, HEIGHT // 2

    # --- Radial glow behind center ---
    glow = Image.new('RGBA', (WIDTH, HEIGHT), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gr, gg, gb = GLOW_COLOR_R, GLOW_COLOR_G, GLOW_COLOR_B
    for r in range(GLOW_RADIUS, 0, -2):
        alpha = int(GLOW_MAX_ALPHA * (1 - r / GLOW_RADIUS))
        gd.ellipse([cx - r, cy - r, cx + r, cy + r], fill=(gr, gg, gb, alpha))
    glow_blurred = glow.filter(ImageFilter.GaussianBlur(GLOW_BLUR))
    base = Image.new('RGBA', (WIDTH, HEIGHT), hex_to_rgb(BG_COLOR) + (255,))
    img = Image.alpha_composite(base, glow_blurred).convert('RGB')
    draw = ImageDraw.Draw(img)

    # --- 4x4 Grid ---
    if GRID_VISIBLE:
        total = 4 * GRID_CELL_SIZE + 3 * GRID_GAP
        gx = (WIDTH - total) // 2
        gy = (HEIGHT - total) // 2 + GRID_OFFSET_Y
        for row in range(4):
            for col in range(4):
                x0 = gx + col * (GRID_CELL_SIZE + GRID_GAP)
                y0 = gy + row * (GRID_CELL_SIZE + GRID_GAP)
                draw.rounded_rectangle(
                    [x0, y0, x0 + GRID_CELL_SIZE, y0 + GRID_CELL_SIZE],
                    radius=12, fill=GRID_COLOR, outline=GRID_OUTLINE, width=1
                )

    # --- Golden tile shadow ---
    tile_x = (WIDTH - TILE_SIZE) // 2
    tile_y = (HEIGHT - TILE_SIZE) // 2
    sc = hex_to_rgb(SHADOW_COLOR)
    for offset in range(SHADOW_LAYERS, 0, -1):
        draw.rounded_rectangle(
            [tile_x + offset, tile_y + offset + 8,
             tile_x + TILE_SIZE + offset, tile_y + TILE_SIZE + offset + 8],
            radius=TILE_RADIUS, fill=sc
        )

    # --- Golden tile base ---
    draw.rounded_rectangle(
        [tile_x, tile_y, tile_x + TILE_SIZE, tile_y + TILE_SIZE],
        radius=TILE_RADIUS, fill=TILE_COLOR
    )

    # --- Gradient overlay ---
    for y in range(tile_y, tile_y + TILE_SIZE):
        p = (y - tile_y) / TILE_SIZE
        r = int(TILE_GRADIENT_TOP_R + (TILE_GRADIENT_BOTTOM_R - TILE_GRADIENT_TOP_R) * p)
        g = int(TILE_GRADIENT_TOP_G + (TILE_GRADIENT_BOTTOM_G - TILE_GRADIENT_TOP_G) * p)
        b = int(TILE_GRADIENT_TOP_B + (TILE_GRADIENT_BOTTOM_B - TILE_GRADIENT_TOP_B) * p)
        draw.line([(tile_x + 4, y), (tile_x + TILE_SIZE - 4, y)], fill=(r, g, b))

    # --- Inner highlight ---
    for i in range(INNER_HIGHLIGHT_LAYERS):
        a = int(180 * (1 - i / INNER_HIGHLIGHT_LAYERS))
        draw.rounded_rectangle(
            [tile_x + 6 + i, tile_y + 6 + i,
             tile_x + TILE_SIZE - 6 - i, tile_y + TILE_SIZE - 6 - i],
            radius=max(1, TILE_RADIUS - 6 - i),
            outline=(255, 255, 255, a), width=1
        )

    # --- Glass reflection ---
    glow_layer = Image.new('RGBA', (WIDTH, HEIGHT), (0, 0, 0, 0))
    gd2 = ImageDraw.Draw(glow_layer)
    for r in range(GLASS_REFLECTION_RADIUS, 0, -1):
        a = int(GLASS_REFLECTION_ALPHA * (1 - r / GLASS_REFLECTION_RADIUS))
        gd2.ellipse(
            [tile_x + 60 - r, tile_y + 50 - r,
             tile_x + 60 + r, tile_y + 50 + r],
            fill=(255, 255, 255, a)
        )
    img = Image.alpha_composite(img.convert('RGBA'), glow_layer).convert('RGB')
    draw = ImageDraw.Draw(img)

    # --- "2048" text ---
    try:
        font = ImageFont.truetype('C:/Windows/Fonts/arialbd.ttf', TEXT_FONT_SIZE)
    except OSError:
        try:
            font = ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf', TEXT_FONT_SIZE)
        except OSError:
            font = ImageFont.load_default()

    bbox = draw.textbbox((0, 0), TEXT, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    tx = (WIDTH - tw) // 2
    ty = (HEIGHT - th) // 2

    draw.text((tx + TEXT_SHADOW_OFFSET_X, ty + TEXT_SHADOW_OFFSET_Y), TEXT,
              fill=TEXT_SHADOW_COLOR, font=font)
    draw.text((tx, ty), TEXT, fill=TEXT_COLOR, font=font)

    # --- Outer glow ring ---
    ring = Image.new('RGBA', (WIDTH, HEIGHT), (0, 0, 0, 0))
    rd = ImageDraw.Draw(ring)
    for i in range(OUTER_GLOW_LAYERS, 0, -1):
        a = int(OUTER_GLOW_MAX_ALPHA * (1 - i / OUTER_GLOW_LAYERS))
        rd.rounded_rectangle(
            [tile_x - i, tile_y - i, tile_x + TILE_SIZE + i, tile_y + TILE_SIZE + i],
            radius=TILE_RADIUS + i, outline=(GLOW_COLOR_R, GLOW_COLOR_G, GLOW_COLOR_B, a), width=1
        )
    img = Image.alpha_composite(img.convert('RGBA'), ring).convert('RGB')

    return img


def copy_to_android(img):
    base = os.path.join('android', 'app', 'src', 'main', 'res')
    dirs = [
        'drawable', 'drawable-v21', 'drawable-night', 'drawable-night-v21',
        'drawable-mdpi', 'drawable-hdpi', 'drawable-xhdpi', 'drawable-xxhdpi', 'drawable-xxxhdpi',
        'drawable-night-mdpi', 'drawable-night-hdpi', 'drawable-night-xhdpi',
        'drawable-night-xxhdpi', 'drawable-night-xxxhdpi',
    ]
    for d in dirs:
        path = os.path.join(base, d)
        if os.path.exists(path):
            img.save(os.path.join(path, 'splash_screen_bg.png'), 'PNG')
            print(f"  Copied to {d}/")


if __name__ == '__main__':
    print("Generating splash screen...")
    img = generate_splash()

    out = 'assets/splash_dark.png'
    img.save(out, 'PNG')
    print(f"Saved: {out} ({img.size[0]}x{img.size[1]})")

    if '--copy' in sys.argv:
        print("Copying to Android drawable folders...")
        copy_to_android(img)
        print("Done. Rebuild your app.")
    else:
        print("Run with --copy to also update Android drawable folders.")
