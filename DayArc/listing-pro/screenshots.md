# DayArc Pro — screenshots

Owner supplies. Status 2026-09-28: none captured yet. Same capture route and rules as
`../listing/screenshots.md` (simulator File → Save Screenshot on FR965, 454×454; no mockups or SVG
drawings as store images).


## Simulator captures, 2026-10-04 (native pixels, scripted)

`tools/listing_shots.sh` drives the simulator in the container (`../docker/capture.sh DayArc tools/listing_shots.sh pro`): the simulator's own clock is set (`faketime`), settings are the face's real defaults edited in a private copy, and each file is what the simulator's File > Save Screen Capture writes, so the pixel size is the device's own. Re-run after any layout change. Simulator values (weather, stress, heart rate, battery) are fake: do not crop them into a claim about real readings.

**Made:** `listing-pro/screens/1-midday.png` (13:15, calendar event and the full grid), `2-evening.png` (20:00), `3-morning.png` (07:15, 842 steps so far: a four-digit count is cut to "8..." in the narrow bottom pill), `4-night.png`, plus `5-instinct-midday.png` and `6-instinct-evening.png` (Instinct E 45 mm). The brief below is what they were made from.

## Store set — FR965 simulator, in this order

Pro's pitch is density under an unchanged hero, so lead with the full grids. Set the time about
halfway through each window.

| # | State | Set time | What it must show |
|---|---|---|---|
| 1 | Midday, calendar event present, full grid | ~13:15 | The Pro-exclusive next-event cell, most grid icons, arc, date, divider under the hero |
| 2 | Evening, full grid | ~20:00 | Body Battery hero, recovery/respiration/pulse ox/VO2max labelled cells, icon-only HR/steps/calories |
| 3 | Morning, full grid | ~7:15 | Weather hero plus sunrise/sunset, battery, HR, steps, floors, notifications |
| 4 | Night | ~23:40 | Identical to DayArc's — shows it is not a missing feature |

Confirm before capturing that the grid shows 3+ rows on FR965 (rows now size per row and drop from
the bottom; the last narrow row may not draw — `DayArcGrid`).

## Not for the store, for the owner's look check (publish-checklist gate 4)

Midday on **approachs50** (smallest round; expect fewer rows — proves the grid degrades by row
count, not overlap) and on **venusq2** (rectangular). Keep them out of the listing.

## Rules

Screenshots <150 KB each; cover 500×500 (<300 KB); hero 1440×720 (<2048 KB, optional). Simulator
values are fake. Don't put a personal calendar title in shot 1 — use the simulator's own event text.
