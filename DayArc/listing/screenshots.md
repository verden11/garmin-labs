# DayArc — screenshots

Owner supplies. Status 2026-09-28: none captured yet. This environment has no display, so it cannot
capture the simulator (`screencapture` fails); capture with the simulator's own File → Save
Screenshot (454×454 on FR965, no bezel), as TwoSuns did (`../../TwoSuns/listing/screenshots.md`).
Never use the site's SVG drawing (`site/src/apps/day-arc/FacePreview.tsx`) or the Design-canvas
mockup as a store image: both are schematics, not the face (`release-contract.md`).


## Simulator captures, 2026-10-04 (native pixels, scripted)

`tools/listing_shots.sh` drives the simulator in the container (`../docker/capture.sh DayArc tools/listing_shots.sh simple`): the simulator's own clock is set (`faketime`), settings are the face's real defaults edited in a private copy, and each file is what the simulator's File > Save Screen Capture writes, so the pixel size is the device's own. Re-run after any layout change. Simulator values (weather, stress, heart rate, battery) are fake: do not crop them into a claim about real readings.

**Made:** `listing/screens/1-morning.png` (07:15), `2-midday.png` (13:15), `3-evening.png` (20:00), `4-night.png` (23:40), all fr965 and 24-hour (the simulator starts on 12-hour, and the face shows no AM/PM), plus `5-instinct-midday.png` and `6-instinct-evening.png` (Instinct E 45 mm, black and white, the arc is a gauge in the round window). The table below is the brief they were made from.

## Store set — FR965 simulator, in this order

Set the clock with Simulation → Set Time, and pick a time about halfway through each window so the
progress arc is visibly part-filled (arc = progress through the *current* window, ADR-013).

| # | State | Set time | What it must show |
|---|---|---|---|
| 1 | Morning, weather present | ~7:15 | Amber arc, feels-like temperature + weather icon, date under the clock |
| 2 | Midday, stress present | ~13:15 | Cyan arc, stress number + wave icon, gauge part-filled (mid value; no reading is "good" or "bad") |
| 3 | Evening, Body Battery present | ~20:00 | Rose arc, Body Battery number + battery icon, gauge |
| 4 | Night | ~23:40 | Time + date only: no arc, no icon (proves the restraint is deliberate) |

Optional 5th: any window with an empty state (e.g. morning with weather unavailable) — proves
"never blank", and the hero icon still shows.

## Not for the store, for the owner's look check (status.md gate 4)

One capture each of morning or midday on a **small round** device (approachs50) and a
**rectangular** one (venusq2) — the only way to see the arc/icon sizing there (no screenshot of the
built face exists yet). Keep them out of the listing.

## Rules

Screenshots <150 KB each (a 454×454 PNG often exceeds it — compress and re-check); cover 500×500
(<300 KB); hero 1440×720 (<2048 KB, optional). Simulator values are fake: don't crop them into a
claim about real readings. Composed cover/hero: same headless-Chrome pipeline as TwoSuns, once the
launcher icon/mark is approved.
