# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

The only web surface is the Days To Go page in `../verden-site`. The product itself is a native Garmin Connect IQ watch face (Monkey C). Watch UI follows [`docs/spec.md`](docs/spec.md), not web conventions.

## Users

Garmin watch wearers counting down to a date: a race, a trip, a birthday, a holiday, an exam, New Year. They glance at it many times a day and want the number right. Many have tried a countdown face whose date would not save.

## Product Purpose

A watch face with one job: how many days until a date, and it is counted in whole calendar days. The count is the largest thing on the screen, the time is second, and nothing else is on by default. It works the moment it is installed (it counts to New Year's Day) and the date can be set on the phone or on the watch. Success means someone keeps it on their wrist until the day.

## Positioning

Countdown-first, not a dashboard with a countdown slot. No permissions, nothing leaves the watch. It is not "the only countdown with no permissions" (a large existing face also asks for none); the difference is that setting the date is the part built to work.

## Operating Context

- Glanced at arm's length, many times a day, in daylight and dark.
- AMOLED watches use always-on with burn-in limits: hero and time only, dim. MIP watches show the full face.
- No input on the face itself. Configured through Garmin Connect / Connect IQ app settings or the watch's own Customize screen.

## Capabilities and Constraints

- Connect IQ watch face, `minApiLevel` 3.0.0, one build, 120 products (117 round plus 3 rectangular AMOLED), no bitmaps. Smallest memory budget 96 KB.
- No network, no permissions, no `Storage`.
- Price: paid, lowest tier $1.99, with one review 45 days after approval ([`docs/decisions.md`](docs/decisions.md) ADR-002).
- Languages: English plus 14 machine-drafted translations, not yet read by native speakers.

## Brand Commitments

- Name: Days To Go. Studio: Verden. Support contact: `hello@verden.watch`.
