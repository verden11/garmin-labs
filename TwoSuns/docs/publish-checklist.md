# When and how to publish Two Suns

**Status 2026-09-27: built and simulator-tested; nothing submitted.** Three spot-checks have run on the owner's FR965 (sunrise/sunset match, gate 3; Positioning, gate 2; on-watch Customize, ADR-019) — the rest of the build is still simulator-only, no full wear day yet. Every gate below is open unless it says otherwise.

Owner's runbook. Do the gates in order; each one names what "passed" looks like and where to record it. Status of the build itself: [`plan.md`](plan.md) "Implementation status". What may be claimed: [`release-contract.md`](release-contract.md).

## Never decide alone

The store name; the price and its wording; the visual identity and the launcher icon; the `Positioning` permission; any upload to the Connect IQ store; any phone or watch test; a site deploy; shipping machine translations no native speaker has read; tier B; any claim the release contract forbids. On 2026-09-26 the owner said to proceed with the implementation without further permission questions and the reversible defaults were taken ([`decisions.md`](decisions.md)); that does not cover this list.

## Ready to submit when ALL of these are true

| # | Gate | Passed looks like | Where it stands |
|---|---|---|---|
| 1 | Name cleared | Store search by eye and a trademark search found no conflict with the chosen name ("Two Suns", confirmed 2026-09-27); "Body Battery" appears nowhere in the name, icon or brand ([ADR-010](decisions.md#adr-010-name-and-slug)) | **Partly open.** Name confirmed by the owner, no conflict found in the store's own search; a real trademark search still not done |
| 2 | Location probes run, decision table filled | `device-test/LocationProbe-N.prg` and `-P.prg` run on the FR965 per `device-test/LocationProbe-CHECKLIST.md`; the decision table in [`plan.md`](plan.md) phase 1 filled from the photos and approved. Positioning kept or dropped; if dropped, delete `TwoSunsSources.positionLocation` and its entry and remove the permission ([ADR-005](decisions.md#adr-005-location-order-and-the-positioning-permission)) | **Done, in part.** M1/M2 run 2026-09-27, Positioning confirmed kept ([ADR-005](decisions.md#adr-005-location-order-and-the-positioning-permission)). M3/M4 not run (not blocking) |
| 3 | Sunrise and sunset compared with the native glance | On the FR965, the face's sunrise and sunset equal the watch's own Sunrise/Sunset glance to the minute, at more than one moment; recorded in `device-test/TwoSuns-CHECKLIST.md`. If they differ by more than 1 minute, stop: make the calculation primary and re-compare ([ADR-003](decisions.md#adr-003-sunrise-and-sunset-come-from-complications)) | **Passed, one comparison** (2026-09-27): exact match, `device-test/TwoSuns-CHECKLIST.md`. A second comparison on another day would close it fully |
| 4 | Look approved | The owner has seen the face in the simulator on at least `fr965` and `fenix7x` and on a rectangle, and approves the colours, glyph and layout, or replaces the direction with a mock-up (then `spec.md` and `DESIGN.md` are updated). Decide the two `#555555` cases at 2.8:1 ([`../DESIGN.md`](../DESIGN.md)) | **Open**. No screenshot of the face exists |
| 5 | Always-on night check | Heat map (simulator, File > View Screen Heat Map) and one night on the FR965 with sleep mode off: no blank screen, no ghosting. If it blanks, raise `BURN_IN_STEP_PERMILLE` or shrink the time ([ADR-007](decisions.md#adr-007-always-on)) and repeat | **Not blocking (owner, 2026-09-27).** Submit without it; fix in a follow-up release if the screen ghosts or blanks |
| 6 | Wear day on the production build | One full day, this face only, the build that will be exported: correct time and ring at first sight, the ring on the right local day across local midnight and across UTC midnight, a run with the phone and GPS off, Body Battery curve shape against Garmin's own graph, DST if a change day falls in the window. Battery over 24 hours against the same watch on Days To Go is for the owner's information: **no battery figure goes in the listing** | **Not blocking (owner, 2026-09-27).** Submit without it; fix in a follow-up release if something surfaces |
| 7 | All-69-products fit sweep | `tools/fit_products.sh` prints `done: 69 pass, 0 fail` on the commit you submit (slow; the simulator must not be shared during it) | **Passed, 2026-09-27**: `bin/fit-products.txt`, `done: 69 pass, 0 fail`, `PASSED (passed=122, failed=0, errors=0)` on every product, including Venu X1. Stale: this run predates the on-watch Customize menu (ADR-019) **and** the 2026-09-27 `watch-design-reviewer` fixes (raised time cap, 2 new tests, 124 total). Re-run on the commit you actually submit |
| 8 | Export checked: 89 versus 69 | Export overreports device count vs. manifest; details in [`compatibility.md`](compatibility.md#the-export-and-89-devices). Decide with the owner before upload if it's wider than the 69 | **Still open.** Resolve at upload: the store form's own Compatible Devices list is authoritative |
| 9 | Language fit and decision | `tools/fit_languages.sh <product>` run per language on the smallest screen (`fr255s`) and a rectangle (`venusq2`), zero fit failures | **Decided (owner, 2026-09-27): ship all 15** (English + the 14 machine-drafted), no native-speaker read required. Fit-testing still to run when the simulator is free, not blocking submission |
| 10 | Real assets | Launcher icon (the current one is a generic placeholder), cover 500×500, hero 1440×720 (optional), screenshots **taken by the owner** on a real watch or the simulator; paths filled in `listing/README.md`, `listing/screenshots.md` written | **Partly done, 2026-09-27.** Two real FR965 screens, a cover and a hero exist and are wired into `listing/README.md` (`listing/screenshots.md`). Still open: launcher icon (generic placeholder) and formal owner look-approval of the cover/hero mark |
| 11 | Listing written and checked | `listing/README.md` in form order, every sentence checked against [`release-contract.md`](release-contract.md); the description says what is shown, never what it means for health; "Body Battery" only descriptively | **Text finalised, 2026-09-27.** Every OWNER field resolved (name, category, price, collects-user-data), images now filled too. Only the launcher icon and formal look sign-off remain |
| 12 | Site live | The pages under `site/src/apps/two-suns/` (landing, support, privacy) built and deployed by the owner (`cd ../site && npm run build && npm run deploy`); `/two-suns/support/` and `/two-suns/privacy/` open without login. The privacy page says what is read (Body Battery history, Garmin's own sunrise and sunset, a location rounded to 0.1 degree that stays on the watch), and matches the manifest | **Deferred (owner, 2026-09-27): deploy once all changes are finalised.** The owner pushes to git and deploys, not this session |
| 13 | Price confirmed | Paid, USD 1.99 — Garmin's first paid price step (custom prices are not offered; same tier as Days To Go) (owner, confirmed 2026-09-27); the flip rule confirmed for this app | Decided; confirm at submit |
| 14 | Baseline recorded | Download buckets, review counts and ratings of HeroSet, HeroFace and Days To Go on the submission day, plus their store links, in `CHANGELOG.md` or the memory file | **Open** |
| 15 | Tests green | `tools/run_tests.sh fr965`, `fenix7` and `venu3` print `PASSED (passed=124, failed=0, errors=0)`, `tools/fit_all.sh` reports no failures, `python3 tools/gen_settings.py --check` and `python3 tools/check_strings.py` pass, zero build warnings, all on the commit you submit | **Partly re-confirmed 2026-09-27**: `gen_settings.py --check` and `check_strings.py` both OK, compile clean (`-w --typecheck 3`) after the `watch-design-reviewer` fixes (2 new tests, 124 total). The full `run_tests.sh`/`fit_all.sh` pass predates those fixes (122 of 122, same day) — re-run once the simulator is free, before submit |

## Timing

- **Earliest sensible day:** the day after gate 6 (the wear day) with gates 1 to 5 and 7 to 12 done. Nothing else is time-based: there is no launch date to hit.
- **Do not** publish a build that gates 3, 5 and 6 did not use. Export the package from the commit you wore.
- **Review takes about 72 hours** (HeroFace notes); a rejection names its reasons. Advice, not evidence: submit early in the week.
- **Price is set at submission.** Changing it later takes the app out of the store for re-review (SDK `Monetization/App_Sales`), so settle gate 13 first.
- A paid app is sold only on Garmin's own list of watches and countries, so the store's device list will be shorter than the manifest's 69. Never quote a watch count.

## Store form answers

Each field's text is in [`../listing/README.md`](../listing/README.md), in form order (written separately). The decisions behind the answers:

- **Name:** the owner's decision (gate 1). "Body Battery" never in it.
- **Category:** Health & Fitness or Utility, the owner's choice at listing time (spec D13).
- **Price:** paid, lowest tier; the merchant flow, the same as Days To Go.
- **Permissions and privacy:** `SensorHistory`, `ComplicationSubscriber`, and `Positioning` only if gate 2 keeps it. Location: used to compute sun times, rounded to 0.1 degree, stays on the watch. No network. No medical claims.
- **Support and privacy URLs:** `https://verden.watch/two-suns/support/` and `/two-suns/privacy/` once deployed. **Never change or remove a published URL.**
- **Languages:** per gate 9.
- **Images:** gate 10, supplied by the owner.

## Submit (one sitting, about 30 minutes)

1. `cd TwoSuns && monkeyc -e -r -f monkey.jungle -o dist/TwoSuns.iq -y ~/.garmin-connectiq/keys/developer_key`
2. Open https://apps.garmin.com/developer/upload, attach `dist/TwoSuns.iq`.
3. Paste each field from `listing/README.md`, in form order. Add the price in the merchant flow.
4. Add the images from gate 10.
5. Same day, update `CHANGELOG.md` (version 1.0.0, upload date, user-facing changes, ADRs) and check that `listing/README.md` has the What's New block and the version.
6. Do not commit `dist/*.iq` or any key file.

## After approval (the day it arrives)

1. Open the live listing page. Check the title, description, images and price. Check the support and privacy links open.
2. **Price review date: approval date + 45 days.** Replace "Price review due: not set until approval" in `CLAUDE.md` with the date and add it to the memory index. Then follow the Days To Go price-review rules ([`../../DaysToGo/docs/decisions.md`](../../DaysToGo/docs/decisions.md) ADR-002): email Connect IQ developer support before any flip, never cancel the merchant account; the proposed flip rule (fewer than 5 sales in 45 days and a download bucket of 10 or lower) is still for the owner to confirm.
3. In `site/src/apps/two-suns/app.ts` set `storeUrl`; add the live store's device list to `facts.ts` only once it is shown there. Rebuild and redeploy the site.
4. Update the root `README.md` status and `CLAUDE.md` row.
5. Day 60: run the success test in [`spec.md`](spec.md) "Success and stop test" (the day-45 price review comes first). Record any review that mentions wrong or blank sun times.
6. Tier B (1.1) only if gate 2 showed a location source that works.

## If the review rejects it

The rejection lists reasons. Fix the named item in the listing or build, bump the version if the package changes, re-submit. Do not change the price in the same step.
