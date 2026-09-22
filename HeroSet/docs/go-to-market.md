# HeroSet Go-To-Market

Status: 2026-09-22. **Only home for open items and blockers.** History: ADRs + `git log`.

**Goal:** publish HeroSet as a paid Connect IQ Store app (USD 2.00 → $1.99 US, no trial, ADR-039). Feature work waits until after launch unless it unblocks it.

## Where things stand

- **v1 store build** (ADR-033/040): `Sensor` permission only, no sync, learning replaces calibration. App id `568d5c9b-eb10-4678-bf28-0080c3efbbc1`. 94 tests (85 store build) pass — both re-run on fr965 2026-09-21, after the ADR-045/046 source changes. **All 67 products passed `everyScreenFitsThisDisplay` on 2026-09-21**, after ADR-045, so the goal picker fits everywhere in the simulator (fr965 and fr255s also checked by hand with the longest goal title, `DIENOS TIKSLAS`, and goal 500). Simulator fonts are not device fonts.
- **1.1.0 is live** (uploaded from `bin/HeroSet-store.iq`, the 2026-09-21 23:45 export; store shows version 1.1.0, latest release 2026-09-21). Listing: https://apps.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377 — "HeroSet - Bodyweight Rep Counter", VerdenApp, $1.99. Developer page: https://apps-developer.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377 (store id ≠ manifest id). It carries the ADR-046 save-crash fix, the ADR-044 complication and the ADR-045 daily goal — so the save crash is no longer reachable by buyers, and HeroFace's link works for anyone who updates. 1.0.0 (approved 2026-09-21) is superseded; that artifact is kept as `bin/HeroSet-store-1.0.0-shipped.iq`.
- **Done:** merchant approved (2026-09-18) · storage upgrade check on FR965 (gate 4) · privacy + support live at https://verden.watch/heroset/ (gate 6, `../verden-site`) · listing screenshots in `listing/` (FR970 sim, store build) · store menu check on watch.
- **Waived for launch (ADR-042, amended 2026-09-21):** full gate 2 accuracy trial. The validation log was cleared and the FR965 fresh-installed 2026-09-21, so there is almost no current accuracy data (one 35-rep set, −4); the detector is unchanged and accuracy work is a **1.1.1** item if buyers report it.
- **Proven only in simulator:** everything except FR965 counting basics and menus.
- **Uncommitted:** Connect sync in the dev build (item 5) · this session's doc and site changes, including the site's `storeUrl` — the site only shows the store button once that is pushed.

## Open items, in order

**1.1.0 shipped 2026-09-21.** The next submission is **1.2.0**: Connect sync (ADR-043, item 5), which adds `Fit`/`FitContributor` to the store manifest and changes privacy, support and listing copy in the same session. Accuracy work is **1.1.1**, taken up only if buyers report it (ADR-042 as amended). The version number lives in the store upload form, not in `manifest-store.xml` (CIQ manifest v3 has no version attribute).

0. **Done — the save crash is fixed in the live build.** `Watchdog Tripped Error - Code Executed Too Long` on FR965 (fw 29.05, CIQ 6.0.2) on 2026-09-20: the ADR-040 replay ran 24 × 500 points in one input callback. ADR-046 counts the set as it runs (181 ms → 1 ms), verified on the watch 2026-09-21 with a 35-rep set, and shipped in 1.1.0. Buyers who installed 1.0.0 between 2026-09-21 and the 1.1.0 release could have hit it on a learning save.
1. **Live listing device list.** Compatible Devices tab omits fēnix 6S (non-Pro), MARQ Gen 1, Descent MK2/MK2S, FR945 LTE, Enduro Gen 1, though all are in `manifest-store.xml` and the `.iq`. Check the live listing's device list against the upload form, else ask Garmin. "Signature check failed" → Garmin developer forum.
2. **Done — the live build publishes the complication.** 1.0.0 shipped without `HeroSetComplicationPublisher` (settled 2026-09-20 by unpacking the uploaded `.iq`); 1.1.0 carries it, so HeroFace shows HeroSet mode to buyers who own both and have updated (`../../heroFace/docs/go-to-market.md` §2).
3. **Now live:** store page public, site links to it (item 8 closed). Still open: private beta (small group, multi-day: crashes, listener leaks) · announcing the paid launch — both now unblocked — 1.1.0 removed the save crash.
4. **Configurable daily goal** (ADR-045, [`configurable-goal-plan.md`](configurable-goal-plan.md)): **shipped in 1.1.0.** Implemented 2026-09-20 in both builds and in HeroFace. Next: the watch checks at the end of that plan and a per-language menu check (Menu2 item labels do not shrink, unlike screen text).
5. **Connect sync — in 1.2.0** (ADR-043, [`connect-sync-plan.md`](connect-sync-plan.md), moved out of 1.1.0 by user call 2026-09-21): implemented in dev build. Next: FR965 spike (step 0) + device acceptance, then store build gets `Fit` + `FitContributor` and privacy/support/store copy change same session.
6. **Post-launch watch checks** (FR965, dev build unless noted):
   - [ ] Gate 2 (evidence, not a 1.1.0 gate — log cleared 2026-09-21, fresh install): 3 × 10 reps per exercise at slow/medium/fast; 60 s still in position per exercise (count phantoms, then Discard); one 30+ rep set. Known risks from the deleted data: push-ups over-count on 15–25 rep sets, squats collapsed to 3-for-10 twice, fast squats, push-up getting-up rep. Tuning `HeroSetConfig` is a 1.1.1 item. Results → `validation-log.md`, summary → `release-contract.md`.
   - [ ] Gate 3: every screen, no clipped text.
   - [ ] Gate 7: HR looks like pulse, calories climb; battery per [`battery.md`](battery.md) measurement (store build).
   - [ ] Store build: one set, phone sync, no activity in Connect.
   - [ ] Validation Log: photograph every page before it wraps (30 entries).
7. **Beta testers for the other 66 watches** (don't gate launch, ADR-039): per family confirm buttons, screens, counting; MIP also daylight contrast. Failing family → drop from both manifests.

8. **Done — the site links to the store.** `storeUrl` set in `../verden-site/src/apps/heroset/app.ts` 2026-09-22, once 1.1.0 made the daily-goal copy true. Two claims were corrected in `Landing.tsx` the same session: XP now reads "up to 100 reps per exercise a day" (it said "up to each day's goal", which contradicts the ADR-045 cap at any goal above 100), and the learning line no longer promises it "gets closer with every set" — there is no accuracy data to support that. **Uncommitted: needs a push to deploy.**

## Launch gates

| # | Gate | State |
|---|---|---|
| 2 | Median \|error\| ≤ 1 per 10-rep set (after ~5 learning sets); ≤ 1 phantom per 60 s still in position; no crash in 30 min | Accuracy waived (ADR-042, amended). **1.1.0 bar passed 2026-09-21** and shipped: 35-rep set saved, no watchdog crash. 30 min soak, speeds and idle still unmeasured |
| 3 | Finish/adjust/save/discard/Back flows on watch; no clipped text | Flows done; clip check open |
| 4 | Storage upgrade keeps counts, XP, streak, `hero_learning` | Passed 2026-09-18 |
| 5 | `.iq` release menu: exercises + manual log + daily goal only; permissions exactly `Sensor` + `ComplicationPublisher` | **Passed 2026-09-21** on FR965, `HeroSet-store.prg`: exercises + Manual Log present, no Connect Sync toggle, no Validation Log entry, Daily Goal opens the picker and steps by 10. Permissions read off `manifest-store.xml`, not the watch — a sideload shows no permission screen |
| 6 | Privacy + support public; listing matches behavior | **Passed 2026-09-22** — 1.1.0 ships the daily goal, so site, listing and build agree; `storeUrl` set, two `Landing.tsx` claims corrected (item 8) |
| 7 | HR/calories sane; battery | Open |
| 8 | Sync (1.2.0): one activity per workout lands in Connect, nothing stray; re-check gate 6 | Dev build, `connect-sync-plan.md` device acceptance |

## Never promise

Medical-grade calories · universal device support · perfect or measured counting accuracy · native Garmin calorie totals · automatic or default sync · any Training Status/Readiness/Load effect with sync off. Full list: [`release-contract.md`](release-contract.md).

## After launch (backlog, don't pull forward)

- Battery/performance sweep ([`battery.md`](battery.md)).
- Rollback build ready for the first week.
- More device waves (touch watches, Instinct, pre-3.4): [`compatibility.md`](compatibility.md).
- More languages if demand; Russian not supported.
