# Two Suns changelog

One entry per Connect IQ Store publication, newest first. The store's "What's New"
text for each version is in [`listing/README.md`](listing/README.md).

**There has been no store publication.** Nothing is submitted, no version number is confirmed, and nothing has run on a wrist.

## Unreleased / 1.0.0 in preparation

Built 2026-09-26. Evidence: simulator only (SDK 9.2.0). 120 tests pass on `fr965`, `fenix7`, `venu3` and the ten screen-fit devices (`fr255s`, `fenix7s`, `fenix7`, `fenix7x`, `fr265s`, `fr165`, `epix2`, `fr965`, `venusq2`, `fenix9pro51mm`); a full 69-product compile sweep, run after the 15-language manifest was added, printed `BUILD SUCCESSFUL` for all 69 with zero errors and no warning beyond the launcher-icon-scaling notice — the build outputs were not kept as artifacts (`bin/` is git-ignored scratch, deleted after each run per house rules), so this rests on the run having happened, not a saved log. Tests do not check pixels. The suite was re-run on `fr965`, `fenix7`, `venu3` and all ten fit-sweep devices on 2026-09-27, after the translations and manifest were added and after the low-battery colour change: 122 of 122 pass on every device.

Built:

- Watch face for 69 products (66 round, 3 rectangular AMOLED), Connect IQ 4.2 and up, one build, no bitmaps.
- A 24-hour sky ring (night, civil twilight, daylight still to come, daylight gone, optional golden-hour arc, sunrise and sunset ticks, a sun marker), noon or midnight at the top.
- Sunrise and sunset from Garmin's own Complications; our own NOAA calculation for tomorrow's sunrise, twilight, golden hour and polar days (27 reference tests against the US Naval Observatory, within 2 minutes where it lists an event).
- The sun sentence in up to three wordings, with a sentence for every failure: "No place yet", "No sun data", "Sun stays up today", "Sun stays down today", "No sunrise tomorrow".
- Body Battery from `SensorHistory` as a 24-hour curve (96 buckets of 15 minutes), a battery glyph and the value; stale after 60 minutes (muted, hollow); `--` when there is no valid sample; no verdicts.
- Five list settings: Accent colour, Ring orientation, Golden hour, Energy curve, Date.
- AMOLED always-on: time, Body Battery value and sun sentence, dim, drifting on a 3 × 3 grid.
- A remembered place (rounded to 0.1 degree, never sent anywhere), location order Activity, Weather, `Position.getInfo`, saved.
- 15 languages: English and 14 machine-drafted translations, not read by native speakers and not fit-tested.
- ADRs 001 to 018 ([`docs/decisions.md`](docs/decisions.md)).

Not done, and not to be claimed:

- Nothing has run on a wrist: no device compare of sunrise and sunset with the watch's own glance, no wear test, no always-on night, no battery figure.
- The two on-watch location probes have not been run, so the `Positioning` permission is provisional and the location code has never run on a watch.
- The owner has not approved the look, the rectangular screens or the launcher icon (a generic placeholder). No screenshot exists.
- The fit test ran on ten devices (10 of 11 screen sizes; Venu X1 not run) and, as part of the full suite, on `venu3`; the other 58 products have not been run (`tools/fit_products.sh` is written, not run). No language has been fit-tested.
- The store name is a working name. Category, price wording, listing, screenshots and site deploy are not decided or done.
- The `.iq` export prints "89 OUT OF 89 DEVICES BUILT" for a manifest of 69 products; unresolved.
- Tier B (API 3.4 to 4.1, 23 products) is planned for 1.1 and not started.
