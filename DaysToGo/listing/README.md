# Days To Go — store listing (paste-ready)

Status: 2026-09-26. **1.0.1 submitted** on top of 1.0.0, pending review. Gates before submitting are in [`NOTES.md`](NOTES.md) ("Before you submit") and [`../docs/publish-checklist.md`](../docs/publish-checklist.md).

Fields are in the order of the upload form (https://apps.garmin.com/developer/upload; two steps: attach the `.iq`, then the details). One block = one field: copy the block, paste it. Nothing else is in this file; limits, why each answer is what it is, and history are in [`NOTES.md`](NOTES.md).

## App file

`../dist/DaysToGo.iq` for 1.0.1, exported 2026-09-26 (`monkeyc -e -r -f monkey.jungle -o dist/DaysToGo.iq -y ~/.garmin-connectiq/keys/developer_key`). The form reads Manifest AppID, App Type (Watch Face) and Compatible Devices from the package.

## Title (max 50)

```text
Days To Go
```

## Description (max 4000, one box per language)

Languages are added one at a time: pick a language, press **Add**, fill Title + Description. Only English is drafted; see [`NOTES.md`](NOTES.md).

```text
A countdown watch face: one big number for the days left until your date.

One number
The days left is the biggest thing on the screen, in the largest size your watch can draw. The time sits above it and the date below. A thin ring around the bezel drains through the last year and fills on the day itself. Nothing else is on by default: no steps, no heart rate, no weather.

Set the date from plain lists
Choose the month, day and year from three simple lists in Garmin Connect or the Connect IQ app. First set Event to My own date. Nothing set up yet? It counts to the next New Year's Day, so it is never empty. Choose "Every year" for birthdays and anniversaries and it rolls over by itself.

Count what you need
Days, or weeks and days. An optional event time turns the last 24 hours into hours and minutes. Give the event a name (up to 16 characters). Choose day-first or month-first order for the date. Pick one of six accent colours. Optionally show battery or steps on a bottom line.

Whole calendar days
The count is whole days on your calendar: tomorrow is 1 day, the day itself says TODAY, and afterwards it counts the days since. A date that does not exist, like 30 February, asks you to set a date instead of showing a wrong number.

One design, many screens
It measures itself to your screen. On AMOLED watches the always-on screen dims to a quiet number and clock that shifts position every minute; other watches keep the full face. See Compatible Devices for your model.

Nothing leaves your watch
No permissions, no account, no internet, no analytics, no ads.

Support and answers: https://verden.watch/days-to-go/support/
```

## Version

The form reads it from the package; if a field asks, type:

```text
1.0.1
```

## What's new

```text
Long event names on small screens now end in "..." instead of being cut off without a marker.
```

## Keywords / tags (only if the form asks; trim from the end if it caps the count)

```text
watch face, countdown, days left, days until, event, birthday, holiday, weeks, minimal, always-on
```

## Hero Image (optional, 1440×720, under 2048 KB)

Not made; leave blank.

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

[`cover-500.png`](cover-500.png) (the screenshot centred on black; replace with a designed cover if you make one)

## Screen Images (under 150 KB each, upload in this order)

1. [`screens/1-countdown.png`](screens/1-countdown.png) (FR965 simulator, 97 DAYS)

One device is enough. More states (a named event in weeks, the last day in hours, TODAY) would help; capture and add them in order after this one.

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

**No**

## iOS / Android Companion App URL / Additional Hardware Requirements (optional)

Leave blank.
