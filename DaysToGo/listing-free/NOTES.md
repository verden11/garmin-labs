# Days To Go (Free) listing: notes

What sits behind [`README.md`](README.md), the paste-ready copy. Nothing here is pasted into the form. Status 2026-10-01: **draft, UNRELEASED, simulator only, nothing uploaded**; built against the Free + Pro plan (WP4 step 6 and the WP10 description skeleton, `../../reports/Free and Pro ladder execution plan.md`). Decision record: ADR-014 (Free + Pro ladder, proposed) in [`../docs/decisions.md`](../docs/decisions.md). Claims are checked against [`../docs/release-contract.md`](../docs/release-contract.md), which now has a "Free and Pro listings" section.

## Owner decisions (not made here)

| Decision | Placeholder in the draft |
|---|---|
| Store title (Free) | "Days To Go: Countdown to a Date" (31 characters, the plan's proposal); store-collision check by eye first |
| On-watch app name | "Days To Go" (`../resources-free/strings/strings.xml`) |
| Pro's name and title | "Days To Go Pro" / "Days To Go Pro: Countdown, Hours, Footer" (plan proposal) |
| Pro's store URL (line 1) | `<PRO STORE URL ...>`: needs Pro live (or upload Pro first); the line must be the real URL, not a placeholder, at submission |
| Pro's price | Plan proposes the $3.00 tier (US $2.99); today it is $1.99. **The listing never states a price** |
| Icon and cover | Not made; look and identity are the owner's |
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
| The device sentence | **Not in the paste-ready text.** It is a to-verify note (below): no device claim goes in until the store shows the Free listing's real device list |
| The review request | **Not in the paste-ready text.** The plan's WP10 skeleton has a one-sentence review request, but the release contract does not list it as an allowed claim; the owner decides whether to add one (for example "If this face works for you, a rating in the store helps other people find it.") |

Not claimed anywhere: battery figures, always-on ghosting, MIP contrast, any watch count, download, rating or review number, "the only countdown with no permissions", "works on every watch", rivals by name, "set it on your watch" (the beta round trip T4 is still open, `../docs/publish-checklist.md`).

## To verify after approval (not paste-ready)

- **Device sentence** (plan WP4 step 6): "Pro is sold only on devices Garmin lists for paid apps; this free version also runs on older watches such as FR245 and vívoactive 4." Add a version of it only after the Free listing's real compatible-device list shows those watches, and without a watch count. The contract forbids "works on X" for a watch only the simulator has seen.
- **Pro-available line**: the plan puts "say so on line 2" if Pro is offered on the reader's device. Nothing is claimed about Pro's availability until the Pro listing's device list is visible.

## Description rules

Same as [`../listing/NOTES.md`](../listing/NOTES.md): one box per language, 4000 characters, plain text (the store keeps line breaks and shows `**` literally), describe what the app is, the last line is the support URL (the form has no support field). The Free description follows the WP10 skeleton: sibling line, promise, what Free has, "Pro adds", permissions in plain words (the review request and the device sentence are left out, see above). **"More from Verden" is left out**: it lists only live free siblings, and none is known to be live today; add up to four store URLs after a free sibling is approved.

## Why each answer

| Field | Reason |
|---|---|
| Category | Utility, as the Pro listing |
| Collects user data | No: nothing leaves the watch; no permissions |
| Monetization | No: Free asks no payment and unlocks nothing in-app (Pro is a separate app). The form's wording decides at submission |
| App Migration | No: a new app id, not a newly compatible device on an existing app |
| Price | $0 (free). The Free listing is the only listing where "free" wording is allowed (release contract) |

## After approval (plan WP4 step 6, WP9)

1. Read the Free listing's real compatible-device list and add the plan's device sentence (above) only if the list shows those watches.
2. Put the live Free URL on the first line of the Pro listing ("Also available: Days To Go (<URL>)", no "free" wording on the paid listing) and the live Pro URL here.
3. Record both app ids and the approval dates for the gates G1 to G4 in the ladder plan; do not turn download buckets into revenue.
4. Send nothing to Garmin about twins until the owner decides (the email is the owner's).
