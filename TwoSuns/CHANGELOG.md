# Two Suns changelog

One entry per Connect IQ Store publication, newest first. The store's "What's New"
text for each version is in [`listing/README.md`](listing/README.md).

## Unreleased

Everything below is **UNRELEASED**: built 2026-10-01 against the Free + Pro plan, **proposed** (`docs/decisions.md` ADR-020 (Free + Pro ladder) and ADR-021 (Body Battery in Free); the owner has not signed off), simulator-grade evidence, nothing uploaded. The headings are the versions the owner would upload; dates and uploads are theirs. The prepared 1.0.1 below is separate: it was built before this work, and its package (`dist/TwoSuns.iq`) is untouched.

### Two Suns (Free) 1.0.0 — UNRELEASED, a new app (new app id), not uploaded

- First release of the Free twin: the same 69 products and 15 languages, permission `ComplicationSubscriber` only (no location, no history), no place kept and no `Application.Storage` (the accent colour is saved as a Properties setting). The time, the 24-hour sun ring from Garmin's own sunrise and sunset (daylight to come and gone, sunrise and sunset ticks, the sun marker), the sun sentence ("3:42 of daylight", "Sunrise 06:41", "Sunrise ~06:41" after sunset, "Sun is up", "No sun data"), Garmin's own Body Battery number in a level pill (`--` and a hollow pill when there is none), always-on, the on-watch Customize screen.
- Settings: Accent colour (the six shipped colours: sky, mint, autumn, violet, pink, winter), on the phone and in Customize.
- Not in Free (Pro only): the 24-hour energy curve, golden hour, ring orientation, the date row, civil twilight and tomorrow's own sunrise, polar-day and polar-night sentences, the remembered place.
- App id `9d5735b5-ac4b-4fa8-86d3-eee0f4f83c04` (generated 2026-10-01). Store name and title are the owner's decision (placeholder "Two Suns").
- ADRs: 020 (Free + Pro ladder, proposed), 021 (Body Battery in Free, proposed).
- Evidence, 2026-10-01, **compile only** (the simulator was not used): both jungles, normal and `-t` test builds, on the ten `fit_all.sh` devices plus `venux1`: 44 of 44 pass (zero warnings beyond the known launcher-icon notice); the whole-manifest compile sweep (`tools/compile_sweep.sh`, normal builds): **69 of 69 products pass on each jungle, 0 fail**; 57 per jungle carry only the known launcher-icon size notice, the other 12 are warning-free; `tools/check_free_package.sh --build` passes on the exported `dist/TwoSunsFree.iq` and `dist/TwoSunsPro.iq` (Free: permission `ComplicationSubscriber` only, only the `Accent` key, none of the Pro functions, files or modules in `debug.xml`, no "Pro" anywhere). The 67 Free tests are **written and compiled, not run**. Nothing has run on a wrist.

### Two Suns Pro 1.1.0 — UNRELEASED, an update of the existing paid app id, not uploaded

- The paid app is renamed on the watch to "Two Suns Pro" (placeholder name; the owner decides it and the price). Behaviour, settings, ids, defaults and permissions are the same as 1.0.1: `resources-pro/settings` is byte-identical to the old shared settings, and the 124 existing tests are unchanged apart from annotations and equivalent helper refactors (twins for helpers that touch Pro-only code; one assertion helper).
- No new feature. The plan's other Pro addition (accent ids 6 to 11) is **deferred**, not built; the shipped accent ids 0 to 5 keep their colours (`TwoSunsAccentTest`).
- Build change: Pro is now `monkey.jungle` with `resources;resources-pro` and `(:free)` code excluded. Two internal refactors keep Pro identical: `TwoSunsSources.sunDays(time)` calls `updatePlace()` itself in the same order as before, and `Position`, `SensorHistory`, `Weather` and `Activity` are named in full instead of imported.
- ADRs: 020 (Free + Pro ladder, proposed). ADR-002 (price, day-45 review) still governs until the owner signs off.
- Evidence: as above (the same compile matrix, sweep and package check cover Pro). The 130 Pro tests (the 124 existing plus 6 new accent-table tests) are written and compiled, **not run**; the main thread's Pro run (expect `passed=130`) is the regression check for the refactors above.

## 1.0.1 — prepared 2026-09-28, not yet submitted

Owner is holding submission until 1.0.0's review concludes. Built on top of 1.0.0, no other
changes. Evidence: simulator only — compiled and the full 124-test suite re-run on `fr965`,
`fenix7`, `venu3` (the same three devices 1.0.0's own note names), all pass, zero regressions. No
device evidence; this has not run on a wrist.

- Fixed (defensive, `docs/decisions.md` ADR-017's 2026-09-28 amendment): the Body Battery glyph
  fill's trailing (anchored) edge now rounds to match the track's own curve there, capped so it can
  never exceed half the fill's own width or height. The moving (leading) edge — the one actually
  responsible for the 1.0.0 "toggle switch" defect — is untouched at every fill level, so this
  can't reintroduce that bug. Not confirmed as a visible defect on a real screenshot; found by a
  geometry check during code review, applied as a precaution.
- Corrected two mislabelled evidence claims: `docs/decisions.md` ADR-017 and `CHANGELOG.md`'s own
  1.0.0 entry (below) both said "real FR965 screenshot" for the original toggle-switch fix; the
  matching capture on file (`listing/screenshots.md`) is a simulator screenshot. Fixed in both
  places rather than left standing.

## 1.0.0 — submitted 2026-09-27, approved 2026-09-28 (late afternoon, owner)

Store page (live since approval): https://apps.garmin.com/apps/9d4bca45-d79a-4f26-abf5-04e0519cf10b

Built 2026-09-26, extended 2026-09-27. Evidence: mostly simulator (SDK 9.2.0), plus spot-checks on the owner's FR965 (sunrise/sunset match to the native glance; Positioning; on-watch Customize, ADR-019). 124 tests pass on `fr965`, `fenix7`, `venu3` (compile-checked after the 2026-09-27 fixes below; the full run and the 69-product fit sweep predate them and need re-confirming once the simulator is free — the sweep last printed `done: 69 pass, 0 fail`, 122 of 122 on every product including Venu X1, `bin/fit-products.txt`, 2026-09-27). Tests do not check pixels.

What's New (initial release): blank, per the store form — no field for "first release" text.

`watch-design-reviewer` (`watch-design-kit`) ran against this build 2026-09-27 and found 8 material issues; fixed same day:

- Winter-accent/`MUTED` colour collision fixed (ADR-017 amendment, `docs/decisions.md`).
- Always-on text contrast fixed (ADR-007 amendment, `docs/decisions.md`).
- Always-on time's "two sizes smaller" claim fixed to derive from awake's actual font choice (ADR-007 amendment, `docs/decisions.md`).
- AMOLED burn-in limit's three conflicting doc/code accounts reconciled to one (ADR-007 amendment, `docs/decisions.md`).
- Energy-curve halo width fixed, was same radius as the dot (ADR-017 amendment, `docs/decisions.md`).
- Doc headers claiming "nothing has run on a watch" were stale (ADR-005 and ADR-019 both have real FR965 evidence); corrected across `DESIGN.md`, `decisions.md`, `spec.md`, `CLAUDE.md`.
- `spec.md`'s non-goals still listed "an on-watch settings screen," which ADR-019 built; removed.
- Time size raised (230→260 permille of D) on the owner's own FR965 feedback ("plenty of space"); not yet re-confirmed by a fit sweep or a new device photo.

Two findings are still open, not fixable from a coding session alone: settings persistence across a real Garmin Connect sync is untested (ADR-018); the always-on Body Battery number still has no context marker distinguishing it from a battery percentage (spec.md "Ideas", not designed).

One more caught from a real FR965 **simulator** screenshot, same day (corrected 2026-09-28: previously misstated as a real-device screenshot here and in `docs/decisions.md` ADR-017; the matching capture on file, `listing/screenshots.md`, says "Owner's FR965 simulator"): the Body Battery glyph's fill rounded its own leading edge once wide enough, which at a mid-level reading (59%, the owner's real value at the time) looked like a toggle switch, not a level. Fill is now a plain rectangle inside the rounded outline.

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
