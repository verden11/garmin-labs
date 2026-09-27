# Two Suns screenshots

**None exist yet.** The environment that wrote the listing cannot capture the Connect IQ simulator (`Dc.getPixel` does not exist in SDK 9.2, and the simulator window is not scriptable here), and no watch has run the face. **The owner captures them.** Do not use the site's SVG drawing (`site/src/apps/two-suns/FacePreview.tsx`) as a store image: it is a schematic with example numbers, not the face.

Nothing below is a claim about how the face looks; the look (colours, glyph, layout) is not yet approved by the owner. Capture after the owner has approved it.

## What to capture

Sizes as Days To Go's: the FR965 simulator at **454 × 454** (the store form takes one device, and under **150 KB per screen image**; upload in the order below), plus a **500 × 500 cover** (under 300 KB). One is enough to submit; the states below are what tells the story. Say "simulator capture" if asked; a wrist photo is not required.

| Order | File to make | State | Why it is worth a slot |
|---|---|---|---|
| 1 | `screens/1-day.png` | **Day**: a time mid-morning, sun up, ring with the marker solid, a Body Battery curve with the number, "H:MM of daylight" | The default, the picture of the whole idea |
| 2 | `screens/2-after-sunset.png` | **After sunset**: sun marker an outline, night ring, "Sunrise HH:MM" (tomorrow's) | Shows the ring and the sentence changing |
| 3 | `screens/3-no-place.png` | **No place yet**: plain ring, no marker, "No place yet" | Honest about the failure state, which is also the support question |
| 4 | `screens/4-stale.png` | **Stale battery**: newest reading over an hour old: grey curve, grey number, hollow dot | Shows that stale is a shape as well as a colour |

Optional if you have room: golden hour on (warm arc); the always-on screen (AMOLED, dim time, number and sun line); a small screen (218 or 240 px MIP) showing the dropped rows.

## How to get each state in the simulator

- Day and after sunset: the simulator clock (Simulation, Set Time) and its sunrise/sunset values; the sun times come from the Complication values in the simulator's data fields.
- No place yet: clear the saved place (a fresh simulator profile) with no location set in the simulator.
- Stale: set the Body Battery history so the newest sample is older than an hour, or stop the simulated history feed.

These recipes are untested suggestions (nobody has driven the simulator for this); the repository has test fixtures for the same states in `../source/test/TwoSunsTestStates.mc`.

## Files

| File | What it shows | Where it came from |
|---|---|---|
| (none) | | |

Cover: made from the day capture centred on black at 500 × 500, as Days To Go's: `sips --padToHeightWidth 500 500 --padColor 000000 screens/1-day.png --out cover-500.png`.

Not made: hero image (1440 × 720, optional), device icons (128 × 128, optional), all states above. Framed captures with a watch bezel are not used in the listing.
