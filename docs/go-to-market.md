# HeroSet Go-To-Market

Status: 2026-09-18.

## Status checkpoint (2026-09-18): read this first if resuming

**Where things stand.**
- **Code:** v1 scope locked (ADR-033): calibration in store build, Connect sync out, no `Fit` permission, new app id `568d5c9b-eb10-4678-bf28-0080c3efbbc1`. Rep detector rebuilt (ADR-032); repo simplification pass (ADR-036). 80 unit tests pass (78 in store build — skips `(:debug)` tests); all 67 supported products pass screen-fit test in simulators; dev build, store build, store `.iq` export (`development.md`) all compile. Not committed yet.
- **Proven only in simulator:** layouts, navigation, storage, XP/rank/streak, rep counting on physically shaped traces. **Not proven on watch:** counting accuracy with new detector, store build menus.
- **History:** decisions + reasons in `decisions.md`; what changed when in `git log`. This section track open items only.

**Open items, in priority order.** Step-by-step tick list: [`launch-checklist.md`](launch-checklist.md).

0. ~~Decide which products first paid submission lists.~~ **Decided 2026-09-18: all 67, simulator-verified** (ADR-039). No in-app trial (ADR-039).
1. **Fix idle false positives, then re-run idle + counting trials (gate 2).** 2026-09-18 FR965 trials (`validation-log.md` Summary): counting passes (median |error| 0.5, calibration 3/3, no crash) but idle with normal wrist movement fails — push-ups 14, sit-ups 2, squats 5 phantom reps per 60 s; wrist at rest 0. Fix: count only in exercise position (push-ups: wrist roughly flat/face-down), which also drops the extra rep from getting up. **Open user call:** replace calibration with learning from corrections (store per-set swing sizes, fit threshold to saved count, small running-average step) before launch, or after launch as update. Fast squats miss reps when hands move to/from chin — accepted for now; possible listing/on-screen tip ("keep hands still").
2. **Publish privacy policy + support page (gate 6). Deferred by user until screenshots exist, but must be live before submission — remind user.** Ready in `site/` (`index.html` = support, `privacy.html`, `style.css`), support email `verdenapp@gmail.com`. Host not chosen (GitHub Pages need public repo or paid plan; Netlify/Cloudflare Pages drag-and-drop of `site/` also work). Then put both URLs in upload form. Store-build storage or permissions change → update `privacy.html` first. Update `site/` to say 66 of 67 watches simulator-verified (ADR-039).
3. ~~Merchant enrollment.~~ **Approved 2026-09-18.** No longer blocks paid submission.
4. **Upload new store `.iq`.** Earlier "Signature check failed" not key mismatch: old package and new one carry same public key as repo `developer_key`, and known store bug (value `0xE1C0DE12` in app code) not apply. Most likely old app id registered to different key by earlier upload; new id sidestep that. New upload still fails → report on Garmin developer forum with package.
5. **Screenshots from simulator, store build** (listing, ADR-039) — **remind user; needed before site + upload.** Dashboard → calibration → live count → manual correction → completion, plus 500×500 cover. ~~Storage upgrade check (gate 4)~~ **passed 2026-09-18 on FR965** (sideload over previous build: XP, rank, streak, today counts kept; calibration reset as intended). HR/calorie + battery sanity (gate 7) done in same watch session as item 1.
6. **Beta testers for other 66 watches** — wanted, no longer gate launch (ADR-039). At least one owner per family confirm buttons, screens, counting; MIP watches also daylight contrast. Family that fails → drop from both manifests in update.

## Goal

**Publish HeroSet as paid Connect IQ Store app.** Primary goal. Feature work beyond what implemented is secondary, wait until after publish, unless it directly unblocks publishing.

Positioning: button-first daily bodyweight challenge — beta auto-counting, manual correction, progress without phone, live HR/calorie readout. Connect sync out of v1 (ADR-033). Target: owners of 67 supported round watches (`compatibility.md`, ADR-034/035/037) wanting repeatable short workout ritual. Never promise: medical-grade calories, universal device support, perfect auto-counting, Garmin Connect native calorie totals, that sync automatic/default, or any effect on Training Status/Readiness/Acute Load with sync off (no activity ever recorded then).

## Phase 1 — decisions to lock in first

Nothing in Phase 2 start until these answered; they change what Phase 2 checklist even contains.

| Decision | Options | Recommendation |
|---|---|---|
| Calibration scope for v1 | (A) Ship calibration in the store build, validated. (B) Drop calibrated positioning entirely, manual-first v1. | **Decided 2026-09-17: (A)** (ADR-033). Original reasoning: **(A), with lightweight validation bar** — solo dev across multiple sessions/speeds/exercises (not full 10-external-tester matrix), since auto-counting is product core value prop and already honestly framed "beta." Dropping it (B) faster to publish but guts pitch; fall back to B only if solo validation show accuracy too poor to defend "beta" claim. |
| Accuracy validation method | 10 testers × 3 exercises × 3 speeds (as currently documented), vs. solo/small-group real-device sessions. | **Solo/small-group first.** 10-tester study unrealistic for single-dev project pre-revenue. Run enough solo sessions per exercise/speed to hit numeric gate (median \|error\| ≤ 1/10-rep set, ≤1 false positive/60s idle, ≥90% calibration success), log in `release-contract.md`, treat external testers as nice-to-have, not gate. |
| Privacy/support page hosting | Dedicated domain vs. free static host. | **GitHub Pages (or equivalent free static host) off this repo.** No PII leaves watch (ADR-021/ADR-025 already constrain this), so policy short — free host proportionate, clears launch blocker fastest. |
| Garmin Connect/Strava sync in v1 | Keep opt-in/off (ADR-025) vs. flip to on-by-default vs. leave out. | **Decided 2026-09-17: leave out of v1** (ADR-033). Misbehaved on watch (ADR-030), fixing would delay launch. |

## Phase 2 — path to publish (ordered)

Each step is launch gate; see Launch Gates table below for exact pass/fail bar.

1. **Physical accuracy validation** (gate 2) — run Phase 1 validation method. Real workout sets auto-log detected-vs-saved counts on-device (ADR-026, main menu → Validation Log); transcribe into `docs/validation-log.md`, roll summary into `release-contract.md`.
2. **Layout/UI confirmation on real FR965** (gate 3) — screenshot every screen/state on-device; confirm no text clipping (round-screen fix simulator-verified only so far).
3. **Storage upgrade check** (gate 4) — confirm schema migration preserves counters/XP/streak/calibration on real device, not just in tests.
4. **Sync verification on real hardware** (gate 8) — **out of v1** (ADR-033). Only confirm store build creates no activity.
5. **HR/calorie sanity + battery check on-device** (gate 7).
6. **Privacy policy + support URL published** (gate 6) — per Phase 1 recommendation; must match actual behavior (no sync, nothing leaves watch). Drafts: `site/`.
7. **Release `.iq` export** (gate 5) — build with `store.jungle` (`development.md`), confirm menu has Calibrate but no Connect Sync or Validation Log, test on simulator + physical device.
8. **Merchant onboarding** — Garmin Connect IQ Store merchant account, payment/tax/country eligibility (`docs/store-release.md`).
9. **Private beta** — small trusted group, watch for crashes/listener leaks over real multi-day use.
10. **Paid launch** at USD 2.00 (→ $1.99 US per Garmin price-point mapping).

## Phase 3 — after publish (backlog, do not pull forward)

- **Engineering sweep for battery/performance optimizations** (user request 2026-09-18; battery looked OK in first watch session, no measurement yet): sensor sample rate, refresh timers, draw cost, storage writes.
- Guided first-run calibration flow.
- Weak-calibration retry state.
- Rollback build kept ready for first post-launch week.
- Garmin Connect custom/developer FIT fields.
- Further device waves (two-button touch watches, Instinct, Connect IQ 3.3 and older): `docs/compatibility.md` lists what each needs.
- Additional localization beyond initial 15 launch languages, if store demand and device/font testing justify. Russian not supported.

## Launch gates (P0 — acceptance criteria for Phase 2)

1. If calibration ships: 10-rep calibration succeeds per exercise on FR965.
2. Counting accuracy measured vs manual ground truth: median |error| ≤ 1 per 10-rep set; ≤ 1 false positive per 60 s idle; calibration success ≥ 90%; no crash/listener leak in 30 min sessions.
3. Finish→adjust→save/discard/Back flows tested on watch; no text clips.
4. Storage upgrade preserves counters, XP, streak. Calibration from old detector deliberately dropped (ADR-032); newer profiles must survive.
5. Exported `.iq` has release menu: Calibrate present (ADR-033), no Connect Sync, no Validation Log; manifest permissions are `Sensor` only.
6. Privacy notice + support contact public; listing matches actual behavior.
7. Live HR/calorie readout checked for sane values on watch.
8. Connect sync: not in v1 (ADR-033). When it returns: enabling on-watch, logging a set, confirming one combined activity (no GPS, no duplicate-per-set) lands in Garmin Connect and Strava correctly, and re-verify gate 6, since sync changes privacy listing.

## Listing

- Title: HeroSet — Bodyweight Rep Counter ("Bodyweight Counter" read like body-weight scale app)
- Description: push-up/sit-up/squat tracking with daily goals, streaks, manual correction, live HR/calorie readout; auto-counting in beta on 67 supported watches (`compatibility.md`).
- Screenshots: dashboard → calibration → live count → manual correction → completion. Simulator running store build (ADR-039), no mockups.
- Disclosure: counting depends on watch placement/movement; calibration per exercise; not medical device; calories are estimates, not native session-level Garmin values. HeroSet records no activity and sends no data anywhere: no Garmin Connect/Strava sync in v1 (ADR-033).