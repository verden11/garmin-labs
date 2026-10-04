# Two Suns (Free) — store listing (paste)

Paste blocks only, in the order of the upload form (https://apps.garmin.com/developer/upload; two steps: attach the `.iq`, then the details). One block = one field: copy the block, paste it. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml); why each answer is what it is, and history, in [`NOTES.md`](NOTES.md).

**Do not paste a block while a `<` placeholder remains in it** (store URLs are owner-supplied). Check each block for a `<` before pasting.

## Title (max 50)

Plan placeholder, **owner decides** (and searches the store by eye for a collision first):

```text
Two Suns
```

## Description (max 4000, one box per language)

English only until the owner decides on translations (see [`NOTES.md`](NOTES.md)). Line 1 is the sibling's store URL; replace the placeholder with the real Pro URL once Pro is live.

```text
Looking for more? Get Two Suns Pro: <PRO STORE URL: owner fills in once the Pro listing is live>

A watch face for the sun's day: the time, a 24-hour ring for the light, and your Body Battery number.

The time
The largest thing on the screen. No steps, no heart rate, no weather, no advice.

A ring for the sun
A thin ring around the bezel is the 24 hours of your day, noon at the top. Night is dim, daylight lit in your accent colour and dimmer once it has passed. Ticks mark sunrise and sunset; a marker sits where the sun is now, solid while it is up.

One line for the sun
How much daylight is left, or when the sun returns, from your watch's own sunrise and sunset.

Your Body Battery
Garmin's own number, shown as Garmin reports it, beside a small level bar. No advice attached. When the watch has no number, the face shows two dashes.

One setting
Accent colour, six to choose from, in Garmin Connect or right on the watch (Customize, next to Apply). The defaults work if you never touch it.

One face, every screen
Fits round and rectangular watches alike. It dims to a quiet time, number and sun line when the screen sleeps.

If this face works for you, a rating in the store helps other people find it.

Nothing leaves your watch
This free version reads only your watch's own sunrise, sunset and Body Battery numbers. No location, no account, no internet, no analytics, no ads. It stores no place and no history; the only thing it saves is your accent colour setting.

Support and answers: https://verden.watch/two-suns/support/
```

## Version

The form reads it from the package; if a field asks, type:

```text
1.0.0
```

## What's new

Blank, per this app's rule for an initial release ([`../listing/NOTES.md`](../listing/NOTES.md): the form has no "first release" field and the text reads as noise). If the owner prefers a line, a draft: `First release of the free Two Suns: the time, a 24-hour sun ring, your Body Battery number and an accent colour.`

## Hero Image (optional, 1440×720, under 2048 KB)

**OWNER approves the look first** (rendered 2026-10-04 from the Free build in the simulator; canned data, see [`screenshots.md`](screenshots.md)). [`hero-1440x720.png`](hero-1440x720.png), 242 KB. It shows no curve, no date and nothing from Pro.

## Category

**Utility** (alternative: Health & Fitness, as for Pro)

## Subcategory

Whatever the Category choice offers.

## Does your app collect user data?

**No.** Free reads no location and keeps no place; nothing leaves the watch. The privacy-policy URL field is conditional on Yes, so it may not appear.

## Does your app decode/encode any ANT+ profiles?

**No**

## Does your app have regional limits?

**No**

## Cover Image (500×500, under 300 KB)

**OWNER approves the look first.** [`cover-500.png`](cover-500.png), 78 KB: the plain ring, no golden arcs, no pill (Pro's cover has both).

## Screen Images (under 150 KB each, upload in this order)

**OWNER approves the looks first.** Five images from the Free build, simulator only with canned data (sun times and the Body Battery number are set for the picture, never a reading). Details and commands in [`screenshots.md`](screenshots.md).

1. [`screens/1-day.png`](screens/1-day.png), 16 KB, FR965: the day, the ring and Garmin's number
2. [`screens/2-evening.png`](screens/2-evening.png), 17 KB, FR965: after sunset (mint accent)
3. [`screens/3-accent-pink.png`](screens/3-accent-pink.png), 16 KB, FR965: another accent (the one setting)
4. [`screens/4-instinct-e45.png`](screens/4-instinct-e45.png), 1.2 KB, **Instinct E 45 mm (the Instinct-family shot, black and white, the ring as a dial in the round window)**
5. [`screens/5-small-fr255s.png`](screens/5-small-fr255s.png), 4 KB, FR255S: a small round screen (violet accent)

Do not describe the Instinct shot as a supported-device claim until the store lists those watches (`meta.yaml` `held_back_text`).

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

**No** (this is a new app, not an update)

## Monetization

**No**: the Free app asks for no payment and unlocks nothing. Read the form's own wording at submission.

## iOS / Android Companion App URL / Additional Hardware Requirements (optional)

Paste the **bare URL only**, nothing else: the store's API names this field `hardwareProductUrl`, and a live listing's value is a bare URL (owner, 2026-10-02: used as the link to the website; Garmin research 2026-10-04, [`reports/Garmin policies and design guidelines.md`](../../reports/Garmin%20policies%20and%20design%20guidelines.md)). Paste:

```text
https://verden.watch/two-suns/
```
