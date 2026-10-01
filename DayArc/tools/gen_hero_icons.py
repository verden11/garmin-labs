#!/usr/bin/env python3
"""Generates DayArc's hero icon bitmap resources: 3 icons x 6 accent hues = 18 SVGs (ADR-014).

The templates in tools/hero_icon_templates/ are the owner-approved ADR-013 hero icons (real Tabler
Icons paths) with their one fill/stroke colour replaced by @HUE@. Hero icons carry a single colour
and no highlight (unlike the two-tone Pro grid icons), so this script only substitutes that colour.
Pre-coloured bitmaps, not a runtime tint: drawBitmap2's :tintColor is broken on FR165/FR165m.

Run from DayArc/: python3 tools/gen_hero_icons.py
Hue values must match DayArcPalette.ACCENTS (all 64-colour-safe).
"""
import os

HUES = {"cyan": "#55FFFF", "amber": "#FFAA00", "rose": "#FF55AA",
        "green": "#55FF55", "blue": "#55AAFF", "purple": "#AA55FF"}
ICONS = ["weather", "stress", "battery"]
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "resources", "drawables", "icons")

for icon in ICONS:
    with open(os.path.join(ROOT, "tools", "hero_icon_templates", icon + ".svg")) as f:
        template = f.read()
    for name, hue in HUES.items():
        with open(os.path.join(OUT, f"hero_{icon}_{name}.svg"), "w") as f:
            f.write(template.replace("@HUE@", hue))
print(f"wrote {len(ICONS) * len(HUES)} hero icons to {OUT}")
