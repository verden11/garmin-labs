# HeroFace (Free) listing: notes

What sits behind [`README.md`](paste.md), the paste-ready copy. Nothing here is pasted into the form. Status 2026-10-01: **draft, UNRELEASED, simulator tests passed (24 on each jungle on fr965, fenix5s, fr55, 2026-10-01), nothing uploaded, nothing on a wrist**; built against the Free + Pro plan (WP6 and the WP10 description skeleton, `../../reports/Free and Pro ladder execution plan.md`). Decision record: ADR-001 (Free + Pro ladder, proposed) in [`../docs/decisions.md`](../docs/decisions.md). Claims are checked against "Claims allowed and forbidden" in [`../docs/status.md`](../docs/status.md) (HeroFace has no separate release-contract file).

## Owner decisions (not made here)

| Decision | Placeholder in the draft |
|---|---|
| Store title (Free) | "HeroFace" (the current store title); the plan's WP6 does not propose a different one. Store-collision check by eye first |
| On-watch app name | "HeroFace" (`../resources-free/strings/strings.xml`) |
| Pro's name and title | "HeroFace Pro" (plan WP6 step 5: renamed **inside the pending listing-repair submission**, keeping its device tokens in the title) |
| Pro's store URL (line 1) | `<PRO STORE URL ...>`: needs Pro live (or upload Pro first); the line must be the real URL, not a placeholder, at submission |
| HeroSet's store URL (the "With HeroSet" paragraph) | Filled in 2026-10-04 from the live listing (the site's `storeUrl`); add HeroSet Free's URL when it exists |
| Pro's price | The $2.50 tier from the 1.1.0 upload (live at the $2.00 tier until then; ADR-004, price: the $2.50 tier for every paid app). **The listing never states a price** |
| Icon, cover, hero, screens | **Rendered 2026-10-04 for the owner's look-approval** ([`screenshots.md`](screenshots.md)): five Free-build simulator screens (one from an Instinct E 40 mm), a hero showing the three accents, the plain mark as cover and icons. **Design proposal, OWNER decides:** Free = the plain mark, Pro = the same mark with a small white "PRO" pill (cover, both icons, hero). Free's pictures show only what Free has (no temperature, no seconds, bars on Auto, accent, HeroSet mode); the HeroSet value in shot 4 is canned in the simulator's private copy. The on-watch launcher icon is shared by both tiers and unchanged |
| Translations | English only; any translation is machine-drafted and needs the owner's OK and a native read (`../listing/NOTES.md` "Languages") |
| Upload order | Free (new app) first, Pro 1.1.0 the same day |
| Whether line 1 is the sibling URL | The plan (D8) puts it first. It costs the list-view preview, which shows the first sentence; the owner may move the URL line below the promise sentence |

## Owner to confirm: the Free listing may name Pro

The rule "no Pro word in Free" (`../docs/decisions.md`, enforced by `tools/check_free_package.sh`) covers the **watch app and its settings only**, not the store listing. This draft's description names "HeroFace Pro" on line 1 (the sibling URL, as the plan puts it first) and in a "HeroFace Pro adds" paragraph. That is store text, not an upgrade prompt on the watch, but it is the owner's call whether the Free listing should mention Pro at all and where; move or drop the paragraph and the line-1 URL if not.

## Claim check

| Claim in the description | Allowed because |
|---|---|
| The time is the largest element; three goal bars (steps, intensity minutes, floors) with fallbacks; a whole-day ring | Plan "Missions are slots", the layout and fit tests (simulator only); the live Pro listing says the same |
| Bars fall back to what the watch measures | The fallback chains (`HeroFaceConfig.SLOT_CHAINS`), `fr245` run in the simulator (2026-09-22, Pro 1.0.1) |
| A gold streak line counts days in a row | `HeroFaceStreak`, logic tests; unchanged by the split |
| Blue, cyan or magenta accent | The Accent list, ids 0 to 2 in both tiers; `shippedAccentIdsKeepTheirColours` (passes in the simulator, both jungles). Magenta is `#FFAAFF` since 2026-10-04 (ADR-003) and clears the face's own 3:1 track rule (4.42:1); no claim about it** |
| HeroSet mode needs HeroSet installed; bars show reps, rank, streak; holding the face opens HeroSet; **Connect IQ 4.2+** | Plan "Two modes", the link on the FR965 from 2026-09-20 (**the paid app's id; the Free app id has never been tried against HeroSet's private complication**, `../docs/status.md` F7) |
| "Without HeroSet, nothing is missing" | The same sentence the live Pro listing uses; Free shows everyday goals when no complication exists |
| Dims to a quiet clock that shifts every minute on always-on watches | The always-on frame; **no ghosting or battery claim**, forbidden until measured |
| "Up to a 466-pixel fēnix", "round watches" | Screen-fit on ten sizes (Pro build, simulator); the Free build's fit run is still to do |
| No account, no internet, no analytics, no ads; the permission sentence | `manifest.free.xml` asks for `ComplicationSubscriber` only, same as Pro; no network code. The wording is the live Pro listing's |
| Pro's additions | Exactly what `(:pro)` compiles in: the metric per bar (Slot 1 to 3), Seconds, Weather (the temperature). Nothing else is claimed |

Not claimed anywhere: battery figures, always-on ghosting, MIP contrast, any watch count, download, rating or review number, "works with every Garmin", accuracy of any kind, a "free" or "Pro" claim about the paid listing.

## Device sentence and Instinct (ROADMAP 10.15, 2026-10-04)

Garmin's paid-app list excludes the Instinct 2, 2S, 2X and Descent G1 and 37 older products (Forerunner 245/945 and others), plus 11 listed products no paid app is sold on; the paid HeroFace Pro cannot reach any of them, the Free twin can (counts in [`../docs/compatibility.md`](../docs/compatibility.md) "Paid vs free reach"). That is a genuine plus, so a one-sentence version is kept in `meta.yaml` `held_back_text`: "HeroFace Pro is sold only on watches Garmin lists for paid apps; this version also installs on some watches Pro cannot be bought for, including the Instinct 2, 2S, 2X and Descent G1." It is not in `paste.md` because the claim is only true once the Free listing's own Compatible Devices list shows those watches and the Instinct upload is approved (the template's rule, [`../../reports/listing-template.md`](../../reports/listing-template.md) section 4); paste it after "HeroFace Pro adds" then.

## Instinct

The Instinct ring-gauge sentence is out of the paste text until the upload is approved and the store lists those watches; the sentence is kept in `meta.yaml` (`held_back_text`; ADR-002, Instinct family, proposed).

## Description rules

Same as [`../listing/NOTES.md`](../listing/NOTES.md): one box per language, 4000 characters, plain text (the store keeps line breaks and shows `**` literally), describe what the app is, the last line is the support URL (the form has no support field). The Free description follows the WP10 skeleton: sibling line, promise, what Free has, one line that HeroSet mode needs HeroSet, "Pro adds", permissions in plain words. The one-line review request ("If this face works for you, a rating in the store helps other people find it.", owner, 2026-10-04, DayArc's wording) is in; the device sentence is left out until the Free listing's real device list is visible. **"More from Verden" is left out**: it lists only live free siblings, and none is known to be live today.

## Why each answer

| Field | Reason |
|---|---|
| Category | Digital, as the Pro listing |
| Collects user data | No: nothing leaves the watch |
| Monetization | No: Free asks no payment and unlocks nothing in-app (Pro is a separate app). The form's wording decides at submission |
| App Migration | No: a new app id, not a newly compatible device on an existing app |
| Price | $0 (free) |
| Additional Hardware Requirements | Paste the bare URL `https://verden.watch/heroface/` only (API field `hardwareProductUrl`; the old sentence is retired, ROADMAP 10.16) |
| Refund line | None: a free app has nothing to refund |

## After approval (plan WP6, WP9)

1. Read the Free listing's real compatible-device list and decide on a device sentence only if it shows watches the paid listing cannot reach.
2. Put the live Free URL on the first line of the Pro listing and the live Pro URL here.
3. Record both app ids, the approval dates and the exposure-test day-0 and day-30 dates (plan WP6 "Done when") so the ratio stays readable.
4. Send nothing to Garmin about twins until the owner decides.
