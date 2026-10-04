# Verden: the one to-do list

**Single source for every open item, all apps.** Evidence stays in each project's `docs/status.md`; decisions in its `docs/decisions.md`.
Do not keep open checkboxes anywhere else. Status 2026-10-04.

**NEXT ACTION:** the owner decides the "Decide" list below (top to bottom); the agent works the "Agent can do now" list in parallel.

## How to use it

- **Tags:** `[you]` only the owner can do it (decision, watch, store dashboard, a person), `[agent]` Claude can do it unprompted, `[both]`.
- **Drive mode:** say "drive M3". Claude takes the whole milestone, runs agents, stops at every `[you]` gate and hands you a checklist.
- **Step mode:** say "next task". Claude shows the first unticked task of the section you name, you approve or do it, tick, repeat.
- **Never decide alone:** names, prices, icons, looks, uploads, translations, site deploys, deleting history. Always `[you]`.
- Ids are stable (other docs cite them): `1.x` to `8.x` are the old milestones, `9.x` Instinct family, `10.x` housekeeping. Add new work at the end of the right milestone.
- Dates are earliest, never promises.

## 1. Decide (needs your answer; blocks agent work)

- [ ] 2.3 `[you]` **OD1/OD2:** do the Free + Pro ladder, and retire the day-45 flip rule? Write yes/no in `reports/Free and Pro ladder.md`. (Unblocks 2.4, M3, M4, M5.)
- [ ] 2.5 `[you]` **OD3/OD4:** names and Pro price tier for each face (placeholders now: "X" / "X Pro"). Two Suns shows $2.25 in the store against $1.99 documented.
- [ ] 3.4 `[you]` Days To Go: Pro's headline: thin Pro as it is (timed events, bottom line), or research what countdown buyers pay for.
- [ ] 4.1 `[you]` Two Suns: submit the prepared 1.0.1 (existing id) now from commit `807977d`, or fold it into 1.1.0.
- [ ] 4.3 `[you]` Two Suns Free: wording of a missing Body Battery number (`--` now; words need 14 translations). Also whether the date row and ring orientation are Pro only.
- [ ] 5.2 `[you]` HeroFace: confirm Free has no temperature (paid users have it by default).
- [ ] 5.3 `[you]` HeroFace: Magenta accent fails the 3:1 contrast rule against the track (2.84). Keep, fix the colour, or drop it.
- [ ] 1.4 `[you]` DayArc: confirm the names "DayArc" / "DayArc Pro" after a store search and a trademark search.
- [ ] 1.7 `[you]` DayArc: night-window default (ADR-010 placeholder) and languages (English only v1?).
- [x] 9.1 `[you]` Look approval for the Instinct faces: Two Suns approved 2026-10-04 (merged to main, 72 products); the other four were approved as mocked.
- [ ] 9.2 `[you]` **Instinct 2 family and Descent G1 (CIQ 3.4) for Two Suns and DayArc?** They have no Complications, so it needs a separate build (Two Suns' Tier B: our own sun calculation and a remembered place; DayArc: another source for every field) and an on-wrist location probe. Yes (which first), or leave them out for good. This is the only gap between the faces' device lists.
- [ ] 9.3 `[you]` HeroSet glance on Instinct E / 3 Solar: the simulator draws it under the round window (text and third bar cut). Fix it blind (use `getSubscreen()`), or wait for a real watch?
- [ ] 8.2 `[you]` (later) Approve a direction for a bolder Days To Go; then implement.

## 2. Your hands (a watch, the store dashboard, a person)

Uploads. You said you will re-upload every app and face when ready; the agent prepares each package, What's New and CHANGELOG line first (9.8).
- [ ] 7.7 `[you]` Upload **HeroSet 1.3.0** (Instinct family, stale-draft fix, glance on Instinct E / 3 Solar, hint and corner fixes): `HeroSet/dist/HeroSet-store.iq` (re-exported 2026-10-04), What's New and description bullet from `HeroSet/listing/paste.md`. Steps: `HeroSet/docs/status.md` "Upload 1.3.0".
- [ ] 7.2 `[you]` Upload the 7 framed HeroSet screenshots (`HeroSet/listing/screens-framed/`) to the live listing (edit details need no re-review).
- [ ] 1.9 `[you]` Upload DayArc Free first, DayArc Pro the same day (after 1.4 to 1.7 and 1.5).
- [ ] 3.6 `[you]` Upload Days To Go Free 1.0.0 (new app) and Pro 1.1.0 (existing id) together; Pro's on-watch rename follows.
- [ ] 4.4 `[you]` Upload Two Suns Free + Pro 1.1.0 (icons and price tier first).
- [ ] 5.6 `[you]` Upload HeroFace Free + Pro (rename the paid listing "HeroFace Pro" inside the pending listing-repair submission).
- [ ] 6.6 `[you]` Paste the hardware-field link (text in each `*/listing*/paste.md`) into the four live listings: HeroSet, HeroFace, Days To Go, Two Suns. Check whether the dashboard lets you edit the field without a new version, and note the answer in `research_notes/Free and Pro ladder/garmin_rules.md`.
- [ ] 2.1 `[you]` Send the Garmin email (`research_notes/Free and Pro ladder/garmin_questions.md`: does repricing remove an approved app; do twins count as duplicates). Add: why 14 of HeroSet's 80 products and 48 of HeroFace's 117 are not listed.
Assets (agent renders, you approve and upload).
- [ ] 1.5 `[you]` Launcher icons, covers and hero images for DayArc, DayArc Pro, Days To Go Free/Pro, Two Suns Free/Pro, HeroFace Free/Pro (placeholders now), then 9.7.
- [ ] 3.3 `[you]` Days To Go: an icon for each tier.
- [ ] 10.5 `[you]` Replace the live listing images that changed (HeroFace cover/hero/icons, Days To Go hero) once re-rendered (11.x below); check whether swapping images triggers re-review.
Wrist and watch checks (a simulator cannot do these).
- [ ] 1.1 `[you]` Wear the DayArc dev build on the FR965 through all four time windows; list what is wrong or say "fine". Open from 2026-10-03: edges crisp; the recovery cell reads `R… 2501`; 2 px strokes after a full day (any "no": `git revert a170619`).
- [ ] 3.1 `[you]` Days To Go, FR965, store-equivalent build: Free shows no Hour or Footer; the accent change round trip (phone, sync, restart, then on the watch); the on-watch name. Also the beta round trip T1, T2, T4, T5 (T2: the phone-set date survives reopening settings) and one night of always-on (heat map).
- [ ] 4.2 `[you]` Two Suns, FR965: Free shows `--` with no Body Battery; Pro curve unchanged. Weather-row wear check: `device-test/TwoSuns-weather-CHECKLIST.md` (B4 sunlight, B5 rain, B10 Bluetooth off, Q5 to Q10 one-liners).
- [ ] 5.5 `[you]` HeroFace: a Free app id receives HeroSet's complication on a watch. Also the FR965 store install of 1.0.1 (face then HeroSet installs, link appears within a minute, °F rounding).
- [ ] 7.3 `[you]` HeroSet accuracy proof (gate 2): 3 x 10 reps per exercise at slow, medium, fast; 60 s still per exercise; one 30+ rep set. **Without it there is no HeroSet Free (7.4).**
- [ ] 7.9 `[you]` HeroSet device checks on the FR965 dev build: B1 (START finishes a set, saves pickers, hint `UP/DOWN`, Back after a lone dropped rep), B5 (goal 30 and 500, survives restart), gate 7 (HR, calories, battery), store build sync, photograph every Validation Log page before it wraps (30 entries).
- [ ] 9.6 `[you]` When any Instinct is in reach: HeroSet accelerometer at 25 Hz, the real bezel and window clearance, contrast, memory of every Instinct face (Two Suns Pro is at 77%), whether the on-watch Customize menu is offered.
People.
- [ ] 7.10 `[you]` Native-speaker read of the 1.1.1 touch-hint strings (`deu`, `lit`, `pol`) and any language you ship as store copy (all faces are machine-drafted in 14 languages).
- [ ] 6.4 `[you]` After each Free is approved: the 30-day (G1) and 60-day (G2) exposure reads. Dates go here.
- [ ] 5.1 `[you]` Read the 30-day exposure result on the HeroFace listing; decide go (about 2026-10-25).
- [ ] 10.3 `[you]` Delete the pre-rewrite git backup tag `backup/main-2026-10-04` once you are happy with the new history.
- [ ] 10.4 `[you]` Commit the `watch-design-kit` knowledge files (`~/dev/watch-design-kit`: another session also has staged edits there).

## 3. Agent can do now (no input needed)

Simulator work (the GUI tooling in `docker/sim-gui.sh` can drive it).
- [ ] 3.2 `[agent]` Days To Go Free fit and memory view on fenix5s / fr55 (not measured). Same for HeroFace Free on ten sizes and fenix5s / vivoactive3 (96 KB limit) (5.4).
- [ ] 7.11 `[agent]` HeroSet by hand in the simulator: B2 `venu441mm` (tap mid-set does nothing, START finishes, swipe up = +1, swipe-right shows Resume), B3 `d2airx10` (START opens the menu), glance modes on fr965 / fenix7 / fr255s (E4).
- [ ] 9.4 `[agent]` Memory peaks no unit test measures: the Customize menu and pickers (Two Suns Pro first: 45.8 of 59.8 kB on Instinct, DaysToGo date picker, HeroFace), seconds power budget (HeroFace), MIP contrast screenshots.
- [ ] 9.5 `[agent]` Two Suns weather conditions in the simulator's Weather Editor (B5 rain, icon per condition) and sleep/AOD if the simulator can be made to enter it.
Fixes and polish.
- [ ] 1.2 `[agent]` Fix what 1.1 finds; re-run tests on 6 devices, both jungles. Now also the DayArc recovery cell truncation (`R… 2501`) and the narrow Pro pill showing "12:..." / "8..." on a bottom row.
- [ ] 1.3 `[agent]` Run `watch-design-reviewer` on the built DayArc Free and Pro (fifth pass); done when `disposition: ship` or all fixes closed.
- [ ] 9.10 `[agent]` HeroFace Instinct: "✓ ST." (check mark plus STEP does not fit 40 px) and a multi-day streak in the simulator (history rows did not apply).
- [x] 11.1 `[agent]` Re-render listing images that changed: HeroFace `cover-500`, `hero-1440x720`, `icon-24-128`, `icon-64-128` from `src/*.html` (commands in `HeroFace/listing/screenshots.md`); Days To Go `hero-1440x720` (the blue ring arc was 4.4 units off); optional HeroSet store icon (older unscaled shield). Then 10.5. **Done 2026-10-04:** HeroFace cover, hero, device icons and Days To Go hero re-rendered (not uploaded: 10.5).
- [x] 11.2 `[agent]` Add the line "launcher icon redrawn on the pixel grid" to the CHANGELOG entry of each app when it ships (HeroFace, Days To Go, HeroSet 1.3.0). **Done 2026-10-04:** CHANGELOG lines added (HeroSet 1.3.0 already had it).
- [x] 11.3 `[agent]` Check the "Deploy to Firebase Hosting on merge" runs are green and https://verden.watch/ renders (`gh run list`). **Done 2026-10-04:** runs green; newest deploy predates the history rewrite, later `site/` changes are comments/docs only, so no deploy needed. verden.watch returns 200.
Packages, listings, site (prepare so each upload is a paste).
- [x] 1.8 `[agent]` Finish DayArc's listing drafts against `release-contract.md` (sibling URL on line 1, review request, "More from Verden"). **Done 2026-10-04:** both drafts finished (sibling URL, review ask, More from Verden); OWNER fields still marked.
- [x] 3.5 `[agent]` Final Days To Go listings (the Pro text must not say "free"); same for Two Suns and HeroFace. **Done 2026-10-04:** Days To Go, Two Suns, HeroFace Pro are the 1.1.0 text; Free texts carry placeholders you fill.
- [ ] 6.1 `[agent]` Site: `freeStoreUrl` and a "Free or Pro" section per app page, per-tier privacy and support wording (WP8). Deploy by push when a Free is live.
- [x] 6.2 `[agent]` Write `tools/store_poll.py` and its CSV (WP9). **Done 2026-10-04:** `tools/store_poll.py` + `tools/store_poll_ids.txt`, offline `--selftest`.
- [x] 6.3 `[agent]` Write the listing template (WP10) including the "Additional Hardware Requirements" website-link field. **Done 2026-10-04:** `reports/listing-template.md`.
- [ ] 9.7 `[agent]` Final listing screenshots for every app after the looks are settled: `docker/capture.sh` scenarios exist for DaysToGo, HeroFace, DayArc, HeroSet (Instinct) and a prepared one for Two Suns; you approve the covers and heroes (1.5).
- [x] 9.8 `[agent]` Before each re-upload: fresh `.iq` export, package check, What's New and `meta.yaml` version, CHANGELOG dated entry, store device list note. **Done 2026-10-04:** fresh `.iq` for all 9 packages in `<Project>/dist/<Name>-2026-10-04.iq`, package checks pass, meta.yaml and status.md "Ready to upload" notes written.
- [ ] 9.9 `[agent]` Site: gate Instinct claims behind a flag per app as HeroSet does (`instinctLive`); HeroFace says `watchCount = 117`; flip after Garmin approves each upload (7.8).
- [ ] 7.4 `[agent]` After 7.3: ADR-044 (complication contract) review, then build HeroSet Free (WP7).
- [ ] 2.4 `[agent]` After OD2 yes: flip the Proposed ADRs to Active (DaysToGo 014/015, TwoSuns 020/021/024, HeroFace 001/002, DayArc 015), mark ADR-002s superseded, write approval dates, drop the day-45 reminders.
- [ ] 7.8 `[agent]` After 7.7 is approved: `instinctLive = true` in `site/src/apps/heroset/facts.ts`, push, record the approval date in CHANGELOG and the release contract. If the store drops an Instinct product from its device list, trim the site list.
- [ ] 1.10 `[agent]` After DayArc approval: add the two `storeUrl`s to the site, push, verify live.
- [ ] 3.7 `[agent]` Days To Go site: Free/Pro section and Free store URL, deploy via push.
Later features (need an earlier item first).
- [ ] 8.1 `[agent]` Daring mockup for Days To Go, screenshot-verified at 454 px and the smallest size; stop for look approval (8.2).
- [ ] 8.3 `[both]` Extra accent colours (ids 6 to 11) after the 15-language names are OK'd; repeat for Two Suns and HeroFace.
- [ ] 12.1 `[agent]` Two Suns / DayArc on the Instinct 2 family, only after 9.2 says yes.

- [ ] 10.6 `[you]` **Is HeroSet 1.3.0 already live?** A public store read on 2026-10-04 showed `latestExternalVersion` 1.3.0 released 2026-10-03 with the Instinct What's New (97 device types). If yes, it predates today's bezel/hint/glance-bar fixes, so the fresh export needs a new App Version (your call); then fix `live:` in `HeroSet/listing/meta.yaml` and 7.7.
- [ ] 10.7 `[you]` Native-speaker read of the seven new HeroFace Move abbreviations (`BEV.` dan/nob, `BEW.` deu/dut, `MOV.` spa, `HRK.` tur, `JUD.` lit; machine drafted, 2026-10-04).

## 4. Waiting on a date or an outside event

- [ ] 6.5 `[you]` **2026-10-10** DMARC `p=none` to `p=quarantine` after checking the rua reports in hello@verden.watch; then delete the "Due" line in `site/CLAUDE.md`.
- [ ] 2.6 `[you]` **2026-11-12** day-45 price reviews of Days To Go and Two Suns (approved 2026-09-28), unless OD2 retires them (2.3).
- [ ] 5.7 `[both]` **about 2026-10-25** the HeroSet / HeroFace exposure readout (5.1).
- [ ] 7.12 `[both]` Garmin review of whatever is uploaded; then 7.8, 1.10 and the site flags.
- [ ] 14.1 Parked, not scheduled: private beta, paid-launch announcement, beta testers for watches other than the FR965, HeroSet 1.2.0 Connect sync (ADR-043, gated on an FR965 spike).

## Ship sequences (order of the ids above)

- **M1 DayArc** (first real release; fully built, no old listing to protect): 1.1, 1.2, 1.3, 1.4, 1.5, 1.7, 1.8, 1.9, 1.10.
- **M2 Unblock the ladder:** 2.1, 2.3, 2.4, 2.5.
- **M3 Days To Go Free + Pro 1.1.0** (needs M2): 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7.
- **M4 Two Suns Free + Pro 1.1.0** (needs M2): 4.1, 4.2, 4.3, 4.4.
- **M5 HeroFace Free + Pro** (after the readout): 5.1 to 5.6.
- **M6 Site and measurement** (alongside M3 to M5): 6.1 to 6.6.
- **M7 HeroSet:** 7.7 first (1.3.0), then 7.2, 7.3, 7.4 (Free), 7.8.
- **M8 Bolder faces** (later): 8.1 to 8.3.
- **M9 Instinct family:** 9.1 to 9.10. **M10 Housekeeping:** 10.x. **M11 Image refresh:** 11.x.

## Done (kept short; detail in each project's CHANGELOG)

- 1.6 DayArc price: Garmin's second price step (ADR-007 amended); no price on the site or in listing text.
- 2.2 Days To Go and Two Suns approved 2026-09-28; 7.1 HeroSet 1.2.0 (glance, ADR-053) approved, `glanceLive` is true; HeroFace 1.0.1 live 2026-09-24.
- 7.6 HeroSet Instinct family built, simulator-checked and merged 2026-10-03 (PR #3, ADR-055); fixed 2026-10-04 (bezel corners, hint, glance bars).
- DaysToGo, HeroFace, DayArc, Two Suns Instinct builds (2026-10-03/04): see `docs/compatibility.md` of each. Two Suns merged to main 2026-10-04 (look approved, 9.1).
- Scripted simulator screenshots and what is tested automatically: `docker/SIMULATOR.md`.
