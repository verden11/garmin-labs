# HeroSet listing images: how they are made

Status 2026-10-04. All five screens, the hero, the cover and the two device icons were re-made from the 1.3.1 store build (`store.jungle`, `-r`) on this date. **Simulator only, not device proof**; simulator data is canned (the clock is faked to 2026-10-04 10:09, the reps are seeded). Looks are not yet approved by the owner. Upload order and one-line captions: [`paste.md`](paste.md) "Screen Images"; sizes: [`meta.yaml`](meta.yaml) `assets`.

## The set

| # | File | Device | State | Seed (push-ups, sit-ups, squats) |
|---|---|---|---|---|
| 1 | `screens-framed/1-dashboard.png` | fr965 | the home screen, rank 1, three bars, `NO STREAK YET` | 60, 45, 30 |
| 2 | `screens-framed/2-counting.png` | fr965 | push-ups set, 23 counted, `TODAY 83/100` (`HR --`, see below) | 60, 45, 30 |
| 3 | `screens-framed/3-review.png` | fr965 | review: `DETECTED 23`, adjusted with UP to `+24`, `TODAY 84/100` | 60, 45, 30 |
| 4 | `screens-framed/4-complete.png` | fr965 | `DAILY MISSION COMPLETE`, rank 2, `1 DAY STREAK` | 100, 100, 100 |
| 5 | `screens-framed/5-instinct.png` | **instincte45mm** | the same dashboard in black and white, XP ring in the round window | 60, 45, 30 |

Why these: the owner's story (2026-10-04): the one-glance home screen, counting a set, review and adjust, saved or complete, plus an Instinct. 4 is the complete state, not the `+N SAVED` one (the hero used that before; complete is the reward and the streak starts). The Instinct is the **Instinct E 45 mm**: the Instinct 2 family and Descent G1 are not on Garmin's paid-app product list, so the paid listing is not sold there and no caption names them. Of the three paid Instinct products, the E 45 mm had the boldest text and the most room (E 40 mm and 3 Solar were looked at too). Not used: the menu, the saved screen, a touch watch (the 5-image cap; the old Venu shot is in `old/`).

Known weakness: shot 2 reads `HR --` and `CAL 0`. The container simulator feeds no heart rate (the 2026-09 shots, from the host simulator, showed 143). It is what the build draws with no sensor reading; do not use this picture to claim a live heart rate. A host-simulator re-take (needs the owner's OK, `docker/SIMULATOR.md`) would give a number.

## How the screens were made

1. **Drive the app and photograph the whole simulator window** (display plus the device skin), one container run per device and state. The rep seed is patched into a private copy of the project (the repo is untouched); the clock is faked. From the repo root:

   ```sh
   docker/capture.sh HeroSet tools/drive_screens.sh fr965 btn store.jungle 60,45,30 23 glance all       # 1 (1-dashboard), 2 (3-counting), 3 (5b-up)
   docker/capture.sh HeroSet tools/drive_screens.sh fr965 btn store.jungle 100,100,100 23 glance home    # 4 (1-dashboard)
   docker/capture.sh HeroSet tools/drive_screens.sh instincte45mm btn store.jungle 60,45,30 23 glance home   # 5 (1-dashboard)
   ```

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

- `hero-1440x720.png`: logo mark, name, the promise line, and screens 1, 2 and 5 (the straps are faded out where the square cut them). No price, no accuracy claim.
- `cover-500-designed.png`: shield and name only (it shows at about 100 px in browse).
- `icon-24-128.png` and `icon-64-128.png`: the launcher icon's shield on black, 128x128; the 64-colour one is the 24-bit render snapped to Garmin's 64-colour palette (channels 00/55/AA/FF) by `src/quantize64.py`. The shield is the current pixel-grid launcher shape (`resources/drawables/launcher_icon.svg`), cropped to its bounds.

## Limits checked (2026-10-04)

`stat` on the files, each under Garmin's cap: screens 89 to 113 KB (cap 150), cover 72 KB (cap 300), hero 360 KB (cap 2048); icons 1 and 2 KB; all pixel sizes read from the files (`file`, `identify`): 720x720 x5, 500x500, 1440x720, 128x128 x2. `frame_all.sh` also fails loudly on a screen over 150 KB.

## Honesty rules

Real captures of the store build, never mock-ups; the display pixels are only resized (Instinct) with the skin; the background is the only thing removed. Simulator data is canned (the seeded reps, the clock, no heart rate). No price number in any image. Nothing in an image claims accuracy, a wrist test, the Instinct 2 family, or a glance. The Instinct image shows one Instinct E 45 mm in the simulator: the Instinct claim waits for the store's device list ([`../docs/release-contract.md`](../docs/release-contract.md)).
