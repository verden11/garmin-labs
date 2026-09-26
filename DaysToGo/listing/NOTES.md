# Days To Go listing — notes

What sits behind [`README.md`](README.md), the paste-ready copy. Nothing here is pasted into the form. Release history: [`../CHANGELOG.md`](../CHANGELOG.md). Claims and gates: [`../docs/release-contract.md`](../docs/release-contract.md).

## Before you submit (owner)

The full runbook, with the order, the timing and what to do after approval, is [`../docs/publish-checklist.md`](../docs/publish-checklist.md). The short list:

1. Store search by eye for "Days To Go", and a trademark search (the code-side search found no exact match on 2026-09-26; the search is relevance-capped).
2. **Waived by the owner on 2026-09-26** (`../docs/publish-checklist.md`): the beta round trip on the FR965 (T2 phone date survives, T4 picker and phone do not destroy each other). It can still be run any time with a Beta App upload. Until it is, the description must not promise that the phone saves the date, and the "set it on the watch" sentence stays out.
3. The always-on night and wear day on the FR965 (checklist gates 4 and 5).
4. Real launcher icon (the file in `resources/drawables/` is a simple placeholder: a mint ring and a "1"), cover, hero and screenshots.
5. Site pages live (`npm run deploy` in `verden-site/`): support and privacy must be reachable before review.
6. Native-speaker read of any translation you ship as store copy (see "Languages").

## Edits that depend on the device test (only if the beta round trip is run later)

- **T4 passes** (picker and phone coexist): add to the description, after "Set the date from plain lists": `On many watches you can also set the date on the watch itself: choose the face, then Customize.` Never drop "on many watches": the SDK lists the on-watch settings screen for 94 of the 117 products.
- **T2 fails** (phone lists lose the value): the on-watch picker becomes the main route; rewrite that paragraph and escalate to the owner before submitting.

## Description rules

- One box per language, 4000 characters, plain text: the store shows `**` and `>` literally and keeps every line break.
- The first sentence carries the weight (the store truncates in list views); the last line is the support URL (the form has no support field).
- No watch count, no brand names, no battery or ghosting claims, no download or rating numbers, no "the only countdown with no permissions". Claims allowed: [`../docs/release-contract.md`](../docs/release-contract.md).
- Paid: disclose the price position honestly; the refund position is Garmin's return window, do not restate it in copy.

## Why each answer

| Field | Reason |
|---|---|
| Category | Utility: it is a utility face; Simple is the alternative |
| Keywords | Each is something the face does. "always-on" is a real drawn frame, but ghosting is unmeasured; drop it if reviewers object |
| Collects user data | Nothing leaves the watch; no permissions |
| Monetization | No. The form's own wording: Yes only if the app asks for payment to enable features, or for tips or donations; Days To Go does neither. HeroFace was submitted the same way and is paid through the store. (HeroSet's README records `Paid: Yes, USD 2.00` for what may be a different step of the form: read the form's wording at submission.) |
| Price | Paid, the lowest tier: USD 2.00, shown as $1.99 in the US, the same tier as HeroFace and HeroSet (owner decision, ADR-002). The form has no price field of its own in HeroFace's notes; if a merchant step appears choose "Yes, through Garmin CIQ merchant account". The offered watch list and countries shrink to Garmin's lists. Price is set at submission; re-pricing an approved app removes it for re-review (SDK `Monetization/App_Sales`). Price review 45 days after approval |

## Languages

English plus 14 (dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr) exist as **on-watch strings** and are machine-drafted, not read by a native speaker. Captions are labels, not sentences, so no language needs plural agreement; Polish, Lithuanian, Ukrainian and Finnish therefore read slightly unnatural at some counts (for example 21). The store description is English only until the owner decides whether to translate it. Russian, Greek and Chinese are not included.

## Images

One 454 × 454 FR965 simulator screenshot and a 500 × 500 cover exist; see [`screenshots.md`](screenshots.md). More states (named event in weeks, last day in hours, TODAY) and a real launcher icon would help; generators to adapt are in `../../HeroFace/listing/src/`.

## Previous What's New blocks

- **1.0.0:** `First release.`
