# Two Suns — store listing (paste-ready)

Status: 2026-09-27. **Text finalised; not submitted.** Every field is decided except images (owner supplies later: launcher icon, cover, screenshots — see [`NOTES.md`](NOTES.md) items 4–5). Two device checks have run on the owner's FR965 (sunrise/sunset match, Positioning); the rest of the build is still simulator-only.

Fields are in the order of the upload form (https://apps.garmin.com/developer/upload; two steps: attach the `.iq`, then the details). One block = one field: copy the block, paste it. Nothing else is in this file; limits, why each answer is what it is, and history are in [`NOTES.md`](NOTES.md).

## App file

Not exported yet. Export after the on-watch checks and the owner's sign-off: `monkeyc -e -r -f monkey.jungle -o dist/TwoSuns.iq -y ~/.garmin-connectiq/keys/developer_key` (run in `TwoSuns/`). The form reads Manifest AppID, App Type (Watch Face) and Compatible Devices from the package. Read the device list it shows before submitting ("Open item" in [`NOTES.md`](NOTES.md)).

## Title (max 50)

```text
Two Suns
```

## Description (max 4000, one box per language)

Languages are added one at a time: pick a language, press **Add**, fill Title + Description. Only English is drafted; see [`NOTES.md`](NOTES.md).

```text
A watch face for the sun's day and your Body Battery: the time, a 24-hour ring for the light, and a curve of your last 24 hours.

The time
The largest thing on the screen. No steps, no heart rate, no weather, no advice.

A ring for the sun
A thin ring around the bezel is the 24 hours of your day, noon or midnight at the top. Night is dim, twilight lighter, daylight lit in your accent colour and dimmer once it has passed. Ticks mark sunrise and sunset; a marker sits where the sun is now, solid while it is up. An optional warm arc marks the golden hour.

Your Body Battery, as a curve
The last 24 hours of your Garmin Body Battery under the time, with the current point and its number. Garmin's own estimate, shown as Garmin reports it, no advice attached. A reading over an hour old turns grey with a hollow dot.

One line for the sun
How much daylight is left, or when the sun returns — from your watch's own sunrise and sunset, and, where it has a place, a calculation for what those don't give: tomorrow's sunrise, twilight, the golden hour.

Five settings
Accent colour, ring orientation, golden hour, the energy curve, the date — plain lists, changeable in Garmin Connect or right on the watch (Customize, next to Apply), defaults work if you never touch them.

One face, every screen
Fits round and rectangular watches alike, full detail down to the smallest, and dims to a quiet time, number and sun line when the screen sleeps.

Your place stays on your watch
The face reads your last known location (rounded to about 11 km), your recent Body Battery, and the watch's own sun data — nothing leaves the watch. No internet, no account, no analytics, no ads.

Support and answers: https://verden.watch/two-suns/support/
```

## Version

The form reads it from the package; if a field asks, type:

```text
1.0.1
```

## What's new

```text
Small refinement to the Body Battery level indicator.
```

## Hero Image (optional, 1440×720, under 2048 KB)

[`hero-1440x720.png`](hero-1440x720.png) — 258 KB. Still a draft: the ring-arc/sun mark and wordmark haven't had an owner sign-off pass (same status as the launcher icon placeholder).

## Category

**Utility** (alternative: Health & Fitness)

## Subcategory

Whatever the Category choice offers.

## Does your app collect user data?

**No** (owner, confirmed 2026-09-27). Nothing leaves the watch: no network code, no Communications permission. The face reads a location on the watch and keeps a rounded place there, never sent — see [`NOTES.md`](NOTES.md) ("Collects user data") for the reasoning. The privacy-policy URL field is conditional on Yes, so it may not appear; the policy is https://verden.watch/two-suns/privacy/ regardless.

## Does your app decode/encode any ANT+ profiles?

**No**

## Does your app have regional limits?

**No**

## Cover Image (500×500, under 300 KB)

[`cover-500.png`](cover-500.png) — 81 KB. Same draft-mark status as the hero above.

## Screen Images (under 150 KB each, upload in this order)

Two real device screens from the owner's FR965 simulator run (2026-09-27, native 454×454, no simulator chrome):

1. [`screens/1-face.png`](screens/1-face.png) — 18 KB, awake state
2. [`screens/2-sleep.png`](screens/2-sleep.png) — 6 KB, always-on/AOD state

More states (a different accent, a different sky state) would help but these two are real and store-legal as-is.

## Device icons (optional, 128×128)

Not made; leave blank.

## Preview Video (optional)

None (YouTube/Vimeo only).

## Email Address (shown publicly)

```text
hello@verden.watch
```

## Source Code URL (optional)

Leave blank.

## Review Notification

**Yes**

## App Migration (add newly compatible devices)

**No**

## Monetization

**No** (same wording reading as Days To Go: Yes only if the app asks for payment to enable features, or for tips or donations; it does neither). Paid through the store, USD 1.99, confirmed ([`NOTES.md`](NOTES.md)).

## iOS / Android Companion App URL / Additional Hardware Requirements (optional)

Leave blank.
