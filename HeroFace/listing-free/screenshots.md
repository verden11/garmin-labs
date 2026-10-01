# Free listing: screenshots and store images

Status: 2026-10-01. **Nothing exists yet for the Free listing, and none is invented here.** Everything below is to be captured; all would be **simulator only** (the one wrist evidence, an FR965 photo set from 2026-09-20 onward, is of the paid face).

## Rules

- Capture from the **Free build** (`monkeyc -d fr965 -f monkey.free.jungle -o bin/HeroFaceFree.prg -y ~/.garmin-connectiq/keys/developer_key`, then `monkeydo`), so the shot cannot show a Pro-only thing: no seconds beside the time, no temperature under it.
- The Pro listing's `../listing/screens/` were taken from the single pre-split build with the temperature and (for some) seconds possibly drawn; **re-take** them from the Free build rather than reuse them. `3-heroset.png` and `4-heroset-complete.png` are FR965 System → Screenshot images of the paid face: check for a temperature before reusing.
- Under 150 KB each, up to the store's limit, one device is enough (454 px fr965 first). Cover 500×500 under 300 KB. Hero 1440×720 optional. The cover and the icon are the owner's call.
- Honest per tier: the Free screenshots must not hint at Pro features, and the Pro listing's must not hide that they are Pro.

## To capture (in this order)

1. fr965: everyday, part-filled bars, a streak.
2. fr965: all three goals met (green bars, check marks, green ring).
3. fr965: HeroSet mode (needs a linked HeroSet, or the screen-fit test's `heroSet` state).
4. fr245 (no barometer): the move-bar fallback, once.

## Source of truth for the pixels

The Pro listing's cover and hero are built from `../listing/src/` (HTML rendered with headless Chrome, `../listing/screenshots.md`). A Free cover would reuse that method with a Free screenshot, only after the owner approves the look.
