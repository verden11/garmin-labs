# HeroFace (Free): screenshots and store images

Status 2026-10-04: **a full set rendered from the current Free build (`monkey.free.jungle`), simulator only, for the owner's look-approval; nothing uploaded** (ROADMAP 9.7, 1.5). Five screen images in `screens/`, `cover-500.png`, `hero-1440x720.png`, `icon-24-128.png`, `icon-64-128.png`, and the sources in `src/`. The Free build has no temperature, no seconds, three fixed goal bars (Auto), the accent colour and HeroSet mode, and the pictures show only that. The Pro twin's set is made the same way: [`../listing/screenshots.md`](../listing/screenshots.md) (the shared method is explained there too). Earlier versions are in git history.

## The five screen images (upload order)

All from the Free build, native simulator pixels, clock 2026-10-04 10:09. No price in any image.

| # | File | Device | What it shows |
|---|---|---|---|
| 1 | `screens/1-everyday.png` | `fr965`, 454 px | Everyday: 8420 steps, 18 intensity minutes, 7 floors, ring, the default blue accent |
| 2 | `screens/2-accent-cyan.png` | `fr965`, 454 px | The same day in the Cyan accent (Free's one setting) |
| 3 | `screens/3-goals-met.png` | `fr965`, 454 px | All three goals met: green bars and ring, check marks, gold streak line |
| 4 | `screens/4-heroset.png` | `fr965`, 454 px | HeroSet mode: push-ups, sit-ups, squats, rank and streak, gold ring (the HeroSet value is canned, see below) |
| 5 | `screens/5-instinct-e40.png` | **`instincte40mm`, 166 px native, shown x3 (the Instinct family)** | Black and white, the ring is a gauge in the round window, streak, three reversed labels for finished goals |

The Instinct has no Accent setting, so the choice was only which watch and state looked best: the Instinct E 40 mm with every goal met (the finished-goal pills and the streak line, "STEPS" in full; the Instinct 2 reads "STEP"). `screens/native/5-instincte40mm-166.png` is the simulator's own 166 px capture; `screens/5-instinct-e40.png` (the one to upload, as in the Days To Go listing) is the same pixels enlarged x3 with nearest-neighbour (498 px, two colours, no smoothing) because the store shows screenshots larger than the display: `src/instinct-up.html`, rendered with the same Chrome command at `--window-size=498,498` to `screens/5-instinct-e40.png`. Use the native file if you prefer.

## How they were made

Same scenario script as Pro (`../tools/listing_shots.sh`, `free` argument), one container run, one scenario per picture:

```sh
cd <repo root>
docker/capture.sh HeroFace tools/listing_shots.sh free     # writes HeroFace/listing-free/screens/1-…5-*.png and src/hero-magenta.png
```

- **Run the accent pictures in their own container run, one file per run** (`... free 2-accent-cyan.png`, then `... free hero-magenta.png`; the extra arguments name the files to take, so any picture can be re-taken alone, which is also how a flaky "NOT SAVED" is repeated). In one long run the simulator kept the Accent value stored by the first scene, and the Cyan and Magenta scenes came out blue. The 2026-10-04 set was taken as: one full run (`4-heroset`, `1-everyday`; its accent frames and its `3-goals-met` / Instinct saves did not come out), then `2-accent-cyan`, `hero-magenta` and `3-goals-met` + the Instinct frame (`5-instincte40mm-166.png`, saved in `screens/native/`) as separate runs. Every picture was looked at.
- Built in a **private copy** of the project (the repo is never touched); the clock is the simulator's (`faketime`); activity data typed into Simulation > Activity Monitoring; each file is File > Save Screen Capture at the device's own pixel size.
- The only setting Free has is the accent: shot 2 sets `Accent` 1 (Cyan) in the private copy's `resources-free/settings/properties.xml`; `src/hero-magenta.png` (used only in the hero) sets `Accent` 2 (the pale `#FFAAFF`).
- **HeroSet mode (shot 4) is canned**, exactly as for Pro: the simulator never sees HeroSet's complication, so the private copy's `HeroFaceLink.mc` is patched to report linked and to parse `1|20261004|60|45|28|2|40|3|20261003|100`. The drawing after that is the real path; the numbers are made up.
- Simulator data is fake (battery 50, heart rate 80). **Never crop a screenshot into a claim about real readings.** The simulator's activity history does not produce a multi-day streak, so shot 3 reads "1-DAY STREAK".
- Free never reads the temperature, seconds or per-bar settings, so none can appear; the pictures were looked at to confirm it.

## Cover, hero, icons

Sources in `src/` (`cover.html`, `hero.html`, `icon.html`, the Chrome commands as in the Pro file with `HeroFace/listing-free` as the folder; the 64-colour step is `python3 ../listing/src/quantize64.py icon-24-128.png icon-64-128.png`).

```sh
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
cd HeroFace/listing-free
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 \
  --window-size=500,500 --screenshot="$PWD/cover-500.png" "file://$PWD/src/cover.html"
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 \
  --window-size=1440,720 --screenshot="$PWD/hero-1440x720.png" "file://$PWD/src/hero.html"
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 \
  --window-size=128,128 --screenshot="$PWD/icon-24-128.png" "file://$PWD/src/icon.html"
python3 ../listing/src/quantize64.py icon-24-128.png icon-64-128.png
```

**Backgrounds (ROADMAP 10.25, owner decision 2026-10-04).** Garmin's brand page says "Do not choose black or transparent backgrounds" ([`../../reports/Garmin policies and design guidelines.md`](../../reports/Garmin%20policies%20and%20design%20guidelines.md), Store images). Cover and hero are now a solid sky blue `#1F7AFF` (Pro: the deeper royal blue `#0A55D6`), name in white Archivo, the mark's ring white on a pale-blue track, the gold shield and black fist unchanged; the hero keeps the three watches, whose black screens sit on the blue. Earlier versions are in git history. The 128x128 device icons are unchanged (black ground, the launcher's own look): Garmin's text is about the 500x500 cover image; whether the store also wants coloured device icons is not in the pages read, so that is an owner call. Rejected variants: `NOTES.md`.

**Free versus Pro (design proposal, the owner approves):** the same mark; Free is the plain mark on sky blue, Pro adds a white "PRO" pill in the opening of the ring on a deeper blue. The Free cover and icons are the plain mark. Hero: the name, "The time first, today's goals underneath, in your colour.", and three round watches in the three accents (Cyan, Blue, Magenta). No "Pro" word, no price, no temperature or seconds in the pictures.

## Limits and how they were checked

Limits from [`../../reports/listing-template.md`](../../reports/listing-template.md): screens under 150 KB, cover 500x500 under 300 KB, hero 1440x720 under 2048 KB, icons 128x128. Checked 2026-10-04 with `sips -g pixelWidth -g pixelHeight <files>` and `stat -f '%z %N' <files>` (bytes):

| File | Pixels | Size |
|---|---|---|
| `screens/1-everyday.png` | 454x454 | 16.1 KB |
| `screens/2-accent-cyan.png` | 454x454 | 15.1 KB |
| `screens/3-goals-met.png` | 454x454 | 15.1 KB |
| `screens/4-heroset.png` | 454x454 | 18.5 KB |
| `screens/5-instinct-e40.png` | 498x498 (x3 of the 166 px native) | 3.5 KB |
| `screens/native/5-instincte40mm-166.png` | 166x166 | 1.6 KB |
| `cover-500.png` | 500x500 | 11.7 KB |
| `hero-1440x720.png` | 1440x720 | 247 KB |
| `icon-24-128.png` | 128x128 | 2.4 KB |
| `icon-64-128.png` | 128x128 | 1.1 KB |

## Honesty rules

- The real face from the Free build; the one patched thing is the canned HeroSet value (shot 4).
- Nothing on a Free picture that Free does not have; Pro's pictures show the Pro-only things.
- No claim in an image that the listing could not make ([`../docs/release-contract.md`](../docs/release-contract.md)): no battery, always-on, accuracy, watch count, rating or price.
