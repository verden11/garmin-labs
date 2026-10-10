# DayArc — release contract

What either listing may claim, in listing, site, anywhere else user-facing.
Every listing sentence checked against this file before ship.

## May claim

- What each window shows, plain descriptive terms: morning weather (feels-like temperature,
  high/low, chance of rain, UV when device supports it), midday stress reading, evening Body
  Battery reading; time and date in every window's header. Pro: extra per-window field
  grid, named plainly (steps, heart rate, floors, etc.), never "insights" or "coaching" — and
  never with a COUNT of fields: count depends on watch screen (about 4-6 on FR965,
  about 2 on Venu Sq 2), so say "as many as fit your watch's screen." Say "heart rate", never
  "resting heart rate" (field = watch's plain heart-rate reading).
- Content changes automatically through day on fixed schedule (5:00/9:30/17:00/23:00).
- DayArc Pro = separate, paid listing, more fields per window than DayArc.
- Numbers shown in device's own configured units.
- One setting, **Accent colour** (short colour list, default Auto = each time of
  day has own colour) (ADR-014). Both listings. "Changeable in the Garmin Connect app" =
  intended store wording but **unverified until a store install** — sideloaded build cannot
  exercise phone page (`docs/status.md` gate 5); owner decides ship worded firmly or softly.

## May never claim

- Medical or health advice, or reading good/bad, "on track," or needs action ("go
  outside," "take a break," "reset your stress").
- Sleep coach, sleep recommendation, or anything framed as personalized guidance — SDK
  exposes backward-looking sleep score at most, face doesn't use it at all (v1 cut).
- Calendar field distinguishes "no sync enabled" from "no upcoming event" — can't; copy
  says only "None" (beside calendar icon; was "No upcoming event" until 2026-10-05).
- Accuracy or device reach wider than real testing (fit sweep, not just compile) confirmed.
- Data leaving watch — doesn't; no network, no `Communications`, no `Background`.
- Accent colour changeable **on the watch itself** (Customize next to Apply) — menu
  built, but route (including select-then-exit, which closes Customize) not tried
  on wrist for DayArc; claim only after that device check (gate 5).
- More than one setting, or density switchable — density = separate listing (ADR-003).
- Chosen colour means anything about reading: stress and Body Battery keep one constant
  colour whatever they read (ADR-006); never "turns green when you're rested."
- "No settings" or "nothing to configure" — no longer true (ADR-014). Say "one setting".
- Body Battery or stress readings work identically across whole product set — Garmin's own
  docs say stress not measured during physical activity, pulse ox/VO2max/weekly distance have
  no documented per-device support list; DayArc's own copy for those fields = "--", not claimed
  cause.
- "Free trial," "unlock," or any language implying Pro is Simple-plus-a-toggle — separate
  products, separate listings, separate app ids (ADR-003).

## Paid vs free reach (2026-10-04)

**Devices.** Garmin sells paid apps only on products of its App Sales list. DayArc never submitted, so device list unmeasured; device set (Connect IQ 4.2+, 72 products with Instinct E 40/45 mm and Instinct 3 Solar, ADR-015) = Two Suns' family, and Two Suns' live paid listing misses 1 of 69 (D2 Air X10, on list but sold to no paid app). **Instinct 2, 2S, 2X and Descent G1 not in either DayArc build**, and Free DayArc has almost no extra reach. **Listing text never names watch models, in either listing, carries no device sentence; store's device tab is the claim** (owner, 2026-10-04). Add number here after first listing shows its Compatible Devices ([`../../reports/Garmin policies and design guidelines.md`](../../reports/Garmin%20policies%20and%20design%20guidelines.md) section 3).

**Listing text.** No refund or return wording in listing text (owner decision, 2026-10-04). No language name or count either (fact stays in docs). Pro listing still never uses word "free".

## Data and privacy

Nothing leaves watch. No location read (no `Positioning` permission, unlike TwoSuns — DayArc
has no sun-position feature). `ComplicationSubscriber` only permission, reads data
watch already has (steps, Body Battery, calendar next-event, etc., as published by Garmin's own
system) — nothing sent anywhere. Only thing stored: one Accent colour choice, single
small number in app's own settings storage on watch (and, if changed in
Garmin Connect app, in Garmin's own Connect IQ settings sync, which developer never sees).
No readings stored — every value read fresh each time face redraws.