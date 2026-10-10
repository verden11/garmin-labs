# Release contract

What listing, store page, site may claim. Copy of rules in [`spec.md`](spec.md) "Claims", made checkable.

## Allowed (each backed by a test or a device check)

| Claim | Backed by |
|---|---|
| The count flips at local midnight | Unit tests (calendar); device wear day (plan phase 9) before claim made live |
| Set the date on your watch (on many watches) | Works on FR965 (sideload, 2026-09-26); SDK lists 94 of 117 round products; phone/watch overwrite question (T4, beta) still decides whether listing sentence goes in |
| No permissions; nothing leaves your watch | Manifest empty permission list; no network code |
| Works without your phone after setup | No phone code path |
| Counts to New Year's Day until you set an event | `DaysToGoSettings` defaults |
| **Pro only:** event with start time counts down to the minute (hours and minutes in last 24 hours) | Unit tests (`DaysToGoZoneTest`, ADR-018 (the event minute and zone)), simulator only; wrist checks in `status.md` (travel day, a DST day, phone-set Minute and zone surviving reopened settings screen) before upload |
| **Pro only:** set the time zone the event starts in, as UTC offset; countdown follows that clock | Same tests. Description must say wearer chooses offset (watch keeps no time zone rules). Headline phrase ("count down to the minute, in the time zone it starts in") may stand alone in title and images only because same listing's description and What's New carry that offset sentence; never use in a place without such sentence |
| Count of days stays on own calendar, changes at own midnight, also with event time zone set | Unit tests (`dayCountFlipsAtWatchMidnightWhateverTheZone`); device wear day before claim goes live |

## Forbidden

- **Pro only (ADR-018 (the event minute and zone)):** "adjusts for daylight saving", "handles daylight saving", "knows the time zone of a city", "automatic time zones", or any wording saying face works out an event's time zone or its DST. Face has no time-zone database: wearer picks UTC offset. **"Works across time zones" allowed only in a sentence that also says wearer picks the offset;** alone reads as DST promise, so forbidden. Never claim "to the second" (face is to the minute), never claim Minute or zone settings are on the watch itself (phone only).
- Battery figures, always-on ghosting, MIP contrast: unmeasured on a device.
- Any watch count, or "works on X" for watch only simulator has seen (store's list shorter than manifest; paid app sold only on Garmin's own list).
- Any download, rating or review number.
- "The only countdown with no permissions". "Works on every watch". "Set it on your watch" without "on many watches".
- Anything about a rival by name. Brand names in tags.
- "Free" wording while price is paid; disclose any limited-time free period (store review guideline 4d).
- Translated store copy no native speaker has read, **except** Spanish and Chinese (Simplified) listing text (title, description, What's New, hero tagline) owner chose to publish machine-drafted (2026-10-05 / 2026-10-08; ROADMAP 13.33, native read stays open, 7.10).

## Paid vs free reach (2026-10-04)

**Devices.** Garmin sells paid apps only on products of its App Sales list. Days To Go Pro 1.0.1 listed on 72 of its 120 products; 37 off list, 11 more on list but sold to no paid app (measured by part number, [`compatibility.md`](compatibility.md) "Paid vs free reach"). Of 7 Instinct products in 1.1.0, **only Instinct E 40/45 mm and Instinct 3 Solar on list; Instinct 2, 2S, 2X and Descent G1 not.** So **listing text never names watch models, in either listing; store's device tab is the claim** (owner, 2026-10-04). Free-only reach: 37 products plus 11 unsold, and 4 more with Instinct products (52 of 127). **First-generation Venu Sq and Sq Music (added 2026-10-05) not on list either** (App Sales page read 2026-10-05; CIQ 3.3.6, under 3.4 floor): Free-only reach 54 of 129, neither listing names them. No watch count in any listing.

**Listing text.** No refund or return wording in listing text (owner decision, 2026-10-04). No language name or count either (fact stays in docs). Pro listing still never uses word "free".

## Free and Pro listings (ADR-014 (Free + Pro ladder), accepted 2026-10-04)

- Same allowed and forbidden lists apply to both listings. Nothing claimed that only other tier ships: Free listing never says it has timed events or battery or steps line; Pro listing's "adds" list is those two plus "to the minute" (Minute and Event time zone, ADR-018 (the event minute and zone)), plus any later Pro-only item once built.
- "Free" wording allowed **only** in Free listing (which is $0). Pro listing keeps existing rule: no "free" wording while price is paid.
- Each listing names other tier's store URL on first line; URL placeholder until both live. Free listing says "Get Days To Go Pro: <URL>"; Pro listing says "Also available: Days To Go (<URL>)", **never "Try free first"** or any "free" wording. No download, rating or review number about either.
- No device sentence and no watch model name in either listing, now or after approval (owner, 2026-10-04): store's device tab is the claim, no watch count. Review request ("If this face works for you, a rating in the store helps other people find it.", DayArc's wording) in Free listing only, by owner's decision of 2026-10-04; asks and claims nothing, so not a claim about ratings.
- Free's description says nothing locked or unlockable inside Free (no locked items); never "upgrade" wording inside app or in Free description's first lines beyond sibling line.
- "More from Verden" links only live **free** siblings.
- From Free 1.1.0 / Pro 1.2.0 (129 products, prepared 2026-10-08): ring named by screen type (around the bezel on round screen, along the glass on rectangular one, a gauge in round window of black-and-white screen; ADR-019 (rectangles get a square design), ADR-015 (Instinct family)), never "a thin ring around the bezel" for every watch; Pro's bottom line never claimed for black-and-white screens (no footer there); "Set it on your watch" stays "on many watches" (ADR-020: not on Venu Sq 2 and Sq 2 Music).