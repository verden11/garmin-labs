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

## Still missing

A cover redo in the wordmark style (optional — the existing one already
works and is live/pending review, not worth the mid-review risk to redo);
more screen states (named event in weeks, last day in hours, TODAY); a real
launcher icon (current is a generic mint-ring placeholder).
