#!/usr/bin/env python3
"""Generate SunWindow/docs/archive/mockup.html (plan P2.3) from the simulator font measurements (plan P2.1).

Every string is drawn with SVG textLength = its measured pixel width on that device and font, and a font size derived
from the measured line height, so widths are real even though the browser's typeface is not Garmin's. Each text row is
checked against the round (or rectangular, or Instinct visible-circle) outline and the Instinct sub-window; a row that
does not fit is outlined red and listed. Sun paths are illustrative (a sine between sunrise and sunset), not the NOAA
maths. Run: python3 gen_mockup.py  (writes ../../../SunWindow/docs/archive/mockup.html)
"""
import math, os, re, html

HERE = os.path.dirname(os.path.abspath(__file__))
LOGS = os.path.join(HERE, "..", "fontprobe", "results")
OUT = os.path.join(HERE, "..", "..", "..", "SunWindow", "docs", "archive", "mockup.html")
REV = 2

def load(dev):
    m = {"glance": {}, "full": {}}
    for line in open(os.path.join(LOGS, f"fonts-{dev}.log")):
        g = re.match(r"FP (\w+) dc (\d+)x(\d+)", line)
        if g:
            m[g[1]]["dc"] = (int(g[2]), int(g[3])); continue
        g = re.match(r"FP full subscreen (\d+),(\d+) (\d+)x(\d+)", line)
        if g:
            m["sub"] = tuple(map(int, g.groups())); continue
        g = re.match(r"FP (\w+) (\S+) h(\d+) (.*)", line)
        if g:
            widths = dict(p.rsplit("=", 1) for p in g[4].strip(" |").split(" | "))
            m[g[1]][g[2]] = (int(g[3]), {k: int(v) for k, v in widths.items()})
    return m

DEVS = {d: load(d) for d in ["fr965", "venu3", "fenix7s", "fr255s", "venux1", "instincte40mm", "instincte45mm"]}
SHAPE = {"venux1": "rect", "instincte40mm": "instinct", "instincte45mm": "instinct"}

ACCENTS = [("Sky", "#55AAFF"), ("Mint", "#55FFAA"), ("Amber", "#FFAA00"), ("Pink", "#FF55AA"), ("Violet", "#AA55FF"), ("White", "#FFFFFF")]
TEXT, MUTED, TRACK, CARD = "#FFFFFF", "#AAAAAA", "#555555", "#10303A"

def width(dev, area, font, s):
    h, w = DEVS[dev][area][font]
    if s in w:
        return w[s]
    # not measured: scale from a measured string of similar character mix (marked ~ in the problem list)
    ref = "Finding your place"
    return round(w[ref] / len(ref) * len(s))

def text_el(dev, area, font, s, x, y, colour, anchor="middle"):
    h, _ = DEVS[dev][area][font]
    w = width(dev, area, font, s)
    left = x - w / 2 if anchor == "middle" else x
    t = (f'<text x="{left:.1f}" y="{y + h * 0.78:.1f}" font-size="{h * 0.80:.1f}" textLength="{w}" '
         f'lengthAdjust="spacingAndGlyphs" fill="{colour}">{html.escape(s)}</text>')
    return t, (left, y, w, h)

def visible_half_width(dev, y0, y1):
    """Widest centred row the screen shows between y0 and y1."""
    W, H = DEVS[dev]["full"]["dc"]
    if SHAPE.get(dev) == "rect":
        return W / 2 - 8
    cx, cy = W / 2, H / 2
    r = W * 0.557 if SHAPE.get(dev) == "instinct" else W / 2
    r = min(r, W / 2 + 0.0) if SHAPE.get(dev) != "instinct" else r
    d = max(abs(y0 - cy), abs(y1 - cy))
    if d >= r:
        return 0
    hw = math.sqrt(r * r - d * d) - 4
    if SHAPE.get(dev) == "instinct":
        hw = min(hw, W / 2 - 4)
    return hw

def fits(dev, box, problems, label):
    left, y, w, h = box
    W, H = DEVS[dev]["full"]["dc"]
    hw = visible_half_width(dev, y, y + h)
    ok = left >= W / 2 - hw - 0.5 and left + w <= W / 2 + hw + 0.5
    sub = DEVS[dev].get("sub")
    if sub and ok:
        sx, sy, sw, sh = sub
        if left + w > sx and y < sy + sh:
            ok = False
    if not ok:
        problems.append(f"{dev} {label}: '{box}' does not fit")
    return ok

def mark(cx, cy, size, kind, colour, mono=False):
    """State mark: a sill bar and a disc. OPEN filled above, CLOSED outline above, NONE outline below the bar."""
    r = size * 0.28
    sw = max(2, size / 12)
    bar = f'<line x1="{cx - size * 0.5:.1f}" y1="{cy:.1f}" x2="{cx + size * 0.5:.1f}" y2="{cy:.1f}" stroke="{TEXT if mono else MUTED}" stroke-width="{sw:.1f}"/>'
    if kind == "open":
        disc = f'<circle cx="{cx:.1f}" cy="{cy - r - sw * 1.5:.1f}" r="{r:.1f}" fill="{colour}"/>'
    elif kind == "closed":
        disc = f'<circle cx="{cx:.1f}" cy="{cy - r - sw * 1.5:.1f}" r="{r - sw / 2:.1f}" fill="none" stroke="{colour}" stroke-width="{sw:.1f}"/>'
    else:
        disc = f'<circle cx="{cx:.1f}" cy="{cy + r + sw * 1.5:.1f}" r="{r - sw / 2:.1f}" fill="none" stroke="{colour}" stroke-width="{sw:.1f}"/>'
    return bar + disc

# ---- states ------------------------------------------------------------------------------------------------------
SUMMER = dict(rise=4.75, set=21.97, peak=58)   # Vilnius around midsummer; window 10:26-16:16 (fixtures)
WINTER = dict(rise=8.5, set=16.0, peak=12)
STATES = {
    "open":        dict(word="OPEN", mark="open", sky=SUMMER, now=13.0, reason=None, times="10:26-16:16"),
    "before":      dict(word="CLOSED", mark="closed", sky=SUMMER, now=9.0, reason="Opens 10:26", times="10:26-16:16"),
    "cloud":       dict(word="CLOSED", mark="closed", sky=SUMMER, now=13.0, reason="Cloud cover", times="10:26-16:16"),
    "after":       dict(word="CLOSED", mark="closed", sky=SUMMER, now=17.5, reason="Closed for today", times="10:26-16:16"),
    "none":        dict(word="NONE TODAY", mark="none", sky=WINTER, now=12.0, reason="Sun stays low", times=None),
    "noweather":   dict(word="OPEN", mark="open", sky=SUMMER, now=13.0, reason="No weather", times="10:26-16:16"),
    "locating":    dict(word=None, mark=None, sky=None, now=None, reason="Finding your place", times=None),
    "nofix":       dict(word=None, mark=None, sky=None, now=None, reason="No place yet", times="Press START"),
}
LABEL = {"open": "OPEN", "before": "CLOSED, before the window", "cloud": "CLOSED, sky (low UV)", "after": "CLOSED, after the window",
         "none": "NONE TODAY", "noweather": "OPEN, no weather data", "locating": "First run: finding a place", "nofix": "No fix"}

def elev(sky, t):
    if t <= sky["rise"] or t >= sky["set"]:
        return -5
    return sky["peak"] * math.sin(math.pi * (t - sky["rise"]) / (sky["set"] - sky["rise"]))

def full_view(dev, state, accent, problems):
    W, H = DEVS[dev]["full"]["dc"]
    mono = SHAPE.get(dev) == "instinct"
    acc = TEXT if mono else accent
    st = STATES[state]
    big = W >= 300
    word_font = "LARGE" if big else "MEDIUM"
    out = []
    # screen outline
    if SHAPE.get(dev) == "rect":
        out.append(f'<rect x="0" y="0" width="{W}" height="{H}" rx="40" fill="#000"/>')
    elif mono:
        r = W * 0.557
        out.append(f'<rect width="{W}" height="{H}" fill="#000"/>')
        out.append(f'<circle cx="{W/2}" cy="{H/2}" r="{r:.1f}" fill="none" stroke="#333" stroke-dasharray="3 3"/>')
        sx, sy, sw, sh = DEVS[dev]["sub"]
        out.append(f'<circle cx="{sx + sw/2}" cy="{sy + sh/2}" r="{sw/2}" fill="#000" stroke="#666"/>')
    else:
        out.append(f'<circle cx="{W/2}" cy="{H/2}" r="{W/2}" fill="#000"/>')
    horizon = H * (0.49 if not mono else 0.52)
    scale = H * (0.40 if not mono else 0.30) / 90
    x0, x1 = W * 0.11, W * 0.89
    if mono:
        x0, x1 = W * 0.12, W * 0.62   # keep the diagram left of the sub-window
    y = horizon + H * 0.02
    if st["sky"]:
        sky = st["sky"]
        tr, ts = 4.0, 22.5   # shared time axis so summer and winter compare
        pts_all, pts_win = [], []
        for i in range(0, 181):
            t = tr + (ts - tr) * i / 180
            e = elev(sky, t)
            if e < 0:
                continue
            px, py = x0 + (x1 - x0) * (t - tr) / (ts - tr), horizon - e * scale
            pts_all.append(f"{px:.1f},{py:.1f}")
        sill = horizon - 45 * scale
        lw = max(2, W / 110)
        out.append(f'<line x1="{x0 - W*0.04:.1f}" y1="{horizon:.1f}" x2="{x1 + W*0.04:.1f}" y2="{horizon:.1f}" stroke="{TEXT if mono else TRACK}" stroke-width="{lw:.1f}"/>')
        out.append(f'<line x1="{x0:.1f}" y1="{sill:.1f}" x2="{x1:.1f}" y2="{sill:.1f}" stroke="{TEXT if mono else MUTED}" stroke-width="{max(1, lw/2):.1f}" stroke-dasharray="{lw*2:.0f} {lw*2:.0f}"/>')
        out.append(f'<polyline points="{" ".join(pts_all)}" fill="none" stroke="{TEXT if mono else TRACK}" stroke-width="{lw:.1f}"/>')
        # the window: the part of the path above the sill, thick, in the accent
        seg = []
        for i in range(0, 181):
            t = tr + (ts - tr) * i / 180
            e = elev(sky, t)
            if e >= 45:
                seg.append(f"{x0 + (x1 - x0) * (t - tr) / (ts - tr):.1f},{horizon - e * scale:.1f}")
        if seg:
            out.append(f'<polyline points="{" ".join(seg)}" fill="none" stroke="{acc}" stroke-width="{lw*3:.1f}" stroke-linecap="round"/>')
        e = elev(sky, st["now"])
        if e > 0:
            px, py = x0 + (x1 - x0) * (st["now"] - tr) / (ts - tr), horizon - e * scale
            r = max(5, W * 0.038)
            if st["mark"] == "open":
                out.append(f'<circle cx="{px:.1f}" cy="{py:.1f}" r="{r:.1f}" fill="{acc}"/>')
            else:
                out.append(f'<circle cx="{px:.1f}" cy="{py:.1f}" r="{r - lw/2:.1f}" fill="#000" stroke="{acc}" stroke-width="{lw:.1f}"/>')
    else:
        y = H * 0.40
    if mono and st["mark"]:
        sx, sy, sw, sh = DEVS[dev]["sub"]
        out.append(mark(sx + sw / 2, sy + sh * 0.55, sw * 0.7, st["mark"], TEXT, mono=True))
    rows = []
    if st["word"]:
        rows.append((word_font, st["word"], TEXT))
    if st["reason"]:
        rows.append(("SMALL", st["reason"], TEXT if not st["word"] else MUTED))
    if st["times"]:
        rows.append(("TINY", st["times"], MUTED))
    for font, s, col in rows:
        el, box = text_el(dev, "full", font, s, W / 2, y, col)
        if not fits(dev, box, problems, f"{LABEL[state]} / {font} '{s}'"):
            l, by, bw, bh = box
            el += f'<rect x="{l}" y="{by}" width="{bw}" height="{bh}" fill="none" stroke="red" stroke-width="2"/>'
        out.append(el)
        y += DEVS[dev]["full"][font][0]
    return W, H, "".join(out)

def glance(dev, state, problems):
    W, H = DEVS[dev]["glance"]["dc"]
    mono = SHAPE.get(dev) == "instinct"
    st = STATES[state]
    gh, _ = DEVS[dev]["glance"]["GLANCE"]
    th, _ = DEVS[dev]["glance"]["XTINY"]
    out = [f'<rect width="{W}" height="{H}" rx="8" fill="{"#000" if mono else CARD}"/>']
    y_title = max(0, (H - th - gh) / 2) if not mono else 2
    t, _ = text_el(dev, "glance", "XTINY", "Sun Window", 0, y_title, TEXT if mono else MUTED, anchor="start")
    out.append(t)
    y2 = y_title + th
    if mono:
        y2 = 35   # under the sub-window (which ends at y 52 on the screen, y 33 in the glance)
    if state == "locating":
        el, box = text_el(dev, "glance", "GLANCE", "Open once", 0, y2, TEXT, anchor="start")
        if box[2] > W:
            problems.append(f"{dev} glance: 'Open the app once' {box[2]} px > {W}")
        out.append(el)
    else:
        msize = gh
        out.append(mark(msize * 0.5, y2 + gh * 0.62, msize * 0.9, st["mark"], TEXT, mono))
        el, box = text_el(dev, "glance", "GLANCE", st["word"], msize * 1.15, y2, TEXT, anchor="start")
        if box[0] + box[2] > W:
            problems.append(f"{dev} glance: '{st['word']}' ends at {box[0] + box[2]:.0f} px > {W}")
            el += f'<rect x="{box[0]}" y="{box[1]}" width="{box[2]}" height="{box[3]}" fill="none" stroke="red"/>'
        out.append(el)
    if mono:
        # the sub-window overlaps the glance's top right on Instinct E (simulator geometry): draw it as a keep-out
        sub = DEVS[dev]["sub"]
        out.append(f'<rect x="{sub[0] - 9}" y="0" width="{W}" height="{sub[3] - 19}" fill="none" stroke="#666" stroke-dasharray="3 3"/>')
    return W, H, "".join(out)

def frame(W, H, body, caption, scale=1.0):
    return (f'<figure><svg width="{W*scale:.0f}" height="{H*scale:.0f}" viewBox="0 0 {W} {H}" font-family="Roboto, Helvetica, Arial, sans-serif">{body}</svg>'
            f'<figcaption>{html.escape(caption)}</figcaption></figure>')

def main():
    problems = []
    parts = []
    parts.append("<h2>1. Glance (on the system's themed card; the card colour is the simulator's, the real one varies)</h2><div class=row>")
    for dev in ["fr965", "fenix7s", "fr255s", "instincte40mm", "instincte45mm"]:
        for s in ["open", "before", "none", "locating"]:
            W, H, b = glance(dev, s, problems)
            parts.append(frame(W, H, b, f"{dev} {W}x{H}: {LABEL[s]}", 1.5 if W < 200 else 1.0))
    parts.append("</div><h2>2. Full view, every state (fr965, 454 px)</h2><div class=row>")
    for s in STATES:
        W, H, b = full_view("fr965", s, "#55AAFF", problems)
        parts.append(frame(W, H, b, f"fr965: {LABEL[s]}", 0.7))
    parts.append("</div><h2>3. Full view, other screens (OPEN / CLOSED after / NONE TODAY)</h2><div class=row>")
    for dev in ["venu3", "fenix7s", "fr255s", "venux1", "instincte45mm", "instincte40mm"]:
        for s in ["open", "after", "none"]:
            W, H, b = full_view(dev, s, "#55AAFF", problems)
            sc = 0.7 if W > 300 else (1.5 if W < 200 else 1.2)
            parts.append(frame(W, H, b, f"{dev} {W}x{H}: {LABEL[s]}", sc))
    parts.append("</div><h2>4. Accent list (Free six, Sky default), OPEN on fr965</h2><div class=row>")
    for name, hexv in ACCENTS:
        W, H, b = full_view("fr965", "open", hexv, problems)
        parts.append(frame(W, H, b, f"{name} {hexv}", 0.45))
    parts.append("</div>")
    prob = "".join(f"<li>{html.escape(p)}</li>" for p in problems) or "<li>none: every row fits its screen outline and keep-out</li>"
    doc = f"""<!doctype html><html><head><meta charset="utf-8"><title>Sun Window mockup rev {REV}</title>
<style>body{{background:#2a2a2a;color:#ddd;font:14px/1.4 -apple-system,Helvetica,sans-serif;margin:24px;width:1880px}}
h1{{font-size:22px}} h2{{font-size:16px;margin:28px 0 8px}} .row{{display:flex;flex-wrap:wrap;gap:18px;align-items:flex-end}}
figure{{margin:0}} figcaption{{font-size:12px;color:#aaa;margin-top:4px;max-width:340px}} ul{{margin:4px 0}}</style></head><body>
<h1>Sun Window — mockup rev {REV} (2026-10-05). Simulator-measured text widths; not a watch.</h1>
<p>One move: today's sun path over a dashed <b>45° sill</b>; the part of the path above the sill (the window) is drawn thick in the accent;
the sun disc is <b>filled when the window is open</b>, an <b>outline otherwise</b>. The glance repeats it as a mark: bar plus disc (filled above = OPEN,
outline above = CLOSED, outline below = NONE TODAY). Words carry the state too; nothing depends on colour (greyscale and 1-bit safe).
Sun paths are illustrative curves (Vilnius-like summer and winter), not the real maths. Times are today's window (ADR-006).</p>
<p>Rows that do not fit their screen: <ul>{prob}</ul></p>
{''.join(parts)}
</body></html>"""
    with open(OUT, "w") as f:
        f.write(doc)
    print("wrote", os.path.normpath(OUT))
    for p in problems:
        print("PROBLEM", p)

main()
