# HeroFace Pro: screenshots and store images

Status 2026-10-04: **a full set rendered from the current Pro build (`monkey.jungle`), simulator only.** **Text uploaded with Pro 1.1.0 on 2026-10-04 (in Garmin review); whether these images replaced the live ones is ROADMAP 10.5.** Everything the store form takes is in this folder: five screen images in `screens/`, `cover-500.png`, `hero-1440x720.png`, `icon-24-128.png`, `icon-64-128.png`. The superseded set is in git history. The Free twin's set is in [`../listing-free/screenshots.md`](../listing-free/screenshots.md); the two are made the same way.

## The five screen images (upload order)

All from the Pro build, native simulator pixels, clock 2026-10-04 10:09. No price in any image.

| # | File | Device | What it shows (what Pro has) |
|---|---|---|---|
| 1 | `screens/1-everyday.png` | `fr965`, 454 px | Everyday: 8420 steps, 18 intensity minutes, 7 floors, ring, blue accent, the temperature under the time |
| 2 | `screens/2-your-bars.png` | `fr965`, 454 px | **Pro's own:** the bars set to the move bar, steps and intensity minutes (each bar fills), seconds beside the time, the pale magenta accent |
| 3 | `screens/3-goals-met.png` | `fr965`, 454 px | All three goals met: green bars and ring, check marks, gold streak line |
| 4 | `screens/4-heroset.png` | `fr965`, 454 px | HeroSet mode: push-ups, sit-ups, squats, rank and streak, gold ring (the HeroSet value is canned, see below) |
| 5 | `screens/5-instinct-e40.png` | **`instincte40mm`, 166 px native, shown x3 (the Instinct family)** | Black and white, the ring is a gauge in the round window (closed here), the time and date left of it, streak, three reversed labels for finished goals |

The Instinct has no Accent setting, so there is nothing to choose; the goals-met state was picked because it is the best-looking frame (the finished-goal pills and the streak line, drawn icons in reversed pills since 2026-10-05, 13.11). **Pro is sold for the Instinct E and Instinct 3 watches, not the Instinct 2 family** (Garmin's paid-app product list, `../../reports/Garmin policies and design guidelines.md`), so the Pro Instinct picture is an Instinct E 40 mm. `screens/5-instinct-e40.png` (the one to upload, as in the Days To Go listing) is the simulator's own 166 px capture (`tools/listing_shots.sh` writes it to `screens/native/5-instincte40mm-166.png`; not kept in git) enlarged x3 with nearest-neighbour (498 px, two colours, no smoothing) because the store shows screenshots larger than the display: `src/instinct-up.html`, rendered by the same Chrome command with `--window-size=498,498` and `--screenshot="$PWD/screens/5-instinct-e40.png"`. `instinct3solar45mm` did not save in the scripted run (it opens on its glance), so it was not used.

## How they were made

`tools/listing_shots.sh` drives the simulator in the container, one `docker/capture.sh` run, one scenario per picture (about 2 minutes each, one container at a time):

```sh
cd <repo root>
docker/capture.sh HeroFace tools/listing_shots.sh pro 2-your-bars.png   # one picture per run (see below); writes HeroFace/listing/screens/2-your-bars.png
# the other four the same way: 1-everyday.png  3-goals-met.png  4-heroset.png  5-instincte40mm-166.png (the native Instinct frame, saved in screens/native/; then render src/instinct-up.html with Chrome to make the x3 upload file)
```

**Take each picture in its own run.** In the Free twin's long run the simulator kept the Accent value stored by the first scene (the Cyan and Magenta frames came out blue); Pro's 2026-10-04 set was taken in one longer run in a different order (HeroSet scenes first) where it did not happen, and the trimmed script's order (1-everyday, then 2-your-bars) was **not** re-proven in one run. One picture per run is the safe, documented way, and the extra arguments make that cheap.

- The five pictures came out of one full run that also took a few extra frames (a second custom-bars variant, Instinct 2 and Instinct E 45 mm, a goals-met HeroSet frame); the script was trimmed to the chosen five afterwards and the unused frames were discarded. The scenes are unchanged. Extra arguments after `pro` name the files to re-take alone (`... pro 3-goals-met.png`); a "NOT SAVED" line means repeat that one. In the Free twin's long run the simulator kept a stored Accent value, so Free's accent frames are taken one per run; look at every picture.
- The face is built in a **private copy** of the project, so `source/` and the repo's `properties.xml` are never touched. The clock is the simulator's own (`faketime`), the activity data is typed into Simulation > Activity Monitoring, and each file is the simulator's File > Save Screen Capture, so the size is the device's own.
- Settings a user would change are set by editing the private copy's `resources-pro/settings/properties.xml`: shot 2 sets `Accent` 2 (Magenta), `Seconds` true, `Slot1` 6 (move bar), `Slot2` 1 (steps), `Slot3` 3 (intensity minutes); only metrics with a goal were used, so every column has a filling bar (distance and calories have no goal and draw an empty column; the first version of this picture used distance and was retaken for that reason); the others use the defaults (blue, no seconds, bars on Auto).
- **HeroSet mode (shot 4) is canned.** The simulator runs one app at a time, so the face never sees HeroSet's complication. The private copy's `HeroFaceLink.mc` is patched (`isLinked()` true, `progress()` parses `1|20261004|60|45|28|2|40|3|20261003|100`: 60 / 45 / 28 reps of a goal of 100, rank 2, 40 % into the rank, streak 3). Everything after that is the real drawing path, the same one the on-watch link feeds; the numbers are made up and say nothing about HeroSet.
- Simulator data is fake: the 68° temperature, battery 50, heart rate 80 and the move bar (no value while quiet since 2026-10-05, 13.10) are canned or derived. **Never crop a screenshot into a claim about real readings.** The simulator's activity history does not produce a multi-day streak, so shot 3 reads "1-DAY STREAK".
- The FR965 wrist captures from 2026-09-20/21 are of the pre-split paid build and are no longer used.

## Cover, hero, icons

Sources in `src/`, rendered by headless Chrome (cover 500x500, hero 1440x720, icon 128x128; the fonts come from Google Fonts, so a network is needed). From the repo root:

```sh
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
cd HeroFace/listing
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 \
  --window-size=500,500 --screenshot="$PWD/cover-500.png" "file://$PWD/src/cover.html"
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 \
  --window-size=1440,720 --screenshot="$PWD/hero-1440x720.png" "file://$PWD/src/hero.html"
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 \
  --window-size=128,128 --screenshot="$PWD/icon-24-128.png" "file://$PWD/src/icon.html"
python3 src/quantize64.py icon-24-128.png icon-64-128.png     # the "64 Color" icon: every channel snapped to 00/55/AA/FF
```

The 24-bit icon is the SVG mark (the same shapes as `resources/drawables/launcher_icon.svg`) rendered at 128 px; the 64-colour icon is that render snapped to Garmin's 64-colour palette, because Chrome antialiases the edges into off-palette colours.

**Backgrounds (ROADMAP 10.25, owner decision 2026-10-04).** Garmin's brand page says "Do not choose black or transparent backgrounds" ([`../../reports/Garmin policies and design guidelines.md`](../../reports/Garmin%20policies%20and%20design%20guidelines.md), Store images). Cover and hero are now a solid sky blue `#1F7AFF` (Pro: the deeper royal blue `#0A55D6`), name in white Archivo, the mark's ring white on a pale-blue track, the gold shield and black fist unchanged; the hero keeps the three watches, whose black screens sit on the blue. Earlier versions are in git history. The 128x128 device icons are unchanged (black ground, the launcher's own look): Garmin's text is about the 500x500 cover image; whether the store also wants coloured device icons is not in the pages read, so that is an owner call. Rejected variants: `NOTES.md`.

**Free versus Pro (a design proposal for the owner to approve):** the same mark in both. Pro adds a white "PRO" pill in the opening of the ring, in the cover (drawn larger there so it reads at 100 px), both icons (small, white with black text, palette-safe) and, as a pill beside the name, the hero; Free has the plain mark. On the cover and hero the pill is white with royal-blue text. The on-watch launcher icon is shared by both tiers and is not changed here (that is `resources/`, and an owner call).

Hero: the copy on the left (the name with its PRO pill and one sentence, no "free", no price), three round watches on the right: everyday, Pro's own (centre), HeroSet mode. The Instinct is not in the hero (a square 166 px picture clips in the round frame).

## Limits and how they were checked

Garmin's limits are in [`../../reports/listing-template.md`](../../reports/listing-template.md): screens under 150 KB each, cover 500x500 under 300 KB, hero 1440x720 under 2048 KB, device icons 128x128. Checked 2026-10-04 with:

```sh
sips -g pixelWidth -g pixelHeight screens/*.png cover-500.png hero-1440x720.png icon-*.png
stat -f '%z %N' screens/*.png cover-500.png hero-1440x720.png icon-*.png          # bytes
```

| File | Pixels | Size |
|---|---|---|
| `screens/1-everyday.png` | 454x454 | 16.9 KB |
| `screens/2-your-bars.png` | 454x454 | 18.2 KB |
| `screens/3-goals-met.png` | 454x454 | 16.0 KB |
| `screens/4-heroset.png` | 454x454 | 19.3 KB |
| `screens/5-instinct-e40.png` | 498x498 (x3 of the 166 px native) | 3.5 KB |
| `cover-500.png` | 500x500 | 15.7 KB |
| `hero-1440x720.png` | 1440x720 | 280 KB |
| `icon-24-128.png` | 128x128 | 3.6 KB |
| `icon-64-128.png` | 128x128 | 1.4 KB |

## Still missing

**Always on.** Capture it on the FR965, not the simulator: the sleep render is the one thing the simulator cannot vouch for, and it is what Garmin's burn-in rules apply to ([`../docs/status.md`](../docs/status.md) §1). Deferred to a later listing update (user call, 2026-09-21).

## Where they go

- **Store:** upload in the submission form, in the numbered order above.
- **Website:** `../../site/public/heroface/screens/` has the 2026-09 images (`everyday.png`, `goals-met.png`, `heroset.png`); the site is not touched here. Refreshing it from this set is a separate step.

## Honesty rules

- Capture the real face, never a mock-up; the one patched thing is the canned HeroSet value (shot 4), said above.
- The numbers on screen must be ones the watch could actually produce.
- No claim in the image that the listing itself could not make ([`../docs/release-contract.md`](../docs/release-contract.md)): no battery, always-on, accuracy, watch count, rating or price.
- The Pro listing's text never says "free", and neither does an image.
