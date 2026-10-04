# Pro listing: screenshots and store images

Status: 2026-10-04. The whole set was re-rendered today from the **current Pro build** (after the on-watch date picker, the rectangle layout and the bottom-line changes of the same day). **Proposals: the owner approves every look before upload; nothing is uploaded.** Superseded files (the 1.0.1 face-render cover, the earlier hero and screens) are in `old/`. Simulator only, no wrist photo: simulator passing is not device proof, and the clock, battery and steps in the pictures are canned, never a claim about real readings.

## The set (upload order)

| File | Size | Device | State |
|---|---|---|---|
| `screens/1-hours-battery.png` | 454 px, 18 KB | fr965 | event today 18:00 (Hour 18:00): 7:51 HOURS, battery on the date row, mint |
| `screens/2-weeks-steps.png` | 454 px, 17 KB | fr965 | "70.3" in weeks and days, steps on the date row, sky |
| `screens/3-days-battery.png` | 454 px, 18 KB | fr965 | "Wedding", 161 DAYS, battery on the date row, pink |
| `screens/4-rectangle.png` | 320x360, 4 KB | venusq2 | hours state, amber (the bottom line is not drawn on the rectangle) |
| `screens/5-instinct.png` | 498 px, 3 KB | instincte40mm (**Instinct family**) | hours state, black and white, ring as a gauge in the round window (the bottom line is not drawn there) |

Five is the limit chosen by the owner (2026-10-04). Pro shows only what Pro adds on top of Free's fields (Hour, Footer); the accent colours are Free's too but vary the set. The Instinct picture comes from the **Instinct E 40 mm** on purpose: Garmin's paid-app product list has no Instinct 2, 2S, 2X or Descent G1 (coordinator note, `reports/Garmin policies and design guidelines.md`), so a Pro listing must not show or name them. `screens/native/5-instincte40mm-166.png` is the simulator's own 166 px capture; `screens/5-instinct.png` is the same pixels enlarged x3 with nearest-neighbour (498 px, no smoothing) because the store shows screenshots larger than that display. Use the native file if you prefer.

Composed images (sources in `src/`): `cover-500.png` (500x500, 83 KB), `hero-1440x720.png` (1440x720, 265 KB), `icon-24-128.png` and `icon-64-128.png` (128x128). The mark is the launcher icon's own geometry (`resources/drawables/launcher_icon.svg`: ring r 27, arc from the top 242.5 degrees, white "1"), so the hero's ring mark now agrees with the icon (the earlier hero's arc was a different angle, re-rendered 2026-10-04, ROADMAP 11.1). **Free and Pro are told apart by one thing:** the same mark with a small amber PRO badge on Pro (Free has none). A proposal; the real launcher icon is still the owner's (ROADMAP 3.3).

## How each was made

Screens, in the container (own simulator, one run at a time), then the Instinct enlargement and the check:

```sh
docker/capture.sh DaysToGo tools/listing_shots.sh pro      # from the repo root; ~6 min; writes listing/screens/ and screens/native/
DaysToGo/tools/render_listing.sh pro screens                # screens/5-instinct.png from the native capture (Chrome, image-rendering: pixelated)
DaysToGo/tools/check_listing_images.sh                      # sizes, limits, screen count
```

`tools/listing_shots.sh` sets the simulator's clock (`faketime`, Sunday 2026-10-04 10:09), edits the face's real default properties in a private copy (Event, Name, Month, Day, Year, Unit, Hour, Footer, Accent), builds `monkey.jungle` (Pro) and saves with the simulator's own File > Save Screen Capture, so each pixel size is the device's own. The simulator keeps an app's settings between loads, so the script deletes them before every shot (without that, only the first load's settings applied). Image 2 sets the step count by hand (`sim_activity steps=6420`) and waits 70 s. Commands for the composed images (Chrome headless; the Archivo font loads from Google Fonts, so it needs the network once):

```sh
DaysToGo/tools/render_listing.sh pro cover hero icon       # all of them: cover.html 500x500, hero.html 1440x720, icon.html 128x128
```

which runs, per image: `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=8000 --window-size=<w>,<h> --screenshot=<png> file://<listing>/src/<page>.html`. The 64 Color icon is the 24 bit render snapped to Garmin's palette (channels 00, 55, AA, FF) by `src/quantize64.py` (the same script HeroSet and HeroFace use), because Chrome anti-aliases edges into off-palette colours.

## Limits and how they were checked

Garmin: screenshots under 150 KB each, cover 500x500 under 300 KB, hero 1440x720 under 2048 KB, device icons 128x128 (`reports/listing-template.md`). `DaysToGo/tools/check_listing_images.sh` reads each file's size in bytes (`stat`) and pixel size (`sips`) and fails on a miss; all pass (largest screen 18 KB, cover 83 KB, hero 265 KB). Every image was also opened and looked at.

## Honesty rules

- Capture the real face (the build), never a mock-up; the numbers are ones the watch could produce, but the clock, battery and steps are canned.
- No price number in any image; nothing the release contract forbids (no battery-life, device-count or rival claim).
- The Pro text and images never use the word "free".
- The date picker (Customize > Set date) is not pictured: it is a different view, the simulator cannot open it on a face (a harness is needed, `tools/picker_shot.sh`), a colour MIP picker draws white there whatever the app clears, and "set it on your watch" is not an allowed claim until it is device-checked (release contract).

## Not done

- The always-on (sleep) state: the simulator would not enter it (needs a wrist).
- A wrist photo of any state.
- The owner's real launcher icon (ROADMAP 3.3); the icons here are proposals.
