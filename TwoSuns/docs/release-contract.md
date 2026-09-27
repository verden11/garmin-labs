# Release contract

What the listing, the store page and the site may claim. The checkable form of the rules in [`spec.md`](spec.md) "Claims that may be made", adapted to the state on 2026-09-26: **built, simulator-tested only, nothing run on a wrist.** A claim is allowed only after the check in its row has been done and recorded. "State today" says whether that has happened.

## Allowed once the check is done

| Claim | Backed by | State today |
|---|---|---|
| Sunrise and sunset match your watch's own Sunrise/Sunset glance | The device compare on the owner's FR965: `Complications` values against the native glance, to the minute, on the wear day ([`publish-checklist.md`](publish-checklist.md) gate 3) | **Not allowed yet.** Not done. The simulator's sun values are canned |
| Works without GPS or your phone | A run on the watch with phone and GPS off: the face shows sunrise and sunset and Body Battery | **Not allowed yet.** Not done |
| Your location never leaves the watch | The manifest has no `Communications` or `Background` permission and no network code; the only stored location is a place rounded to 0.1 degree in `Application.Storage` (checked by reading the manifest and the source, 2026-09-26) | Allowed as a statement of what the code does. It must sit beside the disclosure that the face may use the watch's location to compute sun times (only while `Positioning` is declared: [ADR-005](decisions.md#adr-005-location-order-and-the-positioning-permission)) |
| Shows your last 24 hours of Body Battery as a curve | `SensorHistory` history read on the FR965 and compared with Garmin's own graph (plan phase 9); the simulator's history is synthetic | **Not allowed yet.** Logic tested in the simulator only |
| Shows Body Battery as Garmin reports it, with no advice | Code and strings: no verdict words, no per-level colour ([ADR-008](decisions.md#adr-008-no-verdicts-on-body-battery)) | Allowed as a description of design (code and strings, not a device check) |
| Says what is missing instead of showing a blank | Simulator tests for every sky and Body Battery state; the "?" fallback if reading throws | Allowed as a description of design, simulator only ("shows a message when it has no sun data"); not "never blank" until seen on a watch |
| 15 languages on the watch | Manifest language list; strings written and parity-checked | Allowed only as "15 languages, 14 machine-drafted"; no language has been fit-tested or read by a native speaker |
| Paid, one purchase | Price decision ([ADR-002](decisions.md#adr-002-price)); the store form | Allowed at submission |

## Forbidden

- Battery figures, always-on ghosting, MIP contrast: unmeasured on a device.
- Any watch count, or "works on X" for a watch only the simulator has seen (the store's list is shorter than the manifest; a paid app is sold only on Garmin's own list; the export prints 89 devices for 69 products, unresolved).
- Any download, rating or review number.
- **Accuracy of Body Battery**, "accurate Body Battery", "the most accurate sun times", and any statement that the face is more accurate than Garmin's own screens.
- **Anything about health outcomes**: "improves", "optimises", "recovery advice", "know when to rest", diagnosis, treatment, prevention. Body Battery is a wellness estimate; describe what the face shows, never what it means for the body. The store's review guidelines forbid medical claims.
- "Body Battery" as a name, brand, icon or tag prefix; any suggestion that Garmin endorses the face. Descriptive use only ("shows your watch's Body Battery").
- Anything about a rival by name. Brand names in tags.
- "Free" wording while the price is paid; disclose any limited-time free period (store review guideline 4d). The store's "trial" does not exist for watch faces.
- "No permissions" or "no location permission" while `Positioning` is in the manifest.
- Translated store copy that no native speaker has read.
- A claim about the look, a screenshot, or "designed for" a watch before the owner has approved the look and supplied the images.
