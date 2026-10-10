# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

Only web surface: Days To Go page in `../site`. Product = native Garmin Connect IQ watch face (Monkey C). Watch UI follows [`docs/spec.md`](docs/spec.md), not web conventions.

## Users

Garmin watch wearers counting down to date: race, trip, birthday, holiday, exam, New Year. Glance many times/day, want number right. Many tried countdown face whose date would not save.

## Product Purpose

Watch face, one job: days until date, counted in whole calendar days. Count = largest thing on screen, time second, nothing else on by default. Works once installed (counts to New Year's Day); date set on phone or watch. Success = someone keeps it on wrist until the day.

## Positioning

Countdown-first, not dashboard with countdown slot. No permissions, nothing leaves watch. Not "the only countdown with no permissions" (large existing face also asks none); difference: setting date is the part built to work.

## Operating Context

- Glanced at arm's length, many times/day, daylight and dark.
- AMOLED watches use always-on with burn-in limits: hero and time only, dim. MIP watches show full face.
- No input on face itself. Configured via Garmin Connect / Connect IQ app settings or watch's own Customize screen.

## Capabilities and Constraints

- Connect IQ watch face, `minApiLevel` 3.0.0, one build per tier, 129 products (117 round, 5 rectangular, 7 Instinct), no bitmaps. Smallest memory budget 96 KB.
- No network, no permissions, no `Storage`.
- Price: paid, $2.50 tier of Garmin's price points for Days To Go Pro (set in upload form with 1.1.0; live at lowest tier until then; [ADR-017](docs/decisions.md#adr-017), price: the $2.50 tier for every paid app); Days To Go (Free) is free; no price number in listing or site text (day-45 flip review of [`docs/decisions.md`](docs/decisions.md) ADR-002 retired 2026-10-04 by Free + Pro ladder, ADR-014).
- Languages: English plus 14 machine-drafted translations, not yet read by native speakers.

## Brand Commitments

- Name: Days To Go. Studio: Verden. Support contact: `hello@verden.watch`.