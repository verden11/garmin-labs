# HeroFace (Free) listing: notes

What sits behind [`paste.md`](paste.md), the paste-ready copy. Nothing here is pasted into the form. Status 2026-10-05: **uploaded by the owner 2026-10-04 as a new app, in Garmin review** (the text below is the dated record of how it was drafted); built against the Free + Pro plan (WP6 and the WP10 description skeleton, `../../reports/Free and Pro ladder execution plan.md`). Decision record: ADR-001 (Free + Pro ladder, accepted 2026-10-04) in [`../docs/decisions.md`](../docs/decisions.md). Claims are checked against "Claims allowed and forbidden" in [`../docs/status.md`](../docs/status.md) (HeroFace has no separate release-contract file).

## Owner decisions (not made here)

| Decision | Placeholder in the draft |
|---|---|
| Store title (Free) | "HeroFace" (the current store title); the plan's WP6 does not propose a different one. Store-collision check by eye first |
| On-watch app name | "HeroFace" (`../resources-free/strings/strings.xml`) |
| Pro's name and title | "HeroFace Pro" (plan WP6 step 5: renamed **inside the pending listing-repair submission**, keeping its device tokens in the title) |
| Pro's store URL (line 1) | `<PRO STORE URL ...>`: needs Pro live (or upload Pro first); the line must be the real URL, not a placeholder, at submission |
| HeroSet's store URL (the "With HeroSet" paragraph) | Filled in 2026-10-04 from the live listing (the site's `storeUrl`); add HeroSet Free's URL when it exists |
| Pro's price | The $2.50 tier from the 1.1.0 upload (live at the $2.00 tier until then; ADR-004, price: the $2.50 tier for every paid app). **The listing never states a price** |
| Icon, cover, hero, screens | **Rendered 2026-10-04 for the owner's look-approval** ([`screenshots.md`](screenshots.md)): five Free-build simulator screens (one from an Instinct E 40 mm), a hero showing the three accents, the plain mark as cover and icons. **Cover and hero are on a solid sky-blue background (2026-10-04, ROADMAP 10.25: Garmin's brand page says not to choose black or transparent backgrounds; owner decision). Variants tried and rejected: a near-white `#F2F6FB` ground with the mark's own colours and a navy name (clean, but the pale ring track and the white Free/Pro difference disappear next to the store's white page, so it has the least pull at 100 px); a pale-magenta `#FFAAFF` ground (Pro's own accent; reads as a different product and clashes with the blue Free accent); a deep royal blue for Free too (taken by Pro instead, so the two tiers differ without the pill alone carrying it). The 128x128 device icons are unchanged: the quote is about the 500x500 cover and the store shows device icons on the watch's own black.** **Design proposal, OWNER decides:** Free = the plain mark, Pro = the same mark with a small white "PRO" pill (cover, both icons, hero). Free's pictures show only what Free has (no temperature, no seconds, bars on Auto, accent, HeroSet mode); the HeroSet value in shot 4 is canned in the simulator's private copy. The on-watch launcher icon is shared by both tiers and unchanged |
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
| "Up to the largest 466-pixel round screens", "round watches" (was "up to a 466-pixel fēnix"; no model name in listing text) | Screen-fit on ten sizes (Pro build, simulator); the Free build's fit run is still to do |
| No account, no internet, no analytics, no ads; the permission sentence | `manifest.free.xml` asks for `ComplicationSubscriber` only, same as Pro; no network code. The wording is the live Pro listing's |
| Pro's additions | Exactly what `(:pro)` compiles in: the metric per bar (Slot 1 to 3), Seconds, Weather (the temperature). Nothing else is claimed |

Not claimed anywhere: battery figures, always-on ghosting, MIP contrast, any watch count, download, rating or review number, "works with every Garmin", accuracy of any kind, a "free" or "Pro" claim about the paid listing.

## Device sentence and Instinct (ROADMAP 10.15, 2026-10-04)

Garmin's paid-app list excludes the Instinct 2, 2S, 2X and Descent G1 and 37 older products (Forerunner 245/945 and others), plus 11 listed products no paid app is sold on; the paid HeroFace Pro cannot reach any of them, the Free twin can (counts in [`../docs/compatibility.md`](../docs/compatibility.md) "Paid vs free reach"). That is a genuine plus, but listing text never names watch models and carries no device sentence (owner, 2026-10-04): the store's device tab, taken from each build, is the claim, so the former `meta.yaml` `held_back_text` sentences are deleted (their old wording: "HeroFace Pro is sold only on watches Garmin lists for paid apps; this version also installs on some watches Pro cannot be bought for, including the Instinct 2, 2S, 2X and Descent G1", and an Instinct ring-gauge sentence).

## Instinct

The description says nothing about Instinct or any other model; ADR-002 (Instinct family, accepted 2026-10-04) and the compatibility doc keep the facts.

## Description rules

Same as [`../listing/NOTES.md`](../listing/NOTES.md): one box per language, 4000 characters, plain text (the store keeps line breaks and shows `**` literally), describe what the app is, the last line is the support URL (the form has no support field). The Free description follows the WP10 skeleton: sibling line, promise, what Free has, one line that HeroSet mode needs HeroSet, "Pro adds", permissions in plain words. The one-line review request ("If this face works for you, a rating in the store helps other people find it.", owner, 2026-10-04, DayArc's wording) is in. **"More from Verden" is left out**: it lists only live free siblings, and none is known to be live today.

## Why each answer

| Field | Reason |
|---|---|
| Category | Digital, as the Pro listing |
| Collects user data | No: nothing leaves the watch |
| Monetization | No: Free asks no payment and unlocks nothing in-app (Pro is a separate app). The form's wording decides at submission |
| App Migration | No: a new app id, not a newly compatible device on an existing app |
| Price | $0 (free) |
| Additional Hardware Requirements | Paste the bare URL `https://verden.watch/heroface/` only (API field `hardwareProductUrl`; the old sentence is retired, ROADMAP 10.16) |
| Refund wording | No refund or return wording appears in listing text (owner decision, 2026-10-04). |

## What's New: history

- **1.0.0** (uploaded 2026-10-04, in review): `First release of the free HeroFace: the time, three goal bars, a progress ring, your streak, three accent colours, and HeroSet mode if you have HeroSet.`

## 1.1.0: what `paste.md` now holds (prepared 2026-10-08, not uploaded)

- **Version** `1.1.0` (next minor; App Version is free text in the form). It can go up while 1.0.0 is still in review (`../../research_notes/Free and Pro ladder/garmin_rules.md`).
- **What's New:** the Free side of `../CHANGELOG.md` "Free 1.1.0": the rectangles (ADR-005 (rectangular watches, the ring as a frame)), the bar icons, the ring without the move bar, GO only, the centred streak, the always-on grey (ADR-006). No temperature line (Free has none), no watch model, no language.
- **Description fixed for the new build (upload gate of 2026-10-08):** the ring sentence now says it turns green when the goals are all met and that a move bar (where Auto falls back to it, e.g. no barometer) stays out of the ring; "Round watches, one design" is now "Round or rectangular, one design". Spanish and Chinese mirrored.

## After approval (plan WP6, WP9)

1. Read the Free listing's real compatible-device list and record it in `../docs/compatibility.md` (no device sentence goes into listing text).
2. Put the live Free URL on the first line of the Pro listing and the live Pro URL here.
3. Record both app ids, the approval dates and the exposure-test day-0 and day-30 dates (plan WP6 "Done when") so the ratio stays readable.
4. Send nothing to Garmin about twins until the owner decides.

## 2026-10-04: what moved out of `paste.md` (owner rule: paste.md holds only what is pasted or uploaded)

- **Form:** https://apps.garmin.com/developer/upload; two steps, attach the `.iq`, then the details. One block is one field. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml); the approvals the owner owes are in its `owner_approvals`.
- **Description:** line 1 holds the sibling's store URL (filled 2026-10-04; the link works once Garmin approves that listing); the HeroSet sentence carries HeroSet's live store URL (from the site's `storeUrl`). English only until the owner decides on translations. Check each block for a `<` before pasting.
- **Hero, cover, icons:** the Pro listing's images carry a PRO pill, these do not; do not swap them, and do not use the Pro cover here. (The image sections of `paste.md` now list files only; captions and devices are in `meta.yaml` `assets.screens`.)
- **Category:** Digital, as the Pro listing. **Subcategory:** whatever the Category choice offers. **Collects user data:** No; the privacy-policy URL field is conditional on Yes, so it may not appear. **Preview Video:** none (YouTube or Vimeo only).
- **App Migration:** No; this is a new app, not an update.
- **Monetization:** No: the Free app asks for no payment and unlocks nothing. Read the form's own wording at submission (`../listing/NOTES.md` records that the wording is easy to misread).
- **Hardware field:** the bare URL only; the store API names it `hardwareProductUrl`, and a live listing's value is a bare URL (owner, 2026-10-02; Garmin research 2026-10-04).

## Instinct image, black and white only (2026-10-08)

`screens-framed/5-instinct-e40.png` (instincte40mm): re-framed 2026-10-08 (105 KB, under the 150 KB cap): the Instinct E skin's display hole carries a ghost of Garmin's sample screen at alpha 1 to 25 of 255 (6,500 to 10,700 pixels), which the framing composited over the black screen as faint grey marks; `docker/frame_shot.sh` now clears alpha under 10% inside the display rectangle (the opaque bezel and window rim stay). The capture was checked: pure black and white (2 colours), so nothing to snap; `screens/native/` re-made from the x3 copy (`-sample`, exact). Only the faint marks went; the screen content is the same.
