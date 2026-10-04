# Two Suns (Free) listing: notes

What sits behind [`README.md`](paste.md), the paste-ready copy. Nothing here is pasted into the form. Status 2026-10-01: **draft, UNRELEASED, simulator only, nothing uploaded**; built against the Free + Pro plan (WP5 and the WP10 description skeleton, `../../reports/Free and Pro ladder execution plan.md`). Decision records: ADR-020 (Free + Pro ladder, proposed) and ADR-021 (Body Battery in Free, proposed) in [`../docs/decisions.md`](../docs/decisions.md). Claims are checked against [`../docs/release-contract.md`](../docs/release-contract.md), which has a "Free and Pro listings" section.

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
| The empty Body Battery state (ADR-021, Body Battery in Free) | `--` and a hollow pill (the existing display). The alternative is a worded value ("No data"), which needs 15 languages of machine-drafted text |
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
| Fits round and rectangular watches alike | Screen-fit tests on every size (simulator, 2026-09-27, Pro build); the Free build's fit run is still to do. "Full detail down to the smallest" was dropped from this draft; the same phrase in `../listing/paste.md` line 42 is **to verify** (noted in `../listing/NOTES.md`, not edited) |
| "This free version reads only your watch's own sunrise, sunset and Body Battery numbers. No location, no account, no internet, no analytics, no ads. It stores no place and no history; the only thing it saves is your accent colour setting." | The Free manifest has `ComplicationSubscriber` alone, no network code, no place and no `Application.Storage` call compiled in (`tools/check_free_package.sh`, the compiler); the accent colour is a Properties value. "No analytics, no ads" are the words the Pro listing already uses |
| The device sentence | Says only that Pro is sold on Garmin's paid-app list and that this version can also be installed on some watches Pro cannot be bought for. **Not in the paste text**: it is in `meta.yaml` `held_back_text`. **To verify** against the SDK's `Monetization/App_Sales` list and the store form's device lists after approval; the draft marks it for the owner. **No watch names or count** (the contract forbids "works on X" for a watch only the simulator has seen) |

Not claimed anywhere: battery figures, always-on ghosting, MIP contrast, any watch count, download, rating or review number, "works without GPS or your phone" (not run), accuracy of the sun times or of Body Battery, rivals by name.

## Instinct

The Instinct wording is out of the paste text until the upload is approved and the store lists those watches; the sentence is kept in `meta.yaml` (`held_back_text`).

## Description rules

Same as [`../listing/NOTES.md`](../listing/NOTES.md): one box per language, 4000 characters, plain text (the store keeps line breaks and shows `**` literally), describe what the app is, the last line is the support URL (the form has no support field). The Free description follows the WP10 skeleton: sibling line, promise, what Free has, a one-sentence review request, permissions in plain words. **"More from Verden" is left out**: it lists only live free siblings, and none is known to be live today.

## Why each answer

| Field | Reason |
|---|---|
| Category | Utility, as the Pro listing |
| Collects user data | No: Free reads no location and keeps no place; nothing leaves the watch |
| Monetization | No: Free asks no payment and unlocks nothing in-app (Pro is a separate app). The form's wording decides at submission |
| App Migration | No: a new app id, not a newly compatible device on an existing app |
| What's new | Blank, this app's rule for an initial release (`../listing/NOTES.md`); a draft line is in the README |
| Price | $0 (free). The Free listing is the only listing where "free" wording is allowed (release contract) |
| Additional Hardware Requirements | Paste the bare URL `https://verden.watch/two-suns/` only (API field `hardwareProductUrl`; the old sentence is retired, ROADMAP 10.16) |
| Refund line | None: a free app has nothing to refund |
| Device sentence (ROADMAP 10.15) | Two Suns has almost no Free-only reach: every one of its 72 products except D2 Air X10 is on Garmin's paid list (the Instinct E and 3 Solar included), and D2 Air X10 is one of the 11 products no paid app is sold on. The held-back sentence is therefore not a genuine plus; the owner may drop it rather than paste it ([`../docs/release-contract.md`](../docs/release-contract.md) "Paid vs free reach") |

## After approval (plan WP5, WP9)

1. Read the Free listing's real compatible-device list and replace the device sentence with a more specific one only if the list shows those watches.
2. Put the live Free URL on the first line of the Pro listing ("Also available: Two Suns, a lighter version: <URL>"; the paid listing must not say "free") and the live Pro URL here.
3. Record both app ids and the approval dates for the gates G1 to G4 in the ladder plan; do not turn download buckets into revenue.
4. Send nothing to Garmin about twins until the owner decides (the email is the owner's).
