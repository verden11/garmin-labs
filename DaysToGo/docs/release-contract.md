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
