# Screenshots and store images

Status: 2026-09-27.

## What exists

`listing/screens/`:

| File | Screen | Mode | State | Source |
|---|---|---|---|---|
| `1-countdown.png` | 454 px | Face | "97 DAYS", Fri Jan 1 2027 | `fr965` simulator |

`listing/cover-500.png`: already uploaded as part of the 1.0.1 submission
(pending review) — a direct face render, not the wordmark treatment below.
**Not touched here**: DaysToGo is mid-review; changing a live listing image
is unverified against Garmin's own docs as safe mid-review, so this stays
as-is until the owner says otherwise (see `NOTES.md` "Images").

`listing/hero-1440x720.png`: **new draft, 2026-09-27, not uploaded.**
Wordmark + gradient + the existing `1-countdown.png` in a round frame,
matching HeroSet/HeroFace's own hero style (studio family consistency).
Source `src/hero.html`. Re-render after re-taking the screen:

```sh
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
cd listing
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files \
  --virtual-time-budget=5000 --window-size=1440,720 \
  --screenshot="$PWD/hero-1440x720.png" "file://$PWD/src/hero.html"
```


## Simulator captures, 2026-10-04 (native pixels, scripted)

`tools/listing_shots.sh` drives the simulator in the container (`../docker/capture.sh DaysToGo tools/listing_shots.sh pro`): the simulator's own clock is set (`faketime`), settings are the face's real defaults edited in a private copy, and each file is what the simulator's File > Save Screen Capture writes, so the pixel size is the device's own. Re-run after any layout change. Simulator values (weather, stress, heart rate, battery) are fake: do not crop them into a claim about real readings.

`listing/screens/`, new files beside `1-countdown.png` (which predates the Free/Pro split): `1-new-year.png`, `2-weeks.png`, `3-today.png`, `4-small-fr255s.png`, `5-instinct2.png`, `6-instinct-e40.png`, and the Pro-only `7-hours-battery.png` (a timed event counts the last 24 hours as H:MM, with the battery bottom line) and `8-steps-line.png` (the steps bottom line). The bottom line has no event name beside it: on the fr965 a name, the date and the bottom line together leave the hero too little room, so the face drops the bottom line first.

## Still missing

A cover redo in the wordmark style (optional — the existing one already
works and is live/pending review, not worth the mid-review risk to redo);
more screen states (named event in weeks, last day in hours, TODAY); a real
launcher icon (current is a generic mint-ring placeholder).
