# Days To Go listing — notes

What sits behind [`README.md`](paste.md), the paste-ready copy. Nothing here is pasted into the form. Release history: [`../CHANGELOG.md`](../CHANGELOG.md). Claims and gates: [`../docs/release-contract.md`](../docs/release-contract.md).

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

- One box per language, 4000 characters, plain text: the store shows `**` and `>` literally and keeps every line break. The English description is **1325 characters**. There is no Keywords field and no What's New field on the form; the README no longer carries a Keywords block (2026-09-27 tidy-up — the form never had one).
- About what the app **is**, not how to use it: describe the feature, not the tap-by-tap steps to reach it (2026-09-27 tidy-up, applied across all four apps' listings).
- The first sentence carries the weight (the store truncates in list views); the last line is the support URL (the form has no support field).
- No watch count, no brand names, no battery or ghosting claims, no download or rating numbers, no "the only countdown with no permissions". Claims allowed: [`../docs/release-contract.md`](../docs/release-contract.md).
- Paid: disclose the price position honestly; the refund position is Garmin's return window, do not restate it in copy.

## Why each answer

| Field | Reason |
|---|---|
| Category | Utility: it is a utility face; Simple is the alternative |
| Collects user data | Nothing leaves the watch; no permissions |
| Monetization | No. The form's own wording: Yes only if the app asks for payment to enable features, or for tips or donations; Days To Go does neither. HeroFace was submitted the same way and is paid through the store. (HeroSet's `listing/paste.md` records `Paid: Yes, price tier USD 2.50` for what may be a different step of the form: read the form's wording at submission.) |
| Price | Paid, the $2.50 tier (US $2.49, eurozone 2,99 EUR), the same tier as every paid app of the studio (owner decision 2026-10-04, ADR-017 (price: the $2.50 tier for every paid app); first submitted at the lowest tier, USD 2.00 / $1.99 US, ADR-002 price superseded). Set with the 1.1.0 upload. The form has no price field of its own in HeroFace's notes; if a merchant step appears choose "Yes, through Garmin CIQ merchant account". The offered watch list and countries shrink to Garmin's lists. Re-pricing an approved app can remove it for re-review (SDK `Monetization/App_Sales`; unconfirmed for a higher tier, ROADMAP 2.1), so it ships with the 1.1.0 version upload. No price number in the listing text. No day-45 review (retired, ADR-014) |

## Languages

English plus 14 (dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr) exist as **on-watch strings** and are machine-drafted, not read by a native speaker. Captions are labels, not sentences, so no language needs plural agreement; Polish, Lithuanian, Ukrainian and Finnish therefore read slightly unnatural at some counts (for example 21). The store description is English only until the owner decides whether to translate it. Russian, Greek and Chinese are not included.

## Images

One 454 × 454 FR965 simulator screenshot and a 500 × 500 cover exist; see [`screenshots.md`](screenshots.md). A hero (1440×720) was drafted 2026-09-27, adapted from HeroFace's own `listing/src/` generators as this file already suggested — **not uploaded**: DaysToGo is mid-review (1.0.1, submitted 2026-09-26) and whether editing a live listing image restarts or affects that review is unconfirmed against Garmin's own published docs. Owner's call before adding it to `README.md`'s Hero Image field. More states (named event in weeks, last day in hours, TODAY) and a real launcher icon would help.

## Previous What's New blocks

- **1.0.1:** `Long event names on small screens now end in "..." instead of being cut off without a marker.`
- **1.0.0:** `First release.`

## Pro 1.1.0: what `paste.md` now holds (UNRELEASED, accepted 2026-10-04 under ADR-014 (Free + Pro ladder), nothing uploaded; moved from a draft here, 2026-10-04)

`paste.md` is the 1.1.0 text. Names are confirmed (2026-10-04); the sibling URL is the owner's; the price is the $2.50 tier (ADR-017), set in the form.

- **Title** (plan proposal, OWNER decides): `Days To Go Pro: Countdown, Hours, Footer`.
- **Line 1:** `Also available: Days To Go (<URL>)`. The paid listing must not use the word "free" (release contract; store review guideline 4d), so the plan's "Try free first" wording is deliberately not used. The rest of the description is the 1.0.1 text: it already describes only what Pro has (timed events, the battery or steps line, six accents).
- **Instinct:** the sentence about the Instinct ring gauge is out of the paste text until the upload is approved and the store lists those watches; it is kept in `meta.yaml` (`held_back_text`).
- **Version** `1.1.0`; the What's New is the rename line, naming the sibling without "free".
- Device note (plan WP4 step 6): not in the text. Add one only after the other listing's real device list is visible, with no "free" wording and no watch names or count.
- The price is **not** in this file (ADR-017: the $2.50 tier, set in the form with the 1.1.0 upload). Re-pricing an approved app can remove it for re-review (SDK `Monetization/App_Sales`); shipping it with the version upload covers that.
- "More from Verden" is left out: it lists only live free siblings, none live today.
