# Design critique 2026-10-05: running log

Working notes for evening executive summary. One project at a time, from listing screenshots + simulator runs
(UI and UX). Owner answered every round "do your picks". All below **simulator only**: nothing on a wrist, nothing reaches users until owner uploads next version of each app. Items = ROADMAP 13.x.

## Done, per project

| Project | What changed (user-visible) | ROADMAP | Commits |
|---|---|---|---|
| Days To Go | Ring full only on day (was full at 365 days), keeps draining through last 24 h, no jump to near full | 13.1 | `8e2314d` |
| Days To Go Pro | Last 24 h read `8h 06m` (small h/m), not `8:06 HOURS` (looked like second clock) | 13.2 | `cc01749` |
| Days To Go | Drawn arrow before event date while ahead (read as today's date); Pro footer gets battery or footprints mark | 13.3, 13.4 | `24877e6` |
| Days To Go | Ring direction (drains) kept | 13.6 | `cc01749` |
| HeroFace | Drawn icons replace `STEP`/`CAL`/`INT`/`FLR`; streak + temperature one centred group (no jumping); Free's empty band closed; MOVE shows nothing until alert (red GO) | 13.8–13.12 | `b2fa837`, `2ce547b` |
| Two Suns Pro | Weather + watch battery rows Off by default (listing showed off, buyers got on); compact weather row = current conditions only | 13.13, 13.14 | `ac96202` |
| Two Suns | Energy curve = line (fill was night ring's colour); solid bolt (half-grey gauge read broken); `7h 22m of daylight` not `7:22` | 13.15–13.17 | `ac96202` |
| DayArc | Body Battery hero icon = bolt (battery shell read as second battery); Pro grid icons all muted grey (rainbow competed with hero) | 13.19, 13.20 | `8e316d4` |
| Studio | Bolt = Body Battery everywhere; intensity minutes = pulse line (HeroFace, DayArc) | 13.19 | `2ce547b`, `8e316d4` |
| HeroSet | Review screen: `+24` (what START saves) = big number; `CAL --` until 1, not `CAL 0`; Instinct: no `STREAK 0` row on day one | 13.21–13.23 | `cfb9c33` |

Every changed listing image set recaptured (both tiers where both changed), store hero re-rendered.

## Tooling fixed on the way

- HeroFace `tools/listing_shots.sh` now clears simulator's stored app settings per scene (Pro accent/seconds shot silently came out default).
- Two Suns: new `h`/`m` strings need copy in every language folder to keep zero-warning compile (English letters, flagged under 13.7).

## Checks run

- Unit suites in container simulator after each project's changes, 5 to 8 devices per project incl. an Instinct and a small round watch; all PASSED. Exception: Two Suns' last change (`units.xml` copies per language) checked by full compile sweep only, not test re-run.
- Full compile sweeps, both tiers: Days To Go 127/127, HeroFace 124/124, Two Suns 72/72, DayArc 72/72. HeroSet: store build tests 103 PASSED.

## Follow-ups done at the end

- **DayArc packages re-exported** (`dist/DayArc-1.0.0.iq`, `dist/DayArcPro-1.0.0.iq`; 93/93 devices, `check_package.sh` OK), so first upload matches new images. Other four `dist/` folders still hold versions in review: re-export before each next upload.
- **Image sets vs. versions:** every recaptured set shows next version. ROADMAP 7.2 and 10.5 and each listing's `meta.yaml` `owner_approvals` now say so; for anything uploaded sooner use set from commit before 13.x change (HeroSet: `git show cfb9c33^:HeroSet/listing/screens-framed/<file>`).
- **Site sweep:** besides Two Suns (13.18), HeroFace, HeroSet, DayArc site pages show old look: ROADMAP 13.24 (not edited; a push deploys).
- Stale screenshot captions corrected in `screenshots.md` / `meta.yaml` (Days To Go hours, Two Suns daylight and bolt, HeroFace MOVE and Instinct labels, HeroSet calories).

## Simulator options mapped (afternoon)

- Container simulator **can** do always-on: Settings > Display Mode > Always-On (checked on Two Suns: dim face, drift each minute). `docker/SIMULATOR.md` said it could not; corrected, full menu map (section 3).
- **Burn-in check:** File > View Screen Heat Map has 24-hour simulation. Two Suns fr965: "no screen burn-in detected, peak luminance 1.09%" (limit 10%). Helpers `sim_always_on`, `sim_burnin_24h` added to `docker/sim-gui.sh`.
- **Glance:** already simulated (HeroSet opens on glance on glance devices; `drive_screens.sh` step `0b-glance`).
- Also there, unused so far: language switch, Set Weather / Position / Battery Status / Phone Notifications, Time Simulation (fast-forward), Trigger App Settings (phone-settings path), Edit Persistent Storage, View Memory. Watchface Diagnostics greyed.

## Watch-framed listing images (evening)

- Owner asked HeroSet-style images (chassis + part of strap) in every listing, ideally different watch per image. Done all 9 listings (45 images): each scene captured on own watch (Fenix 8, Fenix 8 Pro, Epix Pro, FR970, FR965, FR265, Venu 3, Venu 4 41 mm; Instinct E, Venu Sq 2, FR255S kept), framed by new shared `docker/frame_shot.sh` / `docker/frame_listing.sh` (device's own simulator skin, no window capture; 720x720, all under 150 KB). `meta.yaml` points at `screens-framed/`; heroes re-rendered. HeroSet's old window-crop pipeline replaced. Commits `a033d80`, `f20730b`.
- Found on the way: DayArc's shot script kept stale simulator settings (Pro "accent blue" shot was pink); fixed, as HeroFace's earlier.

## Edge-state pass (evening; simulator only)

- **Burn-in (24-hour heat-map simulation, always-on):** all pass; Days To Go 0.84%, Two Suns 1.09%, HeroFace 1.23%, DayArc 2.52% peak luminance (simulator's 10% pass mark; unverified as Garmin rule).
- **Always-on looks:** three different greys across studio: Days To Go and HeroFace `#555555` (2.8:1, under house 3:1 bar), Two Suns `#5C5C5C` (its ADR-027 (Two Suns always-on grey)), DayArc full muted `#AAAAAA` (brightest, hence higher luminance). Decision for owner.
- **First run:** Days To Go counts down to default event (Jan 1 2027) until set; HeroFace shows zeros, empty bars; HeroSet glance says `NO STREAK YET`; all read fine.
- **DayArc Pro:** next-calendar-event pill reads `00:00` in simulator with no event (Garmin's complication string, passed through): check on wrist (1.1).
- **Not covered yet:** low battery, missing weather / Body Battery on screen, other languages on screen (unit fit tests cover them), Fenix 8 glance path in HeroSet's driver.

## Website on phones (evening)

- Every page scrolled sideways on phones: studio bar's six app names (456 px) ran past screen below about 640 px. Fixed on branch `site-mobile-fix` (`1cda274`): bar wraps (wordmark, then names, 44 px tap targets, no JS), hero name's minimum smaller (HeroFace wider than 320 px phone), drawn previews scale down. `site/scripts/check-overflow.mjs` (phone emulation, 320/360/375/414 px): no overflow on all 20 pages. Not merged: merging deploys verden.watch (ROADMAP 13.26).

## Late evening

- **Website on phones:** merged, live (`61ac734`); live site no horizontal scroll at 320 to 414 px.
- **Website images:** owner asked update every app page now. Every page shows real watch-framed captures (hero, "On the wrist" strip, DayArc's four windows incl. framed night capture); hand-drawn SVG previews deleted; Two Suns wording fixed (8h 41m, Pro's optional weather/battery rows). Live (`c72b358`), checked on phones.
- **DayArc approvals (owner):** updated face design, screens, listing text as drafted, upload order. Left: wear check on today's build (1.1), launcher icons, cover, hero (1.5).

- **Sideload builds:** all nine FR965 debug builds rebuilt from `bba7750` into `device-test/` (HeroSet dev only; no `.iq`), each loaded in simulator (all draw). Two builds of same project in parallel clash (DayArc Pro failed once); rebuilt one at a time.

- **DayArc wrist photos (owner, 7 photos, morning build):** first real-watch evidence of morning + midday windows, both tiers; weather and stress empty states work on watch. Two bugs found, fixed (`5bb9557`): 12-hour time zero-padded (sunset showed `06:54`), empty calendar cut to "No up...". Two questions added (13.28 feels-like label, 13.29 morning icon). DayArc packages and sideloads rebuilt.

- **DayArc morning (owner's picks, `03cd700`):** "Feels like" label; icon now current condition (five glyphs), none without weather. Sideloads, packages, listing shots, heroes, website refreshed.

- **Simulator QA pass (owner asked, evening):** plan, results, findings in `reports/QA/Simulator QA 2026-10-05.md` (`763c7e6`): 107 captures across all five projects, 7 device types, every DayArc window and boundary, 12/24-hour, memory, burn-in, HeroSet flows, website. Verdict: DayArc fit to submit. Fixed during it: website's watch lists (`37f6c0e`, owner noticed missing watches), QA tool's 24-hour switch. New owner question: 13.30.

- **DayArc and DayArc Pro LIVE (Garmin approved both, late evening):** DayArc https://apps.garmin.com/apps/9e641dce-3838-4613-a129-55faeb761193, DayArc Pro https://apps.garmin.com/apps/b6373747-2569-4a55-86ca-c42914c571fe. Website links both (`dbb7d3d`, deployed, checked); docs, CHANGELOG (1.0.0, first publication), ROADMAP (1.9, 1.10) updated.

## Open for the owner

All that needs owner is in ROADMAP.md section 1 or 2 (13.x, 1.1). Added this evening: 13.25 always-on grey, 13.26 site merge, 13.27 framed images, DayArc calendar check in 1.1.


- **13.5** Days To Go time-zone list: city hints (parked by owner for later).
- **13.7** `h`/`m` letters (Days To Go Pro, Two Suns) English on every watch; "m" can read as metres. Keep, use "min", or translate.
- **13.18, 13.24** Site pages (Two Suns, HeroFace, HeroSet, DayArc) show old look or wording; site push deploys, so wait for OK, best after uploads.
- **Uploads:** every change ships only with each app's next version (Days To Go both tiers, HeroFace both, Two Suns both, DayArc first submission, HeroSet 1.3.2). New listing images go up with them (10.5).
- **Looks:** owner approves looks before upload: review `*/listing*/screens*/` per project.
- **DayArc wear check (1.1)** ran today on FR965 with builds from before these changes (sideloaded in morning).