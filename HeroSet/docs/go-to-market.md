# HeroSet Go-To-Market

Status: 2026-09-26. **Only home for open items and blockers.** History: [`../CHANGELOG.md`](../CHANGELOG.md), ADRs, `git log`.

**Goal:** a paid Connect IQ Store app (USD 2.00 → $1.99 US, no trial, [ADR-039](decisions.md#adr-039)), live since 2026-09-21. Feature work waits unless it unblocks a fix.

## Where things stand

- **1.1.1 is live** (released 2026-09-24 15:32 UTC): 80 products, touch-first wave ([ADR-048](decisions.md#adr-048)), review fixes ([ADR-049](decisions.md#adr-049)/[050](decisions.md#adr-050)). Earlier versions: [`../CHANGELOG.md`](../CHANGELOG.md). Listing: https://apps.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377 · developer page: https://apps-developer.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377 (store id ≠ manifest id, app id `568d5c9b-eb10-4678-bf28-0080c3efbbc1`). Artifacts in `bin/`: `HeroSet-store-1.0.0-shipped.iq`, `HeroSet-store.iq` (1.1.0), `HeroSet-store-next.iq` (1.1.1, re-exported 2026-09-24 after [ADR-050](decisions.md#adr-050)).
- **Tests:** 99 dev / 88 store on fr965 (2026-09-24). Dev suite 97/97 on all 80 products in English and in all 15 languages on `venu2s` + `fr265s` (`tools/fit-sweep.sh`); store suite 88/88 on fr965, venu441mm, d2airx10. `longestLearnableSetFinishes` bounds counting at 1000 ms (it failed three times at 563–610 ms under simulator load against 400); the saving bound stays 50 ms. Simulator fonts are not device fonts.
- **Device evidence is FR965 only:** counting basics, menus, storage upgrade (gate 4), the store menu (gate 5) and a 35-rep set saved with no watchdog crash (2026-09-21). Every other product, the touch UI and the goal picker are simulator-only.
- **Waived ([ADR-042](decisions.md#adr-042), amended):** the full gate 2 accuracy trial. The log was cleared and the FR965 fresh-installed 2026-09-21, so there is almost no accuracy data (one 35-rep set, −4). Accuracy work happens only if buyers report it.
- **Site:** privacy, support and the store link are live (gate 6). Device copy says "works on most Garmin watches" and asks owners of an unsupported model to email it. CSP is enforced.
- **Store device list (store API, 2026-09-25):** 66 of the 80 products are listed. Missing: fēnix 6S, MARQ Gen 1 ×8, Descent MK2/MK2S, FR945 LTE, Enduro, D2 Air X10. HeroFace misses the same families plus every CIQ 3.x product, so this looks like a store-side device policy, not an upload error. The public Compatible Devices tab omits fēnix 6S, MARQ Gen 1, Descent MK2/MK2S, FR945 LTE and Enduro Gen 1, though all are in `manifest-store.xml` and the `.iq`.

## Next session

Cross-app order; HeroFace's half is in [`../../HeroFace/docs/go-to-market.md`](../../HeroFace/docs/go-to-market.md). Tick here, then fold results into the sections above.

**A. Listings**
- [ ] A1. Ask Garmin why 14 of 80 products (and 48 of HeroFace's 117) are not listed; record the answer in "Where things stand". "Signature check failed" → Garmin developer forum.
- [ ] A2. The API reads category 219 (Health & Fitness): check the dashboard saved Strength Training / Other, or whether the change needs review. (Description and What's New edits via Edit Details need no re-review.)
- [ ] A3. Findability: mobile Connect IQ search lists HeroSet for "heroset" and "rep counter" (2026-09-25). Still to do: search "HeroFace" with a fēnix 9 or Forerunner 170 selected, for the reported paid-listings-hidden bug.
- [ ] A4. Venu screenshot for the listing is in `listing/screens/6-review-touch.png` (2026-09-26). To do: upload it as an extra Screen Image on the HeroSet store listing.

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
- [ ] **1.2.0: Connect sync** ([ADR-043](decisions.md#adr-043), [`connect-sync-plan.md`](connect-sync-plan.md)): implemented in the dev build. Next: FR965 spike (step 0) and device acceptance, then the store manifest gets `Fit` + `FitContributor` and privacy, support and store copy change in the same session. The version number lives in the store upload form, not in `manifest-store.xml`.

## Launch gates

Passed: **4** storage upgrade keeps counts, XP, streak, `hero_learning` (2026-09-18) · **5** release menu is exercises + manual log + daily goal, permissions exactly `Sensor` + `ComplicationPublisher` (2026-09-21 on FR965; permissions read off `manifest-store.xml`, a sideload shows no permission screen) · **6** privacy + support public, listing matches behavior (2026-09-22).

| # | Gate | State |
|---|---|---|
| 2 | Median \|error\| ≤ 1 per 10-rep set (after ~5 learning sets); ≤ 1 phantom per 60 s still in position; no crash in 30 min | Accuracy waived ([ADR-042](decisions.md#adr-042)). Launch bar passed 2026-09-21; 30 min soak, speeds and idle unmeasured |
| 3 | Finish/adjust/save/discard/Back flows on watch; no clipped text | Flows done; clip check open |
| 7 | HR/calories sane; battery | Open |
| 8 | Sync (1.2.0): one activity per workout in Connect, nothing stray; re-check gate 6 | Dev build, [`connect-sync-plan.md`](connect-sync-plan.md) device acceptance |

## Never promise

Medical-grade calories · universal device support · perfect or measured counting accuracy · native Garmin calorie totals · automatic or default sync · any Training Status/Readiness/Load effect with sync off. Full list: [`release-contract.md`](release-contract.md).

## After launch (backlog, don't pull forward)

- Battery/performance sweep ([`battery.md`](battery.md)).
- Rollback build ready for the first week of a release.
- More device waves (Instinct, pre-3.4): [`compatibility.md`](compatibility.md).
- More languages if demand; Russian not supported.
