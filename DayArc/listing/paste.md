# DayArc — store listing (paste)

Paste blocks only, in the order of the upload form (https://apps.garmin.com/developer/upload; two steps: attach the `.iq`, then the details). One block = one field: copy the block, paste it. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml); why each answer is what it is, and history, in [`NOTES.md`](NOTES.md).

**Do not paste a block marked OWNER until it is decided** (see [`NOTES.md`](NOTES.md)). **Do not paste a block while a `<` placeholder remains in it** (store URLs are owner-supplied). Claims are checked against [`../docs/release-contract.md`](../docs/release-contract.md).

## Title (max 50)

```text
DayArc
```

## Description (max 4000, one box per language)

**OWNER, before pasting:** the store URLs are placeholders (line 1 needs DayArc Pro live; keep only the free faces that are live under "More from Verden"), and "chosen in the Garmin Connect app" is unverified until a store install. Details: [`NOTES.md`](NOTES.md).

```text
Get DayArc Pro: <DAYARC PRO STORE URL: owner fills in once the Pro listing is live>

DayArc changes what it shows through the day, on a fixed schedule. One setting: an accent colour,
chosen in the Garmin Connect app — or leave it on Auto, where each time of day has its own colour.

Morning: feels-like temperature, the day's high and low, and chance of rain — what to dress for.
Midday: a stress reading, shown as a number and a plain gauge, never a mood or a verdict.
Evening: your Body Battery reading, the same way — a number, never good or bad.
Night: time and date — which every window shows in its header.

DayArc shows one reading at a time, on purpose. Looking for more fields per window? DayArc Pro is a
separate, paid listing with a denser view of the same four windows.

If this face works for you, a rating in the store helps other people find it.

DayArc reads data your watch already has. Nothing is sent anywhere, no location, no network.

More from Verden
Days To Go: <DAYS TO GO STORE URL, once live>
Two Suns: <TWO SUNS STORE URL, once live>
HeroFace: <HEROFACE STORE URL, once live>

Support and answers: https://verden.watch/day-arc/support/
```

## Version

```text
1.0.0
```

## What's new

Blank — initial release.

## Hero Image (optional, 1440×720, under 2048 KB)

**OWNER, look approval first** (proposal: the arc mark, three windows, no price, no claim beyond what each window shows).

[`hero-1440x720.png`](hero-1440x720.png)

## Category

**Utility** (alternative: Health & Fitness — same choice TwoSuns made, ADR-012 doesn't touch this).

## Does your app collect user data?

**No.** Nothing leaves the watch: no network code, no `Communications` permission, no location
(DayArc reads no location at all — simpler than TwoSuns here).

## Cover Image (500×500, under 300 KB)

**OWNER, look approval first** (the arc mark and the name; the proposal that tells this listing from DayArc Pro is that Pro carries a white PRO tag).

[`cover-500.png`](cover-500.png)

## Screen Images (under 150 KB each, upload in this order)

At most 5; the night window is left out on purpose. All five are the simulator's own captures at native pixels with a 24-hour clock; the values (weather, stress, Body Battery) are the simulator's canned ones, not readings. Captions are notes for the owner, not form fields (how each was made: [`screenshots.md`](screenshots.md)).

1. [`screens/1-morning.png`](screens/1-morning.png): Morning, weather (feels-like, high/low, rain, UV). FR965, 454 px.
2. [`screens/2-midday.png`](screens/2-midday.png): Midday, a stress reading as a number and a plain gauge. FR965, 454 px.
3. [`screens/3-evening.png`](screens/3-evening.png): Evening, the Body Battery reading the same way. FR965, 454 px.
4. [`screens/4-accent-purple.png`](screens/4-accent-purple.png): The one setting, the accent colour (here purple at midday). FR965, 454 px.
5. [`screens/5-instinct-evening.png`](screens/5-instinct-evening.png): **The Instinct one**: black and white, the arc a gauge in the round window. Instinct E 40 mm, 166 px.

Do not add the word Instinct to the description for this: the device wording waits for the store's real device list ([`meta.yaml`](meta.yaml) `held_back_text`).

## Device icons (optional, 128×128)

**OWNER, look approval first.**

- 64 Color: [`icon-64-128.png`](icon-64-128.png)
- 24 bit: [`icon-24-128.png`](icon-24-128.png)

## Monetization

```text
Free
```

## iOS / Android Companion App URL / Additional Hardware Requirements (optional)

Paste the **bare URL only**, nothing else: the store's API names this field `hardwareProductUrl`, and a live listing's value is a bare URL (owner, 2026-10-02: used as the link to the website; Garmin research 2026-10-04, [`reports/Garmin policies and design guidelines.md`](../../reports/Garmin%20policies%20and%20design%20guidelines.md)). Paste:

```text
https://verden.watch/day-arc/
```

## Email Address (shown publicly)

```text
hello@verden.watch
```
