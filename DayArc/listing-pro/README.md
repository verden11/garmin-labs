# DayArc Pro — store listing (paste-ready)

Status: 2026-09-28. Not submitted; text drafted, not finalised. Fields marked **OWNER** are
undecided — see [`NOTES.md`](NOTES.md).

Fields are in the order of the upload form (https://apps.garmin.com/developer/upload). One block =
one field.

## App file

Export command: `docs/development.md` "Export" (`monkey.pro.jungle`). Read the device list the
package shows before submitting.

## Title (max 50)

```text
DayArc Pro
```

## Description (max 4000, one box per language)

```text
DayArc Pro changes what it shows through the day, on a fixed schedule — no settings, nothing to
configure.

The same four windows as DayArc, denser: morning adds sunrise/sunset, date, battery, resting heart
rate, steps, floors and notifications alongside the weather read; midday adds your next calendar
event, heart rate, intensity minutes, floors, steps, calories, notifications, current temperature,
weekly run distance and weekly bike distance alongside the stress read; evening adds recovery time,
respiration, heart rate, steps, calories, pulse ox and VO2max alongside Body Battery. Night stays
time and date only.

Every reading is shown as a number, never a mood or a verdict. Fields the watch can't provide show
as "--", not blank and not a guess.

This is the paid, data-rich listing — $1.99, fixed, no free tier. Looking for the simpler one
reading-per-window face instead? That's DayArc, a separate free listing.

DayArc Pro reads data your watch already has. Nothing is sent anywhere, no location, no network.
```

## Version

```text
1.0.0
```

## What's new

Blank — initial release.

## Category

**Utility** (alternative: Health & Fitness).

## Does your app collect user data?

**No.** Nothing leaves the watch: no network code, no `Communications` permission, no location.

## Monetization

```text
Paid — $1.99, one-time, no subscription, no flip-to-free (docs/decisions.md ADR-007).
```

## Email Address (shown publicly)

```text
hello@verden.watch
```
