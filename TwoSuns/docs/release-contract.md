# Release contract

What the listing, the store page and the site may claim. The checkable form of the rules in [`spec.md`](spec.md) "Claims that may be made", adapted to the state on 2026-10-05: **live 1.0.0; Pro 1.1.0 and Free 1.0.0 uploaded 2026-10-04, in review; on a wrist only three FR965 spot-checks (2026-09-27) and a partial weather-row wear day (2026-10-03/04, `status.md` F12), everything else simulator only.** A claim is allowed only after the check in its row has been done and recorded. "State today" says whether that has happened.

## Allowed once the check is done

| Claim | Backed by | State today |
|---|---|---|
| Sunrise and sunset match your watch's own Sunrise/Sunset glance | The device compare on the owner's FR965: `Complications` values against the native glance, to the minute, on the wear day ([`status.md`](status.md) gate 3) | **Not allowed yet.** Not done. The simulator's sun values are canned |
| Works without GPS or your phone | A run on the watch with phone and GPS off: the face shows sunrise and sunset and Body Battery | **Not allowed yet.** Not done |
| Your location never leaves the watch | The manifest has no `Communications` or `Background` permission and no network code; the only stored location is a place rounded to 0.1 degree in `Application.Storage` (checked by reading the manifest and the source, 2026-09-26) | Allowed as a statement of what the code does. It must sit beside the disclosure that the face may use the watch's location to compute sun times (only while `Positioning` is declared: [ADR-005](decisions.md#adr-005-location-order-and-the-positioning-permission)) |
| Shows your last 24 hours of Body Battery as a curve | `SensorHistory` history read on the FR965 and compared with Garmin's own graph (plan phase 9); the simulator's history is synthetic | **Allowed as a description** of what the face draws (it reads Garmin's own 24-hour `SensorHistory`; ROADMAP 4.5, the agent's pick taken on the owner's standing instruction 2026-10-05, owner may reverse). **Not allowed:** any claim that it matches Garmin's own graph or is accurate, until the FR965 comparison (ROADMAP 4.2). Listing images draw the curve from the simulator's synthetic history. Logic tested in the simulator only |
| Shows Body Battery as Garmin reports it, with no advice | Code and strings: no verdict words, no per-level colour ([ADR-008](decisions.md#adr-008-no-verdicts-on-body-battery)) | Allowed as a description of design (code and strings, not a device check) |
| Says what is missing instead of showing a blank | Simulator tests for every sky and Body Battery state; the "?" fallback if reading throws | Allowed as a description of design, simulator only ("shows a message when it has no sun data"); not "never blank" until seen on a watch |
| 15 languages on the watch | Manifest language list; strings written and parity-checked | A fact for docs only: **listing text and What's New name no language and give no count** (owner, 2026-10-04; at most "Multi-language support: it follows your watch's language."). Stated in docs as "15 languages, 14 machine-drafted"; no language has been fit-tested or read by a native speaker |
| Paid, one purchase | Price decision ([ADR-026](decisions.md#adr-026-price-the-250-tier-for-every-paid-app), price: the $2.50 tier for every paid app, which supersedes ADR-002's USD 1.99); the store form; no price number in listing text | Allowed at submission |

## Forbidden

- Battery figures, always-on ghosting, MIP contrast: unmeasured on a device.
- Any watch count, or "works on X" for a watch only the simulator has seen (the store's list is shorter than the manifest; a paid app is sold only on Garmin's own list; the export prints 89 devices for 69 products: explained 2026-10-01 from the SDK's part numbers, `compatibility.md`; the store form's list stays authoritative).
- Any download, rating or review number.
- **Accuracy of Body Battery**, "accurate Body Battery", "the most accurate sun times", and any statement that the face is more accurate than Garmin's own screens.
- **Anything about health outcomes**: "improves", "optimises", "recovery advice", "know when to rest", diagnosis, treatment, prevention. Body Battery is a wellness estimate; describe what the face shows, never what it means for the body. The store's review guidelines forbid medical claims.
- "Body Battery" as a name, brand, icon or tag prefix; any suggestion that Garmin endorses the face. Descriptive use only ("shows your watch's Body Battery").
- Anything about a rival by name. Brand names in tags.
- "Free" wording while the price is paid; disclose any limited-time free period (store review guideline 4d). The store's "trial" does not exist for watch faces.
- "No permissions" or "no location permission" while `Positioning` is in the manifest.
- Translated store copy that no native speaker has read.
- A claim about the look, a screenshot, or "designed for" a watch before the owner has approved the look and supplied the images.

## Paid vs free reach (2026-10-04)

**Devices.** Garmin sells paid apps only on the products of its App Sales list. Two Suns 1.0.0 is listed on 68 of its 69 products (D2 Air X10, on the list but sold to no paid app, is the one gap). The Instinct E 40/45 mm and Instinct 3 Solar added in 1.1.0 are on the list (the 1.1.0 manifest has 72 products), and the Instinct 2, 2S, 2X and Descent G1, which are not on the list, are not in Two Suns at all. The Free twin has almost no extra reach (1 product) ([`compatibility.md`](compatibility.md) "Paid vs free reach"). **Listing text never names watch models, in either listing; the store's device tab is the claim** (owner, 2026-10-04).

**Listing text.** No refund or return wording appears in listing text (owner decision, 2026-10-04). The Pro listing still never uses the word "free".

## Free and Pro listings (ADR-020 (Free + Pro ladder), accepted 2026-10-04)

- The same allowed and forbidden lists apply to both listings. Nothing is claimed that only the other tier ships: the Free listing never mentions the energy curve, golden hour, tomorrow's sunrise, twilight, the date row, ring orientation or a remembered place, and names Pro only in its sibling line (no "Pro adds" list); the Pro listing describes only what Pro has.
- **Free's privacy wording differs from Pro's.** Free: "no location, no place kept, no history" is allowed as a statement of what the Free code does (the manifest has `ComplicationSubscriber` alone; no location source is read; no `Application.Storage` call is compiled in; checked by `tools/check_free_package.sh` and the compiler). "Nothing stored" is **not** allowed: the accent colour is saved as a Properties setting. The allowed phrase is "it stores no place and no history; the only thing it saves is your accent colour setting", and "no location permission" is allowed **for Free only**. Pro keeps every existing rule (the place rounded to 0.1 degree stays on the watch; never "no location permission" while `Positioning` is declared). The Free page must not describe Pro's place or history to Free users.
- **Free's Body Battery is "Garmin's own number"**: never "live", "accurate", "the last 24 hours" or "curve" in Free (no history, no timestamp: ADR-021, Body Battery in Free). A missing number is `--`, said as such, not as "not worn" or any state of the person.
- **What's New, Pro 1.1.0 (owner, 2026-10-04):** the sentence "New: optional Weather and Watch battery rows, switched on in the settings" is allowed (it names the switches, not what the rows show); describing what the weather row shows or how accurate it is still waits for the wrist check below.
- **Weather row (Pro only, ADR-022, uploaded in Pro 1.1.0 2026-10-04, in review):** allowed once a wrist check has run: "shows the current conditions and feels-like temperature from your watch's own weather, and the conditions ahead to sunset". Always "Garmin's cached weather" or "your watch's weather"; never "live", "accurate", "real-time" or "forecast accuracy", and no claim about how many hours ahead (the hourly list's length is unverified). Free's listing never mentions weather. Privacy: the face reads the forecast the watch already holds and sends nothing; the site's privacy page does not say this yet (status F12).
- "Free" wording is allowed **only** in the Free listing (which is $0). The Pro listing keeps the existing rule: no "free" wording while the price is paid.
- Each listing names the other tier's store URL on its first line; the URL is a placeholder until both are live. No download, rating or review number about either.
- Neither listing carries a device sentence or a watch model name (owner, 2026-10-04): the store's device tab, taken from each build, is the claim, and there is no watch count. The paid listing carries no "free" wording (its sibling line reads "Also available: Two Suns, a lighter version: <URL>").
- Free's description says nothing is locked or unlockable inside Free (there are no locked items); never "upgrade" wording inside the app or in the Free description's first lines beyond the sibling line.
- "More from Verden" links only live **free** siblings.
- **From Pro 1.2.0 / Free 1.1.0 (72 products, prepared 2026-10-08):** the ring is described by screen type: around the bezel on a round screen, a track along the edges of the glass on a rectangular one (ADR-028 (rectangles: the sky ring follows the screen)), a small 24-hour dial in the round window on a black-and-white one (ADR-024 (Instinct E and 3 Solar)); never a watch model or count, and no longer "round and rectangular watches alike" (each shape has its own design). What's New may say the Weather and Watch battery rows are off until switched on (it names the switches); it still does not describe what the weather row shows.
