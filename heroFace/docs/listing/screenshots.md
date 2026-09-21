# Screenshots and store images

Status: 2026-09-21. Everything below is captured and lives in `../../listing/`.
The always-on shot was **deferred to a post-launch listing update** (user call,
2026-09-21) — it needs a human at the simulator GUI, and the five screens here
satisfy the store requirement without it.

## What exists

`../../listing/screens/`, in upload order:

| File | Screen | Mode | State | Source |
|---|---|---|---|---|
| `1-everyday.png` | 240 px | Everyday | Part-filled: 3406 steps, 20 intensity minutes, 7 floors | `fenix5` simulator |
| `2-goals-met.png` | 240 px | Everyday | All three met: green bars, check marks, green ring, 1-day streak | simulator |
| `3-heroset.png` | 454 px | HeroSet | 20/45/10 reps, rank 2, orange ring | **FR965**, System → Screenshot |
| `4-heroset-complete.png` | 454 px | HeroSet | All three met, rank 2, streak 1 | **FR965** |
| `5-no-barometer.png` | 240 px | Everyday | STEPS / INT / **MOVE** — the fallback when the watch has no barometer | `fr245` simulator |

The composed images, all in `../../listing/`: `cover-500.png` (store cover),
`hero-1440x720.png`, `icon-24-128.png` and `icon-64-128.png` (optional device
icons). Sources are in `listing/src/`; re-render after re-taking any screen:

```sh
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
cd listing
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files \
  --virtual-time-budget=5000 --window-size=500,500 \
  --screenshot="$PWD/cover-500.png" "file://$PWD/src/cover.html"
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files \
  --virtual-time-budget=5000 --window-size=1440,720 \
  --screenshot="$PWD/hero-1440x720.png" "file://$PWD/src/hero.html"
"$CH" --headless=new --hide-scrollbars --allow-file-access-from-files \
  --virtual-time-budget=5000 --window-size=128,128 \
  --screenshot="$PWD/icon-24-128.png" "file://$PWD/src/icon.html"
python3 src/quantize64.py icon-24-128.png icon-64-128.png
```

## Still missing

**Always on.** Capture it on the FR965, not the simulator: the sleep render is
the one thing the simulator cannot vouch for, and it is what Garmin's burn-in
rules apply to (`../go-to-market.md` §1).

## Which source for which shot

Everyday mode has to come from the simulator and HeroSet mode from the watch,
because each is only real where it is captured:

- The simulator runs one app at a time, so HeroSet never publishes its
  complication there. `HeroFaceLink.progress` is gated on `_id != null`, which
  is only set when `find()` sees the live complication — a cached value in
  storage does not stand in for it. So the simulator always draws everyday
  mode, whatever it has stored.
- The watch has HeroSet installed and publishing, so it always draws HeroSet
  mode. FR965: System → Screenshot writes a true 454×454 file.

Set simulator state under Simulation → Activity Monitor and Simulation → Time,
then File → Save Screenshot.

```sh
monkeyc -d fr965 -f monkey.jungle -o bin/HeroFace.prg -y ~/.garmin-connectiq/keys/developer_key
monkeydo bin/HeroFace.prg fr965
```

## Where they go

- **Store:** upload in the submission form, in the numbered order above.
- **Website:** copied to `../../../verden-site/public/heroface/screens/` as
  `everyday.png`, `goals-met.png`, `heroset.png`, and wired into
  `../../../verden-site/src/apps/heroface/facts.ts`. The `Always on` slot there
  still renders a "Screenshot pending" placeholder.

## Honesty rules

- Capture the real face, never a mock-up.
- The numbers on screen must be ones the watch could actually produce.
- No claim in the image that the listing itself could not make
  (`../go-to-market.md`).
