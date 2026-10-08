# Release contract

What the listing, the store page and the site may claim. Copy of the rules in [`spec.md`](spec.md) "Claims", made checkable.

## Allowed (each backed by a test or a device check)

| Claim | Backed by |
|---|---|
| The count flips at local midnight | Unit tests (calendar); device wear day (plan phase 9) before the claim is made live |
| Set the date on your watch (on many watches) | Works on the FR965 (sideload, 2026-09-26); SDK lists 94 of the 117 round products; the phone/watch overwrite question (T4, beta) still decides whether the listing sentence goes in |
| No permissions; nothing leaves your watch | Manifest has an empty permission list; no network code |
| Works without your phone after setup | No phone code path |
| Counts to New Year's Day until you set an event | `DaysToGoSettings` defaults |
| **Pro only:** an event with a start time counts down to the minute (hours and minutes in the last 24 hours) | Unit tests (`DaysToGoZoneTest`, ADR-018 (the event minute and zone)), simulator only; the wrist checks in `status.md` (travel day, a DST day, phone-set Minute and zone surviving a reopened settings screen) before the upload |
| **Pro only:** you can set the time zone the event starts in, as a UTC offset, and the countdown follows that clock | Same tests. The description must say the wearer chooses the offset (the watch keeps no time zone rules). The headline phrase ("count down to the minute, in the time zone it starts in") may stand alone in the title and the images only because the same listing's description and What's New carry that offset sentence; never use it in a place that has no such sentence |
| The count of days stays on your own calendar and changes at your own midnight, also with an event time zone set | Unit tests (`dayCountFlipsAtWatchMidnightWhateverTheZone`); device wear day before the claim goes live |

## Forbidden

- **Pro only (ADR-018 (the event minute and zone)):** "adjusts for daylight saving", "handles daylight saving", "knows the time zone of a city", "automatic time zones", or any wording that says the face works out an event's time zone or its DST. The face has no time-zone database: the wearer picks a UTC offset. **"Works across time zones" is allowed only in a sentence that also says the wearer picks the offset;** alone it reads as a DST promise, so it is forbidden. Never claim "to the second" (the face is to the minute), and never claim the Minute or zone settings are on the watch itself (phone only).
- Battery figures, always-on ghosting, MIP contrast: unmeasured on a device.
- Any watch count, or "works on X" for a watch only the simulator has seen (the store's list is shorter than the manifest; a paid app is sold only on Garmin's own list).
- Any download, rating or review number.
- "The only countdown with no permissions". "Works on every watch". "Set it on your watch" without "on many watches".
- Anything about a rival by name. Brand names in tags.
- "Free" wording while the price is paid; disclose any limited-time free period (store review guideline 4d).
- Translated store copy that no native speaker has read.

## Paid vs free reach (2026-10-04)

**Devices.** Garmin sells paid apps only on the products of its App Sales list. Days To Go Pro 1.0.1 is listed on 72 of its 120 products; 37 are off the list and 11 more are on the list but sold to no paid app (measured by part number, [`compatibility.md`](compatibility.md) "Paid vs free reach"). Of the 7 Instinct products in 1.1.0, **only Instinct E 40/45 mm and Instinct 3 Solar are on the list; Instinct 2, 2S, 2X and Descent G1 are not.** So **listing text never names watch models, in either listing; the store's device tab is the claim** (owner, 2026-10-04). Free-only reach: 37 products plus the 11 unsold, and 4 more with the Instinct products (52 of 127). **The first-generation Venu Sq and Sq Music (added 2026-10-05) are not on the list either** (App Sales page read 2026-10-05; CIQ 3.3.6, under the 3.4 floor): Free-only reach 54 of 129, and neither listing names them. No watch count in any listing.

**Listing text.** No refund or return wording appears in listing text (owner decision, 2026-10-04). No language name or count either (the fact stays in docs). The Pro listing still never uses the word "free".

## Free and Pro listings (ADR-014 (Free + Pro ladder), accepted 2026-10-04)

- The same allowed and forbidden lists apply to both listings. Nothing is claimed that only the other tier ships: the Free listing never says it has timed events or a battery or steps line; the Pro listing's "adds" list is those two plus "to the minute" (Minute and Event time zone, ADR-018), plus any later Pro-only item once built.
- "Free" wording is allowed **only** in the Free listing (which is $0). The Pro listing keeps the existing rule: no "free" wording while the price is paid.
- Each listing names the other tier's store URL on its first line; the URL is a placeholder until both are live. The Free listing says "Get Days To Go Pro: <URL>"; the Pro listing says "Also available: Days To Go (<URL>)", **never "Try free first"** or any "free" wording. No download, rating or review number about either.
- No device sentence and no watch model name goes in either listing, now or after approval (owner, 2026-10-04): the store's device tab is the claim, and there is no watch count. The review request ("If this face works for you, a rating in the store helps other people find it.", DayArc's wording) is in the Free listing only, by the owner's decision of 2026-10-04; it asks and claims nothing, so it is not a claim about ratings.
- Free's description says nothing is locked or unlockable inside Free (there are no locked items); never "upgrade" wording inside the app or in the Free description's first lines beyond the sibling line.
- "More from Verden" links only live **free** siblings.
- From Free 1.1.0 / Pro 1.2.0 (129 products, prepared 2026-10-08): the ring is named by screen type (around the bezel on a round screen, along the glass on a rectangular one, a gauge in the round window of a black-and-white screen; ADR-019 (rectangles get a square design), ADR-015 (Instinct family)), never "a thin ring around the bezel" for every watch; Pro's bottom line is never claimed for black-and-white screens (no footer there); "Set it on your watch" stays "on many watches" (ADR-020: not on the Venu Sq 2 and Sq 2 Music).
