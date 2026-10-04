# Two Suns — status and release runbook

> **Open items live only in the root [`ROADMAP.md`](../../ROADMAP.md).** This file keeps where things stand, the evidence, the release gates and the upload steps. Listing text and metadata: [`../listing/paste.md`](../listing/paste.md) and [`../listing/meta.yaml`](../listing/meta.yaml). Claims: [`release-contract.md`](release-contract.md). Build history: [`archive/plan.md`](archive/plan.md).

**Where things stand, 2026-10-04.** Approved 2026-09-28 (1.0.0). Prepared, not submitted: 1.0.1 (commit `807977d`). Built, unreleased: the Free + Pro pair (ADR-020/021), the Pro weather and watch battery rows (ADR-022/023; FR965 wear check in progress, `device-test/TwoSuns-weather-RESULTS.md`). 72 products with the Instinct E and 3 Solar (ADR-024, look approved 2026-10-04, simulator only). Open work: ROADMAP M4, 9.2.

**Status 2026-09-27: 1.0.0 submitted, pending review.** Store page (live once approved): https://apps.garmin.com/apps/9d4bca45-d79a-4f26-abf5-04e0519cf10b. Three spot-checks have run on the owner's FR965 (sunrise/sunset match, gate 3; Positioning, gate 2; on-watch Customize, ADR-019) — the rest of the build is still simulator-only, no full wear day yet. The gates below record what state the app was in when the owner chose to submit, not a claim that every one closed first — several were explicitly waived by the owner (see each gate's own note).

**1.0.1 prepared 2026-09-28, not submitted.** One defensive rendering fix plus a docs correction (`CHANGELOG.md`, `docs/decisions.md` ADR-017) — see `CHANGELOG.md`'s 1.0.1 entry. Owner is holding submission until 1.0.0's review concludes. All the gates below are 1.0.0's own status, unchanged by 1.0.1's fix (nothing here closes a previously-open gate).

Owner's runbook. Do the gates in order; each one names what "passed" looks like and where to record it. Status of the build itself: [`archive/plan.md`](archive/plan.md) "Implementation status". What may be claimed: [`release-contract.md`](release-contract.md).

## Ready to upload (prepared 2026-10-04, NOT uploaded)

Free 1.0.0 (a new app id) and Pro 1.1.0 (the existing id). Text: `../listing-free/paste.md` and `../listing/paste.md` (now the 1.1.0 text; if the owner submits 1.0.1 first, ROADMAP 4.1, use `TwoSuns-1.0.1-prepared.iq`, keep the title "Two Suns", drop the "Also available" line and use the 1.0.1 What's New kept in `../listing/NOTES.md`); metadata `../listing*/meta.yaml`.

| File (absolute path) | Products | Check |
|---|---|---|
| `/Users/mbp/dev/garmin/TwoSuns/dist/TwoSunsFree-1.0.0.iq` | 72 | `tools/check_free_package.sh`: OK (permission ComplicationSubscriber only, key Accent only) |
| `/Users/mbp/dev/garmin/TwoSuns/dist/TwoSunsPro-1.1.0.iq` | 72 | same script: OK (Positioning, SensorHistory, seven keys) |

**Re-exported 2026-10-04 after the always-on text colour change (ADR-027, always-on text is a dim grey, ROADMAP 10.26); older exports were moved to `dist-old/`, so `dist/` holds only the packages to upload.** Unit suite on fr965, fr255s, epix2 and instincte40mm for both tiers passed (Pro 154, 154, 154, 146; Free 67, 67, 67, 60), which includes `everyStateFitsThisDisplay` and `alwaysOnFrameFitsAtEveryDrift`; simulator only. Built in the `verden-ciq-build` container (`docker/run.sh`), checked with the project's package script without `--build`; simulator and compile only, **nothing on a wrist**. The files are in the main checkout's git-ignored `dist/` under a dated name (the older exports and `dist/old/` are untouched); the same bytes are `dist/<name>.iq` in the build worktree. Product counts are `<iq:product>` lines in the manifest; the export holds more part numbers (device variants). Names and the price tier ($2.50 for every paid app) were decided 2026-10-04; the owner's decisions (icons, uploads, translations) are still open: see ROADMAP.

## Never decide alone

The store name; the price wording (the tier itself is decided: $2.50, ADR-026); the visual identity and the launcher icon; the `Positioning` permission; any upload to the Connect IQ store; any phone or watch test; a site deploy; shipping machine translations no native speaker has read; tier B; any claim the release contract forbids. On 2026-09-26 the owner said to proceed with the implementation without further permission questions and the reversible defaults were taken ([`decisions.md`](decisions.md)); that does not cover this list.

## Ready to submit when ALL of these are true

| # | Gate | Passed looks like | Where it stands |
|---|---|---|---|
| 1 | Name cleared | Store search by eye and a trademark search found no conflict with the chosen name ("Two Suns", confirmed 2026-09-27); "Body Battery" appears nowhere in the name, icon or brand ([ADR-010](decisions.md#adr-010-name-and-slug)) | **Partly open.** Name confirmed by the owner, no conflict found in the store's own search; a real trademark search still not done |
| 2 | Location probes run, decision table filled | `device-test/LocationProbe-N.prg` and `-P.prg` run on the FR965 per `device-test/LocationProbe-CHECKLIST.md`; the decision table in [`archive/plan.md`](archive/plan.md) phase 1 filled from the photos and approved. Positioning kept or dropped; if dropped, delete `TwoSunsSources.positionLocation` and its entry and remove the permission ([ADR-005](decisions.md#adr-005-location-order-and-the-positioning-permission)) | **Done, in part.** M1/M2 run 2026-09-27, Positioning confirmed kept ([ADR-005](decisions.md#adr-005-location-order-and-the-positioning-permission)). M3/M4 not run (not blocking) |
| 3 | Sunrise and sunset compared with the native glance | On the FR965, the face's sunrise and sunset equal the watch's own Sunrise/Sunset glance to the minute, at more than one moment; recorded in `device-test/TwoSuns-CHECKLIST.md`. If they differ by more than 1 minute, stop: make the calculation primary and re-compare ([ADR-003](decisions.md#adr-003-sunrise-and-sunset-come-from-complications)) | **Passed, one comparison** (2026-09-27): exact match, `device-test/TwoSuns-CHECKLIST.md`. A second comparison on another day would close it fully |
| 4 | Look approved | The owner has seen the face in the simulator on at least `fr965` and `fenix7x` and on a rectangle, and approves the colours, glyph and layout, or replaces the direction with a mock-up (then `spec.md` and `DESIGN.md` are updated). Decide the two `#555555` cases at 2.8:1 ([`../DESIGN.md`](../DESIGN.md)) | **Open**. No screenshot of the face exists |
| 5 | Always-on night check | Heat map (simulator, File > View Screen Heat Map) and one night on the FR965 with sleep mode off: no blank screen, no ghosting. If it blanks, raise `BURN_IN_STEP_PERMILLE` or shrink the time ([ADR-007](decisions.md#adr-007-always-on)) and repeat | **Not blocking (owner, 2026-09-27).** Submit without it; fix in a follow-up release if the screen ghosts or blanks |
| 6 | Wear day on the production build | One full day, this face only, the build that will be exported: correct time and ring at first sight, the ring on the right local day across local midnight and across UTC midnight, a run with the phone and GPS off, Body Battery curve shape against Garmin's own graph, DST if a change day falls in the window. Battery over 24 hours against the same watch on Days To Go is for the owner's information: **no battery figure goes in the listing** | **Not blocking (owner, 2026-09-27).** Submit without it; fix in a follow-up release if something surfaces |
| 7 | All-69-products fit sweep | `tools/fit_products.sh` prints `done: 69 pass, 0 fail` on the commit you submit (slow; the simulator must not be shared during it) | **Passed, 2026-09-27**: `bin/fit-products.txt`, `done: 69 pass, 0 fail`, `PASSED (passed=122, failed=0, errors=0)` on every product, including Venu X1. Stale: this run predates the on-watch Customize menu (ADR-019) **and** the 2026-09-27 `watch-design-reviewer` fixes (raised time cap, 2 new tests, 124 total). Re-run on the commit you actually submit |
| 8 | Export checked: 89 versus 69 | Export overreports device count vs. manifest; details in [`compatibility.md`](compatibility.md#the-export-and-89-devices). Decide with the owner before upload if it's wider than the 69 | **Count explained 2026-10-01** (SDK-file evidence: the 69 product ids have exactly 89 part numbers in the SDK, all 89 in the package; [`compatibility.md`](compatibility.md#the-export-and-89-devices)). **Still open at upload:** the store form's own Compatible Devices list is authoritative |
| 9 | Language fit and decision | `tools/fit_languages.sh <product>` run per language on the smallest screen (`fr255s`) and a rectangle (`venusq2`), zero fit failures | **Decided (owner, 2026-09-27): ship all 15** (English + the 14 machine-drafted), no native-speaker read required. Fit-testing still to run when the simulator is free, not blocking submission |
| 10 | Real assets | Launcher icon (the current one is a generic placeholder), cover 500×500, hero 1440×720 (optional), screenshots **taken by the owner** on a real watch or the simulator; paths filled in `listing/paste.md`, `listing/screenshots.md` written | **Partly done, 2026-09-27.** Two real FR965 screens, a cover and a hero exist and are wired into `listing/paste.md` (`listing/screenshots.md`). Still open: launcher icon (generic placeholder) and formal owner look-approval of the cover/hero mark |
| 11 | Listing written and checked | `listing/paste.md` in form order, every sentence checked against [`release-contract.md`](release-contract.md); the description says what is shown, never what it means for health; "Body Battery" only descriptively | **Text finalised, 2026-09-27.** Every OWNER field resolved (name, category, price, collects-user-data), images now filled too. Only the launcher icon and formal look sign-off remain |
| 12 | Site live | The pages under `site/src/apps/two-suns/` (landing, support, privacy) built and deployed by the owner (`cd ../site && npm run build && npm run deploy`); `/two-suns/support/` and `/two-suns/privacy/` open without login. The privacy page says what is read (Body Battery history, Garmin's own sunrise and sunset, a location rounded to 0.1 degree that stays on the watch), and matches the manifest | **Deferred (owner, 2026-09-27): deploy once all changes are finalised.** The owner pushes to git and deploys, not this session |
| 13 | Price confirmed | Paid, the $2.50 tier (US $2.49, eurozone 2,99 EUR), ADR-026 (price: the $2.50 tier for every paid app), set in the form with 1.1.0 (owner, 2026-10-04); it was USD 1.99, Garmin's first paid price step, confirmed 2026-09-27 (ADR-002, price superseded; the store showed $2.25); the flip rule is retired (ADR-020) | Decided 2026-10-04; set at upload |
| 14 | Baseline recorded | Download buckets, review counts and ratings of HeroSet, HeroFace and Days To Go on the submission day, plus their store links, in `CHANGELOG.md` or the memory file | **Open** |
| 15 | Tests green | `tools/run_tests.sh fr965`, `fenix7` and `venu3` print `PASSED (passed=124, failed=0, errors=0)`, `tools/fit_all.sh` reports no failures, `python3 tools/gen_settings.py --check` and `python3 tools/check_strings.py` pass, zero build warnings, all on the commit you submit | **Partly re-confirmed 2026-09-27**: `gen_settings.py --check` and `check_strings.py` both OK, compile clean (`-w --typecheck 3`) after the `watch-design-reviewer` fixes (2 new tests, 124 total). The full `run_tests.sh`/`fit_all.sh` pass predates those fixes (122 of 122, same day) — re-run once the simulator is free, before submit |

## Timing

- **Earliest sensible day:** the day after gate 6 (the wear day) with gates 1 to 5 and 7 to 12 done. Nothing else is time-based: there is no launch date to hit.
- **Do not** publish a build that gates 3, 5 and 6 did not use. Export the package from the commit you wore.
- **Review takes about 72 hours** (HeroFace notes); a rejection names its reasons. Advice, not evidence: submit early in the week.
- **Price is set in the upload form** (Pro: the $2.50 tier, ADR-026). Changing the price of an approved app can take it out of the store for re-review (SDK `Monetization/App_Sales`; unconfirmed for a higher tier; policy research in ROADMAP 2.1), so the repricing ships together with the 1.1.0 version upload, which is re-reviewed anyway.
- A paid app is sold only on Garmin's own list of watches and countries, so the store's device list will be shorter than the manifest's 69. Never quote a watch count.

## Store form answers

Each field's text is in [`../listing/paste.md`](../listing/paste.md), in form order (written separately). The decisions behind the answers:

- **Name:** the owner's decision (gate 1). "Body Battery" never in it.
- **Category:** Health & Fitness or Utility, the owner's choice at listing time (spec D13).
- **Price:** paid, the $2.50 tier (ADR-026); the merchant flow, the same as Days To Go.
- **Permissions and privacy:** `SensorHistory`, `ComplicationSubscriber`, and `Positioning` only if gate 2 keeps it. Location: used to compute sun times, rounded to 0.1 degree, stays on the watch. No network. No medical claims.
- **Support and privacy URLs:** `https://verden.watch/two-suns/support/` and `/two-suns/privacy/` once deployed. **Never change or remove a published URL.**
- **Languages:** per gate 9.
- **Images:** gate 10, supplied by the owner.

## Submit (one sitting, about 30 minutes)

1. `cd TwoSuns && monkeyc -e -r -f monkey.jungle -o dist/TwoSuns-1.0.1.iq -y ~/.garmin-connectiq/keys/developer_key` (**for a 1.0.x, from commit `807977d`, the last one before the ladder work**: this tree builds Pro as "Two Suns Pro". `dist/TwoSuns.iq` today is the already-prepared 1.0.1 and is never overwritten; the ladder's packages are `dist/TwoSunsFree.iq` and `dist/TwoSunsPro.iq`, the Pro one to be renamed with its version at upload)
2. Open https://apps.garmin.com/developer/upload, attach `dist/TwoSuns-1.0.1.iq` (or the prepared `dist/TwoSuns.iq` if the owner chooses it).
3. Paste each field from `listing/paste.md`, in form order. Add the price in the merchant flow (the $2.50 tier, ADR-026).
4. Add the images from gate 10.
5. Same day, update `CHANGELOG.md` (the version being submitted, upload date, user-facing changes, ADRs) and check that `listing/paste.md` has the matching What's New block and version number.
6. Do not commit `dist/*.iq` or any key file.

## After approval (the day it arrives)

1. Open the live listing page. Check the title, description, images and price. Check the support and privacy links open.
2. ~~Price review date: approval + 45 days.~~ **Retired 2026-10-04** (the owner approved the Free + Pro ladder, ADR-020; the paid app is never flipped to free). Still true if the price is ever touched: email Connect IQ developer support first and never cancel the merchant account ([`../../DaysToGo/docs/decisions.md`](../../DaysToGo/docs/decisions.md) ADR-002).
3. In `site/src/apps/two-suns/app.ts` set `storeUrl`; add the live store's device list to `facts.ts` only once it is shown there. Rebuild and redeploy the site.
4. Update the root `README.md` status and `CLAUDE.md` row.
5. Day 60: run the success test in [`spec.md`](spec.md) "Success and stop test". Record any review that mentions wrong or blank sun times.
6. Tier B (1.1) only if gate 2 showed a location source that works.

## Free + Pro pair (approved by the owner 2026-10-04, UNRELEASED: ADR-020 (Free + Pro ladder))

Nothing in this block is done unless it says so; nothing is uploaded. Builds against `../../reports/Free and Pro ladder execution plan.md` (WP5); the owner approved the ladder on 2026-10-04 (OD1, OD2: the day-45 review is retired, ADR-002 Superseded); names are confirmed (2026-10-04), the Pro price is the $2.50 tier (ADR-026) and every upload is still open, and the live paid app is unchanged until then. The prepared 1.0.1 is **not** held back by this work and is not part of it (plan WP5 step 7); the owner submits it or not. No store-package quirk beyond the known "89 devices" oddity is recorded; the Free and Pro exports below are plain `monkeyc -e -r` and were checked with `tools/check_free_package.sh`.

| # | Gate (Free 1.0.0 and Pro 1.1.0, upload together: Free first as a new app, Pro the same day on the existing id) | State |
|---|---|---|
| F1 | Owner signs off OD1 (the ladder), OD2 (retire the day-45 flip rule), OD3 (names), OD4 (Pro price tier (decided 2026-10-04: the $2.50 tier, ADR-026); the store showed $2.25 against the documented $1.99, plan WP5 step 1). ADR-020 (Free + Pro ladder) is Active and the flip rule of ADR-002 (price) Superseded | **Ladder, OD2, names and the price tier done 2026-10-04** (price: the $2.50 tier, ADR-026); set at upload |
| F2 | Store names and titles chosen and searched in the store by eye (plan placeholders: app name "Two Suns" / "Two Suns Pro"). The name is also the on-watch AppName: change `resources-free/strings` and `resources-pro/strings` only | **Open** (owner) |
| F3 | Owner decides the tier of the date row and the ring orientation (plan WP5 puts both in Pro; Free is thinner without them), whether Free keeps civil twilight (needs a place, so no), and the wording of a missing Body Battery number (ADR-021, Body Battery in Free: `--` and a hollow pill, or a word) | **Decided 2026-10-04: Free keeps `--`; date row and ring orientation stay in Free** (owner) |
| F4 | Launcher icon for each tier (the file is still the placeholder; Free and Pro may differ) | **Open** (owner) |
| F5 | Tests run on both jungles: `tools/run_tests.sh <device> monkey.jungle` (expect 154) and `... monkey.free.jungle` (expect 67) on fr965, fr255s, venusq2, venux1; `tools/fit_all.sh monkey.free.jungle` and `tools/fit_all.sh` | **Open**: written and compiled, never run |
| F6 | Packages exported and checked: `tools/check_free_package.sh --build` | **Done 2026-10-01** (compile only; `development.md` "Checking a store package"); re-run after any source change |
| F7 | Device check on the FR965, store-build equivalent: Free shows only Accent in the phone and Customize screens, no curve, no date, no twilight; the accent change round trip (phone, sync, restart; then on the watch); the on-watch name; what Garmin's Body Battery complication shows on a watch with no reading (ADR-021, Body Battery in Free) | **Open** (owner) |
| F8 | `../listing-free/paste.md` filled from; screenshots taken from the Free build (none exist) | **Open** |
| F9 | Pro's `../listing/paste.md` What's New and version are the 1.1.0 text since 2026-10-04 (the sibling URL on line 1 is a placeholder); `CHANGELOG.md` entries get their dates | **Text done; URL and dates open** (on upload) |
| F10 | Site: `freeStoreUrl`, a "Free or Pro" section, per-tier privacy and support wording (Free keeps no place and asks no location; the Free privacy page must not describe Pro's) (plan WP8). Do not change a published URL | **Open** (not in this folder) |
| F11 | Translations of any new string, machine drafts need the owner's OK. **One was added: `setting_weather` ("Weather")**, drafted in 14 languages without review (dan Vejr, deu Wetter, dut Weer, fin Sää, fre Météo, ita Meteo, lit Orai, nob Vær, pol Pogoda, por Tempo, spa Clima, swe Väder, tur Hava durumu, ukr Погода) **and `setting_battery` ("Watch battery")**: dan Ur-batteri, deu Uhr-Akku, dut Horlogebatterij, fin Kellon akku, fre Batterie montre, ita Batteria orologio, lit Laikrodžio baterija, nob Klokkebatteri, pol Bateria zegarka, por Bateria do relógio, spa Batería del reloj, swe Klockans batteri, tur Saat pili, ukr Батарея годинника | **Open** (owner) |
| F12 | Weather row (ADR-022): **wear-check started 2026-10-03: `../../device-test/TwoSuns-weather-CHECKLIST.md` and `TwoSuns-weather-RESULTS.md` (git-ignored). Probe (Q1 to Q4) done except Bluetooth off; wear day (updated 2026-10-04 from photos): B1, B2, B3, B6, B8, B13 to B16 pass, B12 no crash so far, B4 partly; still needed from the owner: tonight's Monday cell, B4 in sun, B9, B11, optional B5, B7, B10, and the look verdicts Q5 to Q8**. Wear-check on the FR965 (the row, the icons in sun, the hours, `Weather` off in the phone and Customize screens); a device probe of the hourly list's length and of the daily forecast's `forecastTime`; memory on the lowest-memory product (the weather row added 18.3 KB to the Pro `.prg`; **simulator reading 2026-10-04, not device proof:** Instinct E Pro 45.9 of 59.8 kB after the face drew, 77%, and about 49 kB at worst with the Customize menu on top, 82%; round 128 KB-class 46.0 of 123.8 kB; see `compatibility.md` "Measured 2026-10-04"; the device check stays open); the site's privacy and Pro wording (Garmin's cached forecast is read on the watch, nothing is sent) is **not yet written** because the site describes the live paid app only | **Open** |

### Free listing block (when F1 to F8 are green)

1. `cd TwoSuns && tools/check_free_package.sh --build` (or export `monkeyc -e -r -f monkey.free.jungle -o dist/TwoSunsFree.iq -y ~/.garmin-connectiq/keys/developer_key`), then open https://apps.garmin.com/developer/upload, attach `dist/TwoSunsFree.iq` (a **new** app: the form reads the new app id from the package).
2. Paste each field from [`../listing-free/paste.md`](../listing-free/paste.md) in form order. Category Utility. Monetization: the free listing asks no payment (confirm the form's wording at submission). Replace the placeholder Pro store URL on line 1 with the real one once Pro 1.1.0 is live, or upload Pro first.
3. Same day: upload `dist/TwoSunsPro.iq` to the existing app id as 1.1.0 (set Pro's price tier to $2.50 in the form, ADR-026; re-pricing an approved app can remove it for re-review, so do it in this same version upload).
4. Update `CHANGELOG.md` (drop UNRELEASED, add upload dates), the What's New blocks, record both app ids for the measurement plan (WP9), and the review-day dates for gates G1 to G4 in the ladder plan.
5. Do not commit `dist/*.iq` or any key file.

## If the review rejects it

The rejection lists reasons. Fix the named item in the listing or build, bump the version if the package changes, re-submit. Do not change the price in the same step.

**Until gate F1 (the Free + Pro pair) is signed off by the owner, build any 1.0.x fix from commit `807977d` (the last before the ladder work), not from the current working tree**: this tree names the paid app "Two Suns Pro" on the watch and has restructured resources and `TwoSunsSources`, none of which the owner has approved for the live app.
