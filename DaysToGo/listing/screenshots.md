# Pro listing: screenshots and store images

**Upload `screens-framed/` (since 2026-10-05, owner: every image in a watch, chassis and part of the strap, a different watch per image, as HeroSet).** Made by `docker/frame_listing.sh` from `src/frames.txt` (which watch frames which image; the device must be the one `tools/listing_shots.sh` captured on); `screens/` keeps the raw native captures, which the hero image and the framing read. Re-run after any recapture: `CIQ_IMAGE=verden-ciq-shots:9.2.0 docker/run.sh DaysToGo bash /ciq-docker/frame_listing.sh listing`.

Status: 2026-10-04. The whole set was re-rendered today from the **current Pro build** (after the on-watch date picker, the rectangle layout and the bottom-line changes of the same day). **Text uploaded with Pro 1.1.0 on 2026-10-04 (in Garmin review); whether these images replaced the live ones is ROADMAP 10.5.** Superseded files are in git history. Simulator only, no wrist photo: simulator passing is not device proof, and the clock, battery and steps in the pictures are canned, never a claim about real readings.

## The set (upload order)

| File | Size | Device | State |
|---|---|---|---|
| `screens/1-to-the-minute.png` | 454 px | fr965 | "Race" at 20:15 in UTC+2 (Hour 20:00, Minute 15, zone UTC+2) on a UTC clock at 10:09: 8h 06m, battery on the date row, mint (2026-10-04, ADR-018, replaces the 7:51 hours-battery capture) |
| `screens/2-weeks-steps.png` | 454 px, 17 KB | fr965 | "70.3" in weeks and days, steps on the date row, sky |
| `screens/3-other-time-zone.png` | 454 px | fr965 | "Launch" the next day at 09:30 in UTC+9 on a UTC clock at 10:09: 14h 21m, the date row reads the written date, battery, pink (2026-10-04, ADR-018, replaces the 161-days capture) |
| `screens/4-rectangle.png` | 320x360, 4 KB | venusq2 | hours state, amber (the bottom line is not drawn on the rectangle) |
| `screens/5-instinct.png` | 498 px, 3 KB | instincte40mm (**Instinct family**) | hours state, black and white, ring as a gauge in the round window (the bottom line is not drawn there) |

Five is the limit chosen by the owner (2026-10-04). Pro shows only what Pro adds on top of Free's fields (Hour, Minute and Event time zone, Footer; the two new captures are "to the minute", ADR-018); the accent colours are Free's too but vary the set. The Instinct picture comes from the **Instinct E 40 mm** on purpose: Garmin's paid-app product list has no Instinct 2, 2S, 2X or Descent G1 (coordinator note, `reports/Garmin policies and design guidelines.md`), so a Pro listing must not show or name them. `screens/5-instinct.png` is the simulator's own 166 px capture (`tools/listing_shots.sh` writes it to `screens/native/5-instincte40mm-166.png`; not kept in git) enlarged x3 with nearest-neighbour (498 px, no smoothing) because the store shows screenshots larger than that display.

Composed images (sources in `src/`): `cover-500.png` (500x500, 17 KB), `hero-1440x720.png` (1440x720, 156 KB; re-rendered 2026-10-04 with the "to the minute" line and the two new screens), `icon-24-128.png` and `icon-64-128.png` (128x128). The mark is the launcher icon's own geometry (`resources/drawables/launcher_icon.svg`: ring r 27, arc from the top 242.5 degrees, white "1"), so the hero's ring mark now agrees with the icon (the earlier hero's arc was a different angle, re-rendered 2026-10-04, ROADMAP 11.1). **Free and Pro are told apart by one thing:** the same mark with a small amber PRO badge on Pro (Free has none). A proposal; the real launcher icon is still the owner's (ROADMAP 3.3). Cover and hero are on a **light/coloured ground** (owner, 2026-10-04, ROADMAP 10.25): Garmin's brand page says "Do not choose black or transparent backgrounds (transparent backgrounds allow the Connect IQ background color to show)" for the 500x500 store icon. Brand mint `#55FFAA`; ink `#06261B` for the arc, the "1" and "Days"; track `#1FBF7A`; "To Go" `#0A6B43`; the hero keeps the three black watch screens on the mint. Earlier versions are in git history. The 128x128 device icons stay on black: Garmin's black-background rule is for the 500x500 store icon, the device-icon guidance is separate and has no background rule, and the icon sits on the watch's own black.

## How each was made

Screens, in the container (own simulator, one run at a time), then the Instinct enlargement and the check:

```sh
docker/capture.sh DaysToGo tools/listing_shots.sh pro      # from the repo root; ~6 min; writes listing/screens/ and screens/native/
docker/capture.sh DaysToGo tools/listing_shots.sh pro "1-to-the-minute.png 3-other-time-zone.png"   # only those two (the second argument is a quoted list of file names)
DaysToGo/tools/render_listing.sh pro screens                # screens/5-instinct.png from the native capture (Chrome, image-rendering: pixelated)
DaysToGo/tools/check_listing_images.sh                      # sizes, limits, screen count
```

`tools/listing_shots.sh` sets the simulator's clock (`faketime`, Sunday 2026-10-04 10:09), edits the face's real default properties in a private copy (Event, Name, Month, Day, Year, Unit, Hour, Minute, EventZone, Footer, Accent), builds `monkey.jungle` (Pro) and saves with the simulator's own File > Save Screen Capture, so each pixel size is the device's own. The simulator keeps an app's settings between loads, so the script deletes them before every shot (without that, only the first load's settings applied). Image 2 sets the step count by hand (`sim_activity steps=6420`) and waits 70 s. Commands for the composed images (Chrome headless; the Archivo font loads from Google Fonts, so it needs the network once):

```sh
DaysToGo/tools/render_listing.sh pro cover hero icon       # all of them: cover.html 500x500, hero.html 1440x720, icon.html 128x128
```

which runs, per image: `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=8000 --window-size=<w>,<h> --screenshot=<png> file://<listing>/src/<page>.html`. The 64 Color icon is the 24 bit render snapped to Garmin's palette (channels 00, 55, AA, FF) by `src/quantize64.py` (the same script HeroSet and HeroFace use), because Chrome anti-aliases edges into off-palette colours.

## Limits and how they were checked

Garmin: screenshots under 150 KB each, cover 500x500 under 300 KB, hero 1440x720 under 2048 KB, device icons 128x128 (`reports/listing-template.md`). `DaysToGo/tools/check_listing_images.sh` reads each file's size in bytes (`stat`) and pixel size (`sips`) and fails on a miss; all pass (largest screen 21 KB, cover 17 KB, hero 156 KB). Every image was also opened and looked at.

## Honesty rules

- Capture the real face (the build), never a mock-up; the numbers are ones the watch could produce, but the clock, battery and steps are canned.
- No price number in any image; nothing the release contract forbids (no battery-life, device-count or rival claim).
- The Pro text and images never use the word "free".
- The date picker (Customize > Set date) is not pictured: it is a different view, the simulator cannot open it on a face (a harness is needed, `tools/picker_shot.sh`), a colour MIP picker draws white there whatever the app clears, and "set it on your watch" is not an allowed claim until it is device-checked (release contract).

## Not done

- The always-on (sleep) state: the simulator would not enter it (needs a wrist).
- A wrist photo of any state.
- The owner's real launcher icon (ROADMAP 3.3); the icons here are proposals.
