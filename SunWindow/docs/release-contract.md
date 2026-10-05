# Sun Window — release contract

What this app is allowed to claim, in the listing, the site, and anywhere
else user-facing. Every listing sentence gets checked against this file
before it ships. Wording rules: [ADR-005](decisions.md#adr-005-wording-rules-no-vitamin-d-anywhere).

## May claim

- It shows whether the sun is at or above 45 degrees right now: OPEN, CLOSED
  or NONE TODAY, plus today's opening and closing clock times in the full
  view. The 45 degrees is a display rule, never a biological fact.
- The sun's height is computed on the watch from the date, the time and a
  stored location.
- On a day when the watch's own weather reports a low UV index, OPEN shows
  as CLOSED. Say "the watch's weather", never "live" or "accurate".
- A glance in the watch's glance list, and an accent colour of the user's
  choice.
- Free, with no ads, no account and no network calls.
- Required line, once per listing and on the site: "For information only;
  not medical advice or a sun-safety tool."

## May never claim

- Medical or health advice, or that a reading or a state is good, bad, safe
  or enough. No dose, minutes, IU, burn time or vitamin D. **"Vitamin D"
  appears nowhere** (ADR-005, option A).
- "No location", or anything implying the app reads no location. It
  declares `Positioning`.
- Accuracy or device reach it hasn't verified. Never quote a watch count or
  name a watch model in listing text. Evidence is FR965-only; MIP and
  Instinct are simulator-only (ADR-013).
- Data leaving the watch.
- A device count wider than what real testing (fit sweep, not just
  compile) has confirmed.
- Pro, upgrades or a price (ADR-003).

## Data and privacy

- **Read:** the watch's position (`Position.getInfo()`, or one location
  request when none is stored), only while the full view is open. Also the
  watch's own current weather (`uvIndex`, and `cloudCover` only as a
  fallback), read on the watch with no cache.
- **Stored on the watch:** the place, rounded to 0.1 degree (about 11 km),
  as `[lat, lon]`. Also the accent colour id (a setting). Nothing else.
- **Sent:** nothing. No network calls, no phone companion, no analytics.
- Store answer "collect user data": **No** (owner, 2026-10-05, ADR-013).
