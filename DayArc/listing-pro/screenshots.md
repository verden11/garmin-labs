# DayArc Pro — store images

Status 2026-10-04: the five screens, the cover, the hero and both device icons are rendered from the current build (after ADR-016 and ADR-017: whole-or-nothing grid cells, hero label kept with the grid, icons sized per screen). **Looks not yet approved by the owner** (ROADMAP 1.5, 9.7); nothing is uploaded. Same route and rules as [`../listing/screenshots.md`](../listing/screenshots.md); no mockup or SVG drawing is a store image. Simulator values (weather, sun times, heart rate, stress, Body Battery, the calendar cell, steps) are canned or random: no image claims a real reading. This listing's images never say "free" and carry no price.

## Upload set (in order)

At most five, the best five for this tier. Pro's pitch is the whole grid under an unchanged hero, so the first three are three windows with their grids; the night window (time and date only, identical to DayArc's) is left out on purpose.

| # | File | What it shows | Device | Size |
|---|---|---|---|---|
| 1 | `screens/1-morning.png` | Morning 07:17: weather hero, sunrise and sunset in the corners, battery, heart rate, steps, floors | FR965 | 454 px |
| 2 | `screens/2-midday.png` | Midday 13:17: stress hero, heart rate and floors in the corners, calendar cell, intensity minutes, steps, calories | FR965 | 454 px |
| 3 | `screens/3-evening.png` | Evening 20:02: Body Battery hero, heart rate and calories, recovery time, respiration, steps, pulse ox | FR965 | 454 px |
| 4 | `screens/4-accent-blue.png` | The one setting, the accent colour (blue in the evening); the grid keeps its fixed icon hues | FR965 | 454 px |
| 5 | `screens/5-instinct-evening.png` | **The Instinct one.** Evening 20:00, black and white; the arc is a gauge in the round window, one row of readings under the hero | Instinct E 40 mm | 166 px |

DayArc Pro's manifest has the same three black-and-white Instincts as DayArc (`instincte40mm`, `instincte45mm`, `instinct3solar45mm`). Pro's grid on them is one row, and where it does not fit (ADR-017 names the 3 Solar morning and midday; the E 45 morning also drew none in the 2026-10-04 run) the picture equals DayArc's by design (ADR-017), so the evening is the frame that shows the difference; the E 40 mm draws the labelled pills ("Rec 5h").

**Simulator caveats that were fixed or are left in the pictures:**

- The simulator's default position is Olathe, Kansas, whose sun times appear in the simulator's UTC clock as 12:17 and 23:59 beside a 07:17 face clock. The scenario sets Settings > Set Position to London (`51.5074, -0.1278`) for shot 1, so the corners read 06:05 and 17:33, which a watch could show at that hour. The position is not a claim about anywhere.
- **Open, OWNER decision: the flame (calories) cell reads 0** beside thousands of steps in the midday and evening frames (and in the hero). The simulator's Activity Monitor dialog has no editable Calories cell (it is derived and greyed; steps, floors and intensity minutes took their values, calories stayed 0, checked by reading the dialog), so a value a watch would not show is in `2-midday`, `3-evening` and `4-accent-blue`. A reader may take the 0 for a fault in the face. Options: accept it with the simulator note, or replace the frames after a simulator route to set calories is found (Set User Profile plus distance were not tried). Morning (`1-morning`) and the Instinct frame show no calories cell.
- The midday calendar cell reads "00:00" with no title: that is the simulator's canned calendar event (a start time of midnight and no text). It is left in because the cell is a Pro feature of that window; a reader could take it for an event at midnight. If the owner prefers, the midday frame can be dropped from the five and replaced by another evening or morning variant.

Composed images, all in this folder: `cover-500.png` (500x500), `hero-1440x720.png`, `icon-24-128.png`, `icon-64-128.png` (the two device icons, 128x128). The mark is the same arc as DayArc's (`src/mark.svg`); **proposal for the owner:** a white PRO tag marks this listing (in the arc on the cover and the icons, beside the name on the hero) and tells it from [`../listing/`](../listing/) in the store at 100 px.

## How they were made

Screens (the container's own simulator, nothing on a wrist):

```sh
docker/capture.sh DayArc tools/listing_shots.sh pro     # writes DayArc/listing-pro/screens/*.png
```

`tools/listing_shots.sh` sets the simulator's own clock (`faketime`, about halfway through each window so the arc is part filled), switches Settings > Time Display to 24-hour, fills Simulation > Activity Monitoring (steps 842 in the morning because a four-digit count is cut in the narrow bottom pill that early; 5310 at midday; 8420 in the evening; 18 intensity minutes, 7 floors; about 70 s wait after each so the face's cache refreshes), edits the default `Accent` property in a private copy for shot 4 only (the repo is never touched), and saves with File > Save Screen Capture, so each file is the display at its native pixels. Heart rate, stress and Body Battery are random per run: a re-run gives other numbers. Screens are under 150 KB (checked with `ls -l`).

Cover, hero and icons (host Chrome, headless; sources in `src/`):

```sh
tools/render_listing_images.sh listing-pro
```

It runs `Google Chrome --headless=new ... --screenshot` on `src/cover.html` (500x500), `src/hero.html` (1440x720, built from the first three screens) and `src/icon.html` (128x128), then `src/quantize64.py` snaps the 24-bit icon to the 64-colour palette (00/55/AA/FF). Re-run after any change to a screen or an HTML file; the render needs network for the Archivo font.

Limits checked with `ls -l` after each render: cover under 300 KB; hero under 2048 KB; screens under 150 KB each; `sips -g pixelWidth -g pixelHeight` for the dimensions.

## Notes

- Shot 4 is an accent choice made by editing the default in the private build; the picture shows the result, not how it is changed (the route is unverified until a store install, `../docs/status.md` gate 5).
- The Instinct frame is the whole 166 px display as the simulator saves it; the real bezel hides the square's corners (ADR-015).
- Device wording (Instinct) stays out of the description until the store lists those watches (`meta.yaml` `held_back_text`).

## Not for the store, for the owner's look check (status.md gate 4)

`tools/window_shots.sh pro-activity ...` writes one capture per window per device to the untracked `bin/shots/`: midday on approachs50 (smallest round; fewer rows) and on venusq2 (rectangular). Keep them out of the listing.

## Rules

Screenshots under 150 KB each; cover 500x500 (under 300 KB); hero 1440x720 (under 2048 KB, optional); device icons 128x128. Do not crop a screen into a claim about real readings. No price number in any image; the word "free" appears in no Pro image.
