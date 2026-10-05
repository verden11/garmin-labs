# Two Suns changelog

One entry per Connect IQ Store publication, newest first. The store's "What's New"
text for each version is in [`listing/paste.md`](listing/paste.md).

## Unreleased (next upload of both)

Design critique 2026-10-05 (owner said "do your picks"; ROADMAP 13.13 to 13.17; simulator only, nothing on a wrist):

- **Pro: the weather row and the watch battery row are Off by default** for new installs, so the first face is the one the listing shows (each is one switch; a wearer who switched one on keeps it).
- **Pro: on a screen too short for the full weather row, the compact row shows the current conditions only** (it showed three ahead icons with no hours).
- **Pro: the energy curve is a white line with no fill** (the `#5555AA` fill was the night ring's colour).
- **Both: the Body Battery bolt is solid** in the battery colour, not a half-grey gauge (Two Suns ADR-023 (watch battery row, bolt) amendment in `docs/decisions.md`).
- **Both: daylight reads "3h 42m of daylight"** ("41m" under an hour), not "3:42", which read as a clock time. The letters are English for now (ROADMAP 13.7).
- Both listing sets recaptured.

## 1.1.0 (Two Suns Pro) and Two Suns Free 1.0.0 — uploaded 2026-10-04 by the owner, in review

Both packages were uploaded on 2026-10-04 and are pending Garmin's review; 1.0.0 stays live until Pro 1.1.0 is approved. Built 2026-10-01 to 2026-10-04 against the Free + Pro plan, **approved by the owner 2026-10-04** ([`docs/decisions.md`](docs/decisions.md) ADR-020 (Free + Pro ladder) and ADR-021 (Body Battery in Free), both Active), simulator-grade evidence only. The prepared 1.0.1 below was folded into Pro 1.1.0 and is not uploaded on its own; its package (`TwoSuns-1.0.1-prepared.iq`) is untouched.

**Both entries include the Instinct E 40 / 45 mm and Instinct 3 Solar 45 mm (72 products instead of 69; ADR-024, Instinct E and 3 Solar support, accepted 2026-10-04, simulator only, look approved by the owner 2026-10-04).** Black and white; the sky ring is a 24-hour dial in the round window; no watch battery row, golden hour or Accent setting there (an Instinct Free has no settings at all). The Instinct 2 family is not included (CIQ 3.4, no Complications). The visible area on an Instinct is a circle about 98 px in radius, which the layout and the fit test now model. Evidence: `docs/compatibility.md` "Instinct E and Instinct 3 Solar".

### Two Suns Pro 1.1.0 — uploaded 2026-10-04, in review (an update of the live paid app id)

Package `dist/TwoSunsPro-1.1.0.iq` (72 products, 93 device variants). Set on the USD 2.50 price tier in the form (ADR-026, the $2.50 tier for every paid app; the store showed $2.25). ADR-002 (price, day-45 review) is Superseded: the review is retired.

- The paid app is renamed on the watch to "Two Suns Pro" (confirmed name). Ids, defaults and permissions are the same as 1.0.0 apart from the new `Weather` and `Battery` settings.
- Always-on (AMOLED) text is a dim neutral grey (`#5C5C5C`) instead of the soft blue `#5555AA`, following Garmin's "avoid much white or blue" advice (ADR-027, always-on text is a dim grey; simulator only, not seen on a wrist).
- **New: the watch battery row** above the stack (ADR-023, watch battery row, Pro, setting `Battery`, On by default, drawn only where the round chord has room), a **bolt-gauge Body Battery glyph** (replaces the level pill; Free gets it too), and an arrow instead of `>` before the next-day weekday. Simulator only.
- **New: the weather row** (ADR-022, weather row in Pro; still Proposed until its wrist check): the now condition icon and feels-like number, three mono condition icons ahead to sunset, the next day after sunset; setting `Weather` (On by default); Garmin's cached forecast via `Toybox.Weather`, no new permission, nothing sent. Simulator only (canned weather). The accent ids 6 to 11 stay **deferred**, not built; the shipped accent ids 0 to 5 keep their colours.
- **Fix found on the wrist:** the on-watch Customize screen now has Weather and Battery toggles (they were only on the phone page, which a sideloaded build does not get).
- **Folded in from the prepared 1.0.1** (ADR-017's 2026-09-28 amendment, Body Battery glyph geometry): the Body Battery glyph fill's trailing edge now rounds to match the track's curve there, capped so it can never exceed half the fill's own width or height. Defensive; not confirmed as a visible defect.
- Build: Pro is now `monkey.jungle` with `resources;resources-pro` and `(:free)` code excluded; internal refactors keep Pro identical.
- Evidence (simulator only, 2026-10-03/04): Pro 154 tests on the ten `fit_all.sh` devices and again on fr965, fr255s, fr265s, fenix7s and venusq2; Free 67; compile sweep 69 of 69 products for both jungles; `tools/check_free_package.sh` passes. The always-on grey was re-run 2026-10-04 on fr965, fr255s, epix2 and instincte40mm (Pro 154, 154, 154, 146). No screenshot of the built weather row exists, and no device has run it. Pro's `.prg` grew from 172,412 to 190,716 bytes on fr965 (+18.3 KB); watch runtime memory is not measured on a device.
- What's New and App Version `1.1.0` are in `listing/paste.md`.

### Two Suns Free 1.0.0 — uploaded 2026-10-04, in review (a new app, new app id)

Package `dist/TwoSunsFree-1.0.0.iq` (72 products, 93 device variants). App id `9d5735b5-ac4b-4fa8-86d3-eee0f4f83c04`. Developer page: https://apps-developer.garmin.com/apps/46bc433c-5c1d-4ec1-97c7-0cf8ca8a5bca ; the public store URL is https://apps.garmin.com/apps/46bc433c-5c1d-4ec1-97c7-0cf8ca8a5bca once approved. Free, no payment.

- First release of the Free twin: permission `ComplicationSubscriber` only (no location, no history), no place kept and no `Application.Storage` (the accent colour is saved as a Properties setting). The time, the 24-hour sun ring from Garmin's own sunrise and sunset (daylight to come and gone, sunrise and sunset ticks, the sun marker), the sun sentence ("3:42 of daylight", "Sunrise 06:41", "Sunrise ~06:41" after sunset, "Sun is up", "No sun data"), Garmin's own Body Battery number in the bolt-gauge glyph (`--` and a hollow glyph when there is none; ADR-021, Body Battery in Free, and ADR-025, larger number), always-on, the on-watch Customize screen.
- Always-on (AMOLED) text is a dim neutral grey (ADR-027, always-on text is a dim grey; simulator only).
- Settings: Accent colour (the six shipped colours: sky, mint, autumn, violet, pink, winter), on the phone and in Customize.
- Not in Free (Pro only): the 24-hour energy curve, golden hour, ring orientation, the date row, the weather and watch battery rows, civil twilight and tomorrow's own sunrise, polar-day and polar-night sentences, the remembered place.
- What's New is blank, per the store form for an initial release; App Version `1.0.0` is in `listing-free/paste.md`.
- ADRs: 020 (Free + Pro ladder), 021 (Body Battery in Free), 025 (Free Body Battery number larger), all accepted 2026-10-04.
- Evidence (simulator and compile only): Free 67 tests on the ten `fit_all.sh` devices; whole-manifest compile sweep 69 of 69 products per jungle (before the Instinct products were added; the Instinct fit runs are in `docs/compatibility.md`); `tools/check_free_package.sh` passes on the exported package (permission `ComplicationSubscriber` only, only the `Accent` key, no "Pro" anywhere). Nothing has run on a wrist.

## 1.0.1 — prepared 2026-09-28, never submitted on its own: folded into Pro 1.1.0 (owner, 2026-10-04)

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
