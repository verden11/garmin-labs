# Days To Go listing — notes

What sits behind [`paste.md`](paste.md), the paste-ready copy. Nothing here is pasted into the form. Release history: [`../CHANGELOG.md`](../CHANGELOG.md). Claims and gates: [`../docs/release-contract.md`](../docs/release-contract.md).

## Before you submit (owner)

The full runbook, with the order, the timing and what to do after approval, is [`../docs/status.md`](../docs/status.md). The short list:

1. Store search by eye for "Days To Go", and a trademark search (the code-side search found no exact match on 2026-09-26; the search is relevance-capped).
2. **Waived by the owner on 2026-09-26** (`../docs/status.md`): the beta round trip on the FR965 (T2 phone date survives, T4 picker and phone do not destroy each other). It can still be run any time with a Beta App upload. Until it is, the description must not promise that the phone saves the date, and the "set it on the watch" sentence stays out.
3. The always-on night and wear day on the FR965 (checklist gates 4 and 5).
4. Real launcher icon (the file in `resources/drawables/` is a simple placeholder: a mint ring and a "1"), cover, hero and screenshots.
5. Site pages live (`npm run deploy` in `site/`): support and privacy must be reachable before review.
6. Native-speaker read of any translation you ship as store copy (see "Languages").

## Edits that depend on the device test (only if the beta round trip is run later)

- **T4 passes** (picker and phone coexist): add to the description, after "Any date, your own event": `On many watches you can also set the date on the watch itself: choose the face, then Customize.` Never drop "on many watches": the SDK lists the on-watch settings screen for 94 of the 117 products.
- **T2 fails** (phone lists lose the value): the on-watch picker becomes the main route; rewrite that paragraph and escalate to the owner before submitting.

## Description rules

- One box per language, 4000 characters, plain text: the store shows `**` and `>` literally and keeps every line break. The English description is **1799 characters** (2026-10-04, with the "To the minute" paragraph; the limit is 4000). There is no Keywords field and no What's New field on the form; the README no longer carries a Keywords block (2026-09-27 tidy-up — the form never had one).
- About what the app **is**, not how to use it: describe the feature, not the tap-by-tap steps to reach it (2026-09-27 tidy-up, applied across all four apps' listings).
- The first sentence carries the weight (the store truncates in list views); the last line is the support URL (the form has no support field).
- No watch count, no brand names, no battery or ghosting claims, no download or rating numbers, no "the only countdown with no permissions". Claims allowed: [`../docs/release-contract.md`](../docs/release-contract.md).
- Paid: no price number in the text. No refund or return wording appears in listing text (owner decision, 2026-10-04).

## Why each answer

| Field | Reason |
|---|---|
| Category | Utility: it is a utility face; Simple is the alternative |
| Collects user data | Nothing leaves the watch; no permissions |
| Monetization | No. The form's own wording: Yes only if the app asks for payment to enable features, or for tips or donations; Days To Go does neither. HeroFace was submitted the same way and is paid through the store. (HeroSet's `listing/paste.md` records `Paid: Yes, price tier USD 2.50` for what may be a different step of the form: read the form's wording at submission.) |
| Additional Hardware Requirements | Paste the bare URL `https://verden.watch/days-to-go/` only (API field `hardwareProductUrl`, a URL; the old "No additional hardware needed..." sentence is retired, ROADMAP 10.16). Live value today: empty |
| Price | Paid, the $2.50 tier (US $2.49, eurozone 2,99 EUR), the same tier as every paid app of the studio (owner decision 2026-10-04, ADR-017 (price: the $2.50 tier for every paid app); first submitted at the lowest tier, USD 2.00 / $1.99 US, ADR-002 price superseded). Set with the 1.1.0 upload. The form has no price field of its own in HeroFace's notes; if a merchant step appears choose "Yes, through Garmin CIQ merchant account". The offered watch list and countries shrink to Garmin's lists. Re-pricing an approved app can remove it for re-review (SDK `Monetization/App_Sales`; unconfirmed for a higher tier; policy research in ROADMAP 2.1), so it ships with the 1.1.0 version upload. No price number in the listing text. No day-45 review (retired, ADR-014) |

## Languages

English plus 14 (dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr) exist as **on-watch strings** and are machine-drafted, not read by a native speaker. Captions are labels, not sentences, so no language needs plural agreement; Polish, Lithuanian, Ukrainian and Finnish therefore read slightly unnatural at some counts (for example 21). The store description is English only until the owner decides whether to translate it. Russian, Greek and Chinese are not included.

## Images

**Re-done 2026-10-04 (owner chat): a complete new image set, all proposals the owner approves before upload.** Five screens (see the update below; originally hours with the battery line, weeks with the steps line, days with the battery line, a rectangle, an Instinct), a hero, a cover and the two device icons, all from the current Pro build; details, commands and the limit check are in [`screenshots.md`](screenshots.md). Earlier versions are in git history. **Updated 2026-10-04 for the headline (ADR-018):** screen 1 is now "to the minute in the zone it starts in" (`1-to-the-minute.png`, 8:06 with a UTC+2 event) and screen 3 "the other side of the world" (`3-other-time-zone.png`, 14:21 for a 09:30 event in UTC+9), replacing the hours-battery and days-battery captures; weeks-steps, the rectangle and the Instinct stay; the hero uses the new two and its line now reads "Count down to the minute, in the time zone it starts in.".

- **Cover and hero on a light/coloured ground (owner decision 2026-10-04, ROADMAP 10.25).** Garmin's brand page: "Do not choose black or transparent backgrounds" (500x500 store icon). Chosen: one brand colour, mint `#55FFAA` (the face's own ring accent), flat; ink `#06261B` arc, "1" and "Days"; `#1FBF7A` track; "To Go" `#0A6B43` (about 4.5:1 on the mint, white "To Go" was 1.3:1); PRO badge amber `#FFAA00` as before. Hero keeps the three black watch screens, on the mint with a soft green shadow. Read at 100 px: the ring, the "1" and the name hold. **Rejected variants** (looked at, not kept): (A) mint with a white arc and white "To Go": white on mint is too weak; (B) near-white `#F2F6F4` with a darkened green `#00B36B` arc: clean and legible, but pale and it drops the brand mint, kept as the fallback if the owner finds the mint too loud; (C) mint with a white disc behind the mark: the mint arc vanishes on the white. **128x128 device icons unchanged (black ground):** the brand page's black/transparent rule is stated for the 500x500 store icon only; the device-icon guidance is separate and has no background rule, and those icons sit on the watch's own black. Owner approves the new look before upload.
- **Pro shows what Pro adds** (Hour for a timed event, the bottom line), no price number, never "free".
- **Free vs Pro:** the same mark (the launcher icon's ring and "1"); Pro adds a small amber PRO badge on the cover, hero and both icons. Owner approves or replaces it; the real launcher icon is ROADMAP 3.3.
- **Instinct picture from the Instinct E 40 mm**, not the Instinct 2: Garmin's paid-app product list has no Instinct 2, 2S, 2X or Descent G1 (`reports/Garmin policies and design guidelines.md`). Never name the Instinct 2 family in a Pro caption or text. Device-reach rule: the picture goes up with the upload that adds the Instinct products; listing text never names a watch model or gives a count (owner, 2026-10-04; the former `held_back_text` sentence is deleted).
- The bottom line is not drawn on the rectangle or on an Instinct E (no room), so those two pictures show the hours state only.
- Not pictured: the date picker (see `screenshots.md`), the always-on state.
- The old caution about editing a live listing's images mid-review (1.0.1, 2026-09-26) is moot: the app is approved (2026-09-28); whether swapping images triggers re-review is still ROADMAP 10.5.

## Previous What's New blocks

- **1.1.0** (uploaded 2026-10-04, in review): `New: count down to the minute. Give an event a start time and the time zone it starts in, and the last 24 hours count down in hours and minutes to the moment it starts. You choose the UTC offset; the watch keeps no time zone rules. The count of days stays on your own calendar. The app is now called Days To Go Pro on the watch. Also available: Days To Go, with the core countdown.`
- **1.0.1:** `Long event names on small screens now end in "..." instead of being cut off without a marker.`
- **1.0.0:** `First release.`

## Pro 1.1.0: what `paste.md` now holds (uploaded 2026-10-04, accepted under ADR-014 (Free + Pro ladder); moved from a draft here, 2026-10-04)

`paste.md` is the 1.1.0 text. Names are confirmed (2026-10-04); the sibling URL is the owner's; the price is the $2.50 tier (ADR-017), set in the form.

- **Title** (OWNER decides): `Days To Go Pro: Countdown to the Minute` (39 characters, limit 50). The earlier proposal `Days To Go Pro: Countdown, Hours, Footer` went stale once the Pro headline was chosen (2026-10-04, ROADMAP 3.10, ADR-018 (the event minute and zone)); "Footer" was the weakest search word and the headline now says what Pro is for. Search words kept: Countdown, and the Minute headline (hours are in the description). Alternatives: `Days To Go Pro: Countdown, Minute, Hours` (40) keeps "Hours" as a search word; `Days To Go Pro` alone (14).
- **Line 1:** `Also available: Days To Go (<URL>)`. The paid listing must not use the word "free" (release contract; store review guideline 4d), so the plan's "Try free first" wording is deliberately not used. The rest of the description is the 1.0.1 text: it already describes only what Pro has (timed events, the battery or steps line, six accents).
- **Instinct:** listing text names no watch model and has no Instinct sentence (owner, 2026-10-04; the store's device tab is the claim). Instinct 2, 2S, 2X and Descent G1 are not on Garmin's paid-app list, so the paid listing is not sold on them ([`../docs/release-contract.md`](../docs/release-contract.md) "Paid vs free reach"; ROADMAP 10.15).
- **Version** `1.1.0`; the What's New leads with "count down to the minute", then the rename line, naming the sibling without "free". The "To the minute" description paragraph says the wearer picks the UTC offset and that the face does not adjust for daylight saving; the whole claim set is `../docs/release-contract.md` (never "works across time zones" without the offset sentence; never "handles daylight saving"). Minute and Event time zone are phone-only settings (the on-watch picker sets the date alone): the description does not say otherwise and gives no tap-by-tap steps.
- Device note (plan WP4 step 6): not in the text, now or later (no device sentence, no watch names or count).
- The price is **not** in this file (ADR-017: the $2.50 tier, set in the form with the 1.1.0 upload). Re-pricing an approved app can remove it for re-review (SDK `Monetization/App_Sales`); shipping it with the version upload covers that.
- "More from Verden" is left out: it lists only live free siblings, none live today.

## Pro 1.2.0: what `paste.md` now holds (prepared 2026-10-08, not uploaded)

- **Version** `1.2.0` (next minor; App Version is free text in the form, the manifest carries none). It can go up while 1.1.0 is still in review (`../../research_notes/Free and Pro ladder/garmin_rules.md`).
- **What's New** lists the user-facing changes of `../CHANGELOG.md` "Pro 1.2.0": the square design (ADR-019 (rectangles get a square design)), `8h 06m` (ADR-018 (to the minute), amendment), the ring's one scale, the date arrow and the bottom-line marks, no on-watch date picker on two rectangles (ADR-020 (no on-watch picker on the Sq 2)), the always-on grey (ADR-007 (always-on), amendment). The first-generation Venu Sq and Sq Music are in the package but not on Garmin's paid list, so Pro's What's New claims no new watches. No watch model, no language, no price, no "free"; nothing about time zones beyond what 1.1.0 said.
- **Description fixed for the new build (the reviewer's upload gate of 2026-10-08):** "A thin ring around the bezel" is now "along the edge of the screen"; "One design, every screen / Round and rectangular watches alike, full detail down to the smallest" is now "Every screen, its own fit", naming the bezel ring, the track along a rectangle's glass and the black-and-white window gauge by screen type; the bottom-line sentence now says "(not on black-and-white screens)" (ADR-015 (Instinct family): no footer there). Spanish and Chinese mirrored. The site wording is a separate, held-back commit (deploy after Garmin approves).

## 2026-10-04: what moved out of `paste.md` (owner rule: paste.md holds only what is pasted or uploaded)

- **Form:** https://apps.garmin.com/developer/upload; two steps, attach the `.iq`, then the details. One block is one field. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml); the approvals the owner owes are in its `owner_approvals`.
- **Title:** "Days To Go Pro: Countdown to the Minute" (the 2026-10-04 title for the headline; the plan's "Countdown, Hours, Footer" is stale); "Days To Go Pro" alone is the short alternative. The owner decides.
- **Description:** line 1 holds the sibling's store URL (filled 2026-10-04; the link works once Garmin approves that listing). Languages are added one at a time (pick a language, press Add, fill Title + Description); only English is drafted, see "Languages" above. The description never uses the word "free" (it is paid; release contract, store review guideline 4d). The refund sentence ("Days To Go Pro is a paid app. Refunds follow the Connect IQ Store return window.") is removed.
- **Version:** the form reads it from the package; if a field asks, type it. paste.md is the 1.1.0 text (the Pro rename); the submitted 1.0.1 What's New is in "Previous What's New blocks" above.
- **Category:** Utility (alternative: Simple). **Subcategory:** whatever the Category choice offers. **Collects user data:** No; the privacy-policy URL field is conditional on Yes, so it may not appear. **Preview Video:** none (YouTube or Vimeo only).
- **Hardware field:** the bare URL only; the store API names it `hardwareProductUrl`, and a live listing's value is a bare URL (owner, 2026-10-02; Garmin research 2026-10-04).
- **Images:** the owner approves the looks first (`meta.yaml` `owner_approvals`). Simulator captures of the Pro build, 2026-10-04 (canned clock, battery and steps; not real readings). The Instinct picture is the Instinct E 40 mm (a Pro caption never names the Instinct 2 family); the simulator image is 166 px and `screens/5-instinct.png` is it enlarged x3 without smoothing (the native capture is re-made by `tools/listing_shots.sh` when re-taking; not kept); upload it only with the package that adds the Instinct products (1.1.0). Captions and devices are in `meta.yaml` `assets.screens`.
