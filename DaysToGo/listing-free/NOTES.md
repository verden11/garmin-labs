# Days To Go (Free) listing: notes

What sits behind [`paste.md`](paste.md), the paste-ready copy. Nothing here is pasted into the form. Status 2026-10-05: **uploaded by the owner 2026-10-04 as a new app, in Garmin review** (the text below is the dated record of how it was drafted); built against the Free + Pro plan (WP4 step 6 and the WP10 description skeleton, `../../reports/Free and Pro ladder execution plan.md`). Decision record: ADR-014 (Free + Pro ladder, accepted 2026-10-04) in [`../docs/decisions.md`](../docs/decisions.md). Claims are checked against [`../docs/release-contract.md`](../docs/release-contract.md), which now has a "Free and Pro listings" section.

## Owner decisions (not made here)

| Decision | Placeholder in the draft |
|---|---|
| Store title (Free) | "Days To Go: Countdown to a Date" (31 characters, the plan's proposal); store-collision check by eye first |
| On-watch app name | "Days To Go" (`../resources-free/strings/strings.xml`) |
| Pro's name and title | "Days To Go Pro" / "Days To Go Pro: Countdown to the Minute" (2026-10-04, ADR-018; the earlier "Countdown, Hours, Footer" went stale) |
| Pro's store URL (line 1) | `<PRO STORE URL ...>`: needs Pro live (or upload Pro first); the line must be the real URL, not a placeholder, at submission |
| Pro's price | The $2.50 tier (ADR-017, price: the $2.50 tier for every paid app), set in the form with the 1.1.0 upload; today it is the lowest tier. **The listing never states a price** |
| Icon, cover, hero, screens | **Prepared 2026-10-04 as proposals** (see "Images" below); the owner approves or replaces the looks, and still owes the real launcher icon (ROADMAP 3.3) |
| Translations | English only; any translation is machine-drafted and needs the owner's OK and a native read (`../listing/NOTES.md` "Languages") |
| Upload order | Free (new app) first, Pro 1.1.0 the same day |
| Whether line 1 is the sibling URL | The plan (D8) puts it first. It costs the list-view preview, which shows the first sentence; the old Pro listing's rule was that the first sentence carries the promise. The owner may move the URL line below the promise sentence |

## Claim check against the release contract

| Claim in the description | Allowed because |
|---|---|
| Counts whole days; tomorrow is 1; the day says TODAY; the days since afterwards | Unit tests (calendar), `../docs/spec.md` "Rules the count follows" (simulator only) |
| Never shows a wrong number for 30 February | Test `impossibleEveryYearDatesAreInvalid` and the SET A DATE state |
| New Year's Day by default, so never empty | `DaysToGoSettings` defaults; the contract's "counts to New Year's Day" row |
| Six accent colours | The shipped Accent ids 0 to 5; test `shippedAccentIdsKeepTheirColours` (passed in the simulator, 2026-10-01) |
| A count in days or in weeks and days | Unit setting; test `weeksModeSplitsWeeksAndDays` |
| Dimming when the screen sleeps | The always-on frame (AMOLED); **no ghosting or battery claim**, forbidden until measured |
| "Round and rectangular watches alike, full detail down to the smallest" | Screen-fit tests on ten sizes and three rectangles (simulator, 2026-09-26, Pro build); the Free build's fit run is still to do |
| No permissions, no account, no internet | Empty permission list in `manifest.free.xml`; no network code (the contract's "no permissions; nothing leaves your watch" row; "no analytics, no ads" are the same words the live Pro listing already uses) |
| Pro's two additions | Exactly what `(:pro)` compiles in: the `Hour` setting (timed events, H:MM in the last 24 h) and the `Footer` setting (battery or steps). Nothing else is claimed; accent ids 6 to 11 and a new layout are deferred, not built |
| Device claims | **Not in the paste-ready text, now or later:** listing text never names watch models; the store's device tab is the claim (owner, 2026-10-04) |
| The review request | **In the Free description** (owner, 2026-10-04): "If this face works for you, a rating in the store helps other people find it." (DayArc's wording; it asks and claims nothing, `../docs/release-contract.md`). Free listing only. |

Not claimed anywhere: battery figures, always-on ghosting, MIP contrast, any watch count, download, rating or review number, "the only countdown with no permissions", "works on every watch", rivals by name, "set it on your watch" (the beta round trip T4 is still open, `../docs/status.md`).

## To verify after approval (not paste-ready)

- **Device sentence** (plan WP4 step 6, which proposed "Pro is sold only on devices Garmin lists for paid apps; this free version also runs on older watches such as FR245 and vívoactive 4"): dropped, no device sentence goes into listing text (owner, 2026-10-04). The contract forbids "works on X" for a watch only the simulator has seen.
- **Pro-available line**: the plan puts "say so on line 2" if Pro is offered on the reader's device. Nothing is claimed about Pro's availability until the Pro listing's device list is visible.

## Device sentence and Instinct (ROADMAP 10.15, 2026-10-04)

Garmin's paid-app list excludes the Instinct 2, 2S, 2X and Descent G1 and 37 older products (Forerunner 245/945 and others), plus 11 listed products no paid app is sold on; the paid Days To Go Pro cannot reach any of them, the Free twin can (counts in [`../docs/compatibility.md`](../docs/compatibility.md) "Paid vs free reach"). That is a genuine plus, but listing text never names watch models and carries no device sentence (owner, 2026-10-04): the store's device tab, taken from each build, is the claim, so the former `meta.yaml` `held_back_text` sentences are deleted (their old wording: "Days To Go Pro is sold only on watches Garmin lists for paid apps; this version also installs on some watches Pro cannot be bought for, including the Instinct 2, 2S, 2X and Descent G1", an Instinct ring-gauge sentence, and a What's New line "Works on the Instinct family too, in black and white (the accent colour does not apply there)").

## Instinct

The description and What's New say nothing about Instinct or any other model; ADR-015 and the compatibility doc keep the facts.

## Description rules

Same as [`../listing/NOTES.md`](../listing/NOTES.md): one box per language, 4000 characters, plain text (the store keeps line breaks and shows `**` literally), describe what the app is, the last line is the support URL (the form has no support field). The Free description follows the WP10 skeleton: sibling line, promise, what Free has, "Pro adds", the review request, permissions in plain words (no device sentence, see above). **"More from Verden" is left out**: it lists only live free siblings, and none is known to be live today; add up to four store URLs after a free sibling is approved.

## Why each answer

| Field | Reason |
|---|---|
| Category | Utility, as the Pro listing |
| Collects user data | No: nothing leaves the watch; no permissions |
| Monetization | No: Free asks no payment and unlocks nothing in-app (Pro is a separate app). The form's wording decides at submission |
| App Migration | No: a new app id, not a newly compatible device on an existing app |
| Price | $0 (free). The Free listing is the only listing where "free" wording is allowed (release contract) |
| Additional Hardware Requirements | Paste the bare URL `https://verden.watch/days-to-go/` only (API field `hardwareProductUrl`; the old sentence is retired, ROADMAP 10.16) |
| Refund wording | No refund or return wording appears in listing text (owner decision, 2026-10-04). |

## What's New: history

- **1.0.0** (uploaded 2026-10-04, in review): `First release of the free Days To Go: a big day count, your own date and name, six accent colours, days or weeks.`

## 1.1.0: what `paste.md` now holds (prepared 2026-10-08, not uploaded)

- **Version** `1.1.0` (next minor; App Version is free text in the form). It can go up while 1.0.0 is still in review.
- **What's New:** the Free side of `../CHANGELOG.md` "Free 1.1.0": more watches (the first-generation Venu Sq and Sq Music, not named), the square design (ADR-019), the ring's one scale, the date arrow, no on-watch date picker on two rectangles (ADR-020), the always-on grey (ADR-007 amendment). No Pro-only item (hours, bottom line), no watch model, no language.
- **Description fixed for the new build (upload gate of 2026-10-08):** the ring sentence and "One design, every screen" rewritten as in the Pro listing (`../listing/NOTES.md` "Pro 1.2.0"). Spanish and Chinese mirrored.

## After approval (plan WP4 step 6, WP9)

1. Read the Free listing's real compatible-device list and record it in `../docs/compatibility.md` (no device sentence goes into listing text).
2. Put the live Free URL on the first line of the Pro listing ("Also available: Days To Go (<URL>)", no "free" wording on the paid listing) and the live Pro URL here.
3. Record both app ids and the approval dates for the gates G1 to G4 in the ladder plan; do not turn download buckets into revenue.
4. Send nothing to Garmin about twins until the owner decides (the email is the owner's).

## Images (prepared 2026-10-04, proposals)

A complete set from the current Free build: five screens (days with a name, weeks and days, TODAY, a rectangle, an Instinct), hero, cover, two device icons; details, commands and the limit check are in [`screenshots.md`](screenshots.md). Earlier versions are in git history.

- **Cover and hero on a light/coloured ground (owner decision 2026-10-04, ROADMAP 10.25).** Garmin's brand page: "Do not choose black or transparent backgrounds" (500x500 store icon). Chosen: one brand colour, mint `#55FFAA` (the face's own ring accent), flat; ink `#06261B` arc, "1" and "Days"; `#1FBF7A` track; "To Go" `#0A6B43` (about 4.5:1 on the mint, white "To Go" was 1.3:1); no badge on Free. Hero keeps the three black watch screens, on the mint with a soft green shadow. Read at 100 px: the ring, the "1" and the name hold. **Rejected variants** (looked at, not kept): (A) mint with a white arc and white "To Go": white on mint is too weak; (B) near-white `#F2F6F4` with a darkened green `#00B36B` arc: clean and legible, but pale and it drops the brand mint, kept as the fallback if the owner finds the mint too loud; (C) mint with a white disc behind the mark: the mint arc vanishes on the white. **128x128 device icons unchanged (black ground):** the brand page's black/transparent rule is stated for the 500x500 store icon only; the device-icon guidance is separate and has no background rule, and those icons sit on the watch's own black. Owner approves the new look before upload.
- Free shows only Free's fields (Event, Name, Month/Day/Year, Unit, Date style, Accent); the accent colour varies across the set. No bottom line, no hours, no price number, no PRO badge.
- **Free vs Pro:** the same mark (the launcher icon's ring and "1"); Pro adds a small amber PRO badge. Owner approves or replaces it; the real launcher icon is ROADMAP 3.3.
- The Instinct picture is the Instinct 2 (Free may show any Instinct; the Pro listing must use the Instinct E or Instinct 3 Solar, which are on Garmin's paid-app list). Device-reach rule: it goes up with the upload that adds the Instinct products; listing text never names a watch model or gives a count (owner, 2026-10-04; the former `held_back_text` sentences are deleted).
- Not pictured: the date picker (needs a device check before any "set it on your watch" claim), the always-on state.

## 2026-10-04: what moved out of `paste.md` (owner rule: paste.md holds only what is pasted or uploaded)

- **Form:** https://apps.garmin.com/developer/upload; two steps, attach the `.iq`, then the details. One block is one field. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml); the approvals the owner owes are in its `owner_approvals`.
- **Title:** "Days To Go: Countdown to a Date" is the plan's proposal; the owner decides, and searches the store by eye for a collision first.
- **Description:** line 1 holds the sibling's store URL (filled 2026-10-04; the link works once Garmin approves that listing). English only until the owner decides on translations. Check each block for a `<` before pasting.
- **Version:** the form reads it from the package; if a field asks, type it.
- **Images:** the owner approves the looks first (`meta.yaml` `owner_approvals`); simulator captures of the Free build, 2026-10-04 (canned clock; not real readings), so no Pro-only thing can appear. The Instinct picture is the Instinct 2 (Free may show any Instinct); the simulator image is 176 px and `screens/5-instinct.png` is it enlarged x3 without smoothing (the native capture is re-made by `tools/listing_shots.sh` when re-taking; not kept); upload it only with the package that adds the Instinct products (1.0.0). Captions and devices are in `meta.yaml` `assets.screens`.
- **Category:** Utility (alternative: Simple). **Subcategory:** whatever the Category choice offers. **Collects user data:** No; the privacy-policy URL field is conditional on Yes, so it may not appear. **Preview Video:** none (YouTube or Vimeo only). **App Migration:** No; a new app, not an update.
- **Monetization:** No: the Free app asks for no payment and unlocks nothing. Read the form's own wording at submission (`../listing/NOTES.md` records that the wording is easy to misread).
- **Hardware field:** the bare URL only; the store API names it `hardwareProductUrl`, and a live listing's value is a bare URL (owner, 2026-10-02; Garmin research 2026-10-04).

## Instinct image, black and white only (2026-10-08)

`screens-framed/5-instinct.png` (instinct2): Checked, not changed: the capture is pure black and white (2 colours) and the Instinct 2 skin has no ghost, so the re-frame is pixel-identical and the file is kept.
