#!/usr/bin/env python3
"""Régénère les sprites pixel art d'Eggly Runner."""
from PIL import Image, ImageDraw
import os

OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "sprites")
os.makedirs(OUT, exist_ok=True)

SKY_TOP = (120, 170, 210)
SKY_BOT = (180, 210, 230)
CLOUD = (230, 240, 245, 200)
FAR_TREE = (70, 100, 90)
FAR_TREE_DARK = (55, 80, 72)
MID_TREE = (45, 90, 55)
MID_TREE_LIGHT = (60, 115, 70)
MID_TRUNK = (70, 50, 35)
GROUND_DIRT = (90, 65, 40)
GROUND_DIRT2 = (75, 55, 35)
GRASS = (70, 130, 55)
GRASS2 = (90, 150, 65)
EGG_SHELL = (245, 230, 200)
EGG_SHADE = (220, 195, 160)
EGG_OUTLINE = (90, 70, 50)
CREST = (200, 60, 50)
CREST_DARK = (150, 40, 35)
LEG = (80, 55, 40)
LEG_LIGHT = (110, 80, 55)
EYE = (40, 30, 25)
ROCK = (110, 105, 95)
ROCK_DARK = (80, 75, 70)
STUMP = (100, 70, 45)
STUMP_DARK = (70, 50, 30)
BUSH = (50, 110, 50)
BUSH_LIGHT = (70, 140, 65)


def save(img, name):
    path = os.path.join(OUT, name)
    img.save(path, "PNG")
    print("wrote", path, img.size)


def make_sky():
    w, h = 128, 96
    img = Image.new("RGBA", (w, h))
    px = img.load()
    for y in range(h):
        t = y / (h - 1)
        r = int(SKY_TOP[0] + (SKY_BOT[0] - SKY_TOP[0]) * t)
        g = int(SKY_TOP[1] + (SKY_BOT[1] - SKY_TOP[1]) * t)
        b = int(SKY_TOP[2] + (SKY_BOT[2] - SKY_TOP[2]) * t)
        for x in range(w):
            px[x, y] = (r, g, b, 255)
    d = ImageDraw.Draw(img)
    clouds = [
        (10, 18, 36, 28),
        (50, 12, 78, 24),
        (90, 22, 120, 34),
        (20, 40, 48, 50),
        (70, 35, 100, 48),
    ]
    for c in clouds:
        d.ellipse(c, fill=CLOUD)
    d.ellipse((-10, 20, 14, 32), fill=CLOUD)
    d.ellipse((118, 20, 140, 32), fill=CLOUD)
    save(img, "sky.png")


def make_far_trees():
    w, h = 160, 80
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rectangle([0, h - 8, w, h], fill=(*FAR_TREE_DARK, 80))
    trees = [
        (8, 50, 28, 78),
        (20, 35, 42, 78),
        (48, 42, 68, 78),
        (62, 28, 88, 78),
        (100, 45, 118, 78),
        (112, 32, 138, 78),
        (140, 40, 158, 78),
    ]
    for i, box in enumerate(trees):
        color = FAR_TREE if i % 2 == 0 else FAR_TREE_DARK
        x0, y0, x1, y1 = box
        mid = (x0 + x1) // 2
        d.polygon([(mid, y0), (x0, y1), (x1, y1)], fill=color)
        tw = max(2, (x1 - x0) // 6)
        d.rectangle([mid - tw, y1 - 10, mid + tw, y1], fill=FAR_TREE_DARK)
    save(img, "far_trees.png")


def make_mid_trees():
    w, h = 192, 120
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    for tx, top in [(30, 55), (90, 48), (150, 58)]:
        d.rectangle([tx - 4, top + 30, tx + 4, h - 4], fill=MID_TRUNK)
        for i, (oy, ow) in enumerate([(0, 36), (14, 42), (28, 34)]):
            color = MID_TREE if i % 2 == 0 else MID_TREE_LIGHT
            d.ellipse(
                [tx - ow // 2, top + oy, tx + ow // 2, top + oy + 28],
                fill=color,
            )
    for bx in (10, 55, 115, 170):
        d.ellipse([bx, h - 28, bx + 28, h - 2], fill=BUSH)
        d.ellipse([bx + 8, h - 34, bx + 24, h - 10], fill=BUSH_LIGHT)
    save(img, "mid_trees.png")


def make_ground():
    w, h = 64, 48
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rectangle([0, 12, w, h], fill=GROUND_DIRT)
    for x, y in [(4, 20), (20, 28), (40, 18), (52, 32)]:
        d.rectangle([x, y, x + 8, y + 4], fill=GROUND_DIRT2)
    d.rectangle([0, 8, w, 14], fill=GRASS)
    for x in range(0, w, 4):
        tip = 4 if (x // 4) % 2 == 0 else 6
        color = GRASS if (x // 4) % 3 else GRASS2
        d.polygon([(x, 12), (x + 2, tip), (x + 4, 12)], fill=color)
    save(img, "ground.png")


def draw_egg(d, ox, oy, leg_phase=0, jumping=False):
    d.polygon([(ox + 14, oy + 4), (ox + 16, oy + 0), (ox + 18, oy + 4)], fill=CREST)
    d.polygon([(ox + 17, oy + 5), (ox + 19, oy + 1), (ox + 21, oy + 6)], fill=CREST_DARK)
    d.ellipse([ox + 6, oy + 4, ox + 26, oy + 30], fill=EGG_SHELL, outline=EGG_OUTLINE)
    d.ellipse([ox + 10, oy + 8, ox + 18, oy + 20], fill=EGG_SHADE)
    d.ellipse([ox + 18, oy + 12, ox + 22, oy + 16], fill=EYE)
    d.point((ox + 20, oy + 13), fill=(255, 255, 255, 200))
    d.polygon(
        [(ox + 24, oy + 15), (ox + 28, oy + 16), (ox + 24, oy + 18)],
        fill=(230, 160, 50),
    )
    if jumping:
        d.line([(ox + 12, oy + 28), (ox + 10, oy + 34)], fill=LEG, width=2)
        d.line([(ox + 18, oy + 28), (ox + 20, oy + 34)], fill=LEG, width=2)
    elif leg_phase == 0:
        d.line([(ox + 12, oy + 28), (ox + 8, oy + 36)], fill=LEG, width=2)
        d.line([(ox + 18, oy + 28), (ox + 22, oy + 34)], fill=LEG_LIGHT, width=2)
    elif leg_phase == 1:
        d.line([(ox + 12, oy + 28), (ox + 12, oy + 36)], fill=LEG, width=2)
        d.line([(ox + 18, oy + 28), (ox + 18, oy + 36)], fill=LEG, width=2)
    else:
        d.line([(ox + 12, oy + 28), (ox + 16, oy + 36)], fill=LEG_LIGHT, width=2)
        d.line([(ox + 18, oy + 28), (ox + 14, oy + 34)], fill=LEG, width=2)


def make_egg_frames():
    for i, phase in enumerate([0, 1, 2, 1]):
        img = Image.new("RGBA", (32, 40), (0, 0, 0, 0))
        draw_egg(ImageDraw.Draw(img), 0, 0, leg_phase=phase)
        save(img, f"egg_run_{i}.png")
    for i in range(2):
        img = Image.new("RGBA", (32, 40), (0, 0, 0, 0))
        draw_egg(ImageDraw.Draw(img), 0, -2 if i == 0 else 0, jumping=True)
        save(img, f"egg_jump_{i}.png")


def make_obstacles():
    img = Image.new("RGBA", (28, 24), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.polygon([(2, 20), (6, 8), (14, 4), (24, 10), (26, 20)], fill=ROCK, outline=ROCK_DARK)
    d.ellipse([8, 10, 14, 15], fill=ROCK_DARK)
    save(img, "obstacle_rock.png")

    img = Image.new("RGBA", (24, 28), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rectangle([6, 8, 18, 28], fill=STUMP)
    d.ellipse([4, 4, 20, 14], fill=STUMP)
    d.ellipse([8, 6, 16, 12], fill=STUMP_DARK)
    d.line([(8, 14), (8, 26)], fill=STUMP_DARK, width=1)
    d.line([(16, 14), (16, 26)], fill=STUMP_DARK, width=1)
    save(img, "obstacle_stump.png")

    img = Image.new("RGBA", (32, 22), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.ellipse([0, 6, 18, 22], fill=BUSH)
    d.ellipse([10, 2, 28, 20], fill=BUSH_LIGHT)
    d.ellipse([16, 8, 32, 22], fill=BUSH)
    save(img, "obstacle_bush.png")


if __name__ == "__main__":
    make_sky()
    make_far_trees()
    make_mid_trees()
    make_ground()
    make_egg_frames()
    make_obstacles()
    print("done")
