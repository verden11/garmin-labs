# HeroSet Go-To-Market

Status: 2026-10-01. **Only home for open items and blockers.** History: [`../CHANGELOG.md`](../CHANGELOG.md), ADRs, `git log`.

**Goal:** a paid Connect IQ Store app (USD 2.00 → $1.99 US, no trial, [ADR-039](decisions.md#adr-039)), live since 2026-09-21. Feature work waits unless it unblocks a fix; the glance ([ADR-051](decisions.md#adr-051)) is the one exception, requested by the owner 2026-09-26.

## Where things stand

- **1.2.0 (glance + idle-kill fix, submitted under that number rather than 1.1.2, ADR-053) uploaded 2026-09-27, approved by Garmin (owner reported 2026-10-01; approval date not recorded), now live.** A read-only glance-list entry on the 63 watches with Connect IQ 4.0+ ([ADR-051](decisions.md#adr-051), [`compatibility.md`](compatibility.md)), plus the recoverable-draft fix for the glance-launch idle-timeout kill found the same day ([ADR-052](decisions.md#adr-052)). Nothing else changes for users. **Owner call: uploaded without E2b, E4 or E5** (see "Next session" E below for exactly what ran and what didn't); the ship-blocking check, E1, did run and pass. `dist/HeroSet-store.iq` exported 2026-09-27. Screenshots not updated for this upload (owner will add later; text fields don't need them).
- **1.1.1 is live** (released 2026-09-24 15:32 UTC): 80 products, touch-first wave ([ADR-048](decisions.md#adr-048)), review fixes ([ADR-049](decisions.md#adr-049)/[050](decisions.md#adr-050)). Earlier versions: [`../CHANGELOG.md`](../CHANGELOG.md). Listing: https://apps.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377 · developer page: https://apps-developer.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377 (store id ≠ manifest id, app id `568d5c9b-eb10-4678-bf28-0080c3efbbc1`). Artifacts in `bin/`: `HeroSet-store-1.0.0-shipped.iq`, `HeroSet-store.iq` (1.1.0), `HeroSet-store-next.iq` (1.1.1, re-exported 2026-09-24 after [ADR-050](decisions.md#adr-050)).
- **Tests:** 114 dev / 101 store on fr965 (2026-10-02: +2 dev-only regression tests for the stale-draft bug below; 2026-09-27: +6 for the recoverable workout draft, ADR-052); the dev suite also passes on one product per glance screen width (fr255s, fēnix 7S, 7, 7X, Venu 2S, Venu 4 41 mm, fr265, fēnix 9 Pro 51 mm, Venu 3), and all 80 products build in both jungles. Earlier (2026-09-24): dev suite 97/97 on all 80 products in English and in all 15 languages on `venu2s` + `fr265s` (`tools/fit-sweep.sh`); store suite 88/88 on fr965, venu441mm, d2airx10. `longestLearnableSetFinishes` bounds counting at 1000 ms (it failed three times at 563–610 ms under simulator load against 400); the saving bound stays 50 ms. Simulator fonts are not device fonts.
- **Device evidence is FR965 only:** counting basics, menus, storage upgrade (gate 4), the store menu (gate 5) and a 35-rep set saved with no watchdog crash (2026-09-21). Every other product, the touch UI and the goal picker are simulator-only.
- **Waived ([ADR-042](decisions.md#adr-042), amended):** the full gate 2 accuracy trial — near-empty log post-reset, details in [`validation-log.md`](validation-log.md). Accuracy work happens only if buyers report it.
- **Site:** privacy, support and the store link are live (gate 6). Device copy says "works on most Garmin watches" and asks owners of an unsupported model to email it. CSP is enforced.
- **Store device list (store API, 2026-09-25):** 66 of the 80 products are listed. Missing: fēnix 6S, MARQ Gen 1 ×8, Descent MK2/MK2S, FR945 LTE, Enduro, D2 Air X10. HeroFace misses the same families plus every CIQ 3.x product, so this looks like a store-side device policy, not an upload error. The public Compatible Devices tab omits fēnix 6S, MARQ Gen 1, Descent MK2/MK2S, FR945 LTE and Enduro Gen 1, though all are in `manifest-store.xml` and the `.iq`.

## Next session

Cross-app order; HeroFace's half is in [`../../HeroFace/docs/go-to-market.md`](../../HeroFace/docs/go-to-market.md). Tick here, then fold results into the sections above.

**A. Listings**
- [ ] A1. Ask Garmin why 14 of 80 products (and 48 of HeroFace's 117) are not listed; record the answer in "Where things stand". "Signature check failed" → Garmin developer forum.
- [ ] A2. The API reads category 219 (Health & Fitness): check the dashboard saved Strength Training / Other, or whether the change needs review. (Description and What's New edits via Edit Details need no re-review.)
- [ ] A3. Findability: mobile Connect IQ search lists HeroSet for "heroset" and "rep counter" (2026-09-25). Still to do: search "HeroFace" with a fēnix 9 or Forerunner 170 selected, for the reported paid-listings-hidden bug.
- [ ] A4. Venu screenshot for the listing is in `listing/screens/6-review-touch.png` (2026-09-26). To do: upload it as an extra Screen Image on the HeroSet store listing.

**E. Glance (submitted as 1.2.0, gates the upload)** — FR965, dev build, all-day wear ([ADR-051](decisions.md#adr-051)); none of this has run on a watch, and the simulator's Glance Launch Mode (Settings) is a GUI toggle that could not be scripted
- [x] E1. **FAILED, then fixed and confirmed (FR965, dev build, 2026-09-27).** A set launched from the glance and left idle was killed at exactly 120s (screen stays lit, redraws don't reset the timer); reps were lost. Fixed same day: [ADR-052](decisions.md#adr-052), a periodic recoverable draft. **Closed** — see E1-retest.
- [x] E1-retest. **Confirmed on FR965 (2026-09-27):** killed a set from idle past 120s, started the same exercise again — count resumed. Other exercises correctly show 0 (draft doesn't bleed across exercises). Not yet confirmed: a draft surviving to the next calendar day reads as 0 (needs an overnight check, not blocking).
- [x] E2a. Glance appears in the glance list **by default, no add needed** (FR965, dev build, 2026-09-27). Listing/FAQ wording ("scroll to your glance list") stands as written.
- [~] E2b. **Skipped, owner call 2026-09-27.** A saved set shows on returning to the list; at 00:01 it shows zeros without opening the app; a missed day shows no streak. Not verified before upload.
- [x] E3. Confirmed (FR965, 2026-09-27): HeroFace shows the same data as HeroSet/the glance after a save. The publish-point move to `getInitialView` works.
- [~] E4. **Skipped, owner call 2026-09-27.** Simulator, Settings → Glance Launch Mode, by hand on `fr965`, `fenix7` (63 px tall) and `fr255s` (140×79): looks right, MIP contrast, done state; open the memory view once. Not looked at before upload — only the automated fit tests (`HeroSetGlanceFitTest`, pixel geometry, no eyes-on rendering) ran.
- [~] E5. **Skipped, owner call 2026-09-27** — `CIQ_LOG.YAML` and the battery comparison were not done before upload. Store build's permission list confirmed unchanged (`Sensor` + `ComplicationPublisher`, manifest untouched). Exported `dist/HeroSet-store.iq` 2026-09-27; upload 1.2.0 with the text in `listing/README.md`. 1.2.0 is live: `glanceLive` is `true` in `../site/src/apps/heroset/facts.ts` (2026-10-01) and the support FAQ about the glance shows (the site deploys on push to `main`).

**Owner call, 2026-09-27: uploading 1.2.0 without E2b, E4 or E5.** What did run and pass first: E1/E1-retest (the ship-blocking idle-timeout kill, found, fixed and confirmed on FR965), E2a (glance shows by default), E3 (HeroFace complication), 112/112 dev + 101/101 store unit tests including the new draft-recovery tests, `HeroSetGlanceFitTest`'s pixel-level layout checks at every glance size, the `-l 3` scope gate, and an 80-product build sweep in both jungles. What did not run: a human look at the rendered glance (E4), a saved-set/midnight-rollover/missed-streak check specifically through the glance (E2b), and the crash-log/battery read after a day of wear (E5). Simulator passing and a build sweep are not device proof ([ADR-022](decisions.md#adr-022)/[023](decisions.md#adr-023)); this upload carries that risk knowingly.

**B. Device and simulator checks** (post-release by owner call, [ADR-048](decisions.md#adr-048)/[050](decisions.md#adr-050)). A Venu 4 owner's report would be the first real evidence for the touch UI; Garmin relays such requests as `noreply@garmin.com` mail, so there is no address to reply to.
- [ ] B1. FR965 on wrist, dev build: START finishes a set; START saves the manual and goal pickers; reps still count; picker hint reads `UP/DOWN`; Back after a lone dropped rep leaves the set ([ADR-050](decisions.md#adr-050)).
- [ ] B2. Simulator by hand, `venu441mm`: tap mid-set does nothing; START finishes; swipe up = +1 in the picker; tap in the picker does nothing; START saves; swipe-right mid-set shows the Resume menu.
- [ ] B3. Simulator, `d2airx10`: START opens the menu and selects in Menu2.
- [ ] B4. Native-speaker read of the strings changed in 1.1.1 (touch hints), at least `deu`, `lit`, `pol`; per-language menu check (Menu2 item labels do not shrink, unlike screen text).
- [ ] B5. Daily goal on watch ([ADR-045](decisions.md#adr-045), simulator-verified only): FR965 with goal 30 and 500, one set each: dashboard bars, menu sublabels and the workout `TODAY` line legible, goal survives a restart. Picker at 500 on one MIP product and one 208 px round product. HeroFace on a CIQ 4.2+ product shows the custom goal and still renders with an old HeroSet installed.

**C. Post-launch watch checks** (FR965, dev build unless noted)
- [ ] Gate 2 evidence: 3 × 10 reps per exercise at slow/medium/fast; 60 s still in position per exercise (count phantoms, then Discard); one 30+ rep set. Known risks from the deleted data: push-ups over-count on 15–25 rep sets, squats collapsed to 3-for-10 twice, fast squats, push-up getting-up rep. Tuning `HeroSetConfig` is a 1.1.x item. Results → [`validation-log.md`](validation-log.md), summary → [`release-contract.md`](release-contract.md).
- [ ] Gate 3: every screen, no clipped text.
- [ ] Gate 7: HR looks like pulse, calories climb; battery per [`docs/battery.md`](battery.md) (store build).
- [ ] Store build: one set, phone sync, no activity in Connect.
- [ ] Validation Log: photograph every page before it wraps (30 entries).

**D. Later**
- [ ] Private beta (small group, multi-day: crashes, listener leaks) and the paid-launch announcement. Both unblocked.
- [ ] Beta testers for watches other than the FR965 (don't gate anything, [ADR-039](decisions.md#adr-039)): per family confirm buttons, screens, counting; MIP also daylight contrast. Failing family → drop from both manifests.
- [x] **1.3.0: Connect sync — shelved, [ADR-054](decisions.md#adr-054).** FR965 step 0 spike (2026-09-27): Garmin Connect (mobile + web) doesn't render our developer lap/session fields at all — Sets table stays a native empty placeholder, zero mentions of the exercise totals in the web export. Plus two device bugs found (stray recording blocks reopen after exit; Discard still laps). Not pursuing further without a different product design. Dev-build code untouched.

**F. Instinct 2 family (proposed wave 6, branch `worktree-agent-af3357b81b1eb31cf`, nothing uploaded; [ADR-056](decisions.md#adr-056))** — simulator only, look unapproved
- [ ] F1. Owner: approve or change the look (`instinct-mockup.html`): XP gauge in the window, no "XP TO GO" line, streak beside the rank, outlined bar tracks.
- [ ] F2. Owner: which products ship (`instinct2`, `instinct2s`, `instinct2x`, `descentg1` are in the branch's manifests). Descent G1 and Instinct 2X share the Instinct 2's layout but have not been run in their own simulator (see ADR-056 Evidence).
- [ ] F3. Hint wording: the Instinct 2's select key is printed `GPS`, hints say `START` ([ADR-029](decisions.md#adr-029)).
- [ ] F4. A real Instinct 2: accelerometer at 25 Hz (otherwise NO SENSOR and manual entry), text against the real bezel and window ring (the 11 px ring clearance is read off the simulator image), 1-bit contrast.
- [ ] F5. Before any release: store listing device list, `release-contract.md` and the site's device claims (nothing changed on this branch); store build memory re-measured on the final code.
- Tests on the branch: 115 defined (102 in the store build; +1 `rowsBesideASubscreenWindowStayClearOfIt`, +2 dev-only draft tests from the 2026-10-02 stale-draft fix on main; the counts quoted from the agent's run below were taken at 113 before the rebase). Run 2026-10-02: dev 113/113 on `instinct2`, `instinct2s`, `instinct2x`, `fr255s`, `fenix6`; store 102/102 on `instinct2`, `fr255s`; all 84 manifest products build in both jungles. **Not run:** the `fr965` suite (hangs in this simulator on the baseline commit too, so the FR965 check is still owed) and the `descentg1` suite (see ADR-056 Evidence).

## Launch gates

Passed: **4** storage upgrade keeps counts, XP, streak, `hero_learning` (2026-09-18) · **5** release menu is exercises + manual log + daily goal, permissions exactly `Sensor` + `ComplicationPublisher` (2026-09-21 on FR965; permissions read off `manifest-store.xml`, a sideload shows no permission screen) · **6** privacy + support public, listing matches behavior (2026-09-22).

| # | Gate | State |
|---|---|---|
| 2 | Median \|error\| ≤ 1 per 10-rep set (after ~5 learning sets); ≤ 1 phantom per 60 s still in position; no crash in 30 min | Accuracy waived ([ADR-042](decisions.md#adr-042)). Launch bar passed 2026-09-21; 30 min soak, speeds and idle unmeasured |
| 3 | Finish/adjust/save/discard/Back flows on watch; no clipped text | Flows done; clip check open |
| 7 | HR/calories sane; battery | Open |
| 8 | Sync: one activity per workout in Connect, nothing stray; re-check gate 6 | **Shelved, [ADR-054](decisions.md#adr-054).** Connect doesn't render the developer fields this needed; not pursuing |

## Never promise

Medical-grade calories · universal device support · perfect or measured counting accuracy · native Garmin calorie totals · automatic or default sync · any Training Status/Readiness/Load effect with sync off. Full list: [`release-contract.md`](release-contract.md).

## After launch (backlog, don't pull forward)

- Battery/performance sweep ([`battery.md`](battery.md)).
- Rollback build ready for the first week of a release.
- More device waves (Instinct E / 3 / Crossover; pre-3.4): [`compatibility.md`](compatibility.md).
- More languages if demand; Russian not supported.

## Resolved: glance idle-timeout kill (2026-09-27, same day: found, fixed, confirmed)

**Confirmed on FR965, dev build, exact boundary: killed at exactly 120s idle.** Set from the glance (e.g. START squats/sit-ups), do 2-3 reps, leave the watch untouched on a desk. Screen stays lit the whole time (not a display-off issue) and the app still runs its normal 1 Hz redraw (HR/calories) — so the system's launched-from-glance inactivity timer is **not reset by redraws**, only by real input. At exactly 120s the process is killed and the in-progress reps are gone: nothing was banked, because nothing is saved until Save is pressed (by design — "nothing is saved until you've seen it"). A set started from the normal app-list launch has no such timeout (SDK docs).

**Owner picked "recoverable draft."** [ADR-052](decisions.md#adr-052): the live workout screen checkpoints its in-progress detected count to Storage every 15s (and once more when paused by the Resume/Save/Discard menu), not as a saved rep — just enough that starting that exercise again resumes the count instead of 0. Cleared at every real ending (Finish, Save, Discard, the no-count Back). 6 new store-level unit tests, written and compile-checked only (the simulator was busy with another session; never actually run).

**Confirmed fixed on FR965 (2026-09-27):** killed a set idle past 120s, restarted the same exercise — count resumed; a different exercise correctly showed 0 (no cross-exercise bleed). Not yet confirmed, not blocking: a draft surviving unresumed to the next calendar day reads as 0 (needs an overnight check). Known, accepted gap (not built): the review picker's own pending delta (after Finish, before Save) isn't checkpointed, so idling there can still lose a correction — same shape, smaller window in practice.
