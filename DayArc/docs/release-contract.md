# DayArc — release contract

What either listing is allowed to claim, in the listing, the site, and anywhere else user-facing.
Every listing sentence gets checked against this file before it ships.

## May claim

- What each window shows, in plain descriptive terms: morning weather (feels-like temperature,
  high/low, chance of rain, UV when the device supports it), midday stress reading, evening Body
  Battery reading; the time and date in every window's header. Pro: an additional per-window field
  grid, named plainly (steps, heart rate, floors, etc.), never as "insights" or "coaching" — and
  never with a COUNT of fields: how many show depends on the watch's screen (about 4-6 on an FR965,
  about 2 on a Venu Sq 2), so say "as many as fit your watch's screen." Say "heart rate", never
  "resting heart rate" (the field is the watch's plain heart-rate reading).
- That content changes automatically through the day on a fixed schedule (5:00/9:30/17:00/23:00).
- That DayArc Pro is a separate, paid listing with more fields per window than DayArc.
- That numbers are shown in the device's own configured units.
- That there is one setting, **Accent colour** (a short list of colours, default Auto = each time of
  day has its own colour) (ADR-014). Both listings. "Changeable in the Garmin Connect app" is the
  intended store wording but is **unverified until a store install** — a sideloaded build cannot
  exercise the phone page (`docs/publish-checklist.md` gate 5); the owner decides whether to ship it
  worded firmly or softly.

## May never claim

- Medical or health advice, or that a reading is good/bad, "on track," or needs action ("go
  outside," "take a break," "reset your stress").
- A sleep coach, sleep recommendation, or anything framed as personalized guidance — the SDK
  exposes a backward-looking sleep score at most, and this face doesn't use it at all (v1 cut).
- That the calendar field distinguishes "no sync enabled" from "no upcoming event" — it can't; copy
  says only "No upcoming event."
- Accuracy or device reach wider than what real testing (fit sweep, not just compile) has confirmed.
- Data leaving the watch — it doesn't; no network, no `Communications`, no `Background`.
- That the accent colour can be changed **on the watch itself** (Customize next to Apply) — the menu
  is built, but the route (including select-then-exit, which closes Customize) has not been tried on
  a wrist for DayArc; claim it only after that device check (gate 5).
- More than one setting, or that density can be switched — density is a separate listing (ADR-003).
- That a chosen colour means anything about a reading: stress and Body Battery keep one constant
  colour whatever they read (ADR-006); never "turns green when you're rested."
- "No settings" or "nothing to configure" — no longer true (ADR-014). Say "one setting".
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
system) — nothing is sent anywhere. The only thing stored is the one Accent colour choice, a single
small number kept in the app's own settings storage on the watch (and, if it is changed in the
Garmin Connect app, in Garmin's own Connect IQ settings sync, which the developer never sees).
No readings are stored — every value is read fresh each time the face redraws.
