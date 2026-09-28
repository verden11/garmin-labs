# DayArc — release contract

What either listing is allowed to claim, in the listing, the site, and anywhere else user-facing.
Every listing sentence gets checked against this file before it ships.

## May claim

- What each window shows, in plain descriptive terms: morning weather (feels-like temperature,
  high/low, chance of rain, UV when the device supports it), midday stress reading, evening Body
  Battery reading, night time and date. Pro: the additional per-window field grid, named plainly
  (steps, heart rate, floors, etc.), never as "insights" or "coaching."
- That content changes automatically through the day on a fixed schedule (5:00/9:30/17:00/23:00).
- That DayArc Pro is a separate, paid listing with more fields per window than DayArc.
- That numbers are shown in the device's own configured units.

## May never claim

- Medical or health advice, or that a reading is good/bad, "on track," or needs action ("go
  outside," "take a break," "reset your stress").
- A sleep coach, sleep recommendation, or anything framed as personalized guidance — the SDK
  exposes a backward-looking sleep score at most, and this face doesn't use it at all (v1 cut).
- That the calendar field distinguishes "no sync enabled" from "no upcoming event" — it can't; copy
  says only "No upcoming event."
- Accuracy or device reach wider than what real testing (fit sweep, not just compile) has confirmed.
- Data leaving the watch — it doesn't; no network, no `Communications`, no `Background`.
- That Body Battery or stress readings work identically across the whole product set — Garmin's own
  docs say stress isn't measured during physical activity, and pulse ox/VO2max/weekly distance have
  no documented per-device support list; DayArc's own copy for those fields is "--", not a claimed
  cause.
- "Free trial," "unlock," or any language implying Pro is Simple-plus-a-toggle — they are separate
  products, separate listings, separate app ids (ADR-003).

## Data and privacy

Nothing leaves the watch. No location is read (no `Positioning` permission, unlike TwoSuns — DayArc
has no sun-position feature). `ComplicationSubscriber` is the only permission, and it reads data the
watch already has (steps, Body Battery, calendar next-event, etc., as published by Garmin's own
system) — nothing is sent anywhere, nothing is stored beyond what a normal `onUpdate` redraw needs.
