# Free listing: screenshots and store images

Status: 2026-10-04. The whole set was rendered today from the **current Free build** (after the on-watch date picker, the rectangle layout and the bottom-line changes of the same day). **Uploaded by the owner 2026-10-04 with this set (looks approved by the upload), in Garmin review.** Earlier versions are in git history. Simulator only, no wrist photo: simulator passing is not device proof, and the clock in the pictures is canned.

## The set (upload order)

| File | Size | Device | State |
|---|---|---|---|
| `screens/1-days-amber.png` | 454 px, 18 KB | fr965 | "Wedding", 161 DAYS, date line with the year, amber |
| `screens/2-weeks-sky.png` | 454 px, 18 KB | fr965 | "70.3", 6 WEEKS + 3 DAYS, sky |
| `screens/3-today-pink.png` | 454 px, 15 KB | fr965 | the day itself: TODAY, ring full, pink |
| `screens/4-rectangle.png` | 320x360, 4 KB | venusq2 | 45 DAYS on a rectangular screen, violet |
| `screens/5-instinct.png` | 528 px, 3 KB | instinct2 (**Instinct family**) | 45 DAYS, black and white, ring as a gauge in the round window |

Five is the limit chosen by the owner (2026-10-04). Free shows only Free's fields: Event, Name, Month/Day/Year, Unit (days or weeks), Date style, Accent; the Free build contains no Hour or Footer code path, so no bottom line or H:MM can appear (`tools/check_free_package.sh`). Accent colours vary across the set because the accent is Free's selling point; the Instinct has none (black and white). Free may use any Instinct (Garmin lists the Instinct 2 family for free apps), so the Instinct 2 is used; `screens/5-instinct.png` is the simulator's own 176 px capture (`tools/listing_shots.sh` writes it to `screens/native/5-instinct2-176.png`; not kept in git) enlarged x3 with nearest-neighbour (528 px, no smoothing) because the store shows screenshots larger than that display.

Composed images (sources in `src/`): `cover-500.png` (500x500, 16 KB), `hero-1440x720.png` (1440x720, 156 KB), `icon-24-128.png` and `icon-64-128.png` (128x128). The mark is the launcher icon's own geometry (`resources/drawables/launcher_icon.svg`). **Free and Pro are told apart by one thing:** Free is the bare mark, Pro adds a small amber PRO badge. A proposal; the real launcher icon is still the owner's (ROADMAP 3.3). Cover and hero are on a **light/coloured ground** (owner, 2026-10-04, ROADMAP 10.25): Garmin's brand page says "Do not choose black or transparent backgrounds (transparent backgrounds allow the Connect IQ background color to show)" for the 500x500 store icon. Brand mint `#55FFAA`; ink `#06261B` for the arc, the "1" and "Days"; track `#1FBF7A`; "To Go" `#0A6B43`; the hero keeps the three black watch screens on the mint. Earlier versions are in git history. The 128x128 device icons stay on black: Garmin's black-background rule is for the 500x500 store icon, the device-icon guidance is separate and has no background rule, and the icon sits on the watch's own black.

## How each was made

```sh
docker/capture.sh DaysToGo tools/listing_shots.sh free     # from the repo root; ~6 min; writes listing-free/screens/ and screens/native/
DaysToGo/tools/render_listing.sh free screens               # screens/5-instinct.png from the native capture (Chrome, image-rendering: pixelated)
DaysToGo/tools/render_listing.sh free cover hero icon       # cover.html 500x500, hero.html 1440x720, icon.html 128x128 (+ the 64 Color snap)
DaysToGo/tools/check_listing_images.sh                      # sizes, limits, screen count
```

`tools/listing_shots.sh` sets the simulator's clock (`faketime`, Sunday 2026-10-04 10:09), edits the Free build's real default properties in a private copy, builds `monkey.free.jungle` and saves with the simulator's own File > Save Screen Capture (native pixels). The simulator keeps an app's settings between loads, so the script deletes them before every shot. The composed images run `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=8000 --window-size=<w>,<h> --screenshot=<png> file://<listing-free>/src/<page>.html` (the Archivo font loads from Google Fonts: network needed once). The 64 Color icon is the 24 bit render snapped to Garmin's palette (00, 55, AA, FF) by `src/quantize64.py`.

## Limits and how they were checked

Garmin: screenshots under 150 KB each, cover 500x500 under 300 KB, hero 1440x720 under 2048 KB, device icons 128x128 (`reports/listing-template.md`). `DaysToGo/tools/check_listing_images.sh` reads each file's size in bytes (`stat`) and pixel size (`sips`) and fails on a miss; all pass. Every image was also opened and looked at.

## Honesty rules

- Capture from the Free build only; never hint at Pro in a Free image (no bottom line, no H:MM, no PRO badge); the Pro listing's images do not hide that they are Pro.
- No price number in any image; nothing the release contract forbids.
- The date picker (Customize > Set date) is not pictured: a different view the simulator cannot open on a face, a colour MIP picker draws white there, and "set it on your watch" needs a device check first (release contract).

## Not done

- The always-on (sleep) state (needs a wrist); a wrist photo; the owner's real launcher icon (ROADMAP 3.3).
