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

**No** (same wording reading as Days To Go: Yes only if the app asks for payment to enable features, or for tips or donations; it does neither). Paid through the store; the price tier is the owner's call (documented USD 1.99, the store showed $2.25 on 2026-10-01, ROADMAP 2.5; [`NOTES.md`](NOTES.md)).

## iOS / Android Companion App URL / Additional Hardware Requirements (optional)

Use it as a link to the website: many Connect IQ apps do (owner, 2026-10-02), the field is optional free text, and
the page has the support and privacy pages and the other apps. Garmin does not document this use, so keep the text true
(it states that no extra hardware is needed). Paste:

```text
No additional hardware needed. Help, privacy and more apps: https://verden.watch/two-suns/
```
