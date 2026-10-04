# DayArc — listing notes

Why each `README.md` field is what it is, field limits, and history of changes. One numbered item
per field, matching `README.md`'s order.

1. **Title.** "DayArc," 6 characters, well under the 50-char limit. Store-collision checked
   (`docs/decisions.md` ADR-012), no registered-trademark search.
2. **Description.** States what's shown, never what it means for health (per
   `docs/release-contract.md`). Names DayArc Pro once, as a separate product, not an upsell inside
   this listing's own copy.
3. **Category/data-collection/monetization/email.** Reused directly from the studio's own
   established defaults (TwoSuns's listing) rather than left as open owner decisions — DayArc's own
   facts (no location at all) make the data-collection answer simpler than TwoSuns's, not harder.

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

- Both launcher icon, cover (500×500), hero (1440×720, optional) images — placeholders only
  (`resources/drawables/launcher_icon.svg`).
- All screenshots (`listing/screenshots.md`).
- Support/privacy URL: TwoSuns's pattern is `https://verden.watch/<slug>/...`; DayArc's slug isn't
  picked yet (`../CLAUDE.md` "Open owner decisions").
- Real trademark search, if the owner wants clearance beyond the store-collision check already done.
