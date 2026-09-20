# HeroSet Go-To-Market

Status: 2026-09-20. **Only home for open items and blockers.** History: ADRs + `git log`.

**Goal:** publish HeroSet as a paid Connect IQ Store app (USD 2.00 → $1.99 US, no trial, ADR-039). Feature work waits until after launch unless it unblocks it.

## Where things stand

- **v1 store build** (ADR-033/040): `Sensor` permission only, no sync, learning replaces calibration. App id `568d5c9b-eb10-4678-bf28-0080c3efbbc1`. 94 tests (85 store build) pass; all 67 products passed screen fit in simulator before ADR-045 — the goal picker is verified on fr965 and fr255s (218 px, smallest) only, with the longest goal title (`DIENOS TIKSLAS`) and goal 500; the other 65 products are a re-run still owed.
- **Uploaded 2026-09-19, in Garmin review.** Store page: https://apps-developer.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377 (store id ≠ manifest id). Preview: 1.0.0, 2,49€, permission "Fitness & Sensor Data", 5 screenshots.
- **Done:** merchant approved (2026-09-18) · storage upgrade check on FR965 (gate 4) · privacy + support live at https://verden.watch/heroset/ (gate 6, `../verden-site`) · listing screenshots in `listing/` (FR970 sim, store build) · store menu check on watch.
- **Waived for launch (ADR-042):** full gate 2 accuracy trial. 4 medium sets on FR965 counted +2/0/0/0.
- **Proven only in simulator:** everything except FR965 counting basics and menus.
- **Uncommitted:** v1.1 Connect sync in the dev build (item 3) · the user-set daily goal (item 4).

## Open items, in order

1. **Garmin review.** Compatible Devices tab omits fēnix 6S (non-Pro), MARQ Gen 1, Descent MK2/MK2S, FR945 LTE, Enduro Gen 1, though all are in `manifest-store.xml` and the `.iq`. Check the upload form's device list, else ask Garmin. "Signature check failed" → Garmin developer forum.
2. **Does the build in review publish the complication?** `ComplicationPublisher` is in both manifests now, but `bin/HeroSet-store.iq` was built 2026-09-19 23:52 and the ADR-044/045 work is dated 2026-09-20; the store preview lists one permission, "Fitness & Sensor Data". Check the store page's permission list. If the publisher is not in it, HeroSet needs a 1.0.1 upload, and until that clears review HeroFace shows everyday mode to buyers who own both (`../../heroFace/docs/go-to-market.md` §2).

3. **After approval:** set `storeUrl` in `../verden-site/src/apps/heroset/app.ts` · private beta (small group, multi-day: crashes, listener leaks) · paid launch.
4. **Configurable daily goal** (ADR-045, [`configurable-goal-plan.md`](configurable-goal-plan.md)): implemented 2026-09-20 in both builds and in HeroFace. Next: the watch checks at the end of that plan, **gate 5 re-check** (the release menu now carries a third kind of item), the screen-fit sweep across the remaining 65 products, and a per-language menu check (Menu2 item labels do not shrink, unlike screen text).
5. **v1.1 Connect sync** (ADR-043, [`connect-sync-plan.md`](connect-sync-plan.md)): implemented in dev build. Next: FR965 spike (step 0) + device acceptance, then store build gets `Fit` + `FitContributor` and privacy/support/store copy change same session.
6. **Post-launch watch checks** (FR965, dev build unless noted):
   - [ ] Gate 2: 3 × 10 reps per exercise at slow/medium/fast; 60 s still in position per exercise (count phantoms, then Discard); one 30+ rep set. Known risks: fast squats, push-up getting-up rep. Tune `HeroSetConfig`. Results → `validation-log.md`, summary → `release-contract.md`.
   - [ ] Gate 3: every screen, no clipped text.
   - [ ] Gate 7: HR looks like pulse, calories climb; battery per [`battery.md`](battery.md) measurement (store build).
   - [ ] Store build: one set, phone sync, no activity in Connect.
   - [ ] Validation Log: photograph every page before it wraps (30 entries).
7. **Beta testers for the other 66 watches** (don't gate launch, ADR-039): per family confirm buttons, screens, counting; MIP also daylight contrast. Failing family → drop from both manifests.

## Launch gates

| # | Gate | State |
|---|---|---|
| 2 | Median \|error\| ≤ 1 per 10-rep set (after ~5 learning sets); ≤ 1 phantom per 60 s still in position; no crash in 30 min | Waived for launch, post-launch check |
| 3 | Finish/adjust/save/discard/Back flows on watch; no clipped text | Flows done; clip check open |
| 4 | Storage upgrade keeps counts, XP, streak, `hero_learning` | Passed 2026-09-18 |
| 5 | `.iq` release menu: exercises + manual log + daily goal only; `Sensor` permission only | **Re-check open** — ADR-045 added the `Daily Goal` item to `resources-store/menus/menu.xml` |
| 6 | Privacy + support public; listing matches behavior | Live |
| 7 | HR/calories sane; battery | Open |
| 8 | Sync (v1.1): one activity per workout lands in Connect, nothing stray; re-check gate 6 | Dev build, `connect-sync-plan.md` device acceptance |

## Never promise

Medical-grade calories · universal device support · perfect or measured counting accuracy · native Garmin calorie totals · automatic or default sync · any Training Status/Readiness/Load effect with sync off. Full list: [`release-contract.md`](release-contract.md).

## After launch (backlog, don't pull forward)

- Battery/performance sweep ([`battery.md`](battery.md)).
- Rollback build ready for the first week.
- More device waves (touch watches, Instinct, pre-3.4): [`compatibility.md`](compatibility.md).
- More languages if demand; Russian not supported.
