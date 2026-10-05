# Two Suns (Free): screenshots and store images

**Upload `screens-framed/` (since 2026-10-05, owner: every image in a watch, chassis and part of the strap, a different watch per image, as HeroSet).** Made by `docker/frame_listing.sh` from `src/frames.txt` (which watch frames which image; the device must be the one `tools/listing_shots.sh` captured on); `screens/` keeps the raw native captures, which the hero image and the framing read. Re-run after any recapture: `CIQ_IMAGE=verden-ciq-shots:9.2.0 docker/run.sh TwoSuns bash /ciq-docker/frame_listing.sh listing-free`.

Status 2026-10-04. Everything here is **simulator only** (the container's simulator, native pixels), rendered from the **Free build** (`monkey.free.jungle`), so no shot can show a Pro-only thing (no curve, no date row, no twilight, no golden hour, no weather or battery row). Nothing is a wrist photo. **Uploaded by the owner 2026-10-04 with this set (looks approved by the upload), in Garmin review.** The Pro screens, cover and hero must not be reused here.

## What the pictures are, honestly

The simulator's canned sun times read wrong in the container's UTC clock (sunrise 12:17, sunset after midnight) and its Body Battery number is random. So `tools/listing_shots.sh` edits a **private copy** of the project (the real `source/` is never changed): sunrise 06:05 and sunset 17:32 stand in for the Complication values (the NOAA times for 51.5 N, 0 E on 4 October; the clock is UTC) and the Body Battery number is fixed at 59. **Canned: the pictures show the design, never a reading**; nothing may be cropped into a claim about real data. The evening shot's "Sunrise ~06:05" is Free's wording when it knows only today's Garmin numbers (the tilde marks an estimate).

## Screen images (upload order)

24-hour clock, the Free build's only setting is the accent. Each file is far under 150 KB.

| # | File | Device | Clock (UTC) | Accent | What it shows |
|---|---|---|---|---|---|
| 1 | `screens/1-day.png` | FR965, 454 px | 10:09 | Sky (0, the default) | Time, bolt and 59, "7h 22m of daylight", the ring (daylight gone and to come, ticks, sun marker) |
| 2 | `screens/2-evening.png` | FR965, 454 px | 20:41 | Mint (1) | After sunset: outline marker on the night half, "Sunrise ~06:05" |
| 3 | `screens/3-accent-pink.png` | FR965, 454 px | 13:21 | Pink (4) | The one setting: another accent |
| 4 | `screens/4-instinct-e45.png` | **Instinct E 45 mm, 176 px (the Instinct-family shot)** | 10:09 | none (black and white) | The ring as a small 24-hour dial in the round window |
| 5 | `screens/5-small-fr255s.png` | FR255S, 218 px | 10:09 | Violet (3) | The same face on a small round screen |

The Instinct family has no accent setting (ADR-024). Two Suns ships on three Instincts (E 40 mm, E 45 mm, 3 Solar 45 mm); E 45 mm is the one pictured.

Not made on purpose: the `--` (no Body Battery number) state. The simulator gives a number whenever the Complication is on; the empty state is covered by the unit tests (ADR-021).

## Cover, hero, device icons

Sources in `src/` (HTML, studio look, the face's own ring as the mark: the plain ring, **no** golden arcs and **no PRO pill**, which is how it is told apart from Pro; the pill is a proposal for the owner):

**Light/coloured ground (2026-10-04, ROADMAP 10.25).** Garmin's brand page says "Do not choose black or transparent backgrounds", so the cover and hero are re-rendered on a **sky-blue ground, `#55AAFF`** (the default Sky accent of the sun-ring palette, so Free is the blue one and the Pro listing the violet one). The mark is the plain ring (daylight white, night in deep blue `#1B2A8F`, ticks and sun in navy `#0B1530`), no golden arcs and no PRO pill; the name is navy with "Suns" in the night blue. The hero keeps the real watch screens (black faces on the blue ground). The device icons stay as they are (the guidance sentence is about the cover; the icon is a small black-ground mark with no text). rejected variants are in `NOTES.md`. Sizes: cover 12 KB, hero 145 KB.

| File | Size | Source |
|---|---|---|
| `cover-500.png` | 500 x 500 | `src/cover.html` |
| `hero-1440x720.png` | 1440 x 720 | `src/hero.html` (uses `screens/1-day.png`, `2-evening.png`, `4-instinct-e45.png`) |
| `icon-24-128.png` | 128 x 128 (24 bit) | `src/icon.html` |
| `icon-64-128.png` | 128 x 128 (64 color) | `icon-24-128.png` snapped to 00/55/AA/FF channels by `src/quantize64.py` |

No price number and no claim are written in any image, and nothing in them names Pro.

## Commands

Screens (the container, one run at a time, about 10 minutes; each shot restarts the simulator on its own clock and clears the simulator's stored settings, because it keeps the last run's in `APP.SET`):

```sh
docker/capture.sh TwoSuns tools/listing_shots.sh free                 # the whole set
docker/capture.sh TwoSuns tools/listing_shots.sh free 5-small-fr255s  # one shot
```

Cover, hero and icons (headless Chrome; fonts from Google Fonts, so it needs the network):

```sh
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
cd TwoSuns/listing-free
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 --window-size=500,500   --screenshot="$PWD/cover-500.png"       "file://$PWD/src/cover.html"
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 --window-size=1440,720 --screenshot="$PWD/hero-1440x720.png"  "file://$PWD/src/hero.html"
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 --window-size=128,128  --screenshot="$PWD/icon-24-128.png"     "file://$PWD/src/icon.html"
python3 src/quantize64.py icon-24-128.png icon-64-128.png
```

## Limits, and how they were checked

Garmin: screen images under 150 KB each, cover 500 x 500 under 300 KB, hero 1440 x 720 under 2048 KB, icons 128 x 128. Checked on 2026-10-04 by reading each PNG's byte size (`os.path.getsize`) and its pixel size from the IHDR header (python3): sizes are in `paste.md` and `meta.yaml`.

## Not made

An always-on frame (the simulator does not enter Always-On), a rectangular-screen shot, the `--` state, and anything from a real watch.
