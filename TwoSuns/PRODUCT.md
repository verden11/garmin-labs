# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

Only web surface: Two Suns page in `../site` (not deployed yet). Product itself = native Garmin Connect IQ watch face (Monkey C). Watch UI follows [`docs/spec.md`](docs/spec.md), [`DESIGN.md`](DESIGN.md), not web conventions.

## Users

Garmin watch wearers already looking at sun and Body Battery, want both on face read all day: runners, hikers, photographers, people planning outdoor day by light left. Per research (desk, not measured) same buyers as HeroSet, HeroFace. Many tried sun face showing blank or wrong sunrise, compared to Garmin's own glance.

## The one question

How much light, how much energy left today? Face answers at glance: ring = light, curve + number = energy, time in middle.

## Product Purpose

Watch face relating sky's day to wearer's day on one dial. Time = hero. Sun numbers = Garmin's own (same as watch's Sunrise/Sunset glance), local time; own calculation only adds what Garmin does not give. Body Battery shown as Garmin reports it, number + curve, never interpreted. Every failure has sentence, never blank. Success = someone keeps it on wrist because sun times right, never shows empty field.

## Principles

- **Match Garmin's numbers.** Reviewers compare face with native glance. Take values from Complications, local time.
- **Never blank.** "No place yet", "No sun data", `--` say what is missing.
- **No verdicts on Body Battery.** No mood, no emoji, no advice, no good/bad colour, none of words good, low, rest, tired. Garmin's own page says "the occasional low-energy day is no cause for alarm"; face must not say otherwise.
- **State never colour alone.** Stale = hollow glyph + outline dot; sun marker solid or outline.
- **Nothing leaves watch.** Only stored thing = place rounded to 0.1 degree.
- **Value watch does not have: hidden or said in words, never faked.**
- **No claim without its check.** [`docs/release-contract.md`](docs/release-contract.md).

## Positioning

Not dashboard with sun slot + Body Battery slot: one face built around pair. Not "accurate Body Battery" or "the most accurate sun times" (forbidden claims); difference = correct numbers, no blanks, curve, finish. Not yet demonstrated on watch.

## Operating Context

- Glanced at arm's length, many times a day, daylight + dark; bright sun washes out dim tracks, so dimmest ring colour at least 3:1 against black (computed, not measured on screen).
- AMOLED watches use always-on with burn-in limits: time, Body Battery value, sun sentence only, dim. MIP watches show full face.
- No input on face. Configured via Garmin Connect / Connect IQ app settings; with all defaults works if that round trip fails.
- Face cannot start GPS. Sun times from Complications need no location; only tomorrow's sunrise, twilight, golden hour, polar days need remembered place.

## Capabilities and Constraints

- Connect IQ watch face, `minApiLevel` 4.2.0, one build, 69 products, no bitmaps. Permissions `SensorHistory`, `ComplicationSubscriber`, `Positioning` (provisional, [ADR-005](docs/decisions.md#adr-005-location-order-and-the-positioning-permission)).
- No network, no `Background`, `Communications` or `UserProfile`.
- Price: paid, $2.50 tier of Garmin's price points for Two Suns Pro (set in upload form with 1.1.0; [`docs/decisions.md`](docs/decisions.md) ADR-026 (price: $2.50 tier for every paid app), supersedes lowest tier of ADR-002); Two Suns (Free) free; no price number in listing or site text. No day-45 review (retired, ADR-020).
- Languages: English + 14 machine-drafted translations, not read by native speakers, not fit-tested.

## Non-goals (v1)

Moon phase, weather, heart rate, steps, seconds, notifications, multiple locations or time zones, city or coordinates setting, sunrise alarms, mood or emoji for Body Battery, predictions of Body Battery, sleep score or training readiness, complications publishing, `date`/`numeric` settings, on-watch settings screen, Instinct and tier B/C/D watches, any network.

## Brand Commitments

- Name: **Two Suns is working name**, not confirmed; runner-up Sun Battery ([ADR-010](docs/decisions.md#adr-010-name-and-slug)). Studio: Verden. Support contact: `hello@verden.watch`.
- "Body Battery" = Garmin's trademark. Never in name, icon, brand; listing uses only descriptively ("shows your watch's Body Battery"). No implied Garmin endorsement. No trademark search done.