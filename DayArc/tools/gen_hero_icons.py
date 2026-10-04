#!/usr/bin/env python3
"""Generates DayArc's hero icon bitmap resources: 3 icons x 6 accent hues, in a LARGE and a SMALL size per screen (ADR-014, ADR-017).

Why sizes: a hero icon is a fixed-pixel bitmap (plain dc.drawBitmap, no tint, no scaling), so one size cannot suit a 218 px
and a 454 px screen, nor the hero number's three font tiers (HOT, MEDIUM, MILD: on an FR965 the digits are 87, 73 and 58 px
high). Each screen size gets two sizes through the jungles (family lines, kept below between the BEGIN/END markers):
LARGE (about the HOT digits' height, ids IconHero<Icon><Hue>) for the HOT tier and SMALL (about the MEDIUM and MILD digits',
ids IconHeroSmall<Icon><Hue>) for the other two. DayArcStack picks by the tier it plans. The ids are the same in every
build, so the code never knows the pixel sizes (the planner reads the loaded bitmap's size).

A folder holds one size of one slot. The default (`resources/`, 72 px large and 54 px small) serves round 360 and 390.
Height = the digits (0.72 x the HOT font's box, DayArcConfig.DIGIT_HEIGHT_PERMILLE) rounded to a multiple of 6, so a stroke
(a tenth of the height) and the sizes stay tidy; the SMALL one is the mean of the MEDIUM and MILD digits.

Pixel grid (ADR-013 amendment 4, kept): every SVG is drawn in PIXEL coordinates (viewBox = width x height, so the SDK's
rasteriser never resamples), every stroke is a whole number of pixels, straight edges sit on pixel boundaries (an odd
stroke is centred on a half pixel), circles have whole radii. The stress wave is Tabler's path scaled to the height and
cropped to its ink (a curve is anti-aliased either way); the weather glyph and the battery are drawn here. The 1-bit Instinct
(`resources-instinct/`) has one white size for both slots; only its weather glyph is generated, the other two are hand-made.

Run from DayArc/: python3 tools/gen_hero_icons.py            (needs nothing but the standard library)
Hue values must match DayArcPalette.ACCENTS (all 64-colour-safe). Colour is the only thing a hue changes.
"""
import math
import os
import re

HUES = {"cyan": "#55FFFF", "amber": "#FFAA00", "rose": "#FF55AA",
        "green": "#55FF55", "blue": "#55AAFF", "purple": "#AA55FF"}
ICONS = ["weather", "stress", "battery"]
# height -> folder ("resources" is what every screen without a family line gets)
LARGE = {42: "resources-hero-L42", 48: "resources-hero-L48", 54: "resources-hero-L54", 72: "resources", 78: "resources-hero-L78",
         90: "resources-hero-L90"}
SMALL = {24: "resources-hero-S24", 30: "resources-hero-S30", 36: "resources-hero-S36", 48: "resources-hero-S48", 54: "resources",
         66: "resources-hero-S66"}
# device family -> (large, small). Digits = 0.72 x the HOT font's box; HOT/MEDIUM/MILD digits measured by DayArcStackTest:
#   218: 42/30/23   240: 48/35/29   260: 52/38/32   280: 56/41/34   320x360: 80/55/43   360: 70/55/48   390: 75/62/50
#   416: 77/58/46   448x486: 89/79/58   454: 87/73/58   466: 91/80/59
FAMILIES = {"round-218x218": (42, 24), "round-240x240": (48, 30), "round-260x260": (54, 36), "round-280x280": (54, 36),
            "rectangle-320x360": (78, 48), "round-390x390": (72, 54), "round-416x416": (78, 54),
            "rectangle-448x486": (90, 66), "round-454x454": (90, 66), "round-466x466": (90, 66)}
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BLACK = "#000000"
BEGIN = "# BEGIN hero icon families (tools/gen_hero_icons.py writes this block)"
END = "# END hero icon families"
# Tabler's "wave-sine" path on its 24 grid, used for the stress icon (MIT, resources/drawables/icons/THIRD_PARTY_LICENSES.md)
STRESS_REST = ("h-2c-.894 0 -1.662 -.857 -1.761 -2c-.296 -3.45 -.749 -6 -2.749 -6s-2.5 3.582 -2.5 8s-.5 8 -2.5 8"
               "s-2.452 -2.547 -2.749 -6c-.1 -1.147 -.867 -2 -1.763 -2h-2")   # after "M21 12"


def stroke(height):
    # about a tenth of the height: the digits' own stroke is about 0.13 of theirs, and a thinner icon read as faint beside
    # them on the 454 px screen (ROADMAP 1.12)
    return round(height / 10)


def n(x):
    s = f"{x:.2f}".rstrip("0").rstrip(".")
    return "0" if s in ("-0", "") else s


def svg(w, h, body):
    return (f'<svg width="{w}" height="{h}" viewBox="0 0 {w} {h}" xmlns="http://www.w3.org/2000/svg">\n{body}</svg>\n')


# ---------------------------------------------------------------- stress: Tabler's wave + a dot, cropped to its ink
def stress(size, hue):
    t = stroke(size)
    r = round(1.25 * t)                       # the dot's radius, whole
    # The ink is 16k + t/2 + r high (k = the 24-grid scale): solve k for `size`, then snap it to an eighth so the wave's
    # horizontal ends (8k from the top, plus half a stroke) sit on a pixel edge for even and odd strokes alike.
    k = round((size - t / 2 - r) / 16 * 8) / 8
    x0, y0 = 3 * k - t / 2, 4 * k - t / 2     # the ink's top-left corner
    rest = re.sub(r"-?\d*\.\d+|-?\d+", lambda m: n(float(m.group()) * k), STRESS_REST)
    path = f"M{n(21 * k - x0)} {n(12 * k - y0)}{rest}"
    w, h = math.ceil(18 * k + t), math.ceil(16 * k + t / 2 + r)
    body = (f'<path d="{path}" fill="none" stroke="{hue}" stroke-width="{t}" stroke-linecap="round" stroke-linejoin="round" />\n'
            f'<circle cx="{n(12 * k - x0)}" cy="{n(20 * k - y0)}" r="{r}" fill="{hue}" />\n')
    return svg(w, h, body)


# ---------------------------------------------------------------- weather: a sun behind an outlined cloud, a black gap between
def circle_hits(a, b):
    (x0, y0, r0), (x1, y1, r1) = a, b
    d = math.hypot(x1 - x0, y1 - y0)
    along = (r0 * r0 - r1 * r1 + d * d) / (2 * d)
    h = math.sqrt(max(r0 * r0 - along * along, 0))
    mx, my = x0 + along * (x1 - x0) / d, y0 + along * (y1 - y0) / d
    ox, oy = h * (y1 - y0) / d, h * (x1 - x0) / d
    return (mx + ox, my - oy), (mx - ox, my + oy)


def upper(points):
    return min(points, key=lambda p: p[1])


def arc_flags(c, p, q):
    """Large-arc flag of the arc on circle c from p to q going counter-clockwise on screen (increasing maths angle)."""
    a = math.atan2(-(p[1] - c[1]), p[0] - c[0])
    b = math.atan2(-(q[1] - c[1]), q[0] - c[0])
    return 1 if (b - a) % (2 * math.pi) > math.pi else 0


def cloud_path(h, t):
    """The cloud's centre line: a flat bottom and three lobes (left, middle, right), as one closed path."""
    bottom = h - t / 2
    rl, rm, rr = round(0.19 * h), round(0.25 * h), round(0.16 * h)
    left = (t / 2 + rl, bottom - rl, rl)
    right = (round(0.95 * h) - t / 2 - rr, bottom - rr, rr)
    mid = (round(0.52 * h), round(0.36 * h) + t / 2 + rm, rm)
    p_rm = upper(circle_hits(right, mid))
    p_ml = upper(circle_hits(mid, left))
    parts = [f"M{n(left[0])} {n(bottom)}", f"H{n(right[0])}",
             f"A{n(rr)} {n(rr)} 0 {arc_flags(right, (right[0], bottom), p_rm)} 0 {n(p_rm[0])} {n(p_rm[1])}",
             f"A{n(rm)} {n(rm)} 0 {arc_flags(mid, p_rm, p_ml)} 0 {n(p_ml[0])} {n(p_ml[1])}",
             f"A{n(rl)} {n(rl)} 0 {arc_flags(left, p_ml, (left[0], bottom))} 0 {n(left[0])} {n(bottom)}Z"]
    return " ".join(parts)


def weather(height, hue):
    h = height
    w = round(1.25 * h)
    t = stroke(height)
    gap = max(2, round(h / 20))
    sx, sy, sr = round(0.80 * h), round(0.46 * h), round(0.20 * h)   # the sun, upper right, partly behind the cloud
    body = f'<circle cx="{sx}" cy="{sy}" r="{sr}" fill="{hue}" />\n'
    if h >= 36:   # rays: north, north-east, east (the cloud hides the rest); axis and 45 degree only
        inner = sr + t                      # a visible gap of t/2 between the disc and a ray's round cap
        outer = inner + max(4, round(0.09 * h))
        for ang in (90, 45, 0):
            c, s = math.cos(math.radians(ang)), -math.sin(math.radians(ang))
            body += (f'<path d="M{n(sx + inner * c)} {n(sy + inner * s)}L{n(sx + outer * c)} {n(sy + outer * s)}" '
                     f'stroke="{hue}" stroke-width="{t}" stroke-linecap="round" fill="none" />\n')
    path = cloud_path(h, t)
    body += (f'<path d="{path}" fill="{BLACK}" stroke="{BLACK}" stroke-width="{t + 2 * gap}" stroke-linejoin="round" />\n'
             f'<path d="{path}" fill="{BLACK}" stroke="{hue}" stroke-width="{t}" stroke-linejoin="round" />\n')
    return svg(w, h, body)


# ---------------------------------------------------------------- battery: Tabler's shell with a heartbeat line, no level
def battery(size, hue):
    w = round(1.25 * size)
    h = 2 * round(0.4375 * size)          # body height, even
    t = stroke(size) + 1
    pulse = max(2, stroke(size) - 1)
    nub_w = t
    body_w = w - nub_w
    ro = round(0.29 * h)
    f = h / 42
    pts = [(12, 21), (19, 21), (24, 14), (32, 28), (37, 21), (44, 21)]
    r = body_w / 54
    poly = " ".join(f"{n(px * r)} {n(h / 2 + (py - 21) * f)}" for px, py in pts)
    body = (f'<rect x="{n(t / 2)}" y="{n(t / 2)}" width="{n(body_w - t)}" height="{n(h - t)}" rx="{n(ro - t / 2)}" fill="none" stroke="{hue}" stroke-width="{t}" />\n'
            f'<rect x="{body_w}" y="{n(h / 2 - round(0.14 * h))}" width="{nub_w}" height="{2 * round(0.14 * h)}" fill="{hue}" />\n'
            f'<polyline points="{poly}" fill="none" stroke="{hue}" stroke-width="{pulse}" stroke-linecap="round" stroke-linejoin="round" />\n')
    return svg(w, h, body)


MAKERS = {"weather": weather, "stress": stress, "battery": battery}
XML_HEAD = ('<drawables xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
            'xsi:noNamespaceSchemaLocation="https://developer.garmin.com/downloads/connect-iq/resources.xsd">\n')


def bitmap_rows(slot, files=None):
    """The <bitmap> lines of one slot ("L" or "S"); `files` overrides the file name (the Instinct's shared compact files)."""
    rows = ""
    for icon in ICONS:
        for hue in HUES:
            ident = f"IconHero{'Small' if slot == 'S' else ''}{icon.capitalize()}{hue.capitalize()}"
            name = files(icon) if files else f"icons/hero_{icon}_{hue}{'_s' if slot == 'S' else ''}.svg"
            rows += f'    <bitmap id="{ident}" filename="{name}" dithering="none" />\n'
    return rows


def write(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        f.write(text)


def write_sets(slot, sets):
    count = 0
    for height, folder in sets.items():
        icons = os.path.join(ROOT, folder, "drawables", "icons")
        for icon in ICONS:
            for name, hue in HUES.items():
                write(os.path.join(icons, f"hero_{icon}_{name}{'_s' if slot == 'S' else ''}.svg"), MAKERS[icon](height, hue))
                count += 1
        if folder != "resources":
            note = f"    <!-- Hero icons, {'small' if slot == 'S' else 'large'} slot, {height} px high (tools/gen_hero_icons.py, ADR-017). -->\n"
            write(os.path.join(ROOT, folder, "drawables", "drawables.xml"), XML_HEAD + note + bitmap_rows(slot) + "</drawables>\n")
    return count


def write_default_xml():
    note = ("    <!-- Hero icons (ADR-013, one per hue per ADR-014's Accent colour, two sizes per ADR-017): pre-coloured, no runtime\n"
            "         tint, plain dc.drawBitmap (drawBitmap2's :tintColor is broken on FR165/165m). This file is written by\n"
            "         tools/gen_hero_icons.py: the default 72 px (large) and 54 px (small) sets; the jungles replace them per screen\n"
            "         size from resources-hero-*. Source: Tabler Icons (MIT) for the stress wave, see icons/THIRD_PARTY_LICENSES.md. -->\n")
    write(os.path.join(ROOT, "resources", "drawables", "drawables.xml"),
          XML_HEAD + '    <bitmap id="LauncherIcon" filename="launcher_icon.svg" dithering="none" />\n' + note + bitmap_rows("L") + bitmap_rows("S") + "</drawables>\n")


def write_instinct():
    """The 1-bit Instinct: one white size (30x24 / 24x24 / 36x24) for both slots (ADR-016); only the weather glyph is drawn here."""
    write(os.path.join(ROOT, "resources-instinct", "drawables", "icons", "hero_weather_compact.svg"), weather(24, "#FFFFFF"))
    compact = lambda icon: f"icons/hero_{icon}_compact.svg"
    note = ("    <!-- The Instinct E and 3 Solar only (ADR-016): the hero icons at about half the size, one white file per window for\n"
            "         both slots. The display is 1-bit (the Accent setting is off there, so only the Auto hue is ever drawn), but\n"
            "         every shared id must exist for DayArcIcons.heroFor. Written by tools/gen_hero_icons.py. -->\n")
    write(os.path.join(ROOT, "resources-instinct", "drawables", "drawables.xml"),
          XML_HEAD + note + bitmap_rows("L", compact) + bitmap_rows("S", compact) + "</drawables>\n")


def write_jungles():
    lines = [BEGIN,
             "# Hero icon sizes per screen (docs/decisions.md ADR-017): the set of icons whose height is about the digits beside them,",
             "# a LARGE one (the HOT number tier) and a SMALL one (MEDIUM and MILD). resources/ holds the default (72 px and 54 px);",
             "# the same ids sit in every set, so no code changes. A family line REPLACES the base list, hence $(base.resourcePath)."]
    for family, (large, small) in FAMILIES.items():
        folders = [f for f in (LARGE[large], SMALL[small]) if f != "resources"]
        lines.append(f"{family}.resourcePath = $(base.resourcePath);{';'.join(folders)}" if folders else f"# {family}: the default sizes")
    lines.append(END)
    block = "\n".join(lines) + "\n"
    for jungle in ("monkey.simple.jungle", "monkey.pro.jungle"):
        path = os.path.join(ROOT, jungle)
        text = open(path).read()
        if BEGIN in text:
            text = text[:text.index(BEGIN)] + block + text[text.index(END) + len(END) + 1:]
        else:
            text = text.rstrip("\n") + "\n\n" + block
        write(path, text)


def main():
    count = write_sets("L", LARGE) + write_sets("S", SMALL)
    write_default_xml()
    write_instinct()
    write_jungles()
    print(f"wrote {count} hero icons in {len(LARGE)} large and {len(SMALL)} small sets, the default and Instinct drawables, and the jungle family lines")


if __name__ == "__main__":
    main()
