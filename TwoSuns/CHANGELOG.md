# Two Suns changelog

One entry per Connect IQ Store publication, newest first. The store's "What's New"
text for each version is in [`listing/README.md`](listing/README.md).

**There has been no store publication.** Nothing is submitted, no version number is confirmed.

## Unreleased / 1.0.0 in preparation

Built 2026-09-26, extended 2026-09-27. Evidence: mostly simulator (SDK 9.2.0), plus spot-checks on the owner's FR965 (sunrise/sunset match to the native glance; Positioning; on-watch Customize, ADR-019). 124 tests pass on `fr965`, `fenix7`, `venu3` (compile-checked after the 2026-09-27 fixes below; the full run and the 69-product fit sweep predate them and need re-confirming once the simulator is free — the sweep last printed `done: 69 pass, 0 fail`, 122 of 122 on every product including Venu X1, `bin/fit-products.txt`, 2026-09-27). Tests do not check pixels.

`watch-design-reviewer` (`watch-design-kit`) ran against this build 2026-09-27 and found 8 material issues; fixed same day:

- The winter accent (`#FFFFFF`) dimmed to a colour bit-identical to `MUTED`/"no data" — a low reading and no reading were indistinguishable. `TwoSunsPalette.dim()` now avoids that collision for every accent.
- Always-on text was `#555555`, 2.8:1 against true black — under this project's own ≥3:1 bar for a persistent colour. Now `#5555AA`, 3.3:1.
- The always-on time's "two sizes smaller than awake" claim was false whenever awake had already fallen back from its largest font. Now derived from awake's actual choice at draw time, genuinely two steps below on every screen.
- The AMOLED burn-in limit was stated three different, uncited ways across the docs and code. Reconciled to one account of what the code actually does (the block moves every minute, so any one pixel is lit for at most a minute), with the underlying "10%" figure marked uncited rather than presented as settled.
- The energy curve's current-point "halo" drew at the same radius as the dot itself, leaving no visible margin — invisible with the winter accent, whose dot and the fresh-state line were both white. The halo now draws wider than the dot.
- Doc headers claiming "nothing has run on a watch" were stale (ADR-005 and ADR-019 both have real FR965 evidence); corrected across `DESIGN.md`, `decisions.md`, `spec.md`, `CLAUDE.md`.
- `spec.md`'s non-goals still listed "an on-watch settings screen," which ADR-019 built; removed.
- Time size raised (230→260 permille of D) on the owner's own FR965 feedback ("plenty of space"); not yet re-confirmed by a fit sweep or a new device photo.

Two findings are still open, not fixable from a coding session alone: settings persistence across a real Garmin Connect sync is untested (ADR-018); the always-on Body Battery number still has no context marker distinguishing it from a battery percentage (spec.md "Ideas", not designed).

Built:

- Watch face for 69 products (66 round, 3 rectangular AMOLED), Connect IQ 4.2 and up, one build, no bitmaps.
- A 24-hour sky ring (night, civil twilight, daylight still to come, daylight gone, optional golden-hour arc, sunrise and sunset ticks, a sun marker), noon or midnight at the top.
- Sunrise and sunset from Garmin's own Complications; our own NOAA calculation for tomorrow's sunrise, twilight, golden hour and polar days (27 reference tests against the US Naval Observatory, within 2 minutes where it lists an event).
- The sun sentence in up to three wordings, with a sentence for every failure: "No place yet", "No sun data", "Sun stays up today", "Sun stays down today", "No sunrise tomorrow".
- Body Battery from `SensorHistory` as a 24-hour curve (96 buckets of 15 minutes), a level pill and the value; stale after 60 minutes (muted, hollow); `--` when there is no valid sample; no verdicts. The pill and value dim one step below a settable low threshold (ADR-008 amendment) — the same dim the ring uses for daylight already gone.
- Five list settings: Accent colour, Ring orientation, Golden hour, Energy curve, Date — changeable in Garmin Connect or on-watch (Customize, next to Apply in the watch-face picker; ADR-019).
- AMOLED always-on: time, Body Battery value and sun sentence, dim, drifting on a 3 × 3 grid.
- A remembered place (rounded to 0.1 degree, never sent anywhere), location order Activity, Weather, `Position.getInfo`, saved.
- 15 languages: English and 14 machine-drafted translations, not read by native speakers and not fit-tested.
- ADRs 001 to 019 ([`docs/decisions.md`](docs/decisions.md)).

Not done, and not to be claimed:

- Device evidence is three spot-checks (sunrise/sunset match; Positioning; on-watch Customize), no full wear day. Not yet done: a full wear day, always-on night, DST, a run with phone and GPS off, battery figure, settings persistence across a real Garmin Connect sync.
- The owner has not approved the look or the launcher icon (a generic placeholder). No screenshot exists.
- No language has been fit-tested (`tools/fit_languages.sh` written, not run); no store description translated.
- The `.iq` export prints "89 OUT OF 89 DEVICES BUILT" for a manifest of 69 products; investigated (the archive itself confirms 89 real entries, keyed by internal part numbers this SDK cannot map back to device ids), still unresolved — the store form's own Compatible Devices list is authoritative at upload.
- Real assets (launcher icon, cover, hero, screenshots) not supplied; owner to provide.
- Tier B (API 3.4 to 4.1, 23 products) is planned for 1.1 and not started.
