# Two Suns Pro: screenshots and store images

Status 2026-10-04. Everything here is **simulator only** (the container's simulator, native pixels), rendered from the **current Pro build** (`monkey.jungle`). Nothing is a wrist photo. **The owner has not approved the looks yet** (screens, cover, hero, icons); upload waits for that (ROADMAP 1.5, 9.7, 10.5).

## What the pictures are, honestly

The simulator has no GPS place, canned sun times that read wrong in the container's UTC clock, a Body Battery history dated in the future (the curve would be one dot) and a random Body Battery number. So `tools/listing_shots.sh` edits a **private copy** of the project (the real `source/` is never changed) so the face can be drawn at all:

- sunrise 06:05 and sunset 17:32 are fixed in place of the Complication values (the NOAA times for 51.5 N, 0 E on 4 October; the clock is UTC);
- Pro gets that place as its remembered place, so twilight and golden hour can draw;
- the energy curve is a **hand-made** 24 h series of 15-minute samples that ends at the clock (shape: a low evening, a night rise, a morning peak at 92, then down to 59);
- the Body Battery number is fixed at 59.

**All of that is canned. These pictures show the design, never a reading**, and none may be cropped into a claim about real data (release contract: the curve, sun times and weather are not yet checked on a wrist). The weather row and the watch battery row are **switched off** in the shots (ADR-022/023: the contract says not to describe them until the wrist check, and the simulator's weather is canned), so no Pro screen shows them. The listing text does not mention either row.

## Screen images (upload order)

All 24-hour clock (`sim_24h`), accent as listed, the date row and curve on (the Pro defaults). Sizes are the device's own pixels; each file is far under 150 KB.

| # | File | Device | Clock (UTC) | Accent | What it shows |
|---|---|---|---|---|---|
| 1 | `screens/1-day.png` | FR965, 454 px | 10:09 | Sky (0) | The default: date, time, bolt and 59, the 24 h curve, "7:22 of daylight"; the ring with twilight beside the ticks, daylight gone and to come, the sun marker |
| 2 | `screens/2-golden-hour.png` | FR965, 454 px | 16:51 | Violet (3), Golden hour **On** | The warm golden-hour arcs beside sunrise and sunset, the marker inside the evening one |
| 3 | `screens/3-evening.png` | FR965, 454 px | 20:41 | Mint (1) | After sunset: outline marker on the night half, "Sunrise 06:07" |
| 4 | `screens/4-instinct-e45.png` | **Instinct E 45 mm, 176 px (the Instinct-family shot)** | 10:09 | none (black and white) | The ring as a small 24-hour dial in the round window, the curve and date lines beside it |
| 5 | `screens/5-small-fr255s.png` | FR255S, 218 px | 10:09 | Pink (4) | The same face on a small round screen |

The Instinct family has no accent or golden-hour setting (ADR-024), so shot 4 shows neither. Two Suns ships on three Instincts (E 40 mm, E 45 mm, 3 Solar 45 mm); E 45 mm is the one pictured (the E 40 and 3 Solar draw the same layout).

## Cover, hero, device icons

Sources in `src/` (HTML, studio look, the face's own ring as the mark; the Pro mark adds the golden-hour arcs and a **PRO** pill, the Free mark has neither, so the pair is told apart the same way in cover, hero and icons: the pill is a **proposal for the owner**):

**Light/coloured ground (2026-10-04, ROADMAP 10.25; the owner has not approved the look).** Garmin's brand page says "Do not choose black or transparent backgrounds", so the cover and hero are re-rendered on a **violet ground, `#AA55FF`** (the Violet accent of the sun-ring palette, so Pro is the violet one and the Free listing is the sky-blue one). The mark keeps the face's own ring: daylight white, night in a deep indigo (`#2B1370`), the two golden-hour arcs in `#FF5500`, ticks and the sun in navy `#0B1530`; the name is navy with "Suns" white; the **PRO** pill is `#FF5500` with navy text and is larger than before so it still reads at 100 px (checked at 100 px). The hero keeps the real watch screens (black faces on the violet ground). The device icons stay as they are: the guidance sentence is about the cover, and the icon is a small black-ground mark with no text. rejected variants are in `NOTES.md`. Sizes: cover 13 KB, hero 151 KB.

| File | Size | Source |
|---|---|---|
| `cover-500.png` | 500 x 500 | `src/cover.html` |
| `hero-1440x720.png` | 1440 x 720 | `src/hero.html` (uses `screens/1-day.png`, `2-golden-hour.png`, `4-instinct-e45.png`) |
| `icon-24-128.png` | 128 x 128 (24 bit) | `src/icon.html` |
| `icon-64-128.png` | 128 x 128 (64 color) | `icon-24-128.png` snapped to 00/55/AA/FF channels by `src/quantize64.py` |

No price number and no claim are written in any image.

## Commands

Screens (the container, one run at a time, about 10 minutes; each shot restarts the simulator on its own clock and clears the simulator's stored settings, because it keeps the last run's in `APP.SET` and a stale accent otherwise beats the new default):

```sh
docker/capture.sh TwoSuns tools/listing_shots.sh pro                 # the whole set
docker/capture.sh TwoSuns tools/listing_shots.sh pro 5-small-fr255s  # one shot
```

Cover, hero and icons (headless Chrome; the fonts come from Google Fonts, so it needs the network):

```sh
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
cd TwoSuns/listing
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 --window-size=500,500   --screenshot="$PWD/cover-500.png"       "file://$PWD/src/cover.html"
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 --window-size=1440,720 --screenshot="$PWD/hero-1440x720.png"  "file://$PWD/src/hero.html"
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 --window-size=128,128  --screenshot="$PWD/icon-24-128.png"     "file://$PWD/src/icon.html"
python3 src/quantize64.py icon-24-128.png icon-64-128.png
```

## Limits, and how they were checked

Garmin: screen images under 150 KB each, cover 500 x 500 under 300 KB, hero 1440 x 720 under 2048 KB, icons 128 x 128. Checked on 2026-10-04 by reading each PNG's byte size (`os.path.getsize`) and its pixel size from the IHDR header (python3): sizes are in `paste.md` and `meta.yaml`.

## Not made

An always-on frame (the simulator does not enter Always-On, `docs/development.md`), a rectangular-screen shot (Venu Sq 2, Venu X1; not looked at), a weather-row or battery-row shot (held back, above), and anything from a real watch.
