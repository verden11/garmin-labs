# HeroSet Go-To-Market

Status: 2026-09-17.

## Status checkpoint (2026-09-17): read this first if resuming

**Where things stand.**
- **Code:** feature-complete for a v1 beta in the simulator. 74 unit tests pass,
  and dev and store builds compile. A large batch of UX work (ADR-027 to 031)
  is uncommitted: part staged, part not, so check `git status` first.
- **Proven only in the simulator:** layouts, navigation, storage, XP/rank/
  streak. **Not proven on the watch:** counting accuracy, Connect sync, and
  the new dashboard's look.
- **History:** decisions and their reasons are in `decisions.md`; what changed
  when is in `git log`. This section only tracks what's open.

**Open items, in priority order.**

0. **Connect Sync probably doesn't give one activity per day on the FR965.
   Investigation paused.** On-watch test (ADR-030): the log showed
   `SYNC LOST`, yet two HeroSet activities appeared in Garmin Connect that
   day. HeroSet only saves on a day change or on sync-off, so the watch
   likely saves an unfinished recording itself when the app closes.
   - **Before touching sync code, ask the user:**
     1. The SYNC lines as shown (newest first). After the second set
        *without leaving* HeroSet, was it `KEPT` or already `LOST`?
        (`KEPT` then `LOST` after reopening supports the hypothesis. `LOST`
        both times means the timer reading doesn't work on this firmware and
        the test proved nothing.)
     2. Was sync turned off at the end, and did it log `SYNC SAVED` or
        `SYNC EMPTY`?
     3. Start time and duration of each of the two activities: do they end
        around when HeroSet was closed?
   - **User constraint:** never one activity per app visit.
   - **Options if confirmed (none agreed):**
     - (a) Discard the recording on app exit and save one short daily
       summary activity with rep totals (no time/HR). The date is only
       right if it's saved when the mission completes, so partial days are
       skipped.
     - (b) Keep only the visit that completes the mission (its time/HR plus
       the whole day's rep totals); partial days lost.
   - Until resolved, don't advertise "one activity per day"
     (`release-contract.md`).
1. **Counting accuracy fails gate 2 in the first trials.** After a
   successful calibration, push-ups counted 4/10 and another exercise
   (probably squats) 19/10. Undiagnosed; needs more trials per exercise and
   speed before blaming the detector. Blocks Phase 2 step 1. Data:
   `validation-log.md`.
2. **Store upload shows "Signature check failed".** Ruled out: mismatched
   keys (one key on this machine, matches VS Code's
   `monkeyC.developerKeyPath`). Next try: a fresh "Monkey C: Export Project"
   and re-upload.
3. **Privacy policy and support URL not published.** This is a hard launch
   gate; the Phase 1 recommendation is GitHub Pages.
4. **Regenerate the manifest app id before the real paid submission.** Test
   uploads consume `372a11c8-fca3-4dd7-b35b-c83ed18d1b19`. Also update the
   `era -a <uuid>` command in `development.md`.

## Goal

**Publish HeroSet as a paid Connect IQ Store app.** This is the project's
primary goal. Feature work beyond what's already implemented is secondary and
waits until after publish, unless it directly unblocks publishing.

Positioning: button-first daily bodyweight challenge — beta auto-counting,
manual correction, progress without a phone, live HR/calorie readout,
optional Garmin Connect/Strava sync. Target: Forerunner 965 owners wanting a
repeatable short workout ritual. Never promise: medical-grade calories,
universal device support, perfect auto-counting, Garmin Connect native
calorie totals, that sync is automatic/default, or any effect on Training
Status/Readiness/Acute Load with sync off (no activity is ever recorded then).

## Phase 1 — decisions to lock in first

Nothing in Phase 2 should start until these are answered; they change what
Phase 2's checklist even contains.

| Decision | Options | Recommendation |
|---|---|---|
| Calibration scope for v1 | (A) Ship calibration in the store build, validated. (B) Drop calibrated positioning entirely, manual-first v1. | **(A), with a lightweight validation bar** — solo dev across multiple sessions/speeds/exercises (not the full 10-external-tester matrix), since auto-counting is the product's core value prop and it's already honestly framed as "beta." Dropping it (B) is faster to publish but guts the pitch; only fall back to B if solo validation surfaces accuracy too poor to defend the "beta" claim. |
| Accuracy validation method | 10 testers × 3 exercises × 3 speeds (as currently documented), vs. solo/small-group real-device sessions. | **Solo/small-group first.** A 10-tester study is unrealistic for a single-dev project pre-revenue. Run enough solo sessions per exercise/speed to hit the numeric gate (median \|error\| ≤ 1/10-rep set, ≤1 false positive/60s idle, ≥90% calibration success), log results in `release-contract.md`, and treat external testers as a nice-to-have, not a gate. |
| Privacy/support page hosting | Dedicated domain vs. free static host. | **GitHub Pages (or equivalent free static host) off this repo.** No PII leaves the watch (ADR-021/ADR-025 already constrain this), so the policy is short — a free host is proportionate and gets the launch blocker cleared fastest. |
| Garmin Connect/Strava sync default | Keep opt-in/off (ADR-025) vs. flip to on-by-default. | **Keep opt-in/off.** Changing the default re-opens launch gate 6 (privacy listing) and ADR-025 was deliberately conservative; don't reopen it to hit a launch date. |

## Phase 2 — path to publish (ordered)

Each step is a launch gate; see the Launch Gates table below for the exact
pass/fail bar.

1. **Physical accuracy validation** (gate 2) — run the Phase 1 validation
   method. Real workout sets auto-log detected-vs-saved counts on-device
   (ADR-026, main menu → Validation Log); transcribe into
   `docs/validation-log.md`, roll the summary into `release-contract.md`.
2. **Layout/UI confirmation on real FR965** (gate 3) — screenshot every
   screen/state on-device; confirm no text clipping (round-screen fix is
   simulator-verified only so far).
3. **Storage upgrade check** (gate 4) — confirm schema migration preserves
   counters/XP/streak/calibration on a real device, not just in tests.
4. **Sync verification on real hardware** (gate 8) — first run the
   ADR-030 on-watch check (`docs/development.md`, validation log section):
   does the day's recording survive closing HeroSet (`SYNC KEPT` vs
   `SYNC LOST`)? First result says no, see status item 0. Then confirm the
   agreed behavior lands correctly in Garmin Connect and Strava (no GPS
   artifacts, no per-set or per-visit duplicates).
5. **HR/calorie sanity + battery check on-device** (gate 7).
6. **Privacy policy + support URL published** (gate 6) — per Phase 1
   recommendation; must match actual behavior (sync opt-in, no PII leaves
   watch).
7. **Release `.iq` export** (gate 5) — build with `store.jungle`, confirm
   calibration menu entry is absent (or present+validated, per the Phase 1
   decision), test on simulator + physical device.
8. **Merchant onboarding** — Garmin Connect IQ Store merchant account,
   payment/tax/country eligibility (`docs/store-release.md`).
9. **Private beta** — small trusted group, watch for crashes/listener leaks
   over real multi-day use.
10. **Paid launch** at USD 2.00 (→ $1.99 US per Garmin's price-point
    mapping).

## Phase 3 — after publish (backlog, do not pull forward)

- Guided first-run calibration flow.
- Weak-calibration retry state.
- Rollback build kept ready for the first post-launch week.
- Garmin Connect custom/developer FIT fields.
- Additional device targets (only after a layout/sensor capability-matrix
  pass — see `docs/compatibility.md`).
- Localization beyond English.

## Launch gates (P0 — acceptance criteria for Phase 2)

1. If calibration ships: 10-rep calibration succeeds per exercise on FR965.
2. Counting accuracy measured vs manual ground truth: median |error| ≤ 1 per
   10-rep set; ≤ 1 false positive per 60 s idle; calibration success ≥ 90%;
   no crash/listener leak in 30 min sessions.
3. Finish→adjust→save/discard/Back flows tested on watch; no text clips.
4. Storage upgrade preserves counters, XP, streak, calibration.
5. Exported `.iq` has release menu, no calibration entry (unless Phase 1
   decision was to ship calibration validated).
6. Privacy notice + support contact public; listing matches actual behavior.
7. Live HR/calorie readout checked for sane values on watch.
8. Connect sync: enabling it on-watch, logging a set, and confirming one
   combined activity (no GPS, no duplicate-per-set) lands in Garmin Connect
   and Strava correctly. If sync ever flips to enabled-by-default, re-verify
   gate 6 — the toggle default and its wording are part of the privacy
   listing.

## Listing

- Title: HeroSet — Bodyweight Rep Counter ("Bodyweight Counter" read like a
  body-weight scale app)
- Description: push-up/sit-up/squat tracking with daily goals, streaks,
  manual correction, live HR/calorie readout; auto-counting in beta on
  Forerunner 965.
- Screenshots: dashboard → calibration → live count → manual correction →
  completion. Real build only, no mockups.
- Disclosure: counting depends on watch placement/movement; calibration per
  exercise; not a medical device; calories are estimates, not native
  session-level Garmin values. No activity is created or synced unless
  Connect Sync is explicitly turned on in settings (off by default);
  when on, it's one combined activity per day, no GPS/distance.
