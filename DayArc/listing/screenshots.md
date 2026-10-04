# DayArc — store images

Status 2026-10-04: the five screens, the cover, the hero and both device icons are rendered from the current build. **Looks not yet approved by the owner** (ROADMAP 1.5, 9.7); nothing is uploaded. Never use the site's SVG drawing (`site/src/apps/day-arc/FacePreview.tsx`) or the Design-canvas mockup as a store image: both are schematics, not the face (`../docs/release-contract.md`). Simulator values (weather, stress, Body Battery) are canned or random: no image claims a real reading.

## Upload set (in order)

At most five, the best five for this tier. The face changes through the day, so the first three are three windows, each with its own reading; the night window (time and date only) is left out on purpose.

| # | File | What it shows | Device | Size |
|---|---|---|---|---|
| 1 | `screens/1-morning.png` | Morning 07:15: feels-like temperature, high/low, rain chance, UV | FR965 | 454 px |
| 2 | `screens/2-midday.png` | Midday 13:15: a stress reading as a number and a plain gauge | FR965 | 454 px |
| 3 | `screens/3-evening.png` | Evening 20:00: the Body Battery reading, the same way | FR965 | 454 px |
| 4 | `screens/4-accent-purple.png` | The one setting, the accent colour (purple at midday) | FR965 | 454 px |
| 5 | `screens/5-instinct-evening.png` | **The Instinct one.** Evening 20:00, black and white; the arc is a gauge in the round window | Instinct E 40 mm | 166 px |

DayArc's manifest has three black-and-white Instincts (`instincte40mm`, `instincte45mm`, `instinct3solar45mm`); the E 40 mm frame has the largest hero of the three, so it is the one shown. Free shows one reading per window, so the Instinct frame is the hero and a gauge.

**Light-ground covers (ROADMAP 10.25, 2026-10-04):** cover and hero sit on an indigo gradient (`#4B3BC4` to `#2A2582`), never black (Garmin's brand page: "Do not choose black or transparent backgrounds"); the arc mark, the white dot and the name are unchanged, the black watch screens sit on it. The dark ones are in `old/`. The 128x128 device icons stay black: Garmin's quote is about the 500x500 store cover, and a device icon is drawn on the watch's own ground. Cover about 65 KB, hero under 480 KB.

Composed images, all in this folder: `cover-500.png` (500x500), `hero-1440x720.png`, `icon-24-128.png`, `icon-64-128.png` (the two device icons, 128x128). The mark is the day as an arc (amber morning, cyan midday, rose evening, a white dot for now) in `src/mark.svg`; the hues are the face's own Auto accents. **Proposal for the owner:** Free is the plain mark, DayArc Pro carries a white PRO tag (`../listing-pro/`), so the two tell apart in the store at 100 px.

## How they were made

Screens (the container's own simulator, nothing on a wrist), one run per tier:

```sh
docker/capture.sh DayArc tools/listing_shots.sh simple     # writes DayArc/listing/screens/*.png
```

`tools/listing_shots.sh` sets the simulator's own clock (`faketime`, about halfway through each window so the arc is part filled), switches Settings > Time Display to 24-hour (the simulator starts on 12-hour, and the face has no AM/PM), edits the face's default `Accent` property in a private copy for shot 4 only (the repo is never touched), and saves with File > Save Screen Capture, so each file is the display at its native pixels. Stress and Body Battery are random per run: a re-run gives other numbers. Screens are under 150 KB (all are below 20 KB; checked with `ls -l`).

Cover, hero and icons (host Chrome, headless; sources in `src/`):

```sh
tools/render_listing_images.sh listing
```

It runs `Google Chrome --headless=new ... --screenshot` on `src/cover.html` (500x500), `src/hero.html` (1440x720, built from the three FR965 screens) and `src/icon.html` (128x128), then `src/quantize64.py` snaps the 24-bit icon to Garmin's 64-colour palette (channels 00/55/AA/FF) for `icon-64-128.png` (the same route as HeroSet and HeroFace). Re-run after any change to a screen, `mark.svg` or an HTML file. The page loads the Archivo font from Google Fonts, so the render needs network.

Limits checked with `ls -l` after each render: cover 500x500 under 300 KB; hero 1440x720 under 2048 KB; screens under 150 KB each; `sips -g pixelWidth -g pixelHeight` for the dimensions.

## Notes

- Shot 4 is an accent choice made by editing the default in the private build (what the phone setting would write); it shows the result, not how it is changed. The listing says the colour is chosen in the Garmin Connect app, which is unverified until a store install (`../docs/status.md` gate 5): the picture claims nothing about the route.
- The Instinct frame is a simulator picture. The Instinct bezel hides the square's corners on a real watch (visible circle about 98 px radius, ADR-015); the file is the whole 166 px display, as Garmin's own tool saves it.
- Listing text never names a watch model (owner, 2026-10-04): the description says nothing about Instinct; the store's device tab is the claim.

## Not for the store, for the owner's look check (status.md gate 4)

`tools/window_shots.sh` writes one capture per window per device to the untracked `bin/shots/`; use it to see the arc and icon sizing on a small round watch (approachs50) and a rectangular one (venusq2). Keep them out of the listing.

## Rules

Screenshots under 150 KB each; cover 500x500 (under 300 KB); hero 1440x720 (under 2048 KB, optional); device icons 128x128. Do not crop a screen into a claim about real readings. No price number in any image.
