# DayArc Pro — listing notes

1. **Title.** "DayArc Pro," store-collision checked separately from "DayArc" (`docs/decisions.md`
   ADR-012, 996 fuzzy results, no exact match).
2. **Description.** Names the Pro-only fields plainly as "as many as fit your watch's screen", never a count, never "resting" heart rate (no "insights"/"coaching" framing, per
   `docs/release-contract.md`). States the no-flip rule directly (no price number: ADR-018, the $2.50 tier, is set in the form only), since ADR-007 is a
   deliberate departure from this studio's usual flip-to-free pattern and the listing should say so
   rather than let a reviewer assume the usual rule applies.
3. **Category/data-collection/email.** Same as DayArc's listing — one product family, one set of
   defaults.
4. **Monetization.** Written as prose, not just "Paid," because the no-flip decision is unusual
   enough for this studio to state explicitly in the field itself, not only in `NOTES.md`.

## Settings, and what the store form needs (ADR-014, 2026-09-28)

Both listings now have ONE setting (Accent colour). **What the owner must change in the upload
form:** only the **Description** box, in both listings — replace the old "no settings, nothing to
configure" opening with the new one in `README.md` (both files already carry it). The store form has
no settings field of its own in this project's field list, and nothing else changes: **"Does your app
collect user data?" stays No** (the choice is one small number kept in the watch's own settings
storage and never sent to the developer — the same answer TwoSuns gave while also shipping a list
setting, `../../TwoSuns/listing/paste.md`; owner to confirm this reading of the question), no new
permission, no new store field. The privacy page (`site/src/apps/day-arc*/Privacy.tsx`) was updated
to say so in the same change. **Not claimed anywhere:** that the colour can also be changed on the
watch itself (Customize, next to Apply) — built, but not yet tried on a wrist, so per
`docs/release-contract.md` the copy names the Garmin Connect app only. Add "or right on the watch"
only after gate 5's device test.

## Open owner decisions

Same open items as `../listing/NOTES.md`: the launcher icons inside the app (ROADMAP 1.5), the look approval of this folder's cover, hero, device icons and five screens (see "Store images" below), the support/privacy URL slug, an optional real trademark search.

## Sibling line, review request, More from Verden (ROADMAP 1.8, 2026-10-04)

The device sentence and the Instinct wording are in `meta.yaml` `held_back_text`, not in `paste.md` (not form fields). The owner decisions before pasting: the placeholder store URLs, and "chosen in the Garmin Connect app" (unverified until a store install, status gate 5).

- **Line 1** is `Also available: DayArc, the lighter version with one reading per window: <URL>`, a placeholder until the DayArc listing is live. The paid listing never says "free": the old "no free tier ... a separate free listing" wording was removed (it was also false once the sibling is free).
- **Refund line (ROADMAP 10.16):** the description carries "DayArc Pro is a paid app. Refunds follow the Connect IQ Store return window." (review guideline 4d). It points at Garmin's window and does not restate the hours (the full return-policy text is unpublished; the 48-hour figure is about when funds are captured). No price number. The Free DayArc listing has none.
- **Additional Hardware Requirements (ROADMAP 10.16):** paste the bare URL `https://verden.watch/day-arc-pro/` only (API field `hardwareProductUrl`; the old "No additional hardware needed..." sentence is retired); the Free listing pastes `https://verden.watch/day-arc/`.
- **Device claims (ROADMAP 10.15), verified 2026-10-04:** the manifests carry no Instinct watch except the Instinct E 40/45 mm and Instinct 3 Solar (plus the AMOLED Instinct 3 and Crossover AMOLED products, which are not part of the Instinct 2 family); Instinct 2, 2S, 2X and Descent G1 are not in DayArc, so nothing needs removing from the paid text. The Free twin has no Free-only Instinct reach either, so the held-back device sentence is optional (see `../docs/release-contract.md` "Paid vs free reach").
- Everything else as in `../listing/NOTES.md`: review request (owner may cut), "More from Verden" with free siblings only (all placeholders today), the device sentence in `meta.yaml` `held_back_text`, no Instinct wording until the store lists it.
- `meta.yaml` site URLs corrected to the Pro slug (`/day-arc-pro/`), matching the paste block.

## Store images (2026-10-04; the owner approves the looks before any upload)

How they are made: [`screenshots.md`](screenshots.md). Why they are what they are:

- **Five screens, the best five for Pro.** Pro's pitch is the whole grid under an unchanged hero, so three are the three windows with their grids (morning with sun times, midday with the calendar cell, evening with recovery, respiration and pulse ox), one is the accent colour (blue, evening), one is an Instinct (E 40 mm evening, where Pro draws one row of readings under the hero, the window that tells it from DayArc there). The night window is left out (identical to DayArc's).
- **Honest Pro picture:** each frame shows what that window really draws on an FR965; a smaller screen draws fewer cells, which the listing says in words ("as many as fit your watch's screen"), and no image counts fields. The word "free" and any price are in no image.
- **Two simulator artifacts handled** (details in `screenshots.md`): the default position makes the sun times read 12:17 and 23:59 beside a 07:17 clock, so the scenario sets the simulator's position to London for the morning frame (06:05 and 17:33); the canned calendar cell reads "00:00" with no title and is left in, flagged for the owner (the midday frame can be swapped).
- **The mark and the PRO tag** are proposals for the owner, as in `../listing/NOTES.md`: the same arc as DayArc, a white PRO tag inside the arc on the cover and icons and beside the name on the hero.
- **Claims check** against `../docs/release-contract.md`: no count of fields, no "insights" or coaching wording, nothing on what a reading means, no price, no "free", no data leaving the watch.
- The old six pictures were replaced by this set; they predated the 2026-10-04 grid and icon changes (ADR-016, ADR-017).
