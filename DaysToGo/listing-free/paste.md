# Days To Go (Free) — store listing (paste)

Paste blocks only, in the order of the upload form (https://apps.garmin.com/developer/upload; two steps: attach the `.iq`, then the details). One block = one field: copy the block, paste it. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml); why each answer is what it is, and history, in [`NOTES.md`](NOTES.md).

**Do not paste a block while a `<` placeholder remains in it** (store URLs are owner-supplied). Check each block for a `<` before pasting.

## Title (max 50)

Plan's proposal, **owner decides** (and searches the store by eye for a collision first):

```text
Days To Go: Countdown to a Date
```

## Description (max 4000, one box per language)

English only until the owner decides on translations (see [`NOTES.md`](NOTES.md)). Line 1 is the sibling's store URL; replace the placeholder with the real Pro URL once Pro is live.

```text
Get Days To Go Pro: <PRO STORE URL: owner fills in once the Pro listing is live>

A countdown watch face: one big number for the days left until your date.

One number
The days left is the biggest thing on the screen, at the largest size your watch can draw. The time above it, the date below. A thin ring around the bezel drains through the last year and fills on the day itself. No steps, no heart rate, no weather.

Any date, your own event
A birthday, an anniversary, a race, a trip — any date, with your own name for it (up to 16 characters), a set of six accent colours, and a count in days or in weeks and days. New Year's Day by default, so it is never empty; "Every year" makes a birthday or anniversary roll over by itself.

Whole calendar days
The count is whole days on your calendar: tomorrow is 1 day, the day itself says TODAY, and afterwards it counts the days since. A date that does not exist, like 30 February, is never shown as a wrong number.

One design, every screen
Round and rectangular watches alike, full detail down to the smallest, dimming to a quiet number and clock when the screen sleeps.

Days To Go Pro adds
An event with a time of day: its last 24 hours turn into hours and minutes.
An optional bottom line that shows your battery or your step count.

If this face works for you, a rating in the store helps other people find it.

Nothing leaves your watch
No permissions, no account, no internet, no analytics, no ads.

Support and answers: https://verden.watch/days-to-go/support/
```

## Version

The form reads it from the package; if a field asks, type:

```text
1.0.0
```

## What's new

```text
First release of the free Days To Go: a big day count, your own date and name, six accent colours, days or weeks.
```

## Hero Image (optional, 1440×720, under 2048 KB)

**OWNER approves the look first** (all store images below are proposals, rendered 2026-10-04 from the current Free build; the hero shows three Free screens with three accent colours, no Pro-only thing, no price number).

[`hero-1440x720.png`](hero-1440x720.png)

## Category

**Utility** (alternative: Simple)

## Subcategory

Whatever the Category choice offers.

## Does your app collect user data?

**No.** The privacy-policy URL field is conditional on Yes, so it may not appear.

## Does your app decode/encode any ANT+ profiles?

**No**

## Does your app have regional limits?

**No**

## Cover Image (500×500, under 300 KB)

**OWNER approves the look.** [`cover-500.png`](cover-500.png): the studio mark (the launcher icon's ring and "1") and the name; the Pro cover is the same plus an amber PRO badge.

## Screen Images (under 150 KB each, upload in this order, five at most)

Simulator captures of the Free build, 2026-10-04 (canned clock; not real readings), so no Pro-only thing can appear. Captions are for you, not form fields.

1. [`screens/1-days-amber.png`](screens/1-days-amber.png): 161 days to a named event, amber accent. FR965.
2. [`screens/2-weeks-sky.png`](screens/2-weeks-sky.png): the same count in weeks and days (6 WEEKS + 3 DAYS), sky accent. FR965.
3. [`screens/3-today-pink.png`](screens/3-today-pink.png): the day itself (TODAY), pink accent, the ring full. FR965.
4. [`screens/4-rectangle.png`](screens/4-rectangle.png): the same face on a rectangular screen (Venu Sq 2), violet accent.
5. **Instinct family:** [`screens/5-instinct.png`](screens/5-instinct.png): black and white, the ring is a gauge in the round window. Instinct 2 (Free may show any Instinct). The simulator image is 176 px; this file is it enlarged x3 without smoothing (the native one is `screens/native/`). Upload it only with the package that adds the Instinct products (1.0.0), and mention no watch name in the form text ([`NOTES.md`](NOTES.md), device-reach rule).

## Device icons (optional, 128×128)

**OWNER approves the look** (proposal: the mark alone; Pro adds a PRO badge; the real launcher icon is still the owner's, ROADMAP 3.3).

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

**No**: the Free app asks for no payment and unlocks nothing. Read the form's own wording at submission (`../listing/NOTES.md` records that wording is easy to misread).

## iOS / Android Companion App URL / Additional Hardware Requirements (optional)

Paste the **bare URL only**, nothing else: the store's API names this field `hardwareProductUrl`, and a live listing's value is a bare URL (owner, 2026-10-02: used as the link to the website; Garmin research 2026-10-04, [`reports/Garmin policies and design guidelines.md`](../../reports/Garmin%20policies%20and%20design%20guidelines.md)). Paste:

```text
https://verden.watch/days-to-go/
```
