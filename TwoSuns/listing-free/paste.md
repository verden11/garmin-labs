# Two Suns (Free) — store listing (paste)

Paste blocks only, in the order of the upload form (https://apps.garmin.com/developer/upload; two steps: attach the `.iq`, then the details). One block = one field: copy the block, paste it. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml); why each answer is what it is, and history, in [`NOTES.md`](NOTES.md).

**Do not paste a block while a `<` placeholder remains in it** (store URLs and the price are owner-supplied). Check each block for a `<` before pasting.

## Title (max 50)

Plan placeholder, **owner decides** (and searches the store by eye for a collision first):

```text
Two Suns
```

## Description (max 4000, one box per language)

English only until the owner decides on translations (see [`NOTES.md`](NOTES.md)). Line 1 is the sibling's store URL; replace the placeholder with the real Pro URL once Pro is live.

```text
Looking for more? Get Two Suns Pro: <PRO STORE URL: owner fills in once the Pro listing is live>
Pro is sold only on watches Garmin lists for paid apps; this version can also be installed on some watches Pro cannot be bought for. (Owner: verify against the store form's device lists before pasting.)

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
Fits round and rectangular watches alike, and on the Instinct E and Instinct 3 Solar it is black and white with the ring as a small 24-hour dial in the round window. It dims to a quiet time, number and sun line when the screen sleeps.

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

Not made; leave blank. (`../listing/hero-1440x720.png` is the Pro draft: it shows the energy curve and must not be reused for Free.)

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

Not made for Free. **Owner's call** (visual identity). Do not reuse the Pro cover if it shows a curve.

## Screen Images (under 150 KB each, upload in this order)

None exist for Free (none invented). See [`screenshots.md`](screenshots.md) for what to capture, from the Free build in the simulator (`monkeydo bin/TwoSunsFree.prg fr965`, built with `monkey.free.jungle`). The two Pro screens in `../listing/screens/` show the curve and the date and are not Free's.

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

**No** (this is a new app, not an update)

## Monetization

**No**: the Free app asks for no payment and unlocks nothing. Read the form's own wording at submission.

## iOS / Android Companion App URL / Additional Hardware Requirements (optional)

Use it as a link to the website: many Connect IQ apps do (owner, 2026-10-02), the field is optional free text, and
the page has the support and privacy pages and the other apps. Garmin does not document this use, so keep the text true
(it states that no extra hardware is needed). Paste:

```text
No additional hardware needed. Help, privacy and more apps: https://verden.watch/two-suns/
```
