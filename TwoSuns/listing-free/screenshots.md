# Free listing: screenshots and store images

Status: 2026-10-01. **Nothing exists yet for the Free listing, and none is invented here.** Everything below is to be captured; all would be **simulator only** (no wrist photo of any Free build exists).

## Rules

- Capture from the **Free build** (`monkeyc -d fr965 -f monkey.free.jungle -o bin/TwoSunsFree.prg -y ~/.garmin-connectiq/keys/developer_key`, then `monkeydo bin/TwoSunsFree.prg fr965`), so a shot cannot show a Pro-only thing: no energy curve, no date row, no twilight arc, no golden-hour arc.
- `../listing/screens/1-face.png` and `2-sleep.png` (owner's FR965 simulator, 2026-09-27) come from the single pre-split build and show the curve and the date: they are Pro's, not Free's. Do not reuse them; the always-on frame is the same in both tiers by construction but must be re-captured from the Free build.
- Under 150 KB each, one device is enough (454 px fr965 first). Cover 500×500 under 300 KB. Hero 1440×720 optional. The look is not approved by the owner and the Free layout (rows re-stacked without the curve and the date) has never been looked at by eye; the launcher icon is still the placeholder. The environment cannot capture the simulator: the owner supplies the images (the simulator's own "Save Screenshot", native size, no chrome).
- Honest per tier: the Free screenshots must not hint at Pro features, and the Pro listing's must not hide that they are Pro.

## To capture (in this order)

1. fr965: awake, daytime: the ring (daylight to come and gone, ticks, solid sun marker), the time, the level pill with a number, "N:NN of daylight".
2. fr965: after sunset ("Sunrise ~06:41", outline marker, night ring).
3. fr965: no Body Battery number (`--` and a hollow pill), the honest empty state of ADR-021 (Body Battery in Free).
4. fr965: another accent (Customize, Accent colour).
5. fr965: always-on.
6. A small round screen (fr255s, 218 px MIP) once, to show the face fits.

How, in the simulator: Simulation → Set Time for day and after sunset (sun times are the simulator's canned Complication values); the Body Battery Complication value can be set or cleared in the simulator's data fields.
