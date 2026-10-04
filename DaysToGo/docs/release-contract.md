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

## Forbidden

- Battery figures, always-on ghosting, MIP contrast: unmeasured on a device.
- Any watch count, or "works on X" for a watch only the simulator has seen (the store's list is shorter than the manifest; a paid app is sold only on Garmin's own list).
- Any download, rating or review number.
- "The only countdown with no permissions". "Works on every watch". "Set it on your watch" without "on many watches".
- Anything about a rival by name. Brand names in tags.
- "Free" wording while the price is paid; disclose any limited-time free period (store review guideline 4d).
- Translated store copy that no native speaker has read.

## Paid vs free reach and the refund line (2026-10-04)

**Devices.** Garmin sells paid apps only on the products of its App Sales list. Days To Go Pro 1.0.1 is listed on 72 of its 120 products; 37 are off the list and 11 more are on the list but sold to no paid app (measured by part number, [`compatibility.md`](compatibility.md) "Paid vs free reach"). Of the 7 Instinct products in 1.1.0, **only Instinct E 40/45 mm and Instinct 3 Solar are on the list; Instinct 2, 2S, 2X and Descent G1 are not.** So (a) the **Pro listing** may name only Instinct E (40 and 45 mm) and Instinct 3 Solar, and only after an Instinct upload is approved and the store lists them; (b) the **Free listing** may say it also installs on watches Pro cannot be bought for, including the Instinct 2, 2S, 2X and Descent G1, on the same condition and once its own device list shows them. Free-only reach: 37 products plus the 11 unsold, and 4 more with the Instinct products (52 of 127). This refines the "no device sentence" rule below: no watch count, and watch names only as stated here.

**Refund line.** The Pro description ends with "Days To Go Pro is a paid app. Refunds follow the Connect IQ Store return window." (guideline 4d). It does not restate the hours (Garmin's full return-policy text is not published on a page we could read; its one stated figure is the 48-hour window before funds are captured). The Free description has no refund line. The Pro listing still never uses the word "free".

## Free and Pro listings (ADR-014 (Free + Pro ladder), accepted 2026-10-04)

- The same allowed and forbidden lists apply to both listings. Nothing is claimed that only the other tier ships: the Free listing never says it has timed events or a battery or steps line; the Pro listing's "adds" list is exactly those two (plus any later Pro-only item once built).
- "Free" wording is allowed **only** in the Free listing (which is $0). The Pro listing keeps the existing rule: no "free" wording while the price is paid.
- Each listing names the other tier's store URL on its first line; the URL is a placeholder until both are live. The Free listing says "Get Days To Go Pro: <URL>"; the Pro listing says "Also available: Days To Go (<URL>)", **never "Try free first"** or any "free" wording. No download, rating or review number about either.
- No device sentence goes in either listing until Garmin's store shows the real device list after approval; then it states only what the list shows, with no watch count. The review request ("If this face works for you, a rating in the store helps other people find it.", DayArc's wording) is in the Free listing only, by the owner's decision of 2026-10-04; it asks and claims nothing, so it is not a claim about ratings.
- Free's description says nothing is locked or unlockable inside Free (there are no locked items); never "upgrade" wording inside the app or in the Free description's first lines beyond the sibling line.
- "More from Verden" links only live **free** siblings.
