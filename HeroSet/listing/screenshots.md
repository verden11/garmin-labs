# HeroSet listing images: how they are made

Status 2026-10-04 (screen 2 and the hero retaken later the same day with a heart rate). All five screens, the hero, the cover and the two device icons were re-made from the 1.3.1 store build (`store.jungle`, `-r`) on this date. **Simulator only, not device proof**; simulator data is canned (the clock is faked to 2026-10-04 10:09, the reps are seeded). Looks are not yet approved by the owner. Upload order and one-line captions: [`paste.md`](paste.md) "Screen Images"; sizes: [`meta.yaml`](meta.yaml) `assets`.

## The set

| # | File | Device | State | Seed (push-ups, sit-ups, squats) |
|---|---|---|---|---|
| 1 | `screens-framed/1-dashboard.png` | fr965 | the home screen, rank 1, three bars, `NO STREAK YET` | 60, 45, 30 |
| 2 | `screens-framed/2-counting.png` | fr965 | push-ups set, 23 counted, `TODAY 83/100`, `00:28 HR 145 CAL 0` (see below) | 60, 45, 30 |
| 3 | `screens-framed/3-review.png` | fr965 | review: `DETECTED 23`, adjusted with UP to `+24`, `TODAY 84/100` | 60, 45, 30 |
| 4 | `screens-framed/4-complete.png` | fr965 | `DAILY MISSION COMPLETE`, rank 2, `1 DAY STREAK` | 100, 100, 100 |
| 5 | `screens-framed/5-instinct.png` | **instincte45mm** | the same dashboard in black and white, XP ring in the round window | 60, 45, 30 |

Why these: the owner's story (2026-10-04): the one-glance home screen, counting a set, review and adjust, saved or complete, plus an Instinct. 4 is the complete state, not the `+N SAVED` one (the hero used that before; complete is the reward and the streak starts). The Instinct is the **Instinct E 45 mm**: the Instinct 2 family and Descent G1 are not on Garmin's paid-app product list, so the paid listing is not sold there and no caption names them. Of the three paid Instinct products, the E 45 mm had the boldest text and the most room (E 40 mm and 3 Solar were looked at too). Not used: the menu, the saved screen, a touch watch (the 5-image cap).

Shot 2 (retaken 2026-10-04): the heart rate is from the simulator's own activity simulation (Simulation > Activity Data > Start/play, `sim_activity_data_start` in `docker/sim-gui.sh`, run with the `act` argument below), so it reads `HR 145` (the simulated rate moved between 123 and 159 over the test runs; this take was kept because it is inside 90 to 150) and `00:28` elapsed (a 25 s wait after opening the set screen, so the clock does not read `00:00`). **`CAL 0` is still 0**: the activity simulation does not move `ActivityMonitor.getInfo().calories` (checked over 3 minutes), and typing a value into the Activity Monitor Info dialog is overwritten by the simulation, so the delta from the start of the set stays 0 and no number was invented. The heart rate is simulator data: do not use this picture to claim an accurate or live reading on a wrist.

## How the screens were made

1. **Drive the app and photograph the whole simulator window** (display plus the device skin), one container run per device and state. The rep seed is patched into a private copy of the project (the repo is untouched); the clock is faked. From the repo root:

   ```sh
   docker/capture.sh HeroSet tools/drive_screens.sh fr965 btn store.jungle 60,45,30 23 glance all act   # 1 (1-dashboard), 2 (3-counting, with a heart rate), 3 (5b-up)
   docker/capture.sh HeroSet tools/drive_screens.sh fr965 btn store.jungle 100,100,100 23 glance home    # 4 (1-dashboard)
   docker/capture.sh HeroSet tools/drive_screens.sh instincte45mm btn store.jungle 60,45,30 23 glance home   # 5 (1-dashboard)
   ```

   The last argument `act` starts the simulator's activity data after the dashboard (`sim_activity_data_start`; before the glance it disturbs the glance) and waits 25 s on the set screen. Without it the set screen reads `HR --`. The heart rate is random, so check the take and run again if it is outside 90 to 150 (two takes after 40 s read 156 and 159, hence the 25 s wait). Each run is about 4 minutes.

   Each step writes `HeroSet/bin/drive-<device>-<step>.png` (the display) and `...-window.png` (the whole window; added to `drive_screens.sh` on 2026-10-04). Copy the window files used into `listing/src/window/` under the names in the table (`fr965-1-dashboard.png`, `fr965-2-counting.png`, `fr965-3-review.png`, `fr965-4-complete.png`, `instincte45mm-5-dashboard.png`); those are the sources of the framed images. `ONLY=home` stops after the home screen.

2. **Frame** (ImageMagick, in the container's shots image): crop the skin out of the window, key the white background to transparent (flood fill from the corners, fuzz 6%), place on a 720x720 canvas centred on the display, 256 colours. Round watches 100%; the Instinct skin is small, so it is enlarged 160% (Lanczos, so its display is a little soft; native pixels are in `bin/drive-*.png`).

   ```sh
   CIQ_IMAGE=verden-ciq-shots:9.2.0 docker/run.sh HeroSet bash tools/frame_all.sh
   ```

   It writes `listing/screens-framed/*.png`, `bin/preview.png` (the five on a dark card to judge the keyed edges) and prints `OVER 150 KB` for any file over the cap. The single-file tool is `tools/frame_shots.sh <device> <window.png> <out.png> [scale] [skin-width]`.

## Hero, cover, icons

Sources in `src/` (`hero.html`, `cover.html`, `icon.html`, `quantize64.py`); rendered with headless Chrome on the host by one script:

```sh
HeroSet/tools/render_listing.sh
```

- `hero-1440x720.png`: on a flat amber `#FFAA00` ground (2026-10-04, ROADMAP 10.25), navy text, the shield mark, name, the promise line, and screens 1, 2 (the centre watch, the counting screen with `HR 145`) and 5 (the straps are faded out where the square cut them). No price, no accuracy claim.
- `cover-500-designed.png`: shield and name only (it shows at about 100 px in browse), flat amber `#FFAA00` ground with navy ink and a blue `#0A3FB0` "Set" (Garmin's brand page: no black or transparent backgrounds; rejected variants in `NOTES.md`).
- `icon-24-128.png` and `icon-64-128.png`: the launcher icon's shield on black, 128x128; the 64-colour one is the 24-bit render snapped to Garmin's 64-colour palette (channels 00/55/AA/FF) by `src/quantize64.py`. The shield is the current pixel-grid launcher shape (`resources/drawables/launcher_icon.svg`), cropped to its bounds.

## Limits checked (2026-10-04)

`stat` on the files, each under Garmin's cap: screens 90 to 113 KB (cap 150), cover 12 KB (cap 300), hero 287 KB (cap 2048); icons 1 and 2 KB; all pixel sizes read from the files (`file`, `identify`): 720x720 x5, 500x500, 1440x720, 128x128 x2. `frame_all.sh` also fails loudly on a screen over 150 KB.

## Honesty rules

Real captures of the store build, never mock-ups; the display pixels are only resized (Instinct) with the skin; the background is the only thing removed. Simulator data is canned (the seeded reps, the clock, the simulated heart rate, calories 0). No price number in any image. Nothing in an image claims accuracy, a wrist test, the Instinct 2 family, or a glance. The Instinct image shows one Instinct E 45 mm in the simulator: the Instinct claim waits for the store's device list ([`../docs/release-contract.md`](../docs/release-contract.md)).
