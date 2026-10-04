# Two Suns — store listing (paste)

Paste blocks only, in the order of the upload form (https://apps.garmin.com/developer/upload; two steps: attach the `.iq`, then the details). One block = one field: copy the block, paste it. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml); why each answer is what it is, and history, in [`NOTES.md`](NOTES.md).

**Do not paste a block while a `<` placeholder remains in it** (the sibling store URL is owner-supplied). **This file is the 1.1.0 text** (the Pro rename); the prepared 1.0.1 What's New is in [`NOTES.md`](NOTES.md). This listing never uses the word "free" (it is paid; release contract, store review guideline 4d).

## Title (max 50)

**OWNER decides** the name (placeholder; device or feature tokens may be added within 50 characters):

```text
Two Suns Pro
```

## Description (max 4000, one box per language)

Languages are added one at a time: pick a language, press **Add**, fill Title + Description. Only English is drafted; see [`NOTES.md`](NOTES.md). Line 1 is the sibling's store URL; replace the placeholder with the real URL once that listing is live.

```text
Also available: Two Suns, a lighter version: <TWO SUNS STORE URL: owner fills in once that listing is live>

A watch face for the sun's day and your Body Battery: the time, a 24-hour ring for the light, and a curve of your last 24 hours.

The time
The largest thing on the screen. No steps, no heart rate, no weather, no advice.

A ring for the sun
A thin ring around the bezel is the 24 hours of your day, noon or midnight at the top. Night is dim, twilight lighter, daylight lit in your accent colour and dimmer once it has passed. Ticks mark sunrise and sunset; a marker sits where the sun is now, solid while it is up. An optional warm arc marks the golden hour.

Your Body Battery, as a curve
The last 24 hours of your Garmin Body Battery under the time, with the current point and its number. Garmin's own estimate, shown as Garmin reports it, no advice attached. A reading over an hour old turns grey with a hollow dot.

One line for the sun
How much daylight is left, or when the sun returns — from your watch's own sunrise and sunset, and, where it has a place, a calculation for what those don't give: tomorrow's sunrise, twilight, the golden hour.

Settings
Accent colour, ring orientation, golden hour, the energy curve, the date — plain lists, changeable in Garmin Connect or right on the watch (Customize, next to Apply), defaults work if you never touch them.

One face, every screen
Fits round and rectangular watches alike. It dims to a quiet time, number and sun line when the screen sleeps.

Your place stays on your watch
The face reads your last known location (rounded to about 11 km), your recent Body Battery, and the watch's own sun data — nothing leaves the watch. No internet, no account, no analytics, no ads.

Two Suns Pro is a paid app. Refunds follow the Connect IQ Store return window.

Support and answers: https://verden.watch/two-suns/support/
```

## Version

The form reads it from the package; if a field asks, type:

```text
1.1.0
```

## What's new

```text
The app is now called Two Suns Pro on the watch. Nothing changes in how it works. A lighter Two Suns, with the sun ring and your Body Battery number, is also available.
```

## Hero Image (optional, 1440×720, under 2048 KB)

**OWNER approves the look first** (rendered 2026-10-04 from the current Pro build in the simulator; canned data, see [`screenshots.md`](screenshots.md)). [`hero-1440x720.png`](hero-1440x720.png), 249 KB. The earlier hero is in `old/`, superseded.

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

**OWNER approves the look first** (the "PRO" pill and the golden arcs are a proposal for telling this listing from its lighter sibling). [`cover-500.png`](cover-500.png), 79 KB. The earlier cover is in `old/`, superseded.

## Screen Images (under 150 KB each, upload in this order)

**OWNER approves the looks first.** Five images, all simulator only with canned data (sun times, curve and number are set for the picture, never a reading; the weather row and the watch battery row are switched off in them). Details and commands in [`screenshots.md`](screenshots.md).

1. [`screens/1-day.png`](screens/1-day.png), 19 KB, FR965: the day, with the date, the energy curve and the sun ring
2. [`screens/2-golden-hour.png`](screens/2-golden-hour.png), 19 KB, FR965: the golden-hour arcs (violet accent)
3. [`screens/3-evening.png`](screens/3-evening.png), 19 KB, FR965: after sunset, the next sunrise (mint accent)
4. [`screens/4-instinct-e45.png`](screens/4-instinct-e45.png), 1.5 KB, **Instinct E 45 mm (the Instinct-family shot, black and white, the ring as a dial in the round window)**
5. [`screens/5-small-fr255s.png`](screens/5-small-fr255s.png), 4.4 KB, FR255S: a small round screen (pink accent)

Caption each only if the form asks; do not describe the Instinct shot as a supported-device claim until the store lists those watches (`meta.yaml` `held_back_text`).

## Device icons (optional, 128×128)

**OWNER approves the look first.**

- 64 Color: [`icon-64-128.png`](icon-64-128.png)
- 24 bit: [`icon-24-128.png`](icon-24-128.png)

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

**No** (same wording reading as Days To Go: Yes only if the app asks for payment to enable features, or for tips or donations; it does neither). Paid through the store; the price tier is the $2.50 tier (owner, 2026-10-04, ADR-026 (price: the $2.50 tier for every paid app); set in the form with the 1.1.0 upload, replacing the $2.25 the store showed; [`NOTES.md`](NOTES.md)).

## iOS / Android Companion App URL / Additional Hardware Requirements (optional)

Paste the **bare URL only**, nothing else: the store's API names this field `hardwareProductUrl`, and a live listing's value is a bare URL (owner, 2026-10-02: used as the link to the website; Garmin research 2026-10-04, [`reports/Garmin policies and design guidelines.md`](../../reports/Garmin%20policies%20and%20design%20guidelines.md)). Paste:

```text
https://verden.watch/two-suns/
```
