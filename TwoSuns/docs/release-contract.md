# Release contract

What the listing, the store page and the site may claim. The checkable form of the rules in [`spec.md`](spec.md) "Claims that may be made", adapted to the state on 2026-09-26: **built, simulator-tested only, nothing run on a wrist.** A claim is allowed only after the check in its row has been done and recorded. "State today" says whether that has happened.

## Allowed once the check is done

| Claim | Backed by | State today |
|---|---|---|
| Sunrise and sunset match your watch's own Sunrise/Sunset glance | The device compare on the owner's FR965: `Complications` values against the native glance, to the minute, on the wear day ([`status.md`](status.md) gate 3) | **Not allowed yet.** Not done. The simulator's sun values are canned |
| Works without GPS or your phone | A run on the watch with phone and GPS off: the face shows sunrise and sunset and Body Battery | **Not allowed yet.** Not done |
| Your location never leaves the watch | The manifest has no `Communications` or `Background` permission and no network code; the only stored location is a place rounded to 0.1 degree in `Application.Storage` (checked by reading the manifest and the source, 2026-09-26) | Allowed as a statement of what the code does. It must sit beside the disclosure that the face may use the watch's location to compute sun times (only while `Positioning` is declared: [ADR-005](decisions.md#adr-005-location-order-and-the-positioning-permission)) |
| Shows your last 24 hours of Body Battery as a curve | `SensorHistory` history read on the FR965 and compared with Garmin's own graph (plan phase 9); the simulator's history is synthetic | **Not allowed yet.** Logic tested in the simulator only |
| Shows Body Battery as Garmin reports it, with no advice | Code and strings: no verdict words, no per-level colour ([ADR-008](decisions.md#adr-008-no-verdicts-on-body-battery)) | Allowed as a description of design (code and strings, not a device check) |
| Says what is missing instead of showing a blank | Simulator tests for every sky and Body Battery state; the "?" fallback if reading throws | Allowed as a description of design, simulator only ("shows a message when it has no sun data"); not "never blank" until seen on a watch |
| 15 languages on the watch | Manifest language list; strings written and parity-checked | Allowed only as "15 languages, 14 machine-drafted"; no language has been fit-tested or read by a native speaker |
| Paid, one purchase | Price decision ([ADR-002](decisions.md#adr-002-price)); the store form | Allowed at submission |

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

## Free and Pro listings (ADR-020 (Free + Pro ladder), proposed)

- The same allowed and forbidden lists apply to both listings. Nothing is claimed that only the other tier ships: the Free listing never mentions the energy curve, golden hour, tomorrow's sunrise, twilight, the date row, ring orientation or a remembered place, and names Pro only in its sibling line (no "Pro adds" list); the Pro listing describes only what Pro has.
- **Free's privacy wording differs from Pro's.** Free: "no location, no place kept, no history" is allowed as a statement of what the Free code does (the manifest has `ComplicationSubscriber` alone; no location source is read; no `Application.Storage` call is compiled in; checked by `tools/check_free_package.sh` and the compiler). "Nothing stored" is **not** allowed: the accent colour is saved as a Properties setting. The allowed phrase is "it stores no place and no history; the only thing it saves is your accent colour setting", and "no location permission" is allowed **for Free only**. Pro keeps every existing rule (the place rounded to 0.1 degree stays on the watch; never "no location permission" while `Positioning` is declared). The Free page must not describe Pro's place or history to Free users.
- **Free's Body Battery is "Garmin's own number"**: never "live", "accurate", "the last 24 hours" or "curve" in Free (no history, no timestamp: ADR-021, Body Battery in Free). A missing number is `--`, said as such, not as "not worn" or any state of the person.
- **Weather row (Pro only, ADR-022, unreleased):** allowed once a wrist check has run: "shows the current conditions and feels-like temperature from your watch's own weather, and the conditions ahead to sunset". Always "Garmin's cached weather" or "your watch's weather"; never "live", "accurate", "real-time" or "forecast accuracy", and no claim about how many hours ahead (the hourly list's length is unverified). Free's listing never mentions weather. Privacy: the face reads the forecast the watch already holds and sends nothing; the site's privacy page does not say this yet (status F12).
- "Free" wording is allowed **only** in the Free listing (which is $0). The Pro listing keeps the existing rule: no "free" wording while the price is paid.
- Each listing names the other tier's store URL on its first line; the URL is a placeholder until both are live. No download, rating or review number about either.
- The device sentence says only what Garmin's store shows after approval. Before approval the Free draft carries "Pro is sold only on watches Garmin lists for paid apps; this version can also be installed on some watches Pro cannot be bought for", marked **to verify** (SDK `Monetization/App_Sales` and the store form) before it is pasted, with no watch names or count. The paid listing carries no device sentence and no "free" wording (its sibling line reads "Also available: Two Suns, a lighter version: <URL>").
- Free's description says nothing is locked or unlockable inside Free (there are no locked items); never "upgrade" wording inside the app or in the Free description's first lines beyond the sibling line.
- "More from Verden" links only live **free** siblings.
