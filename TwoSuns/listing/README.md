# Two Suns — store listing (paste-ready)

Status: 2026-09-26. **Not submitted. Nothing here has been seen on a watch.** Remaining open answers below are owner decisions; each one is marked **OWNER** and explained in [`NOTES.md`](NOTES.md) ("Open owner decisions"). Do not paste a block marked OWNER until you have decided it.

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
Accent colour, ring orientation, golden hour, the energy curve, the date — plain lists in Garmin Connect, defaults work if you never touch them.

One face, every screen
Fits round and rectangular watches alike, full detail down to the smallest, and dims to a quiet time, number and sun line when the screen sleeps.

Your place stays on your watch
The face reads your last known location (rounded to about 11 km), your recent Body Battery, and the watch's own sun data — nothing leaves the watch. No internet, no account, no analytics, no ads.

Support and answers: https://verden.watch/two-suns/support/
```

## Version

The form reads it from the package; if a field asks, type:

```text
1.0.0
```

## What's new

Leave blank: this is the initial release, and the form has no field asking for "first release" text.

## Hero Image (optional, 1440×720, under 2048 KB)

Not made; leave blank.

## Category

**Utility** (alternative: Health & Fitness)

## Subcategory

Whatever the Category choice offers.

## Does your app collect user data?

**OWNER.** Draft answer: No. The face reads a location on the watch, keeps a rounded place on the watch and sends nothing; the Connect IQ review guidelines ask for consent before collecting location, so you decide the wording (see [`NOTES.md`](NOTES.md), "Collects user data"). The privacy-policy URL field is conditional on Yes, so it may not appear. The policy is https://verden.watch/two-suns/privacy/

## Does your app decode/encode any ANT+ profiles?

**No**

## Does your app have regional limits?

**No**

## Cover Image (500×500, under 300 KB)

Not made: needs a real capture. See [`screenshots.md`](screenshots.md).

## Screen Images (under 150 KB each, upload in this order)

None exist yet. The owner supplies them; the states, sizes and order are in [`screenshots.md`](screenshots.md).

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
