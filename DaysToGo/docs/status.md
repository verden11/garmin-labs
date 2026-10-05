# Days To Go — status and release runbook

> **Open items live only in the root [`ROADMAP.md`](../../ROADMAP.md).** This file keeps where things stand, the evidence, the release gates and the upload steps. Listing text and metadata: [`../listing/paste.md`](../listing/paste.md) and [`../listing/meta.yaml`](../listing/meta.yaml). Claims: [`release-contract.md`](release-contract.md). Build history: [`archive/plan.md`](archive/plan.md).

**Where things stand, 2026-10-04.** Approved 2026-09-28 (1.0.1 was submitted 2026-09-26; which version Garmin approved is not recorded). Built, unreleased and simulator only: the Free + Pro pair (ADR-014), the Instinct family (ADR-015), 127 products, and Pro's headline **"To the minute"** (ADR-018: Minute and Event time zone; built 2026-10-04, ROADMAP 3.10). Open work: ROADMAP M3, 9.x, 11.1.

**Status 2026-09-26: 1.0.1 is submitted (on top of 1.0.0) and pending review.** The "After approval" section below is what to do next; the baseline (gate 11) is still to be written down.

Owner's runbook. Do the gates in order; each one names what "passed" looks like and where to record it. Nothing here is done yet unless it says so. Status of the build itself: [`archive/plan.md`](archive/plan.md) "Implementation status".

## Uploaded 2026-10-04 (Days To Go Free 1.0.0 new app, Days To Go Pro 1.1.0 update), in Garmin review: on approval record the dates, read the stores' device lists, set the site's Free store URL and Pro wording (ROADMAP 3.12)

Free 1.0.0 (a new app id) and Pro 1.1.0 (the existing id), together, Free first. Text: `../listing-free/paste.md` and `../listing/paste.md` (now the 1.1.0 text, gate F9's text part is done; the sibling store URLs are placeholders); metadata `../listing*/meta.yaml`.

| File (absolute path) | Products | Check |
|---|---|---|
| `/Users/mbp/dev/garmin/DaysToGo/dist/DaysToGoFree-1.0.0.iq` | 127 | `tools/check_free_package.sh`: OK (no Hour/Footer, no "Pro" anywhere) |
| `/Users/mbp/dev/garmin/DaysToGo/dist/DaysToGoPro-1.1.0.iq` | 127 | same script, explicit file arguments: OK (Hour, Minute, EventZone, Footer and the name found in every .prg). **Re-exported 2026-10-04 with "To the minute" (ADR-018)** |

**Free: the Free 1.0.0 file above is the one the owner uploaded 2026-10-04 and is not replaced.** The Free build was re-exported after ADR-018 only to prove it unchanged (that proof export was deleted 2026-10-05): all 210 settings files are byte-identical to the uploaded export, the check script passes (no Hour, Minute, EventZone or Footer, no "Pro" anywhere), and only the compiled `.prg` differ (shared, dead-in-Free arithmetic: about +1.0 kB of memory on `fr55`, 27.7 to 28.7 kB). No Free re-upload is needed for ADR-018. **Pro was re-exported 2026-10-04 after the last code change (commit "split the zone test helper"); `dist/` holds only the packages to upload (older exports deleted 2026-10-05).** Built in the `verden-ciq-build` container (`docker/run.sh`), checked with the project's package script without `--build`; simulator and compile only, **nothing on a wrist**. The files are in the main checkout's git-ignored `dist/`; the same bytes are `dist/<name>.iq` in the build worktree. Product counts are `<iq:product>` lines in the manifest; the export holds more part numbers (device variants). Names and the price tier ($2.50 for every paid app) were decided 2026-10-04; the owner's decisions (icons, uploads, translations) are still open: see ROADMAP. The paid 1.0.1 as submitted is `DaysToGo-1.0.1-submitted.iq`.

## To the minute (Pro's headline, ADR-018): evidence and wrist checks

Built 2026-10-04 (ROADMAP 3.10; owner chose option 1 of `../../reports/Days To Go Pro research.md`). **Simulator only: nothing here ran on a wrist, and the simulator is not device proof.** What was checked is in `compatibility.md` "To the minute". The rule, its table and its known limits are in [ADR-018](decisions.md#adr-018-to-the-minute-pros-minute-and-event-time-zone); the unit tests are `DaysToGoZoneTest`. The Free package is unchanged in behaviour and settings.

**Wrist checks the owner (or the next session with the watch) must do before the claim "to the minute" is made live.** Use a sideloaded Pro build (the beta build, `python3 tools/make_beta.py`, has its own app id) on the FR965, which is the one real watch on record. Record each result below as Passed or Failed with the date; do not tick them in ROADMAP from here.

| # | Check | Procedure | Passed looks like |
|---|---|---|---|
| W1 | **Phone-set Minute and zone survive** (the phone route is the one rivals lost users on, and gate 2 was waived) | In Garmin Connect set the face: Event = My own date, the date = today, Time of day = three hours from now, **Minute = 37**, **Event time zone = UTC+2** (not your own). Sync, open the watch face. Then leave the settings and **reopen them**; change only Minute to 38 and sync again; reopen again | The face shows `H:MM` to the instant (event minus UTC; check against a world clock). On every reopen the phone still shows Minute 37 (then 38) and UTC+2, not "00" or "My watch time zone". Changing Minute from 37 to 38 moves the countdown by exactly one minute. Fail: any value resets, or the list shows blank: stop and report, this is the rivals' failure |
| W2 | **Travel day** (the event is in another zone than the watch) | (a) Home zone, event in a zone 6 or more hours away (for example UTC-5 from UTC+2): set the event 30 hours out. Note when the face changes from days to `H:MM` (HOURS starts) and when it says TODAY. (b) Then set the watch's own time zone in the watch's settings to a zone several hours away (Garmin: System, Time, Time Zone; or travel) and look again | (a) HOURS starts exactly 24 h before the instant (event time minus the offset, against a world clock) and TODAY at the instant. (b) After changing the watch's zone the `H:MM` is unchanged (same instant), the **day count** changes only at the new local midnight, and TODAY arrives at the same instant. Fail: the countdown jumps by the zone difference |
| W3 | **A DST day** | Choose an event on a day the watch's own region changes its clock (EU: 2026-10-25, last Sunday of October; US: 2027-03-14). Set an event at 12:00 that day with the **explicit offset in force that day** (for example Europe/Berlin on 2026-10-25 is UTC+1 after the change at 03:00 local), wake the face the evening before. Then do the same with Event time zone = My watch time zone | With the explicit offset the countdown matches a world clock to the minute across the change. With My watch time zone the `H:MM` is an hour off across the watch's own DST change: this is the documented limit (spec rule 6, ADR-018 limit a), not a failure. Fail: the explicit offset is off |
| W4 | **Midnight with a zone set** | Event 3 days out in another zone; watch the face across the watch's local midnight (wear day, gate 5) | The day count drops by 1 exactly at local midnight, not at the event zone's midnight |
| W5 | **Settings with no time** | Set Minute and a zone but leave Time of day = All day | The face is an ordinary all-day countdown (Minute and zone are ignored) |
| W6 | **Instinct (if a watch is available)** | The same event on an Instinct E 40 mm or 3 Solar | `H:MM` beside the window is fully visible and legible (the simulator says it fits) |

## Owner decision, 2026-09-26: submit without the beta round trip

The owner chose to submit straight to the store and fix issues in later versions. That waives gates 2 and 3 (phone round trip, T4 decision) and accepts these risks, on record:

- **The phone date route is untested on hardware (T2).** If Garmin Connect loses the date, the buyer's only way in is the on-watch picker (works on the FR965, sideloaded; 94 of the 117 round products by the SDK list). The face still counts to New Year's Day. This is the exact failure that hurt rival faces, and it would hit paying users.
- **A phone save may overwrite an on-watch pick, or the reverse (T4), unknown.** Do not put the "set it on your watch" sentence in the description until it is tested; the support page already says "on many watches".
- **Any fix costs a new version and about 72 hours of review**, and a bad first review is public. Price stays fixed at submission.
- **A later Beta App upload is still possible at any time** (it uses its own app id) to test T2/T4 against the released build's behaviour, and it does not interfere with the live listing.

Gates still required (the owner may waive any of them too, but they are cheap): 1, 4, 5, 6, 7, 8, 9, 11, 12.

## Ready to submit when ALL of these are true

| # | Gate | Passed looks like | Where it stands |
|---|---|---|---|
| 1 | Name cleared | Store search by eye and a trademark search found no conflict with "Days To Go" | **Open** (owner) |
| 2 | Beta round trip, FR965 (plan phase 3) | T1, T2, T4, T5 pass; T2 especially: the date set on the phone is still there after reopening the settings screen | **Open** (owner). If T2 fails, stop: the phone route is broken and the on-watch picker must become the main route |
| 3 | T4 decision recorded | Picker and phone do not destroy each other's values, or "last change wins" is documented; ADR-005 filled in; the listing/support "set it on the watch" sentence added or dropped (`listing/NOTES.md`) | **Open** |
| 4 | Always-on check | Heat map (simulator, File > View Screen Heat Map) and one night on the FR965 with sleep mode off: no blank screen, no ghosting. If it blanks, raise `BURN_IN_STEP_PERMILLE` (ADR-007) and repeat | **Open** |
| 5 | Wear day on the production build | One full day, this face only: midnight flip from 1 DAY to TODAY, day count against the calendar, battery looks normal | **Open**. No battery figure goes in the listing |
| 6 | Look approved | You have seen the face in the simulator on at least `fr965` and `fenix7x` (or replaced the direction with your own mock-up, then `spec.md` and `DESIGN.md` are updated) | **Open** |
| 7 | Real assets | Launcher icon, cover 500×500, hero 1440×720 (optional), one device's screenshots, device icons (optional); paths filled in `listing/paste.md` and `listing/screenshots.md` written | **Partly done**: one screenshot (`listing/screens/1-countdown.png`) and a cover (`cover-500.png`) exist; the real launcher icon is still the placeholder; hero and device icons optional |
| 8 | Languages decided | Ship English only, or English plus the 14 machine-drafted on-watch languages; a native speaker has read any language you ship as store copy | **Open** |
| 9 | Site live | `cd ../site && npm run build && npm run deploy`; then `/days-to-go/support/` and `/days-to-go/privacy/` open without login. Reviewers and users open them | **Done 2026-09-26**: `/days-to-go/`, `/support/` and `/privacy/` return 200 on verden.watch (checked after the owner's deploy). The landing page's store button says "Coming soon" until `storeUrl` is set |
| 10 | Price confirmed | Pro: paid, the $2.50 tier (US $2.49, eurozone 2,99 EUR), ADR-017 (price: the $2.50 tier for every paid app), set in the upload form with 1.1.0; it was the lowest tier (USD 2.00, $1.99 US) at first submission (ADR-002, price superseded). Free is free. No price number in listing or site text. The risk is on record: 15 paid countdown faces all at 10 downloads or fewer | Decided 2026-10-04; set at upload |
| 11 | Baseline recorded | Download buckets, review counts and ratings of HeroSet and HeroFace on the submission day, plus their store links, written in `CHANGELOG.md` or the memory file | **Open** |
| 12 | Tests green | `tools/fit_all.sh` and `tools/run_tests.sh fr965` pass on the commit you submit | Last sweep: 42 tests, ten sizes, fenix6pro, venu2s and the two rectangles (simulator) |

## Timing

- **Earliest sensible day:** the day after gate 5 (the wear day) and gates 1, 2, 4, 6 to 9 are done. Nothing else is time-based: there is no launch date to hit.
- **Do not** publish a build that gates 2 to 5 did not use. Export the package from the commit you wore.
- **Review takes about 72 hours** (HeroFace notes); a rejection names its reasons. Advice, not evidence: submit early in the week so any rejection lands on working days.
- **Price is set in the upload form** (Pro: the $2.50 tier, ADR-017). Changing the price of an approved app can take it out of the store for re-review (SDK `Monetization/App_Sales`; Garmin's handling of a repricing is unconfirmed; policy research in ROADMAP 2.1), so the repricing ships together with the 1.1.0 version upload, which is re-reviewed anyway.
- A paid app is sold only on Garmin's own list of watches and countries, so the store's device list will be shorter than the manifest's 120. Never quote a watch count.

## Submit (one sitting, about 30 minutes)

1. `cd DaysToGo && monkeyc -e -r -f monkey.jungle -o dist/DaysToGoPro.iq -y ~/.garmin-connectiq/keys/developer_key` (the paid app, the live app id; `dist/DaysToGoFree.iq` is the **Free** package, and `dist/DaysToGo-1.0.1-submitted.iq` is the 1.0.1 package as submitted)
2. Open https://apps.garmin.com/developer/upload, attach `dist/DaysToGoPro.iq`.
3. Paste each field from [`../listing/paste.md`](../listing/paste.md), in form order. Category: Utility. Add the price in the merchant flow (the $2.50 tier, ADR-017).
4. Add the images from gate 7.
5. Same day, update `CHANGELOG.md` (version 1.0.0, upload date, user-facing changes, ADRs) and check that `listing/paste.md` has the What's New block and the version.
6. Do not commit `dist/*.iq` or any key file.

## After approval (the day it arrives)

1. Open the live listing page. Check the title, description, images and price. Check the support and privacy links open.
2. ~~Price review date: approval + 45 days.~~ **Retired 2026-10-04** (the owner approved the Free + Pro ladder, ADR-014; the paid app is never flipped to free). Still true if the price is ever touched: email Connect IQ developer support first and never cancel the merchant account.
3. In `site/src/apps/days-to-go/app.ts` set `storeUrl`; add the live store's device list to `facts.ts` only once it is shown there. Rebuild and redeploy the site.
4. Update the root `README.md` status and `CLAUDE.md` price line.
5. Day 60: run the success test in `spec.md`.

## Free + Pro pair (approved by the owner 2026-10-04, UNRELEASED: ADR-014 (Free + Pro ladder))

Nothing in this block is done unless it says so; nothing is uploaded. Builds against `../../reports/Free and Pro ladder execution plan.md` (WP4); the owner approved the ladder on 2026-10-04 (OD1, OD2: the day-45 flip rule is retired, ADR-002 Superseded); names are confirmed (2026-10-04), the Pro price is the $2.50 tier (ADR-017) and every upload is still open, and the live paid app is unchanged until then. No store-package quirk is recorded anywhere in this project's docs; the Free and Pro exports below are plain `monkeyc -e -r` and were checked with `tools/check_free_package.sh`.

| # | Gate (Free 1.0.0 and Pro 1.1.0, upload together: Free first as a new app, Pro the same day on the existing id) | State |
|---|---|---|
| F1 | Owner signs off OD1 (the ladder), OD2 (retire the day-45 flip rule), OD3 (names), OD4 (Pro price). ADR-014 (Free + Pro ladder) is Active and ADR-002's flip rule Superseded | **Ladder, OD2, names and the price tier done 2026-10-04** (ADR-017); set at upload |
| F2 | Store names and titles chosen and searched in the store by eye (plan placeholders: app name "Days To Go" / "Days To Go Pro"; proposed titles "Days To Go: Countdown to a Date" / "Days To Go Pro: Countdown to the Minute", the Pro one changed 2026-10-04 with the headline). Name is also the on-watch AppName: change `resources-free/strings` and `resources-pro/strings` only | **Open** (owner) |
| F3 | Pro headline decided: what a buyer pays for beyond timed events and the battery or steps line | **Done 2026-10-04**: owner picked option 1, "To the minute" (`../../reports/Days To Go Pro research.md`); built as ADR-018 (the event minute and zone), simulator only. Wrist checks are the "To the minute" section below |
| F4 | Launcher icon for each tier (the file is still the placeholder; Free and Pro may differ) | **Open** (owner) |
| F5 | Tests run on both jungles: `tools/run_tests.sh <device> monkey.jungle` and `... monkey.free.jungle` on fr965, fr55, venusq2; `tools/fit_all.sh monkey.free.jungle` | **Done 2026-10-01, simulator only**: Pro 50 / Free 51 PASSED on fr965, fr55, venusq2; `fit_all.sh` on ten devices passes on both jungles. not run on a wrist. **Measured 2026-10-04 (container simulator, not device proof):** Free on `fr55` and `fenix5s` (91.8 kB budget) uses 27.6 and 27.5 kB after the face drew (`-r` build, status bar) and the Free suite passes 53/53 on both; the Customize menu and the date picker, driven in a private watch-app harness (the simulator cannot open Customize on a face), read 26.8 and 31.0 kB on `fenix5s`, 24.0 and 28.2 kB on an Instinct E 40 mm (face 24.9 kB of 59.8 kB): nowhere near a limit. Flag: the harness draws the picker on a white background with white text on the colour MIP screens (check a MIP watch). See `compatibility.md` "Measured 2026-10-04" |
| F6 | Packages exported and checked: `tools/check_free_package.sh --build` | **Done 2026-10-01** after the final edits (compile only; `dist/DaysToGoFree.iq` and `dist/DaysToGoPro.iq`; see `development.md`) |
| F7 | Device check on the FR965, store-build equivalent: Free shows no Hour or Footer in the phone and Customize screens, the accent change round trip (phone, sync, restart; then on the watch), the on-watch name in the watch-face list | **Open** (owner) |
| F8 | Listing-free filled from `../listing-free/paste.md`; screenshots taken from the Free build (none exist) | **Open** |
| F9 | Pro's `../listing/paste.md` What's New and version are the 1.1.0 text since 2026-10-04 (the sibling URL on line 1 is a placeholder); `CHANGELOG.md` entries get their dates | **Text done; URL and dates open** (on upload) |
| F10 | Site: `freeStoreUrl`, a "Free or Pro" section, per-tier privacy and support wording (plan WP8). Do not change a published URL | **Open** (not in this folder) |
| F11 | Translations of any new string, machine drafts need the owner's OK | **Open**: 3 new phone strings (Minute, Event time zone, My watch time zone) in 14 languages, machine-drafted by the agent, not read by native speakers; they are in `../resources-pro-<lang>/strings/` (Pro only). The minute and UTC-offset labels are numbers, not translated |

### Free listing block (when F1 to F8 are green)

1. `cd DaysToGo && tools/check_free_package.sh --build` (or export `monkeyc -e -r -f monkey.free.jungle -o dist/DaysToGoFree.iq -y ~/.garmin-connectiq/keys/developer_key`), then open https://apps.garmin.com/developer/upload, attach `dist/DaysToGoFree.iq` (a **new** app: the form reads the new app id from the package).
2. Paste each field from [`../listing-free/paste.md`](../listing-free/paste.md) in form order. Category Utility. Monetization: the free listing asks no payment (confirm the form's wording at submission). Replace the placeholder Pro store URL on line 1 with the real one once Pro 1.1.0 is live, or upload Pro first.
3. Same day: upload `dist/DaysToGoPro.iq` to the existing app id as 1.1.0 (set Pro's price tier to $2.50 in the form, ADR-017; re-pricing an approved app can remove it for re-review, so do it in this same version upload).
4. Update `CHANGELOG.md` (drop UNRELEASED, add upload dates), the What's New blocks, record both app ids for the measurement plan (WP9), and the review-day dates for gates G1 to G4 in the ladder plan.
5. Do not commit `dist/*.iq` or any key file.

## If the review rejects it

The rejection lists reasons. Fix the named item in the listing or build, bump the version if the package changes, re-submit. Do not change the price in the same step.

**Until gate F1 (the Free + Pro pair) is signed off by the owner, build any 1.0.x fix from the commit before the ladder work, not from the current working tree**: this tree names the paid app "Days To Go Pro" on the watch and has restructured resources, neither of which the owner has approved for the live app.
