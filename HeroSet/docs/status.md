# HeroSet — status

> **Open items live only in the root [`ROADMAP.md`](../../ROADMAP.md).** This file keeps where things stand, the evidence, the release gates and the upload steps. Listing text and metadata: [`../listing/paste.md`](../listing/paste.md) and [`../listing/meta.yaml`](../listing/meta.yaml). Claims: [`release-contract.md`](release-contract.md). Shelved plan: [`archive/connect-sync-plan.md`](archive/connect-sync-plan.md).

**Where things stand, 2026-10-04.** Live: **1.3.0** (uploaded by the owner 2026-10-03: the Instinct family, 87 products; exported before the bezel-corner, `START: MENU` and glance-bar fixes). **1.3.1 uploaded by the owner 2026-10-04, in review** (those three fixes and the glance laid out left of the Instinct E / 3 Solar round window, blind; `dist/HeroSet-1.3.1.iq`, 87 products; set on the USD 2.50 tier, ADR-056 (the $2.50 tier)); the approval date is not yet known. Tests 116 dev / 103 store (2026-10-04, simulator). Device evidence is the FR965 only; every Instinct result is simulator only. Open work: ROADMAP M7, 9.6. **Unreleased (2026-10-05):** Instinct 3 AMOLED 45/50 mm added to both manifests (89 products; on Garmin's paid-app list, so ROADMAP 10.21 is answered for HeroSet; the Crossover AMOLED is on that list too but stays out because its simulated hands cover the screen's middle); dev 116/116 and store 103/103 on both, simulator only ([`compatibility.md`](compatibility.md) wave 7, [ADR-055](decisions.md#adr-055) (Instinct family) amendment). Their look is the owner's to approve.

**Unreleased, 2026-10-05: three rectangles** (`venusq2`, `venusq2m`, `venux1`, [ADR-057](decisions.md#adr-057) (rectangular watches)), 90 products in both manifests. All three are on Garmin's paid-app list. Evidence, simulator only (container): dev and store suites PASSED on the three and on fr965, fr255s, venu3, instincte40mm; 15-language fit sweep PASSED on venusq2 and venux1; screenshots of every screen on venusq2, venux1 and fr965 looked at. Gate before the next upload: the owner approves the rectangle look.

Status: 2026-10-05. (open items moved to the root ROADMAP.md, 2026-10-04) History: [`../CHANGELOG.md`](../CHANGELOG.md), ADRs, `git log`.

**Goal:** a paid Connect IQ Store app (the $2.50 tier from the 1.3.1 upload, live until then at the $2.00 tier, [ADR-056](decisions.md#adr-056) (price: the $2.50 tier for every paid app); no trial, [ADR-039](decisions.md#adr-039) (no in-app trial)), live since 2026-09-21. Feature work waits unless it unblocks a fix; the glance ([ADR-051](decisions.md#adr-051)) is the one exception, requested by the owner 2026-09-26.

## Uploaded 2026-10-04: 1.3.1 (in review)

The owner uploaded 1.3.1 on 2026-10-04 as exported, on the USD 2.50 tier; Garmin's review is pending and 1.3.0 stays live until it ends. Version 1.3.1 changes no product and no permission; it carries the fixes found after the 1.3.0 export ([`../CHANGELOG.md`](../CHANGELOG.md)). Text as uploaded: `../listing/paste.md`. The `live:` and `next:` fields in `../listing/meta.yaml` say 1.3.0 live, 1.3.1 uploaded 2026-10-04.

**On approval (the checks still to do):**

1. Record the approval date here, in `../CHANGELOG.md` and in `../listing/meta.yaml` (`live:` becomes 1.3.1).
2. Open the live listing and read the store's device tab. Flip `instinctLive` in `site/src/apps/heroset/facts.ts` **only after approval and only after checking that list**: name on the site only the Instinct products the store really shows (ROADMAP 7.8, 9.9); Instinct 2, 2S, 2X and Descent G1 are expected to be absent (not on Garmin's paid-app list). Note any further drops under "Where things stand".
3. Check the price shows at the $2.50 tier (US $2.49).
4. The first real Instinct wrist report is the first device evidence for the Instinct products and for the blind glance layout (ROADMAP 9.6).

| File (absolute path) | Products | Check |
|---|---|---|
| `/Users/mbp/dev/garmin/HeroSet/dist/HeroSet-1.3.1.iq` (uploaded) | 87 | no check script: unpacked with `bsdtar` 2026-10-04: app id 568d5c9b-eb10-4678-bf28-0080c3efbbc1 (same as `manifest-store.xml`), permissions Sensor and ComplicationPublisher only, 134 part numbers and 134 .prg, 87 `<iq:product>` lines in the manifest |

Built in the `verden-ciq-build` container (`docker/run.sh`, `monkeyc -e -r -f store.jungle -o dist/HeroSet-store.iq`, then renamed: an export written straight to a differently named `-o` held a second, stale `HeroSet-store.prg` per product). Simulator and compile only, **nothing on a wrist**. The file is in the ignored `dist/` folder; older exports were deleted 2026-10-05 (rebuild from git if needed). Product counts are `<iq:product>` lines in the manifest; the export holds more part numbers (device variants).

## Where things stand

- **1.2.0 (glance + idle-kill fix, submitted under that number rather than 1.1.2, ADR-053) uploaded 2026-09-27, approved by Garmin (owner reported 2026-10-01; approval date not recorded); superseded by 1.3.0 on 2026-10-03.** A read-only glance-list entry on the 63 watches with Connect IQ 4.0+ ([ADR-051](decisions.md#adr-051), [`compatibility.md`](compatibility.md)), plus the recoverable-draft fix for the glance-launch idle-timeout kill found the same day ([ADR-052](decisions.md#adr-052)). Nothing else changes for users. **Owner call: uploaded without E2b, E4 or E5** (see "Next session" E below for exactly what ran and what didn't); the ship-blocking check, E1, did run and pass. `dist/HeroSet-store.iq` exported 2026-09-27. Screenshots not updated for this upload (owner will add later; text fields don't need them).
- **1.1.1** (released 2026-09-24 15:32 UTC, superseded by 1.2.0): 80 products, touch-first wave ([ADR-048](decisions.md#adr-048)), review fixes ([ADR-049](decisions.md#adr-049)/[050](decisions.md#adr-050)). Earlier versions: [`../CHANGELOG.md`](../CHANGELOG.md). Listing: https://apps.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377 · developer page: https://apps-developer.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377 (store id ≠ manifest id, app id `568d5c9b-eb10-4678-bf28-0080c3efbbc1`).
- **Tests:** 116 dev / 103 store since 2026-10-04 (see F). Before: 114 dev / 101 store on fr965 (2026-10-02: +2 dev-only regression tests for the stale-draft bug below; 2026-09-27: +6 for the recoverable workout draft, ADR-052); the dev suite also passes on one product per glance screen width (fr255s, fēnix 7S, 7, 7X, Venu 2S, Venu 4 41 mm, fr265, fēnix 9 Pro 51 mm, Venu 3), and all 80 products build in both jungles. Earlier (2026-09-24): dev suite 97/97 on all 80 products in English and in all 15 languages on `venu2s` + `fr265s` (`tools/fit-sweep.sh`); store suite 88/88 on fr965, venu441mm, d2airx10. `longestLearnableSetFinishes` bounds counting at 1000 ms (it failed three times at 563–610 ms under simulator load against 400); the saving bound stays 50 ms. Simulator fonts are not device fonts.
- **Device evidence is FR965 only:** counting basics, menus, storage upgrade (gate 4), the store menu (gate 5) and a 35-rep set saved with no watchdog crash (2026-09-21). Every other product, the touch UI and the goal picker are simulator-only.
- **Waived ([ADR-042](decisions.md#adr-042), amended):** the full gate 2 accuracy trial — near-empty log post-reset, details in [`validation-log.md`](validation-log.md). Accuracy work happens only if buyers report it.
- **Site:** privacy, support and the store link are live (gate 6). Device copy says "works on most Garmin watches" and asks owners of an unsupported model to email it. CSP is enforced.
- **Store device list (store API, 2026-09-25):** 66 of the 80 products are listed. Missing: fēnix 6S, MARQ Gen 1 ×8, Descent MK2/MK2S, FR945 LTE, Enduro, D2 Air X10. HeroFace misses the same families plus every CIQ 3.x product, so this looks like a store-side device policy, not an upload error. The public Compatible Devices tab omits fēnix 6S, MARQ Gen 1, Descent MK2/MK2S, FR945 LTE and Enduro Gen 1, though all are in `manifest-store.xml` and the `.iq`.

## Checks to run (the procedures; the to-do items are in the root ROADMAP.md)

Cross-app order; HeroFace's half is in [`../../HeroFace/docs/status.md`](../../HeroFace/docs/status.md). The to-do ids are in the root ROADMAP.md; fold results into the sections above.

**A. Listings**
- A1. Ask Garmin why 14 of 80 products (and 48 of HeroFace's 117) are not listed; record the answer in "Where things stand". "Signature check failed" → Garmin developer forum.
- A2. The API reads category 219 (Health & Fitness): check the dashboard saved Strength Training / Other, or whether the change needs review. (Description and What's New edits via Edit Details need no re-review.)
- A3. Findability: mobile Connect IQ search lists HeroSet for "heroset" and "rep counter" (2026-09-25). Still to do: search "HeroFace" with a fēnix 9 or Forerunner 170 selected, for the reported paid-listings-hidden bug.
- A4. Venu screenshot for the listing (2026-09-26): superseded and deleted 2026-10-05 (in git history): the 2026-10-04 listing set is five framed images, none from a Venu (the store caps Screen Images at 5; [`../listing/screenshots.md`](../listing/screenshots.md)).

**E. Glance (submitted as 1.2.0, gates the upload)** — FR965, dev build, all-day wear ([ADR-051](decisions.md#adr-051)); none of this has run on a watch, and the simulator's Glance Launch Mode (Settings) is a GUI toggle that could not be scripted
- [x] E1. **FAILED, then fixed and confirmed (FR965, dev build, 2026-09-27).** A set launched from the glance and left idle was killed at exactly 120s (screen stays lit, redraws don't reset the timer); reps were lost. Fixed same day: [ADR-052](decisions.md#adr-052), a periodic recoverable draft. **Closed** — see E1-retest.
- [x] E1-retest. **Confirmed on FR965 (2026-09-27):** killed a set from idle past 120s, started the same exercise again — count resumed. Other exercises correctly show 0 (draft doesn't bleed across exercises). Not yet confirmed: a draft surviving to the next calendar day reads as 0 (needs an overnight check, not blocking).
- [x] E2a. Glance appears in the glance list **by default, no add needed** (FR965, dev build, 2026-09-27). Listing/FAQ wording ("scroll to your glance list") stands as written.
- [~] E2b. **Skipped, owner call 2026-09-27.** A saved set shows on returning to the list; at 00:01 it shows zeros without opening the app; a missed day shows no streak. Not verified before upload.
- [x] E3. Confirmed (FR965, 2026-09-27): HeroFace shows the same data as HeroSet/the glance after a save. The publish-point move to `getInitialView` works.
- [~] E4. **Skipped, owner call 2026-09-27.** Simulator, Settings → Glance Launch Mode, by hand on `fr965`, `fenix7` (63 px tall) and `fr255s` (140×79): looks right, MIP contrast, done state; open the memory view once. Not looked at before upload. **Looked at 2026-10-04 in the container simulator (`tools/drive_screens.sh`):** the empty-day glance on `fr965`, `fr255s` and `fenix7` fits (`NO STREAK YET` whole, three bars, MIP bright); the done state and the memory view were not looked at — only the automated fit tests (`HeroSetGlanceFitTest`, pixel geometry, no eyes-on rendering) ran.
- [~] E5. **Skipped, owner call 2026-09-27** — `CIQ_LOG.YAML` and the battery comparison were not done before upload. Store build's permission list confirmed unchanged (`Sensor` + `ComplicationPublisher`, manifest untouched). Exported `dist/HeroSet-store.iq` 2026-09-27; upload 1.2.0 with the text in `listing/paste.md`. 1.2.0 is live: `glanceLive` is `true` in `../site/src/apps/heroset/facts.ts` (2026-10-01) and the support FAQ about the glance shows (the site deploys on push to `main`).

**Owner call, 2026-09-27: uploading 1.2.0 without E2b, E4 or E5.** What did run and pass first: E1/E1-retest (the ship-blocking idle-timeout kill, found, fixed and confirmed on FR965), E2a (glance shows by default), E3 (HeroFace complication), 112/112 dev + 101/101 store unit tests including the new draft-recovery tests, `HeroSetGlanceFitTest`'s pixel-level layout checks at every glance size, the `-l 3` scope gate, and an 80-product build sweep in both jungles. What did not run: a human look at the rendered glance (E4), a saved-set/midnight-rollover/missed-streak check specifically through the glance (E2b), and the crash-log/battery read after a day of wear (E5). Simulator passing and a build sweep are not device proof ([ADR-022](decisions.md#adr-022)/[023](decisions.md#adr-023)); this upload carries that risk knowingly.

**B. Device and simulator checks** (post-release by owner call, [ADR-048](decisions.md#adr-048)/[050](decisions.md#adr-050)). A Venu 4 owner's report would be the first real evidence for the touch UI; Garmin relays such requests as `noreply@garmin.com` mail, so there is no address to reply to.
- B1. FR965 on wrist, dev build: START finishes a set; START saves the manual and goal pickers; reps still count; picker hint reads `UP/DOWN`; Back after a lone dropped rep leaves the set ([ADR-050](decisions.md#adr-050)).
- B2. Simulator by hand, `venu441mm`: tap mid-set does nothing; START finishes; swipe up = +1 in the picker; tap in the picker does nothing; START saves; swipe-right mid-set shows the Resume menu. **Done in the container simulator 2026-10-04 (`tools/drive_screens.sh`, xdotool on the display), all six observed:** the mid-set tap left the count and screen unchanged, START opened the picker (`DETECTED 23 / +23`), a quick swipe up made it `+24`, a tap there changed nothing, START saved (`+24 SAVED`), and a swipe right from the left edge during a set opened the `23 reps` menu with Resume first (tapping Resume was not driven). Also seen: in the dashboard-opened menu START does nothing, items are chosen by tap. Simulator, not a wrist.
- B3. Simulator, `d2airx10`: START opens the menu and selects in Menu2. **Half done 2026-10-04:** START on the dashboard opens the menu; a second START in the menu did nothing visible (same on `venu441mm`), so selecting is by tap in the simulator; the first item sits partly under the round bezel (native Menu2). Whether START selects on the real watch is open.
- B4. Native-speaker read of the strings changed in 1.1.1 (touch hints), at least `deu`, `lit`, `pol`; per-language menu check (Menu2 item labels do not shrink, unlike screen text).
- B5. Daily goal on watch ([ADR-045](decisions.md#adr-045), simulator-verified only): FR965 with goal 30 and 500, one set each: dashboard bars, menu sublabels and the workout `TODAY` line legible, goal survives a restart. Picker at 500 on one MIP product and one 208 px round product. HeroFace on a CIQ 4.2+ product shows the custom goal and still renders with an old HeroSet installed.

**C. Post-launch watch checks** (FR965, dev build unless noted)
- Gate 2 evidence: 3 × 10 reps per exercise at slow/medium/fast; 60 s still in position per exercise (count phantoms, then Discard); one 30+ rep set. Known risks from the deleted data: push-ups over-count on 15–25 rep sets, squats collapsed to 3-for-10 twice, fast squats, push-up getting-up rep. Tuning `HeroSetConfig` is a 1.1.x item. Results → [`validation-log.md`](validation-log.md), summary → [`release-contract.md`](release-contract.md).
- Gate 3: every screen, no clipped text.
- Gate 7: HR looks like pulse, calories climb; battery per [`docs/battery.md`](battery.md) (store build).
- Store build: one set, phone sync, no activity in Connect.
- Validation Log: photograph every page before it wraps (30 entries).

**D. Later**
- Private beta (small group, multi-day: crashes, listener leaks) and the paid-launch announcement. Both unblocked.
- Beta testers for watches other than the FR965 (don't gate anything, [ADR-039](decisions.md#adr-039)): per family confirm buttons, screens, counting; MIP also daylight contrast. Failing family → drop from both manifests.
- [x] **1.3.0: Connect sync — shelved, [ADR-054](decisions.md#adr-054).** FR965 step 0 spike (2026-09-27): Garmin Connect (mobile + web) doesn't render our developer lap/session fields at all — Sets table stays a native empty placeholder, zero mentions of the exercise totals in the web export. Plus two device bugs found (stray recording blocks reopen after exit; Discard still laps). Not pursuing further without a different product design. Dev-build code untouched.

**F. Instinct family (wave 6, merged to main 2026-10-03, live as 1.3.0 since the 2026-10-03 upload; [ADR-055](decisions.md#adr-055))** — simulator only, look approved 2026-10-03
- [x] F1. Look approved by the owner 2026-10-03 (`archive/instinct-mockup.html`): XP gauge in the window, no "XP TO GO" line, streak beside the rank, outlined bar tracks; a finished row says DONE where its count was.
- [x] F2. Products: `instinct2`, `instinct2s`, `instinct2x`, `descentg1` plus the CIQ 6 `instincte40mm`, `instincte45mm`, `instinct3solar45mm` are in the branch's manifests (owner 2026-10-03: simulator evidence is enough, no watch available). The Crossover is left out (analog hands over the display). Descent G1 and Instinct 2X share the Instinct 2's layout but have not been run in their own simulator (see ADR-055 Evidence).
- [x] F3. Hint wording: hints stay `START` (owner 2026-10-03: no GPS is needed, so `GPS` would mislead).
- F4. A real Instinct 2: accelerometer at 25 Hz (otherwise NO SENSOR and manual entry), text against the real bezel and window ring (the 11 px ring clearance is read off the simulator image), 1-bit contrast.
- [x] F5a. Drafted 2026-10-03: What's New + App Version `1.3.0` + description bullet in `listing/paste.md` (the number is the owner's call), release contract, `CHANGELOG.md`; the site's Instinct copy sits behind `instinctLive` (`site/src/apps/heroset/facts.ts`, false until the upload is approved).
- [x] F5b. Owner uploaded 1.3.0 on 2026-10-03. Still to do after approval of 1.3.1: flip `instinctLive` to true and push (ROADMAP 7.8); the 1.2.0 listing's device list grows by the seven Instinct products (App Migration: choose per the listing page).
- [x] F5. Store build memory: not re-probed on a running simulator; bounded instead (2026-10-03): the `instinct2` store PRG grew 71,356 -> 71,884 B (+528 B) between the measured commit and main, so the peak is about 53.7 KB of the 98,304 B limit (the probe figure was 53,216 B). A real probe re-run is still possible on request.
- Tests: 116 defined, 103 in the store build (2026-10-04: dev 116/116 on `instincte40mm`, `instincte45mm`, `instinct3solar45mm`, `fr965`, `fr255s`; store 103/103 on `instincte40mm`). Earlier, on the branch: 115 defined (102 in the store build; +1 `rowsBesideASubscreenWindowStayClearOfIt`, +2 dev-only draft tests from the 2026-10-02 stale-draft fix on main; the counts quoted from the agent's run below were taken at 113 before the rebase). Run 2026-10-02: dev 113/113 on `instinct2`, `instinct2s`, `instinct2x`, `fr255s`, `fenix6`; store 102/102 on `instinct2`, `fr255s`; all 84 manifest products build in both jungles. **Not run:** the `fr965` suite (hangs in this simulator on the baseline commit too, so the FR965 check is still owed) and the `descentg1` suite (see ADR-055 Evidence).

**G. Upload 1.3.1 (DONE by the owner 2026-10-04; kept as the record of the steps and form answers)**
1. Developer page for the existing listing (link under "Where things stand") -> upload a new version -> file `HeroSet/dist/HeroSet-1.3.1.iq` (87 products, 134 device variants, same app id and permissions as 1.3.0).
2. App Version `1.3.1`; What's New and the Description are in `listing/paste.md` (the Description changed, see below); paste the blocks as they are. Set the price tier to USD 2.50 in the form (ADR-056 (price: the $2.50 tier); Garmin may re-review a repriced approved app, and this version upload is re-reviewed anyway). Keep every other field as submitted for 1.3.0 (category, privacy URL, review notification Yes, App Migration No). **The description changed too** (no watch model is named any more: the Instinct sentence now says "black-and-white screens", and the language line is the generic "Multi-language support" line): paste the Description block as well, not only What's New. Also edit the live 1.3.0 description in the dashboard if you do not want to wait for the 1.3.1 review: it names Instinct 2, 2S, 2X and Descent G1, which Garmin's paid-app product list does not include, so the store does not sell HeroSet on them (Garmin policies research 2026-10-04, ROADMAP 10.15). A description-only edit of the live text needs no re-review of the app's details (owner's expectation; unverified).
3. Hardware field: the live value is already the bare URL `https://verden.watch/heroset/`; keep it that way (the field is `hardwareProductUrl`, a URL, not a sentence; ROADMAP 6.6).
4. After submitting, tell Claude: the upload date goes in `CHANGELOG.md` and `meta.yaml`. `instinctLive` in `site/src/apps/heroset/facts.ts` flips once Garmin shows the Instinct products in the device list (7.8).
5. Known now (2026-10-04): the store's device list lacks Instinct 2, 2S, 2X and Descent G1 (not on Garmin's paid-app list), so the site's paid HeroSet pages name only Instinct E 40/45 mm and Instinct 3 Solar when `instinctLive` flips (ROADMAP 7.8, 9.9); the four may appear only on a future HeroSet Free page. After the 1.3.1 review, check the real device list and note any further drops in "Where things stand".
Evidence behind the claims: simulator only for every Instinct product ([ADR-055](decisions.md#adr-055)), and the Instinct E / 3 Solar glance layout is blind (the simulator draws the glance under the window; the first real wrist shows whether the layout is needed or right, ROADMAP 9.6); the first real Instinct wrist report will be the first device evidence.

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
- More device waves (Crossover; pre-3.4): [`compatibility.md`](compatibility.md).
- More languages if demand; Russian not supported.

## Resolved: glance idle-timeout kill (2026-09-27, same day: found, fixed, confirmed)

**Confirmed on FR965, dev build, exact boundary: killed at exactly 120s idle.** Set from the glance (e.g. START squats/sit-ups), do 2-3 reps, leave the watch untouched on a desk. Screen stays lit the whole time (not a display-off issue) and the app still runs its normal 1 Hz redraw (HR/calories) — so the system's launched-from-glance inactivity timer is **not reset by redraws**, only by real input. At exactly 120s the process is killed and the in-progress reps are gone: nothing was banked, because nothing is saved until Save is pressed (by design — "nothing is saved until you've seen it"). A set started from the normal app-list launch has no such timeout (SDK docs).

**Owner picked "recoverable draft."** [ADR-052](decisions.md#adr-052): the live workout screen checkpoints its in-progress detected count to Storage every 15s (and once more when paused by the Resume/Save/Discard menu), not as a saved rep — just enough that starting that exercise again resumes the count instead of 0. Cleared at every real ending (Finish, Save, Discard, the no-count Back). 6 new store-level unit tests, written and compile-checked only (the simulator was busy with another session; never actually run).

**Confirmed fixed on FR965 (2026-09-27):** killed a set idle past 120s, restarted the same exercise — count resumed; a different exercise correctly showed 0 (no cross-exercise bleed). Not yet confirmed, not blocking: a draft surviving unresumed to the next calendar day reads as 0 (needs an overnight check). Known, accepted gap (not built): the review picker's own pending delta (after Finish, before Save) isn't checkpointed, so idling there can still lose a correction — same shape, smaller window in practice.
