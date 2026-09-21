# HeroSet Go-To-Market

Status: 2026-09-21. **Only home for open items and blockers.** History: ADRs + `git log`.

**Goal:** publish HeroSet as a paid Connect IQ Store app (USD 2.00 → $1.99 US, no trial, ADR-039). Feature work waits until after launch unless it unblocks it.

## Where things stand

- **v1 store build** (ADR-033/040): `Sensor` permission only, no sync, learning replaces calibration. App id `568d5c9b-eb10-4678-bf28-0080c3efbbc1`. 94 tests (85 store build) pass — both re-run on fr965 2026-09-21, after the ADR-045/046 source changes. **All 67 products passed `everyScreenFitsThisDisplay` on 2026-09-21**, after ADR-045, so the goal picker fits everywhere in the simulator (fr965 and fr255s also checked by hand with the longest goal title, `DIENOS TIKSLAS`, and goal 500). Simulator fonts are not device fonts.
- **The published build crashes on save (ADR-046, item 0).** Fixed on disk, ships in 1.1.0 (ADR-047).
- **1.0.0 approved and live 2026-09-21** (uploaded 2026-09-19). Listing: https://apps.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377 — "HeroSet - Bodyweight Rep Counter" (hyphen, as the live page and `store-release.md` have it), VerdenApp, $1.99, 0 downloads, checked 2026-09-21. Developer page: https://apps-developer.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377 (store id ≠ manifest id). Preview: 1.0.0, 2,49€, permission "Fitness & Sensor Data", 5 screenshots. **The live build is the one that crashes on save (item 0) and does not publish the complication (item 2).** Left published deliberately; fixed forward in 1.1.0 (ADR-047).
- **Done:** merchant approved (2026-09-18) · storage upgrade check on FR965 (gate 4) · privacy + support live at https://verden.watch/heroset/ (gate 6, `../verden-site`) · listing screenshots in `listing/` (FR970 sim, store build) · store menu check on watch.
- **Waived for launch (ADR-042, amended 2026-09-21):** full gate 2 accuracy trial. The validation log was cleared 2026-09-21 and the FR965 fresh install is pending, so there is no current accuracy data; the detector is unchanged and accuracy work is a **1.1.1** item if buyers report it.
- **Proven only in simulator:** everything except FR965 counting basics and menus.
- **Uncommitted:** v1.1 Connect sync in the dev build (item 3) · the user-set daily goal (item 4).

## Open items, in order

**1.1.0 is the next submission** (decided 2026-09-21, ADR-047). Scope: the
ADR-046 save-crash fix, the ADR-044 complication, the ADR-045 daily goal — all
on disk. **Connect sync moved to 1.2.0** (item 5): its step 0 is still a design
fork and its acceptance is weeks, and the crash is live on buyers' watches now.
1.1.0 still adds `ComplicationPublisher` to the store manifest, so it is a full
review cycle. The version number lives in the store upload form, not in
`manifest-store.xml` (CIQ manifest v3 has no version attribute).

**1.1.0 is built and ready to upload.** `bin/HeroSet-store.iq`, exported 2026-09-21 23:45 (`monkeyc -e -r -f store.jungle`), 105 of 105 device variants. The shipped 1.0.0 artifact is kept beside it as `bin/HeroSet-store-1.0.0-shipped.iq`. Gate 2's crash-only bar **passed 2026-09-21** — 35 push-ups saved through the picker on the FR965, detected 31 (−4), no `Watchdog Tripped` (`validation-log.md`). **How its contents were checked, and the limit of it:** a `-r` (release) build strips every symbol and resource name — a release `.prg` greps 0 for `HeroSetComplicationPublisher` *and* for the word `complication`, while the same build without `-r` greps 69. So a symbol scan of the `.iq` proves nothing either way, and the 2026-09-20 unpack that settled item 2 cannot be repeated this way. What is checked: the non-release `store.jungle` build of the same source (`device-test/HeroSet-store.prg`, 23:31) contains `HeroSetComplicationPublisher`, `HeroSetThresholdLearner`, `hero_learning` and `hero_goal`, and does not contain `HeroSetActivitySync` or `HeroSetCalibration`; `-r` strips names but excludes no code beyond the `(:debug)`/`(:sync)` annotations the jungle already drops. Corroboration: 4.5M vs the shipped 1.0.0's 4.3M, consistent with the complication resources being added. **Direct proof is a device check, not a file check:** install `HeroSet-store.prg` with HeroFace and confirm the face updates after a save — **never re-upload
`bin/HeroSet-store.iq`, that file is live 1.0.0.** The 1.0.0 → 1.1.0 upgrade path is **not** being re-tested on device: `hero_goal` (ADR-045) already landed over existing data on the FR965 on 2026-09-20 without losing counts, XP or streak, and the user chose (2026-09-21) a clean delete + fresh install over preserving that state. Gate 4's 2026-09-18 pass stands as the storage-upgrade evidence. Gate 6 stays a re-check until
the site's daily-goal copy matches a shipped build (item 8).

0. **The live 1.0.0 crashes on save — fix verified on device 2026-09-21, ships in 1.1.0.** `Watchdog Tripped Error - Code Executed Too Long` on FR965 (fw 29.05, CIQ 6.0.2) on 2026-09-20, saving a set from the picker: the ADR-040 replay ran 24 × 500 points in one input callback (181 ms in the simulator, 96% of it the replay loop). Reachable on every reviewing save on any device once a set runs long enough — quick-save (Back → Save) doesn't learn and is unaffected. **Fixed on disk (ADR-046)**: the set is counted as it runs, 181 ms → 1 ms. **Decided 2026-09-21 (ADR-047): 1.0.0 stays published, the fix ships in 1.1.0** — buyers until then can hit the crash on a learning save. **Verified on the watch 2026-09-21**: a 35-rep set saved through the picker returned to the dashboard, no crash.
1. **Live listing device list.** Compatible Devices tab omits fēnix 6S (non-Pro), MARQ Gen 1, Descent MK2/MK2S, FR945 LTE, Enduro Gen 1, though all are in `manifest-store.xml` and the `.iq`. Check the live listing's device list against the upload form, else ask Garmin. "Signature check failed" → Garmin developer forum.
2. **The approved build does not publish the complication.** Settled 2026-09-20 by unpacking `bin/HeroSet-store.iq` (built 2026-09-19 23:52, the uploaded one): it contains `HeroSetThresholdLearner` and `hero_learning` but no `HeroSetComplicationPublisher`, and no `HeroSetCalibration`. So until 1.1.0 clears review HeroFace shows everyday mode to buyers who own both (`../../heroFace/docs/go-to-market.md` §2). Item 0 rides the same upload.

3. **Now live:** store page public (item 8 holds the site's `storeUrl` back until 1.1.0). Still open: private beta (small group, multi-day: crashes, listener leaks) · announcing the paid launch — both better after 1.1.0 removes the save crash.
4. **Configurable daily goal** (ADR-045, [`configurable-goal-plan.md`](configurable-goal-plan.md)): implemented 2026-09-20 in both builds and in HeroFace. Next: the watch checks at the end of that plan and a per-language menu check (Menu2 item labels do not shrink, unlike screen text).
5. **Connect sync — in 1.2.0** (ADR-043, [`connect-sync-plan.md`](connect-sync-plan.md), moved out of 1.1.0 by user call 2026-09-21): implemented in dev build. Next: FR965 spike (step 0) + device acceptance, then store build gets `Fit` + `FitContributor` and privacy/support/store copy change same session.
6. **Post-launch watch checks** (FR965, dev build unless noted):
   - [ ] Gate 2 (evidence, not a 1.1.0 gate — log cleared 2026-09-21, fresh install): 3 × 10 reps per exercise at slow/medium/fast; 60 s still in position per exercise (count phantoms, then Discard); one 30+ rep set. Known risks from the deleted data: push-ups over-count on 15–25 rep sets, squats collapsed to 3-for-10 twice, fast squats, push-up getting-up rep. Tuning `HeroSetConfig` is a 1.1.1 item. Results → `validation-log.md`, summary → `release-contract.md`.
   - [ ] Gate 3: every screen, no clipped text.
   - [ ] Gate 7: HR looks like pulse, calories climb; battery per [`battery.md`](battery.md) measurement (store build).
   - [ ] Store build: one set, phone sync, no activity in Connect.
   - [ ] Validation Log: photograph every page before it wraps (30 entries).
7. **Beta testers for the other 66 watches** (don't gate launch, ADR-039): per family confirm buttons, screens, counting; MIP also daylight contrast. Failing family → drop from both manifests.

8. **Site copy is ahead of the live build, so the store link waits.** The summary, `Landing.tsx` and `Support.tsx` under `../verden-site/src/apps/heroset/` describe the ADR-045 daily goal (10…500), which the live 1.0.0 does not have. **Decided 2026-09-21: `storeUrl` stays unset** (a comment in `app.ts` says why) rather than reword the pages twice — buyers reach the listing through Garmin search meanwhile. Set it when 1.1.0 clears review, and re-check gate 6 then. `release-contract.md` describes the on-disk build, not the shipped one.

## Launch gates

| # | Gate | State |
|---|---|---|
| 2 | Median \|error\| ≤ 1 per 10-rep set (after ~5 learning sets); ≤ 1 phantom per 60 s still in position; no crash in 30 min | Accuracy waived (ADR-042, amended). **1.1.0 bar passed 2026-09-21**: 35-rep set saved, no watchdog crash. 30 min soak, speeds and idle still unmeasured |
| 3 | Finish/adjust/save/discard/Back flows on watch; no clipped text | Flows done; clip check open |
| 4 | Storage upgrade keeps counts, XP, streak, `hero_learning` | Passed 2026-09-18 |
| 5 | `.iq` release menu: exercises + manual log + daily goal only; permissions exactly `Sensor` + `ComplicationPublisher` | **Passed 2026-09-21** on FR965, `HeroSet-store.prg`: exercises + Manual Log present, no Connect Sync toggle, no Validation Log entry, Daily Goal opens the picker and steps by 10. Permissions read off `manifest-store.xml`, not the watch — a sideload shows no permission screen |
| 6 | Privacy + support public; listing matches behavior | **Re-check at 1.1.0** — site describes the ADR-045 daily goal, live 1.0.0 does not; store link held back (item 8) |
| 7 | HR/calories sane; battery | Open |
| 8 | Sync (1.2.0): one activity per workout lands in Connect, nothing stray; re-check gate 6 | Dev build, `connect-sync-plan.md` device acceptance |

## Never promise

Medical-grade calories · universal device support · perfect or measured counting accuracy · native Garmin calorie totals · automatic or default sync · any Training Status/Readiness/Load effect with sync off. Full list: [`release-contract.md`](release-contract.md).

## After launch (backlog, don't pull forward)

- Battery/performance sweep ([`battery.md`](battery.md)).
- Rollback build ready for the first week.
- More device waves (touch watches, Instinct, pre-3.4): [`compatibility.md`](compatibility.md).
- More languages if demand; Russian not supported.
