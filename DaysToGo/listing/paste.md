# Days To Go — store listing (paste)

Paste blocks only, in the order of the upload form (https://apps.garmin.com/developer/upload; two steps: attach the `.iq`, then the details). One block = one field: copy the block, paste it. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml); why each answer is what it is, and history, in [`NOTES.md`](NOTES.md).

**Do not paste a block while a `<` placeholder remains in it** (the sibling store URL is owner-supplied). **This file is the 1.1.0 text** (the Pro rename); the submitted 1.0.1 What's New is in [`NOTES.md`](NOTES.md). This listing never uses the word "free" (it is paid; release contract, store review guideline 4d).

## Title (max 50)

**OWNER decides** the name (the plan's proposal below, which keeps search words; "Days To Go Pro" alone is the short alternative):

```text
Days To Go Pro: Countdown, Hours, Footer
```

## Description (max 4000, one box per language)

Languages are added one at a time: pick a language, press **Add**, fill Title + Description. Only English is drafted; see [`NOTES.md`](NOTES.md). Line 1 is the sibling's store URL (the Days To Go listing); replace the placeholder with the real URL once it is live.

```text
Also available: Days To Go (<DAYS TO GO STORE URL: owner fills in once that listing is live>)

A countdown watch face: one big number for the days left until your date.

One number
The days left is the biggest thing on the screen, at the largest size your watch can draw. The time above it, the date below. A thin ring around the bezel drains through the last year and fills on the day itself. No steps, no heart rate, no weather.

Any date, your own event
A birthday, an anniversary, a race, a trip — any date, with your own name for it (up to 16 characters), a set of six accent colours, and a count in days or in weeks and days. New Year's Day by default, so it is never empty; "Every year" makes a birthday or anniversary roll over by itself. An event with a time turns its last 24 hours into hours and minutes, and an optional bottom line can show your battery or step count.

Whole calendar days
The count is whole days on your calendar: tomorrow is 1 day, the day itself says TODAY, and afterwards it counts the days since. A date that does not exist, like 30 February, is never shown as a wrong number.

One design, every screen
Round and rectangular watches alike, full detail down to the smallest, dimming to a quiet number and clock when the screen sleeps.

Nothing leaves your watch
No permissions, no account, no internet, no analytics, no ads.

Days To Go Pro is a paid app. Refunds follow the Connect IQ Store return window.

Support and answers: https://verden.watch/days-to-go/support/
```

## Version

The form reads it from the package; if a field asks, type:

```text
1.1.0
```

## What's new

```text
The app is now called Days To Go Pro on the watch. Nothing changes in how it works. Also available: Days To Go, with the core countdown.
```

## Hero Image (optional, 1440×720, under 2048 KB)

**OWNER approves the look first** (all store images below are proposals, rendered 2026-10-04 from the current Pro build; the hero shows the studio wordmark and three Pro screens, no price number, nothing about the other tier).

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

**OWNER approves the look.** [`cover-500.png`](cover-500.png): the studio mark (the launcher icon's ring and "1") and the name, with a small amber PRO badge that tells Pro from Free. The cover uploaded with 1.0.1 (a face render) is in [`old/`](old/).

## Screen Images (under 150 KB each, upload in this order, five at most)

Simulator captures of the Pro build, 2026-10-04 (canned clock, battery and steps; not real readings). Captions are for you, not form fields.

1. [`screens/1-hours-battery.png`](screens/1-hours-battery.png): Pro's headline, an event with a time: the last 24 hours as hours and minutes (7:51 HOURS), with the battery on the date row. FR965.
2. [`screens/2-weeks-steps.png`](screens/2-weeks-steps.png): weeks and days to a named event, with the step count on the date row. FR965.
3. [`screens/3-days-battery.png`](screens/3-days-battery.png): 161 days to a named event, battery on the date row, pink accent. FR965.
4. [`screens/4-rectangle.png`](screens/4-rectangle.png): the same face on a rectangular screen (Venu Sq 2), hours state, amber accent.
5. **Instinct family:** [`screens/5-instinct.png`](screens/5-instinct.png): black and white, the ring is a gauge in the round window, hours state. Instinct E 40 mm (Garmin's paid-app list has no Instinct 2 or Descent G1, so never name those in a Pro caption). The simulator image is 166 px; this file is it enlarged x3 without smoothing (the native one is `screens/native/`). Upload it only with the package that adds the Instinct products (1.1.0), and mention no watch name in the form text ([`NOTES.md`](NOTES.md), device-reach rule).

## Device icons (optional, 128×128)

**OWNER approves the look** (proposal: the same mark as Free plus the PRO badge; the real launcher icon is still the owner's, ROADMAP 3.3).

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

**No**

## iOS / Android Companion App URL / Additional Hardware Requirements (optional)

Paste the **bare URL only**, nothing else: the store's API names this field `hardwareProductUrl`, and a live listing's value is a bare URL (owner, 2026-10-02: used as the link to the website; Garmin research 2026-10-04, [`reports/Garmin policies and design guidelines.md`](../../reports/Garmin%20policies%20and%20design%20guidelines.md)). Paste:

```text
https://verden.watch/days-to-go/
```
