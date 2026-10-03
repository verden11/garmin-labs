# Days To Go (Free) — store listing (paste-ready draft)

Status: 2026-10-01. **DRAFT, UNRELEASED, nothing uploaded.** Proposed under ADR-014 (Free + Pro ladder, `../docs/decisions.md`); the owner has not signed off, and **names, titles, the Pro store URL and the price are the owner's decisions** (placeholders below are marked). Gates: [`../docs/publish-checklist.md`](../docs/publish-checklist.md) "Free + Pro pair". Why each answer and the open items: [`NOTES.md`](NOTES.md). The paid app's live listing is [`../listing/README.md`](../listing/README.md).

Fields are in the order of the upload form (https://apps.garmin.com/developer/upload; two steps: attach the `.iq`, then the details), the same order as the Pro listing. One block = one field: copy the block, paste it.

## App file

`../dist/DaysToGoFree.iq` (a **new** app: new app id `9fde2744-b0f4-4396-927d-e4c7d65bb119`), exported with `monkeyc -e -r -f monkey.free.jungle -o dist/DaysToGoFree.iq -y ~/.garmin-connectiq/keys/developer_key`. The form reads Manifest AppID, App Type (Watch Face) and Compatible Devices from the package.

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
Round and rectangular watches alike, full detail down to the smallest, dimming to a quiet number and clock when the screen sleeps. On Instinct, in black and white, the ring becomes a gauge in the round window.

Days To Go Pro adds
An event with a time of day: its last 24 hours turn into hours and minutes.
An optional bottom line that shows your battery or your step count.

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
First release of the free Days To Go: a big day count, your own date and name, six accent colours, days or weeks. Works on the Instinct family too, in black and white (the accent colour does not apply there).
```

## Hero Image (optional, 1440×720, under 2048 KB)

Not made; leave blank. (`../listing/hero-1440x720.png` is a Pro-era draft, never uploaded; do not reuse it for Free without the owner's look-approval.)

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

Not made for Free. **Owner's call** (visual identity). Take it from the Free build; do not reuse a Pro image that shows a bottom line or hours.

## Screen Images (under 150 KB each, upload in this order)

None exist for Free (none invented). See [`screenshots.md`](screenshots.md) for what to capture, from the Free build in the simulator (`monkeydo bin/<free>.prg fr965`, built with `monkey.free.jungle`).

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

**No**: the Free app asks for no payment and unlocks nothing. Read the form's own wording at submission (`../listing/NOTES.md` records that wording is easy to misread).

## iOS / Android Companion App URL / Additional Hardware Requirements (optional)

Use it as a link to the website: many Connect IQ apps do (owner, 2026-10-02), the field is optional free text, and
the page has the support and privacy pages and the other apps. Garmin does not document this use, so keep the text true
(it states that no extra hardware is needed). Paste:

```text
No additional hardware needed. Help, privacy and more apps: https://verden.watch/days-to-go/
```
