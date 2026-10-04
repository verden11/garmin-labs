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

- The launcher icons inside the app are still placeholders (`resources/drawables/launcher_icon.svg`, ROADMAP 1.5, the owner's task). The listing images (cover, hero, the two device icons, five screens) were rendered 2026-10-04 and wait for the owner's look approval, see "Store images" below.
- Support/privacy URL: TwoSuns's pattern is `https://verden.watch/<slug>/...`; DayArc's slug isn't
  picked yet (`../CLAUDE.md` "Open owner decisions").
- Real trademark search, if the owner wants clearance beyond the store-collision check already done.

## Sibling line, review request, More from Verden (ROADMAP 1.8, 2026-10-04)

The device sentence and the Instinct wording are in `meta.yaml` `held_back_text`, not in `paste.md` (not form fields). The owner decisions before pasting: the placeholder store URLs, and "chosen in the Garmin Connect app" (unverified until a store install, status gate 5).

Written against `../docs/release-contract.md` and the WP10 Free skeleton (`../../reports/listing-template.md`).

- **Line 1** is the Pro store URL (`Get DayArc Pro: <URL>`), a placeholder until the Pro listing is live. It costs the list-view preview (the store shows the first sentence); the owner may move it below the promise paragraph.
- **Claims:** "separate, paid listing with a denser view" is the contract's "May claim" sentence. No "unlock", no "trial", no "upgrade", no count of fields. "Chosen in the Garmin Connect app" stays marked OWNER (unverified until a store install, gate 5).
- **Review request:** one sentence, the owner may cut it.
- **More from Verden:** free siblings only; none is live today, so every URL is a placeholder and the owner deletes the lines for any face whose free listing is not live. Free names are placeholders until OD3.
- **Additional Hardware Requirements (ROADMAP 10.16):** paste the bare URL `https://verden.watch/day-arc/` only (API field `hardwareProductUrl`; the old "No additional hardware needed..." sentence is retired). No refund line: a free app has nothing to refund.
- **Device sentence:** kept out of the description (`meta.yaml` `held_back_text`): it is a reach claim until both real device lists are visible. No watch names, no count.
- **Instinct:** the 72-product package includes the Instinct E and 3 Solar; the listing text says nothing about it until the upload is approved and the store lists it (`meta.yaml` carries the sentence to add then).
- **Support line** added as the last line (the form has no support field).

## Store images (2026-10-04; the owner approves the looks before any upload)

How they are made: [`screenshots.md`](screenshots.md). Why they are what they are:

- **Five screens, not six.** The owner asked for at most five, the best five for the tier. The face changes through the day, so three are three windows (weather in the morning, stress at midday, Body Battery in the evening), one is the one setting (the accent colour, shown purple), one is an Instinct. The night window (time and date only) is left out; it adds nothing a buyer needs to see. The first four are the FR965 at its native 454 px, the fifth the Instinct E 40 mm at its native 166 px, black and white.
- **One reading per window is the honest Free picture.** Nothing in the five shows a grid, a calendar or a sun time: those are DayArc Pro's (`../listing-pro/`). The hero's captions name only what each window shows (Weather, Stress, Body Battery).
- **The mark** is the day as an arc: amber, cyan and rose are the face's own Auto hues for morning, midday and evening, a white dot is "now". It is a proposal for the owner, as is the Free/Pro rule: Free is the plain mark, Pro has a white PRO tag. The mark is not the launcher icon (ROADMAP 1.5, the owner's), though it could become it.
- **Claims check** against `../docs/release-contract.md`: nothing in the images says what a reading means, no price, no battery or accuracy figure, no device count, no mention of Pro in any image, no data leaves the watch. The accent shot shows a colour, not how it is set (the Garmin Connect route is unverified until a store install).
- **Simulator data** (66 degrees, 77/63, stress and Body Battery random per run) is not a reading; nothing is cropped into a claim.
- **Instinct:** the picture is allowed in the listing before the store lists those watches, but the description says nothing about Instinct until then (`meta.yaml` `held_back_text`).
- The old six pictures (morning, midday, evening, night, two on the Instinct E 45 mm) were replaced by this set; they predated the 2026-10-04 icon-size and label changes (ADR-017).
