# Free listing: screenshots and store images

Status: 2026-10-01. **Nothing exists yet for the Free listing, and none is invented here.** Everything below is to be captured; all would be **simulator only** (no wrist photo exists for any Days To Go build).


## Simulator captures, 2026-10-04 (native pixels, scripted)

`tools/listing_shots.sh` drives the simulator in the container (`../docker/capture.sh DaysToGo tools/listing_shots.sh free`): the simulator's own clock is set (`faketime`), settings are the face's real defaults edited in a private copy, and each file is what the simulator's File > Save Screen Capture writes, so the pixel size is the device's own. Re-run after any layout change. Simulator values (weather, stress, heart rate, battery) are fake: do not crop them into a claim about real readings.

`listing-free/screens/`, in upload order (all from the Free build, so no Pro-only thing can appear):

| File | Device | State |
|---|---|---|
| `1-new-year.png` | fr965 | the default, New Year's Day: 89 days |
| `2-weeks.png` | fr965 | named event "70.3", counted in weeks and days |
| `3-today.png` | fr965 | the day itself: TODAY |
| `4-small-fr255s.png` | fr255s (218 px) | a small round screen (the fr55 is an 8-colour screen and would not show the palette) |
| `5-instinct2.png`, `6-instinct-e40.png` | instinct2, instincte40mm | the Instinct family: black and white, the ring is a gauge in the round window (176 and 166 px native; the store may want them scaled) |

Not yet made: a cover or hero from these (the owner approves the look first).

## Rules

- Capture from the **Free build** (`monkeyc -d fr965 -f monkey.free.jungle -o bin/DaysToGoFree.prg -y ~/.garmin-connectiq/keys/developer_key`, then `monkeydo`), so the shot cannot show a Pro-only thing: no bottom line (battery or steps), no `H:MM` hours state.
- `../listing/screens/1-countdown.png` (fr965 simulator, "97 DAYS") shows neither, so it is probably identical to what Free draws, but it was taken from the single pre-split build and was never re-captured from the Free one: re-take it rather than reuse it.
- Under 150 KB each, up to the store's limit, one device is enough (454 px fr965 first). Cover 500×500 under 300 KB. Hero 1440×720 optional. Visual identity of the cover and the icon is the owner's call; the launcher icon is still the mint-ring placeholder.
- Honest per tier: the Free screenshots must not hint at Pro features, and the Pro listing's must not hide that they are Pro.

## To capture (in this order)

1. fr965: the default (New Year's Day), the day count, ring, time, date line.
2. fr965: a named event in weeks and days (for example "70.3", 45 days, Count in: weeks).
3. fr965: the day itself (TODAY).
4. A small round screen (fr55) once, to show the face fits.

## Source of truth for the pixels

The Pro listing's hero is built from `../listing/src/hero.html` (wordmark, a round frame, one screenshot). A Free hero would reuse that method with a Free screenshot, only after the owner approves the look.
