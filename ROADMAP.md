# Verden roadmap

One file. Milestones > initiatives > small tasks. Tick tasks here; evidence stays in each project's docs.
Draft 2026-10-01. Dates are earliest, never promises. `TODO.md` stays as the HeroSet/HeroFace device-check log until its open items are folded in (see M7).

**NEXT ACTION:** 1.1 below, in progress: the owner is wearing the 2026-10-01 DayArc and DayArc Pro sideloads on the FR965 for a day or two, then reports. (Update this line whenever you finish a task.)

## How to use it

- **Task** = one sitting, ≤30 min, one clear "done when". Tag: `[you]` only you can do it, `[agent]` Claude can do it, `[both]`.
- **Drive mode:** say "drive M3". Claude takes the whole milestone, runs agents, stops at every `[you]` gate and hands you a checklist.
- **Step mode:** say "next task". Claude shows the first unticked task, you do or approve it, tick it, repeat.
- **Never decide alone** (names, prices, icons, uploads, translations, site deploy) are always `[you]`.
- A task can be added anywhere. A milestone is done when every task under it is ticked or struck out with a reason.

## M0 Land today's work (≈30 min)

Initiative 0A: put the three Free builds into git cleanly.
- [x] 0.1 `[you]` Skim `git status` and the three ADRs marked Proposed (DaysToGo ADR-014, TwoSuns ADR-020/021, HeroFace ADR-001). Done when: you say "commit".
- [x] 0.2 `[agent]` Commit in 4 commits: DaysToGo, TwoSuns, HeroFace, reports/root docs (deletes of `resources/settings` and new `resources-*` folders together). Done when: `git status` is clean. Do not push until 0.3.
- [x] 0.3 `[you]` Decide push. Pushing to main deploys the site by Action, and these commits do not touch `site/`, so it is safe.

## M1 Ship pair #1: DayArc and DayArc Pro (first real release)

Why first: fully built, both jungles tested, no old listing to protect.

Initiative 1A: look and fit proven on a wrist.
- [ ] 1.1 `[you]` Sideload the DayArc dev build on the FR965 and wear it all four time windows (`DayArc/docs/publish-checklist.md` "What the owner must eyeball"). Done when: you list what is wrong, or "fine".
- [ ] 1.2 `[agent]` Fix what 1.1 finds, re-run tests on 6 devices, both jungles.
- [ ] 1.3 `[agent]` Run `watch-design-reviewer` on the built Free and Pro (fifth pass). Done when: `disposition: ship` or all fixes closed.

Initiative 1B: assets and decisions.
- [ ] 1.4 `[you]` Names confirmed ("DayArc", "DayArc Pro") plus a store-by-eye search and trademark search. Done when: ticked in publish-checklist gate 1.
- [ ] 1.5 `[you]` Launcher icons, covers, hero images, screenshots for both tiers (placeholders now).
- [x] 1.6 `[you]` Price decided 2026-10-01: Garmin's second price step (ADR-007 amended). No price number on the site or in listing text (Garmin converts tiers per currency); the site and DayArc listing text are already updated.
- [ ] 1.7 `[you]` Night-window default, languages (English only v1?).

Initiative 1C: listing and upload.
- [ ] 1.8 `[agent]` Finish both listing drafts against `release-contract.md`, sibling URL line 1, review request, "More from Verden".
- [ ] 1.9 `[you]` Upload Free first, Pro the same day. Record dates in `CHANGELOG.md` (agent does the doc).
- [ ] 1.10 `[agent]` After approval: add the two `storeUrl`s to the site, push (Action deploys), verify live.

Done when: both live in the store and the site buttons are live.

## M2 Unblock the ladder: your decisions (≈1.5 h total, in any order, one at a time)

Initiative 2A: Garmin and money.
- [ ] 2.1 `[you]` Send the Garmin email (`research_notes/Free and Pro ladder/garmin_questions.md`: does repricing remove an approved app, do twins count as duplicates). Done when: sent.
- [x] 2.2 `[you]` Days To Go and Two Suns were both approved 2026-09-28, late afternoon (docs updated; day-45 reviews fall on 2026-11-12 unless OD2 retires them). Still to read from the dashboard: the Two Suns price tier ($2.25 shown vs $1.99 documented).
- [ ] 2.3 `[you]` Answer OD1 (do the ladder) and OD2 (retire the day-45 flip rule). Done when: yes/no written in `reports/Free and Pro ladder.md`.
- [ ] 2.4 `[agent]` On OD2 yes: flip the Proposed ADRs to Active, mark ADR-002 superseded, write approval dates, drop the day-45 memory reminders.
- [ ] 2.5 `[you]` OD3 names and OD4 Pro price for each face (placeholders now: "X" / "X Pro").

Done when: OD1 to OD4 are answered on record.

## M3 Ship Days To Go Free + Pro 1.1.0 (needs M2)

Initiative 3A: device proof.
- [ ] 3.1 `[you]` FR965 store-equivalent check: Free shows no Hour/Footer, accent round trip (phone, sync, restart; then on watch), watch-face list name (publish-checklist F7).
- [ ] 3.2 `[agent]` Run the Free fit and memory view on fenix5s/fr55 (not measured yet).
Initiative 3B: assets and listing.
- [ ] 3.3 `[you]` Icon for each tier; screenshots from the Free build.
- [ ] 3.4 `[you]` Decide Pro's headline: thin Pro as is, or research what countdown buyers pay for.
- [ ] 3.5 `[agent]` Final listings (Pro text must not say "free").
Initiative 3C: upload.
- [ ] 3.6 `[you]` Upload Free 1.0.0 (new app) and Pro 1.1.0 (existing id) together; Pro keeps the on-watch rename in mind.
- [ ] 3.7 `[agent]` Site: Free/Pro section and Free store URL (WP8), deploy via push.

## M4 Ship Two Suns Free + Pro 1.1.0 (needs M2; same shape as M3)

- [ ] 4.1 `[you]` Decide the prepared 1.0.1 (existing id): submit now from commit `3b10044`, or fold into 1.1.0.
- [ ] 4.2 `[you]` Wrist check: Free shows `--` with no Body Battery; Pro curve unchanged.
- [ ] 4.3 `[you]` Decide Free empty-state wording (`--` now; words need 14 translations).
- [ ] 4.4 `[you]` Icons, price tier, upload both. `[agent]` listings and site.

## M5 Ship HeroFace Free + Pro (after the HeroSet/HeroFace readout, about 2026-10-25)

- [ ] 5.1 `[you]` Read the 30-day exposure result on the HeroFace listing; decide go.
- [ ] 5.2 `[you]` Confirm Free has no temperature (paid users have it by default).
- [ ] 5.3 `[you]` Magenta accent: fails the 3:1 contrast rule against the track (2.84). Keep, fix the colour, or drop it.
- [ ] 5.4 `[agent]` Free fit run on ten sizes, memory on fenix5s/vivoactive3 (96 KB limit).
- [ ] 5.5 `[you]` Check a Free app id receives HeroSet's complication on a watch.
- [ ] 5.6 `[you]` Rename the paid listing "HeroFace Pro" inside the pending listing-repair submission; upload both.

## M6 Site and measurement (can run alongside M3 to M5)

- [ ] 6.1 `[agent]` Add `freeStoreUrl` and a "Free or Pro" section per app page, per-tier privacy and support wording (WP8). Deploy by push when a Free is live.
- [ ] 6.2 `[agent]` Write `tools/store_poll.py` and the CSV (WP9).
- [ ] 6.3 `[agent]` Write the listing template (WP10).
- [ ] 6.4 `[you]` After each Free is approved, run the 30-day (G1) and 60-day (G2) reads. Dates go in this file.
- [ ] 6.5 `[you]` **2026-10-10** DMARC `p=none` to `p=quarantine` after checking the rua reports.

## M7 HeroSet (app, not face)

- [x] 7.1 `[you]` HeroSet 1.2.0 (the glance build; developed as 1.1.2, ADR-053) is approved (owner, 2026-10-01); `glanceLive` is now `true`.
- [ ] 7.2 `[you]` Upload the 7 framed screenshots to the live listing (`TODO.md` A4).
- [ ] 7.3 `[you]` Accuracy proof: 3x10 reps per exercise at slow, medium, fast, plus one 30+ set (gate 2). Without it there is no HeroSet Free.
- [ ] 7.4 `[agent]` Then: ADR-044 (complication contract) review, then build HeroSet Free (WP7).
- [ ] 7.5 `[agent]` Fold the remaining `TODO.md` items into this file and retire `TODO.md`.

## M8 Make it bolder (later, one face at a time)

- [ ] 8.1 `[agent]` Daring mockup for Days To Go, screenshot-verified at 454 px and the smallest size; stop for your look approval.
- [ ] 8.2 `[you]` Approve a direction; `[agent]` implement.
- [ ] 8.3 `[both]` Extra accent colours (ids 6 to 11), after the 15-language names are OK'd. Repeat for TwoSuns and HeroFace.

## Parked (not scheduled)

Private beta, paid-launch announcement, HeroSet 1.2.0 Connect sync (gated on an FR965 spike), native-speaker read of 1.1.1 strings.
