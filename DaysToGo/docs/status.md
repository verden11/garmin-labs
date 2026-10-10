# Days To Go — status and release runbook

> **Open items live only in the root [`ROADMAP.md`](../../ROADMAP.md).** This file keeps where things stand, the evidence, the release gates and the upload steps. Listing text and metadata: [`../listing/paste.md`](../listing/paste.md) and [`../listing/meta.yaml`](../listing/meta.yaml). Claims: [`release-contract.md`](release-contract.md). Build history: [`archive/plan.md`](archive/plan.md).

**Free 1.1.0 and Pro 1.2.0 uploaded by owner 2026-10-08, in Garmin review** (129 products incl. Venu Sq / Sq Music; square design on rectangles; no on-watch picker on Sq 2 family, ADR-020 (no on-watch picker on the Sq 2); one always-on grey; `device-test/upload/DaysToGo-*`). Simulator only.

**Where things stand, 2026-10-05.** Live since 2026-09-28 (1.0.1 submitted 2026-09-26; which version Garmin approved not recorded). **Uploaded by owner 2026-10-04, in Garmin review:** Days To Go Free 1.0.0 (new app) and Days To Go Pro 1.1.0 (paid app renamed, $2.50 tier, with **"To the minute"**, ADR-018 (to the minute: Pro's minute and event time zone)), both with Instinct family (ADR-015 (Instinct family)), 127 products, simulator only. **Unreleased since:** first-generation Venu Sq and Sq Music join both manifests (129 products, Free-only reach, 2026-10-05); always-on time no longer cut on rectangles (ADR-016 (bottom line and name step-down), amendment 5; `compatibility.md` "Venu Sq and Venu Sq Music"); simulator only, both ship with next upload of each tier. Open work: ROADMAP 3.1, 3.7, 3.12, 7.10, 7.12, 10.30.

**Status 2026-09-26 (kept as history): 1.0.1 submitted on top of 1.0.0; approved 2026-09-28.** "After approval" section below lists what follows approval; baseline (gate 11) still to be written down.

Owner's runbook. Do gates in order; each names what "passed" looks like and where to record it. Nothing here done yet unless it says so. Build status: [`archive/plan.md`](archive/plan.md) "Implementation status".

## Uploaded 2026-10-04 (Days To Go Free 1.0.0 new app, Days To Go Pro 1.1.0 update), in Garmin review: on approval record the dates, read the stores' device lists, set the site's Free store URL and Pro wording (ROADMAP 3.12)

Free 1.0.0 (new app id) and Pro 1.1.0 (existing id), together, Free first. Text: `../listing-free/paste.md` and `../listing/paste.md` (now 1.1.0 text, gate F9's text part done; sibling store URLs placeholders); metadata `../listing*/meta.yaml`.

| File (absolute path) | Products | Check |
|---|---|---|
| `/Users/mbp/dev/garmin/DaysToGo/dist/DaysToGoFree-1.0.0.iq` | 127 | `tools/check_free_package.sh`: OK (no Hour/Footer, no "Pro" anywhere) |
| `/Users/mbp/dev/garmin/DaysToGo/dist/DaysToGoPro-1.1.0.iq` | 127 | same script, explicit file arguments: OK (Hour, Minute, EventZone, Footer and name found in every .prg). **Re-exported 2026-10-04 with "To the minute" (ADR-018 (to the minute: Pro's minute and event time zone))** |

**Free: Free 1.0.0 file above is the one owner uploaded 2026-10-04; not replaced.** Free build re-exported after ADR-018 (to the minute: Pro's minute and event time zone) only to prove it unchanged (proof export deleted 2026-10-05): all 210 settings files byte-identical to uploaded export, check script passes (no Hour, Minute, EventZone or Footer, no "Pro" anywhere), only compiled `.prg` differ (shared, dead-in-Free arithmetic: about +1.0 kB memory on `fr55`, 27.7 to 28.7 kB). No Free re-upload needed for ADR-018 (to the minute: Pro's minute and event time zone). **Pro re-exported 2026-10-04 after last code change (commit "split the zone test helper"); `dist/` holds only packages to upload (older exports deleted 2026-10-05).** Built in `verden-ciq-build` container (`docker/run.sh`), checked with project's package script without `--build`; simulator and compile only, **nothing on a wrist**. Files in main checkout's git-ignored `dist/`. Product counts = `<iq:product>` lines in manifest; export holds more part numbers (device variants). Paid 1.0.1 as submitted: `DaysToGo-1.0.1-submitted.iq`.

## To the minute (Pro's headline, ADR-018): evidence and wrist checks

Built 2026-10-04 (ROADMAP 3.10; owner chose option 1 of `../../reports/Days To Go Pro research.md`). **Simulator only: nothing here ran on a wrist, simulator not device proof.** What was checked: `compatibility.md` "To the minute". Rule, table and known limits: [ADR-018](decisions.md#adr-018-to-the-minute-pros-minute-and-event-time-zone); unit tests `DaysToGoZoneTest`. Free package unchanged in behaviour and settings.

**Wrist checks owner (or next session with the watch) must do before claim "to the minute" is made live.** Use sideloaded Pro build (beta build, `python3 tools/make_beta.py`, has own app id) on FR965, the one real watch on record. Record each result below as Passed or Failed with date; do not tick in ROADMAP from here.

| # | Check | Procedure | Passed looks like |
|---|---|---|---|
| W1 | **Phone-set Minute and zone survive** (phone route is the one rivals lost users on, gate 2 waived) | In Garmin Connect set face: Event = My own date, date = today, Time of day = three hours from now, **Minute = 37**, **Event time zone = UTC+2** (not your own). Sync, open watch face. Then leave settings and **reopen them**; change only Minute to 38 and sync again; reopen again | Face shows `H:MM` to the instant (event minus UTC; check against world clock). On every reopen phone still shows Minute 37 (then 38) and UTC+2, not "00" or "My watch time zone". Changing Minute 37 to 38 moves countdown by exactly one minute. Fail: any value resets, or list shows blank: stop and report, this is rivals' failure |
| W2 | **Travel day** (event in another zone than watch) | (a) Home zone, event in zone 6 or more hours away (for example UTC-5 from UTC+2): set event 30 hours out. Note when face changes from days to `H:MM` (HOURS starts) and when it says TODAY. (b) Then set watch's own time zone in watch's settings to zone several hours away (Garmin: System, Time, Time Zone; or travel) and look again | (a) HOURS starts exactly 24 h before the instant (event time minus offset, against world clock) and TODAY at the instant. (b) After changing watch's zone `H:MM` unchanged (same instant), **day count** changes only at new local midnight, TODAY arrives at same instant. Fail: countdown jumps by zone difference |
| W3 | **A DST day** | Choose event on a day watch's own region changes its clock (EU: 2026-10-25, last Sunday of October; US: 2027-03-14). Set event at 12:00 that day with **explicit offset in force that day** (for example Europe/Berlin on 2026-10-25 is UTC+1 after change at 03:00 local), wake face evening before. Then same with Event time zone = My watch time zone | With explicit offset countdown matches world clock to the minute across change. With My watch time zone `H:MM` is an hour off across watch's own DST change: documented limit (spec rule 6, ADR-018 (to the minute: Pro's minute and event time zone) limit a), not a failure. Fail: explicit offset off |
| W4 | **Midnight with a zone set** | Event 3 days out in another zone; watch face across watch's local midnight (wear day, gate 5) | Day count drops by 1 exactly at local midnight, not at event zone's midnight |
| W5 | **Settings with no time** | Set Minute and a zone but leave Time of day = All day | Face is ordinary all-day countdown (Minute and zone ignored) |
| W6 | **Instinct (if a watch is available)** | Same event on Instinct E 40 mm or 3 Solar | `H:MM` beside window fully visible and legible (simulator says it fits) |

## Owner decision, 2026-09-26: submit without the beta round trip

Owner chose to submit straight to store and fix issues in later versions. Waives gates 2 and 3 (phone round trip, T4 decision), accepts these risks, on record:

- **Phone date route untested on hardware (T2).** If Garmin Connect loses date, buyer's only way in is on-watch picker (works on FR965, sideloaded; 94 of 117 round products by SDK list; not offered on Venu Sq 2 and Sq 2 Music, ADR-020 (no on-watch picker on the Sq 2), where phone is only route). Face still counts to New Year's Day. Exact failure that hurt rival faces, would hit paying users.
- **Phone save may overwrite on-watch pick, or reverse (T4), unknown.** Do not put "set it on your watch" sentence in description until tested; support page already says "on many watches".
- **Any fix costs new version and about 72 hours review**, bad first review is public. Price stays fixed at submission.
- **Later Beta App upload still possible at any time** (own app id) to test T2/T4 against released build's behaviour, does not interfere with live listing.

Gates still required (owner may waive any too, but cheap): 1, 4, 5, 6, 7, 8, 9, 11, 12.

## Ready to submit when ALL of these are true

| # | Gate | Passed looks like | Where it stands |
|---|---|---|---|
| 1 | Name cleared | Store search by eye and trademark search found no conflict with "Days To Go" | **Open** (owner) |
| 2 | Beta round trip, FR965 (plan phase 3) | T1, T2, T4, T5 pass; T2 especially: date set on phone still there after reopening settings screen | **Open** (owner). If T2 fails, stop: phone route broken, on-watch picker must become main route |
| 3 | T4 decision recorded | Picker and phone do not destroy each other's values, or "last change wins" documented; ADR-005 filled in; listing/support "set it on the watch" sentence added or dropped (`listing/NOTES.md`) | **Open** |
| 4 | Always-on check | Heat map (simulator, File > View Screen Heat Map) and one night on FR965 with sleep mode off: no blank screen, no ghosting. If it blanks, raise `BURN_IN_STEP_PERMILLE` (ADR-007) and repeat | **Open** |
| 5 | Wear day on the production build | One full day, this face only: midnight flip from 1 DAY to TODAY, day count against calendar, battery looks normal | **Open**. No battery figure in listing. **Simulator only, 2026-10-10:** midnight flip passes on fr965 in real-clock run started at 23:55 (`docker/soak.sh` with start clock, store-like `-r` build, High Power and Always-On alternating): event on Oct 11, Pro and Free, read `1 DAY` at 23:58 and `TODAY` at 00:00; event on Oct 13 (Pro) read `3` then `2 DAYS` at 00:00; no errors. Not wrist proof |
| 6 | Look approved | You have seen face in simulator on at least `fr965` and `fenix7x` (or replaced direction with own mock-up, then `spec.md` and `DESIGN.md` updated) | **Open** |
| 7 | Real assets | Launcher icon, cover 500×500, hero 1440×720 (optional), one device's screenshots, device icons (optional); paths filled in `listing/paste.md` and `listing/screenshots.md` written | **Partly done**: five screens (`listing/screens/`), cover and hero in `listing/` (live since 2026-09-28, updated with later uploads); real launcher icon still placeholder (ROADMAP 3.3); device icons optional |
| 8 | Languages decided | Ship English only, or English plus 14 machine-drafted on-watch languages; native speaker has read any language shipped as store copy | **Open** |
| 9 | Site live | `cd ../site && npm run build && npm run deploy`; then `/days-to-go/support/` and `/days-to-go/privacy/` open without login. Reviewers and users open them | **Done 2026-09-26**: `/days-to-go/`, `/support/` and `/privacy/` return 200 on verden.watch (checked after owner's deploy). Landing page's store button says "Coming soon" until `storeUrl` set |
| 10 | Price confirmed | Pro: paid, $2.50 tier (US $2.49, eurozone 2,99 EUR), ADR-017 (price: the $2.50 tier for every paid app), set in upload form with 1.1.0; was lowest tier (USD 2.00, $1.99 US) at first submission (ADR-002 (flip rule and first price), price superseded). Free is free. No price number in listing or site text. Risk on record: 15 paid countdown faces all at 10 downloads or fewer | Decided 2026-10-04; set at upload |
| 11 | Baseline recorded | Download buckets, review counts and ratings of HeroSet and HeroFace on submission day, plus store links, written in `CHANGELOG.md` or memory file | **Open** |
| 12 | Tests green | `tools/fit_all.sh` and `tools/run_tests.sh fr965` pass on the commit you submit | Last sweep: 42 tests, ten sizes, fenix6pro, venu2s and two rectangles (simulator) |

## Timing

- **Earliest sensible day:** day after gate 5 (wear day) and gates 1, 2, 4, 6 to 9 done. Nothing else time-based: no launch date to hit.
- **Do not** publish a build that gates 2 to 5 did not use. Export package from commit you wore.
- **Review takes about 72 hours** (HeroFace notes); rejection names reasons. Advice, not evidence: submit early in week so any rejection lands on working days.
- **Price set in upload form** (Pro: $2.50 tier, ADR-017 (price: the $2.50 tier for every paid app)). Changing price of approved app can take it out of store for re-review (SDK `Monetization/App_Sales`; Garmin's handling of repricing unconfirmed; policy research in ROADMAP 2.1), so repricing ships together with 1.1.0 version upload, re-reviewed anyway.
- Paid app sold only on Garmin's own list of watches and countries, so store's device list shorter than manifest's 120. Never quote a watch count.

## Submit (one sitting, about 30 minutes)

1. `cd DaysToGo && monkeyc -e -r -f monkey.jungle -o dist/DaysToGoPro.iq -y ~/.garmin-connectiq/keys/developer_key` (paid app, live app id; `dist/DaysToGoFree.iq` is the **Free** package, `dist/DaysToGo-1.0.1-submitted.iq` is the 1.0.1 package as submitted)
2. Open https://apps.garmin.com/developer/upload, attach `dist/DaysToGoPro.iq`.
3. Paste each field from [`../listing/paste.md`](../listing/paste.md), in form order. Category: Utility. Add price in merchant flow ($2.50 tier, ADR-017 (price: the $2.50 tier for every paid app)).
4. Add images from gate 7.
5. Same day, update `CHANGELOG.md` (version 1.0.0, upload date, user-facing changes, ADRs) and check `listing/paste.md` has What's New block and version.
6. Do not commit `dist/*.iq` or any key file.

## After approval (the day it arrives)

1. Open live listing page. Check title, description, images and price. Check support and privacy links open.
2. ~~Price review date: approval + 45 days.~~ **Retired 2026-10-04** (owner approved Free + Pro ladder, ADR-014 (Free + Pro ladder); paid app never flipped to free). Still true if price ever touched: email Connect IQ developer support first, never cancel merchant account.
3. In `site/src/apps/days-to-go/app.ts` set `storeUrl`; add live store's device list to `facts.ts` only once shown there. Rebuild and redeploy site.
4. Update root `README.md` status and `CLAUDE.md` price line.
5. Day 60: run success test in `spec.md`.

## Free + Pro pair (approved by the owner 2026-10-04, uploaded 2026-10-04: ADR-014 (Free + Pro ladder))

**Both uploaded 2026-10-04** (F2, F8, F9 done by that upload). Builds against `../../reports/Free and Pro ladder execution plan.md` (WP4); owner approved ladder 2026-10-04 (OD1, OD2: day-45 flip rule retired, ADR-002 (flip rule and first price) Superseded); names confirmed (2026-10-04), Pro price is $2.50 tier (ADR-017 (price: the $2.50 tier for every paid app)), set in upload form; live paid app unchanged until Garmin approves. No store-package quirk recorded anywhere in project docs; Free and Pro exports below plain `monkeyc -e -r`, checked with `tools/check_free_package.sh`.

| # | Gate (Free 1.0.0 and Pro 1.1.0, upload together: Free first as new app, Pro same day on existing id) | State |
|---|---|---|
| F1 | Owner signs off OD1 (ladder), OD2 (retire day-45 flip rule), OD3 (names), OD4 (Pro price). ADR-014 (Free + Pro ladder) Active and ADR-002's (flip rule and first price) flip rule Superseded | **Ladder, OD2, names and price tier done 2026-10-04** (ADR-017 (price: the $2.50 tier for every paid app)); set at upload |
| F2 | Store names and titles chosen and searched in store by eye (plan placeholders: app name "Days To Go" / "Days To Go Pro"; proposed titles "Days To Go: Countdown to a Date" / "Days To Go Pro: Countdown to the Minute", Pro one changed 2026-10-04 with headline). Name also on-watch AppName: change `resources-free/strings` and `resources-pro/strings` only | **Done 2026-10-04** (uploaded with those titles) |
| F3 | Pro headline decided: what buyer pays for beyond timed events and battery or steps line | **Done 2026-10-04**: owner picked option 1, "To the minute" (`../../reports/Days To Go Pro research.md`); built as ADR-018 (to the minute: Pro's minute and event time zone) (event minute and zone), simulator only. Wrist checks are "To the minute" section above |
| F4 | Launcher icon for each tier (file still placeholder; Free and Pro may differ) | **Open** (owner) |
| F5 | Tests run on both jungles: `tools/run_tests.sh <device> monkey.jungle` and `... monkey.free.jungle` on fr965, fr55, venusq2; `tools/fit_all.sh monkey.free.jungle` | **Done 2026-10-01, simulator only**: Pro 50 / Free 51 PASSED on fr965, fr55, venusq2; `fit_all.sh` on ten devices passes on both jungles. not run on a wrist. **Measured 2026-10-04 (container simulator, not device proof):** Free on `fr55` and `fenix5s` (91.8 kB budget) uses 27.6 and 27.5 kB after face drew (`-r` build, status bar) and Free suite passes 53/53 on both; Customize menu and date picker, driven in private watch-app harness (simulator cannot open Customize on a face), read 26.8 and 31.0 kB on `fenix5s`, 24.0 and 28.2 kB on Instinct E 40 mm (face 24.9 kB of 59.8 kB): nowhere near a limit. Flag: harness draws picker on white background with white text on colour MIP screens (check a MIP watch). See `compatibility.md` "Measured 2026-10-04" |
| F6 | Packages exported and checked: `tools/check_free_package.sh --build` | **Done 2026-10-01** after final edits (compile only; `dist/DaysToGoFree.iq` and `dist/DaysToGoPro.iq`; see `development.md`) |
| F7 | Device check on FR965, store-build equivalent: Free shows no Hour or Footer in phone and Customize screens, accent change round trip (phone, sync, restart; then on watch), on-watch name in watch-face list | **Open** (owner) |
| F8 | Listing-free filled from `../listing-free/paste.md`; screenshots from Free build | **Done 2026-10-04** (uploaded) |
| F9 | Pro's `../listing/paste.md` What's New and version are 1.1.0 text since 2026-10-04; sibling URL on line 1; `CHANGELOG.md` entries get dates | **Done 2026-10-04** (uploaded; approval dates go in CHANGELOG when known; check live Free sibling line, ROADMAP 10.30) |
| F10 | Site: `freeStoreUrl`, "Free or Pro" section, per-tier privacy and support wording (plan WP8). Do not change a published URL | **Open** (not in this folder) |
| F11 | Translations of any new string, machine drafts need owner's OK | **Open**: 3 new phone strings (Minute, Event time zone, My watch time zone) in 14 languages, machine-drafted by agent, not read by native speakers; in `../resources-pro-<lang>/strings/` (Pro only). Minute and UTC-offset labels are numbers, not translated |

### Free listing block (done 2026-10-04; kept as the record of the steps)

1. `cd DaysToGo && tools/check_free_package.sh --build` (or export `monkeyc -e -r -f monkey.free.jungle -o dist/DaysToGoFree.iq -y ~/.garmin-connectiq/keys/developer_key`), then open https://apps.garmin.com/developer/upload, attach `dist/DaysToGoFree.iq` (a **new** app: form reads new app id from package).
2. Paste each field from [`../listing-free/paste.md`](../listing-free/paste.md) in form order. Category Utility. Monetization: free listing asks no payment (confirm form's wording at submission). Line 1 carries Pro store URL.
3. Same day: upload `dist/DaysToGoPro.iq` to existing app id as 1.1.0 (set Pro's price tier to $2.50 in form, ADR-017 (price: the $2.50 tier for every paid app); re-pricing approved app can remove it for re-review, so do it in this same version upload).
4. Update `CHANGELOG.md` (upload dates, then approval dates), What's New blocks, record both app ids for measurement plan (WP9), and review-day dates for gates G1 to G4 in ladder plan.
5. Do not commit `dist/*.iq` or any key file.

## If the review rejects it

Rejection lists reasons. Fix named item in listing or build, bump version if package changes, re-submit. Do not change price in same step.

**Until gate F1 (Free + Pro pair) signed off by owner, build any 1.0.x fix from commit before ladder work, not from current working tree**: this tree names paid app "Days To Go Pro" on watch and has restructured resources, neither of which owner has approved for live app.