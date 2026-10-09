# Two Suns (Free) listing: notes

What sits behind [`paste.md`](paste.md), the paste-ready copy. Nothing here is pasted into the form. Status 2026-10-05: **uploaded by the owner 2026-10-04 as a new app, in Garmin review** (the text below is the dated record of how it was drafted); built against the Free + Pro plan (WP5 and the WP10 description skeleton, `../../reports/Free and Pro ladder execution plan.md`). Decision records: ADR-020 (Free + Pro ladder, accepted 2026-10-04) and ADR-021 (Body Battery in Free, accepted 2026-10-04) in [`../docs/decisions.md`](../docs/decisions.md). Claims are checked against [`../docs/release-contract.md`](../docs/release-contract.md), which has a "Free and Pro listings" section.

## Owner decisions (not made here)

| Decision | Placeholder in the draft |
|---|---|
| Store title (Free) | "Two Suns" (the plan's placeholder); store-collision check by eye first |
| On-watch app name | "Two Suns" (`../resources-free/strings/strings.xml`) |
| Pro's name and title | "Two Suns Pro" (placeholder; the Pro title is not drafted here) |
| Pro's store URL (line 1) | `<PRO STORE URL ...>`: needs Pro live (or upload Pro first); at submission the line must be the real URL, not a placeholder |
| Pro's price | The $2.50 tier (ADR-026, price: the $2.50 tier for every paid app), set in the form with the 1.1.0 upload (documented $1.99, $2.25 shown in the store until then). **The listing never states a price** |
| Icon, cover, hero, screens | Rendered 2026-10-04 from the Free build (simulator, canned data); looks and identity are still the owner's to approve. The plain ring (no golden arcs, no "PRO" pill) tells Free from Pro: a proposal |
| Whether the date row and ring orientation are Pro only | The plan puts both in Pro; Free is a thinner face without them. The draft does not mention them (the release contract: the Free listing never names Pro-only features) |
| The empty Body Battery state (ADR-021, Body Battery in Free) | `--` and a hollow bolt (the existing display; the pill became a bolt in ADR-023). The alternative is a worded value ("No data"), which needs 15 languages of machine-drafted text |
| Translations | English only; any translation is machine-drafted and needs the owner's OK and a native read (`../listing/NOTES.md` "Languages") |
| Upload order | Free (new app) first, Pro 1.1.0 the same day |
| Whether line 1 is the sibling URL | The plan (D8) puts it first. It costs the list-view preview, which shows the first sentence; the Pro listing's rule was that the first sentence carries the promise. The owner may move the URL line below the promise sentence |
| Support and privacy pages | The draft links `/two-suns/support/`. The site's Two Suns pages describe the place, `Positioning` and Body Battery history, which Free does not have: WP8 needs per-tier wording before the Free listing is submitted (`site/` is not touched by this work) |

## Claim check against the release contract

| Claim in the description | Allowed because |
|---|---|
| The time is the largest thing; no steps, heart rate, weather or advice | The layout and the non-goals (`../docs/spec.md`); same sentence as the Pro listing |
| A 24-hour ring, noon at the top, night dim, daylight lit in the accent and dimmer once passed, ticks, a sun marker solid while up | `TwoSunsRingPlan`/`TwoSunsRing` and their tests (simulator); a description of design |
| "From your watch's own sunrise and sunset" | `Complications` SUNRISE and SUNSET (ADR-003, sunrise and sunset from Complications); the Pro listing's own words. **Not claimed:** that they match the watch's glance (device compare, `../docs/release-contract.md`) |
| Garmin's own Body Battery number, as Garmin reports it, a level bar, no advice; two dashes when none | ADR-021 (Body Battery in Free) and ADR-008 (no verdicts on Body Battery); the strings; test `freeBatteryIsTheComplicationOnly` (compiled, not run). **Not claimed:** accuracy, "live", "last 24 hours" (Free has no history and no timestamp) |
| One setting: six accent colours, in Garmin Connect or on the watch | `resources-free/settings` (Accent ids 0 to 5), the on-watch Customize menu (ADR-019, on-watch Customize; confirmed on the FR965 for the pre-split build only, 2026-09-27); `tools/check_free_package.sh` for the keys |
| Dims to a quiet time, number and sun line when the screen sleeps | The always-on frame (AMOLED); **no ghosting or battery claim**, forbidden until measured |
| On a round screen the ring runs around the bezel, on a rectangular one a track along the glass, on black-and-white screens a small dial in the round window (from 1.1.0; was "Fits round and rectangular watches alike") | ADR-028 (rectangles: the sky ring follows the screen) and ADR-024 (Instinct E and 3 Solar); screen-fit tests in both tiers on every `fit_all.sh` device and both rectangles (simulator, 2026-10-08). Earlier: "Full detail down to the smallest" was dropped from this draft; the same phrase in `../listing/paste.md` line 42 is **to verify** (noted in `../listing/NOTES.md`, not edited) |
| "This free version reads only your watch's own sunrise, sunset and Body Battery numbers. No location, no account, no internet, no analytics, no ads. It stores no place and no history; the only thing it saves is your accent colour setting." | The Free manifest has `ComplicationSubscriber` alone, no network code, no place and no `Application.Storage` call compiled in (`tools/check_free_package.sh`, the compiler); the accent colour is a Properties value. "No analytics, no ads" are the words the Pro listing already uses |
| Device claims | **No device sentence and no watch model name in listing text** (owner, 2026-10-04): the store's device tab is the claim. The former `meta.yaml` `held_back_text` sentences are deleted (their old wording: "Pro is sold only on watches Garmin lists for paid apps; this version can also be installed on some watches Pro cannot be bought for", and the Instinct dial sentence for "One face, every screen"). No watch count (the contract forbids "works on X" for a watch only the simulator has seen) |

Not claimed anywhere: battery figures, always-on ghosting, MIP contrast, any watch count, download, rating or review number, "works without GPS or your phone" (not run), accuracy of the sun times or of Body Battery, rivals by name.

## Instinct

The description and What's New say nothing about Instinct or any other model; ADR-024 and the compatibility doc keep the facts.

## Description rules

Same as [`../listing/NOTES.md`](../listing/NOTES.md): one box per language, 4000 characters, plain text (the store keeps line breaks and shows `**` literally), describe what the app is, the last line is the support URL (the form has no support field). The Free description follows the WP10 skeleton: sibling line, promise, what Free has, a one-sentence review request, permissions in plain words. **"More from Verden" is left out**: it lists only live free siblings, and none is known to be live today.

## Why each answer

| Field | Reason |
|---|---|
| Category | Utility, as the Pro listing |
| Collects user data | No: Free reads no location and keeps no place; nothing leaves the watch |
| Monetization | No: Free asks no payment and unlocks nothing in-app (Pro is a separate app). The form's wording decides at submission |
| App Migration | No: a new app id, not a newly compatible device on an existing app |
| What's new | Blank, this app's rule for an initial release (`../listing/NOTES.md`: the form has no "first release" field and the text reads as noise); an optional draft line is in `meta.yaml` `owner_approvals` |
| Price | $0 (free). The Free listing is the only listing where "free" wording is allowed (release contract) |
| Additional Hardware Requirements | Paste the bare URL `https://verden.watch/two-suns/` only (API field `hardwareProductUrl`; the old sentence is retired, ROADMAP 10.16) |
| Refund wording | No refund or return wording appears in listing text (owner decision, 2026-10-04). |
| Device reach (ROADMAP 10.15) | Two Suns has almost no Free-only reach: every one of its 72 products except D2 Air X10 is on Garmin's paid list (the Instinct E and 3 Solar included), and D2 Air X10 is one of the 11 products no paid app is sold on ([`../docs/release-contract.md`](../docs/release-contract.md) "Paid vs free reach"). No device sentence goes into the listing either way |

## What's New: history

- **1.0.0** (uploaded 2026-10-04, in review): blank (initial release).

## 1.1.0: what `paste.md` now holds (prepared 2026-10-08, not uploaded)

- **Version** `1.1.0` (next minor; App Version is free text in the form). It can go up while 1.0.0 is still in review (`../../research_notes/Free and Pro ladder/garmin_rules.md`).
- **What's New:** the Free side of `../CHANGELOG.md` "Free 1.1.0": the rectangles' own design (ADR-028 (rectangles: the sky ring follows the screen)), the Body Battery number in one colour at any level (ADR-008 (no verdicts on Body Battery), amended), the grey `--` (ADR-021 (Body Battery in Free), amended), the solid bolt, the daylight wording. No Pro-only item (curve, weather, battery row), no watch model, no language.
- **Description fixed for the new build (upload gate of 2026-10-08):** the ring sentence and "One face, every screen" rewritten as in the Pro listing (`../listing/NOTES.md` "Pro 1.2.0"). Spanish and Chinese mirrored.

## After approval (plan WP5, WP9)

1. Read the Free listing's real compatible-device list and record it in `../docs/compatibility.md` (no device sentence goes into listing text).
2. Put the live Free URL on the first line of the Pro listing ("Also available: Two Suns, a lighter version: <URL>"; the paid listing must not say "free") and the live Pro URL here.
3. Record both app ids and the approval dates for the gates G1 to G4 in the ladder plan; do not turn download buckets into revenue.
4. Send nothing to Garmin about twins until the owner decides (the email is the owner's).

## 2026-10-04: what moved out of `paste.md` (owner rule: paste.md holds only what is pasted or uploaded)

- **Form:** https://apps.garmin.com/developer/upload; two steps, attach the `.iq`, then the details. One block is one field. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml); the approvals the owner owes are in its `owner_approvals`.
- **Title:** "Two Suns" is the plan placeholder; the owner decides, and searches the store by eye for a collision first.
- **Description:** line 1 holds the sibling's store URL (filled 2026-10-04; the link works once Garmin approves that listing). English only until the owner decides on translations.
- **Version:** the form reads it from the package; if a field asks, type it. **What's New:** blank, per this app's rule for an initial release; the optional draft line is in `meta.yaml` `owner_approvals`.
- **Collects user data:** No; Free reads no location and keeps no place; nothing leaves the watch. The privacy-policy URL field is conditional on Yes, so it may not appear.
- **Category:** Utility (alternative: Health & Fitness, as for Pro). **Subcategory:** whatever the Category choice offers. **Preview Video:** none (YouTube or Vimeo only). **App Migration:** No; a new app, not an update.
- **Monetization:** No: the Free app asks for no payment and unlocks nothing. Read the form's own wording at submission.
- **Hardware field:** the bare URL only; the store API names it `hardwareProductUrl`, and a live listing's value is a bare URL (owner, 2026-10-02; Garmin research 2026-10-04).
- **Images:** the owner approves the looks first; five images from the Free build, simulator only with canned data (sun times and the Body Battery number are set for the picture, never a reading); hero 145 KB (no curve, no date, nothing from Pro), cover 12 KB (the plain ring, no golden arcs, no pill; Pro's cover has both). Captions and devices are in `meta.yaml` `assets.screens`; details and commands in [`screenshots.md`](screenshots.md). Do not describe the black-and-white shot as a supported-device claim.

## 2026-10-04: cover and hero on a coloured ground (ROADMAP 10.25)

Garmin's brand page: "Do not choose black or transparent backgrounds"; the owner chose light or coloured covers. Chosen for Free: **sky blue `#55AAFF` ground** (the default Sky accent), navy name with "Suns" in the night blue `#1B2A8F`, white daylight arc, no pill. Looked at at 500 px and at 100 px. Rejected, rendered and looked at:

- **Pale blue `#E4F1FF` ground** with the ring in full face colours: weak presence at 100 px, and nothing but the missing pill told it from Pro's pale twin.
- **Deeper blue `#2F8CF0`** with white text and an amber sun: strong, but white on it is 3.5:1 and it is not a palette value.
- **White "Suns" on `#55AAFF`** (first try): 2.3:1, so "Suns" became the night blue.

Open for the owner: the look; the device icons stay on black (Garmin's sentence is about the cover; the icon carries no text).

## Instinct image, black and white only (2026-10-08)

`screens-framed/4-instinct-e45.png` (instincte45mm): re-framed 2026-10-08 (99 KB, under the 150 KB cap): the Instinct E skin's display hole carries a ghost of Garmin's sample screen at alpha 1 to 25 of 255, which the framing composited over the black screen as faint grey marks (inside the dial and under the sun line); `docker/frame_shot.sh` now clears alpha under 10% inside the display rectangle (the opaque bezel and window rim stay). The capture `screens/4-instinct-e45.png` was checked: 176 x 176, pure black and white (2 colours), so nothing to snap. Only the faint marks went; the screen content is the same. The four round frames were not replaced (re-framing them changed only anti-aliased edge pixels).
