# DayArc Pro — listing notes

1. **Title.** "DayArc Pro," store-collision checked separately from "DayArc" (`docs/decisions.md`
   ADR-012, 996 fuzzy results, no exact match).
2. **Description.** Names the Pro-only fields plainly as "as many as fit your watch's screen", never a count, never "resting" heart rate (no "insights"/"coaching" framing, per
   `docs/release-contract.md`). States the no-flip rule directly (no price number: ADR-018, the $2.50 tier, is set in the form only), since ADR-007 is a
   deliberate departure from this studio's usual flip-to-free pattern and the listing should say so
   rather than let a reviewer assume the usual rule applies.
3. **Category/data-collection/email.** Same as DayArc's listing — one product family, one set of
   defaults.
4. **Monetization.** `paste.md` carries only "Paid: Yes, price tier USD 2.50". The block used to be prose, because the no-flip decision is unusual for this studio: "Paid: Yes, price tier USD 2.50 (the form's own selection, set in the dashboard; ADR-018 (price: the $2.50 tier)), one-time, no subscription. No price number goes in the description text." The description still says "one purchase, no subscription".

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

Listing text carries no device sentence and no watch model name (owner, 2026-10-04); the former `meta.yaml` `held_back_text` is deleted. The owner decisions before pasting are in `meta.yaml` `owner_approvals`: the placeholder store URLs, and "chosen in the Garmin Connect app" (unverified until a store install, status gate 5).

- **Line 1** is `Also available: DayArc, the lighter version with one reading per window: <URL>`, a placeholder until the DayArc listing is live. The paid listing never says "free": the old "no free tier ... a separate free listing" wording was removed (it was also false once the sibling is free).
- **Refund wording:** no refund or return wording appears in listing text (owner decision, 2026-10-04). No price number.
- **Additional Hardware Requirements (ROADMAP 10.16):** paste the bare URL `https://verden.watch/day-arc-pro/` only (API field `hardwareProductUrl`; the old "No additional hardware needed..." sentence is retired); the Free listing pastes `https://verden.watch/day-arc/`.
- **Device claims (ROADMAP 10.15), verified 2026-10-04:** the manifests carry no Instinct watch except the Instinct E 40/45 mm and Instinct 3 Solar (plus the AMOLED Instinct 3 and Crossover AMOLED products, which are not part of the Instinct 2 family); Instinct 2, 2S, 2X and Descent G1 are not in DayArc, so nothing needs removing from the paid text. The Free twin has no Free-only Instinct reach either (see `../docs/release-contract.md` "Paid vs free reach"). Listing text names no watch model (owner, 2026-10-04).
- Everything else as in `../listing/NOTES.md`: review request (owner may cut), "More from Verden" with free siblings only (all placeholders today), no device sentence and no Instinct wording.
- `meta.yaml` site URLs corrected to the Pro slug (`/day-arc-pro/`), matching the paste block.

## Store images (2026-10-04; the owner approves the looks before any upload)

How they are made: [`screenshots.md`](screenshots.md). Why they are what they are:

- **Five screens, the best five for Pro.** Pro's pitch is the whole grid under an unchanged hero, so three are the three windows with their grids (morning with sun times, midday with the calendar cell, evening with recovery, respiration and pulse ox), one is the accent colour (blue, evening), one is an Instinct (E 40 mm evening, where Pro draws one row of readings under the hero, the window that tells it from DayArc there). The night window is left out (identical to DayArc's).
- **Honest Pro picture:** each frame shows what that window really draws on an FR965; a smaller screen draws fewer cells, which the listing says in words ("as many as fit your watch's screen"), and no image counts fields. The word "free" and any price are in no image.
- **Simulator artifacts** (details in `screenshots.md`): the default position makes the sun times read 12:17 and 23:59 beside a 07:17 clock, so the scenario sets the simulator's position to London for the morning frame (06:05 and 17:33), fixed. **Stubbed for the picture:** the simulator cannot set calories (the flame cell read 0 beside thousands of steps) and its canned calendar event read "00:00" with no title, so the private build copy returns 1240 calories and the event "Standup" (`tools/listing_shots.sh`, `stub_pro_values`; the repo's `source/` is untouched). Affected: midday (both), evening and accent shot (calories), the hero. These are plausible canned values, not readings; the owner should know the pictures carry them.
- **The mark and the PRO tag** are proposals for the owner, as in `../listing/NOTES.md`: the same arc as DayArc, a white PRO tag inside the arc on the cover and icons and beside the name on the hero.
- **Claims check** against `../docs/release-contract.md`: no count of fields, no "insights" or coaching wording, nothing on what a reading means, no price, no "free", no data leaving the watch.
- The old six pictures were replaced by this set; they predated the 2026-10-04 grid and icon changes (ADR-016, ADR-017).

## 2026-10-04: what moved out of `paste.md` (owner rule: paste.md holds only what is pasted or uploaded)

- **Form:** https://apps.garmin.com/developer/upload; two steps, attach the `.iq`, then the details. One block is one field. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml); the approvals the owner owes are in its `owner_approvals`. Claims are checked against [`../docs/release-contract.md`](../docs/release-contract.md). This listing never uses the word "free" (it is paid; store review guideline 4d).
- **Description:** line 1 needs the DayArc listing live (placeholder `<DAYARC STORE URL>`); under "More from Verden" keep only the free faces that are live and delete the other lines. The description's hard line breaks were joined into paragraphs (the store keeps every line break). The refund sentence ("DayArc Pro is a paid app. Refunds follow the Connect IQ Store return window.") is removed.
- **What's New:** blank, initial release. **Category:** Utility (alternative: Health & Fitness). **Collects user data:** No; nothing leaves the watch: no network code, no `Communications` permission, no location.
- **Images:** the owner approves the looks first (`meta.yaml` `owner_approvals`); at most 5 screens; all five are the simulator's own captures at native pixels with a 24-hour clock; the values (weather, sun times, heart rate, Body Battery, stress and the rest) are the simulator's canned or random ones, not readings; the night window is left out on purpose. Captions and devices are in `meta.yaml` `assets.screens`. Before uploading screens 2 to 4 the owner decides on the flame cell (0) and the midday calendar cell ("00:00"), simulator limits, see [`screenshots.md`](screenshots.md).
- **Form fields not in paste.md:** the file never carried Subcategory, ANT+ profiles, regional limits, Preview Video, Source Code URL, Review Notification or App Migration, and does not now; the template's answers for them (`../../reports/listing-template.md`) are No / No / none / blank / Yes / No, to be read against the real form at submission. The Email Address and Hardware blocks now follow the form order (Hardware last).

## Light-ground cover and hero (ROADMAP 10.25, owner decision 2026-10-04)

Garmin's brand page says "Do not choose black or transparent backgrounds"; the old cover and hero were black with a navy glow. New ground: indigo gradient `#4B3BC4` to `#2A2582` on cover and hero, the same in both tiers so the pair reads as one family; Free is the plain mark, Pro has the white PRO tag (as before). The hero keeps the black watch screens, on the indigo.

Looked at three-plus variants at 500 px and at 100 px:
- **Cream `#FFF4E0` (rejected).** Cyan has about 1.2:1 contrast on cream, so the middle arc segment and the "r" of the name wash out; the white dot has to turn dark, which changes the mark. It was the weakest at thumbnail size.
- **Bright blue `#1F5FD0` (rejected).** Cyan and the blue ground sit too close in hue; the middle segment is the weakest of the three arcs.
- **Flat indigo `#3A2E9C` (close second).** Same read as the gradient; the gradient adds a little depth and was picked.
- **Indigo gradient (chosen).** Amber, cyan and rose all stay vivid, the white dot and the white name keep full contrast, and it is legible at 100 px.

Device icons 128x128 are left black: the quoted rule names the 500x500 store icon (cover), and a device icon is drawn on the watch's own ground; the owner may want a coloured ground there too. Owner approves the looks.

## Form fields added to `paste.md` (ROADMAP 10.24, 2026-10-04)

Answered as the sibling listings do (`../../TwoSuns/listing-free/paste.md`, `../../HeroSet/listing/paste.md`): **Subcategory** "whatever the Category choice offers" (Category stays Utility; HeroSet's own category has an "Other" entry, a face's Utility may not); **ANT+** No (the face decodes no ANT+ profile); **regional limits** No; **Preview Video** none (YouTube or Vimeo only); **Source Code URL** blank; **Review Notification** Yes; **App Migration** No (a new app id, not a newly compatible device on an existing app). Privacy-policy URL is not added: the field is conditional on "collects user data" being Yes.
