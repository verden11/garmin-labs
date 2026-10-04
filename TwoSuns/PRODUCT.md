# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

The only web surface is the Two Suns page in `../site` (not deployed yet). The product itself is a native Garmin Connect IQ watch face (Monkey C). Watch UI follows [`docs/spec.md`](docs/spec.md) and [`DESIGN.md`](DESIGN.md), not web conventions.

## Users

Garmin watch wearers who already look at the sun and at their Body Battery and want both on the face they read all day: people who run, hike, photograph or just plan an outdoor day by the light that is left. Per the research (desk, not measured) these are the same kind of buyers as HeroSet and HeroFace. Many have tried a sun face that showed a blank or a wrong sunrise and compared it to Garmin's own glance.

## The one question

How much light, and how much energy, do I have left today? The face answers it at a glance: the ring for the light, the curve and its number for the energy, the time in the middle.

## Product Purpose

A watch face that relates the sky's day to the wearer's day on one dial. The time is the hero. The sun numbers are Garmin's own (the same as the watch's Sunrise/Sunset glance), in local time; our own calculation only adds what Garmin does not give. Body Battery is shown as Garmin reports it, as a number and a curve, and never interpreted. Every failure has a sentence, never a blank. Success means someone keeps it on their wrist because the sun times are right and it never shows an empty field.

## Principles

- **Match Garmin's numbers.** Reviewers compare a face with the native glance. Take the values from Complications, in local time.
- **Never blank.** "No place yet", "No sun data", `--` say what is missing.
- **No verdicts on Body Battery.** No mood, no emoji, no advice, no good/bad colour, none of the words good, low, rest or tired. Garmin's own page says "the occasional low-energy day is no cause for alarm"; a face must not say otherwise.
- **State is never colour alone.** Stale is a hollow glyph and an outline dot; the sun's marker is solid or an outline.
- **Nothing leaves the watch.** The only stored thing is a place rounded to 0.1 degree.
- **A value the watch does not have is hidden or said in words, never faked.**
- **No claim without its check.** [`docs/release-contract.md`](docs/release-contract.md).

## Positioning

Not a dashboard with a sun slot and a Body Battery slot: one face built around the pair. It is not "accurate Body Battery" or "the most accurate sun times" (forbidden claims); the difference is correct numbers, no blanks, the curve and finish. Not yet demonstrated on a watch.

## Operating Context

- Glanced at arm's length, many times a day, in daylight and dark; bright sun washes out dim tracks, so the dimmest ring colour is at least 3:1 against black (computed, not measured on a screen).
- AMOLED watches use always-on with burn-in limits: time, Body Battery value and sun sentence only, dim. MIP watches show the full face.
- No input on the face. Configured through Garmin Connect / Connect IQ app settings; with all defaults it works if that round trip fails.
- The face cannot start GPS. Sun times from Complications need no location; only tomorrow's sunrise, twilight, golden hour and polar days need a remembered place.

## Capabilities and Constraints

- Connect IQ watch face, `minApiLevel` 4.2.0, one build, 69 products, no bitmaps. Permissions `SensorHistory`, `ComplicationSubscriber`, `Positioning` (provisional, [ADR-005](docs/decisions.md#adr-005-location-order-and-the-positioning-permission)).
- No network, no `Background`, `Communications` or `UserProfile`.
- Price: paid, the $2.50 tier of Garmin's price points for Two Suns Pro (set in the upload form with 1.1.0; [`docs/decisions.md`](docs/decisions.md) ADR-026, price: the $2.50 tier for every paid app, which supersedes the lowest tier of ADR-002); Two Suns (Free) is free; no price number in listing or site text. No day-45 review (retired, ADR-020).
- Languages: English plus 14 machine-drafted translations, not read by native speakers and not fit-tested.

## Non-goals (v1)

Moon phase, weather, heart rate, steps, seconds, notifications, multiple locations or time zones, a city or coordinates setting, sunrise alarms, mood or emoji for Body Battery, predictions of Body Battery, sleep score or training readiness, complications publishing, `date`/`numeric` settings, an on-watch settings screen, Instinct and tier B/C/D watches, any network.

## Brand Commitments

- Name: **Two Suns is a working name**, not confirmed; runner-up Sun Battery ([ADR-010](docs/decisions.md#adr-010-name-and-slug)). Studio: Verden. Support contact: `hello@verden.watch`.
- "Body Battery" is Garmin's trademark. It never appears in the name, icon or brand; the listing uses it only descriptively ("shows your watch's Body Battery"). No implied Garmin endorsement. No trademark search has been done.
