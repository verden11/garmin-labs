# HeroSet Go-To-Market

Status: 2026-09-19.

## Status checkpoint (2026-09-19): read this first if resuming

**Where things stand.**
- **Code:** v1 scope locked (ADR-033): Connect sync out; calibration replaced by learning from saved counts (ADR-040), no `Fit` permission, new app id `568d5c9b-eb10-4678-bf28-0080c3efbbc1`. Rep detector rebuilt (ADR-032); repo simplification pass (ADR-036). 79 unit tests pass (77 in store build — skips `(:debug)` tests); all 67 supported products pass screen-fit test in simulators; dev build, store build, store `.iq` export (`development.md`) all compile. Not committed yet.
- **Proven only in simulator:** layouts, navigation, storage, XP/rank/streak, rep counting on physically shaped traces. **Not proven on watch:** counting accuracy with new detector, store build menus.
- **History:** decisions + reasons in `decisions.md`; what changed when in `git log`. This section track open items only.

**Open items, in priority order.** Step-by-step tick list: [`launch-checklist.md`](launch-checklist.md).

0. ~~Decide which products first paid submission lists.~~ **Decided 2026-09-18: all 67, simulator-verified** (ADR-039). No in-app trial (ADR-039).
1. ~~Re-run watch trials with learning build (gate 2).~~ **Waived for launch 2026-09-19 (ADR-042).** 4 medium 10-rep sets on FR965: +2/0/0/0, saves fine (`validation-log.md`). Post-launch: 3 speeds × each exercise, 60 s idle in position, one 30+ rep set, store build: no activity in Connect after a set (menu check passed 2026-09-19). Fast squats + push-up getting-up rep are the known risks. Detector/learning constants in `HeroSetConfig`.
2. **Privacy policy + support page (gate 6): live.** Built 2026-09-19 as separate multi-app static site, sibling repo `../verden-site` (Vite + React prerendered to plain HTML, no client JS; Netlify builds on push to `main`). HeroSet pages: `/heroset/` (landing), `/heroset/support/`, `/heroset/privacy/` — last two go in upload form. Copy says FR965-tested, rest simulator-verified (ADR-039). **Live since 2026-09-19 at https://verden.watch** (Netlify, domain + `hello@verden.watch` inbox at Hostinger); upload form: https://verden.watch/heroset/support/ and https://verden.watch/heroset/privacy/. Screenshots in `public/heroset/screens/`; set `storeUrl` in `src/apps/heroset/app.ts` once listing live. Store-build storage or permissions change → update `src/apps/heroset/Privacy.tsx` there first.
3. ~~Merchant enrollment.~~ **Approved 2026-09-18.** No longer blocks paid submission.
4. **Store `.iq` uploaded 2026-09-19, pending Garmin review** (up to 3 days). Signature error gone with new app id. Store app page: https://apps-developer.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377 (store id differs from manifest app id). Preview shows 1.0.0, 2,49€, only permission "Fitness & Sensor Data", 5 screenshots. **Open:** its Compatible Devices tab lists no fēnix 6S (non-Pro), MARQ Gen 1, Descent MK2/MK2S, Forerunner 945 LTE or Enduro (Gen 1), though all are in `manifest-store.xml` and the `.iq` (105 part numbers). Cause unknown; check the upload form's device list, else ask Garmin.
5. **Screenshots from simulator, store build** (listing, ADR-039) — **done 2026-09-19** (FR970 sim, same 454 px AMOLED as FR965). Listing set in repo `listing/` (`screens/1-dashboard`, `2-counting`, `3-review`, `4-saved`, optional `5-menu`; `cover-500`); watch-framed crops (1300×1300, dev-build session, for site/social) in `~/screenshots/framed/`. Same four on the site. Optional later: one MIP (`fenix7`) shot. ~~Storage upgrade check (gate 4)~~ **passed 2026-09-18 on FR965** (sideload over previous build: XP, rank, streak, today counts kept; calibration reset as intended). HR/calorie + battery sanity (gate 7) done in same watch session as item 1.
6. **Beta testers for other 66 watches** — wanted, no longer gate launch (ADR-039). At least one owner per family confirm buttons, screens, counting; MIP watches also daylight contrast. Family that fails → drop from both manifests in update.

## Goal

**Publish HeroSet as paid Connect IQ Store app.** Primary goal. Feature work beyond what implemented is secondary, wait until after publish, unless it directly unblocks publishing.

Positioning: button-first daily bodyweight challenge — beta auto-counting, manual correction, progress without phone, live HR/calorie readout. Connect sync out of v1 (ADR-033). Target: owners of 67 supported round watches (`compatibility.md`, ADR-034/035/037) wanting repeatable short workout ritual. Never promise: medical-grade calories, universal device support, perfect auto-counting, Garmin Connect native calorie totals, that sync automatic/default, or any effect on Training Status/Readiness/Acute Load with sync off (no activity ever recorded then).

## Phase 1 — decisions to lock in first

Nothing in Phase 2 start until these answered; they change what Phase 2 checklist even contains.

| Decision | Options | Recommendation |
|---|---|---|
| Calibration scope for v1 | (A) Ship calibration in the store build, validated. (B) Drop calibrated positioning entirely, manual-first v1. | **Superseded 2026-09-19 by ADR-040:** calibration screen removed, thresholds learned from saved counts. Was: decided 2026-09-17 (A) (ADR-033). Original reasoning: **(A), with lightweight validation bar** — solo dev across multiple sessions/speeds/exercises (not full 10-external-tester matrix), since auto-counting is product core value prop and already honestly framed "beta." Dropping it (B) faster to publish but guts pitch; fall back to B only if solo validation show accuracy too poor to defend "beta" claim. |
| Accuracy validation method | 10 testers × 3 exercises × 3 speeds (as currently documented), vs. solo/small-group real-device sessions. | **Solo/small-group first.** 10-tester study unrealistic for single-dev project pre-revenue. Run enough solo sessions per exercise/speed to hit numeric gate (median \|error\| ≤ 1/10-rep set, ≤1 false positive/60s idle, ≥90% calibration success), log in `release-contract.md`, treat external testers as nice-to-have, not gate. |
| Privacy/support page hosting | Dedicated domain vs. free static host. | **GitHub Pages (or equivalent free static host) off this repo.** No PII leaves watch (ADR-021/ADR-025 already constrain this), so policy short — free host proportionate, clears launch blocker fastest. |
| Garmin Connect/Strava sync in v1 | Keep opt-in/off (ADR-025) vs. flip to on-by-default vs. leave out. | **Decided 2026-09-17: leave out of v1** (ADR-033). Misbehaved on watch (ADR-030), fixing would delay launch. |

## Phase 2 — path to publish (ordered)

Each step is launch gate; see Launch Gates table below for exact pass/fail bar.

1. **Physical accuracy validation** (gate 2) — run Phase 1 validation method. Real workout sets auto-log detected-vs-saved counts on-device (ADR-026, main menu → Validation Log); transcribe into `docs/validation-log.md`, roll summary into `release-contract.md`.
2. **Layout/UI confirmation on real FR965** (gate 3) — screenshot every screen/state on-device; confirm no text clipping (round-screen fix simulator-verified only so far).
3. **Storage upgrade check** (gate 4) — confirm schema migration preserves counters/XP/streak/learned thresholds on real device, not just in tests.
4. **Sync verification on real hardware** (gate 8) — **out of v1** (ADR-033). Only confirm store build creates no activity.
5. **HR/calorie sanity + battery check on-device** (gate 7).
6. **Privacy policy + support URL published** (gate 6) — per Phase 1 recommendation; must match actual behavior (no sync, nothing leaves watch). Site: `../verden-site` (status item 2).
7. **Release `.iq` export** (gate 5) — build with `store.jungle` (`development.md`), confirm menu has no Calibrate, Connect Sync or Validation Log, test on simulator + physical device.
8. ~~**Merchant onboarding**~~ **done (approved 2026-09-18)** — Garmin Connect IQ Store merchant account, payment/tax/country eligibility (`docs/store-release.md`).
9. **Private beta** — small trusted group, watch for crashes/listener leaks over real multi-day use.
10. **Paid launch** at USD 2.00 (→ $1.99 US per Garmin price-point mapping).

## Phase 3 — after publish (backlog, do not pull forward)

- **Engineering sweep for battery/performance optimizations** (user request 2026-09-18; battery looked OK in first watch session, no measurement yet): findings, keep/update list and measurement plan in `docs/battery.md`.
- Rollback build kept ready for first post-launch week.
- Garmin Connect custom/developer FIT fields.
- Further device waves (two-button touch watches, Instinct, Connect IQ 3.3 and older): `docs/compatibility.md` lists what each needs.
- Additional localization beyond initial 15 launch languages, if store demand and device/font testing justify. Russian not supported.

## Launch gates (P0 — acceptance criteria for Phase 2)

1. ~~Calibration succeeds per exercise.~~ Calibration removed (ADR-040); passed 3/3 on 2026-09-18 while it existed.
2. Counting accuracy measured vs manual ground truth: median |error| ≤ 1 per 10-rep set (after ~5 learning sets per exercise); ≤ 1 false positive per 60 s still in exercise position (ADR-040); no crash/listener leak in 30 min sessions.
3. Finish→adjust→save/discard/Back flows tested on watch; no text clips.
4. Storage upgrade preserves counters, XP, streak. Learned thresholds (`hero_learning`, ADR-040) must survive.
5. Exported `.iq` has release menu: exercises + manual logging only — no Calibrate (ADR-040), no Connect Sync, no Validation Log; manifest permissions are `Sensor` only.
6. Privacy notice + support contact public; listing matches actual behavior.
7. Live HR/calorie readout checked for sane values on watch.
8. Connect sync: not in v1 (ADR-033). When it returns: enabling on-watch, logging a set, confirming one combined activity (no GPS, no duplicate-per-set) lands in Garmin Connect and Strava correctly, and re-verify gate 6, since sync changes privacy listing.

## Listing

- Title: HeroSet — Bodyweight Rep Counter ("Bodyweight Counter" read like body-weight scale app)
- Description: push-up/sit-up/squat tracking with daily goals, streaks, manual correction, live HR/calorie readout; auto-counting ("can be off", no "beta" in public copy) on 67 supported watches (`compatibility.md`).
- Screenshots: dashboard → live count → manual correction → completion. Simulator running store build (ADR-039), no mockups.
- Disclosure: counting depends on watch placement/movement; learns from counts user saves; not medical device; calories are estimates, not native session-level Garmin values. HeroSet records no activity and sends no data anywhere: no Garmin Connect/Strava sync in v1 (ADR-033).