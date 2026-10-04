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

Same open items as `../listing/NOTES.md`: both icons/cover/hero images, all screenshots
(`screenshots.md`), the support/privacy URL slug, an optional real trademark search.

## Sibling line, review request, More from Verden (ROADMAP 1.8, 2026-10-04)

The device sentence and the Instinct wording are in `meta.yaml` `held_back_text`, not in `paste.md` (not form fields). The owner decisions before pasting: the placeholder store URLs, and "chosen in the Garmin Connect app" (unverified until a store install, status gate 5).

- **Line 1** is `Also available: DayArc, the lighter version with one reading per window: <URL>`, a placeholder until the DayArc listing is live. The paid listing never says "free": the old "no free tier ... a separate free listing" wording was removed (it was also false once the sibling is free).
- Everything else as in `../listing/NOTES.md`: review request (owner may cut), "More from Verden" with free siblings only (all placeholders today), the device sentence in `meta.yaml` `held_back_text`, no Instinct wording until the store lists it.
- `meta.yaml` site URLs corrected to the Pro slug (`/day-arc-pro/`), matching the paste block.
