# When and how to publish Days To Go

**Status 2026-09-26: 1.0.1 is submitted (on top of 1.0.0) and pending review.** The "After approval" section below is what to do next; the baseline (gate 11) is still to be written down.

Owner's runbook. Do the gates in order; each one names what "passed" looks like and where to record it. Nothing here is done yet unless it says so. Status of the build itself: [`plan.md`](plan.md) "Implementation status".

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
| 7 | Real assets | Launcher icon, cover 500×500, hero 1440×720 (optional), one device's screenshots, device icons (optional); paths filled in `listing/README.md` and `listing/screenshots.md` written | **Partly done**: one screenshot (`listing/screens/1-countdown.png`) and a cover (`cover-500.png`) exist; the real launcher icon is still the placeholder; hero and device icons optional |
| 8 | Languages decided | Ship English only, or English plus the 14 machine-drafted on-watch languages; a native speaker has read any language you ship as store copy | **Open** |
| 9 | Site live | `cd ../site && npm run build && npm run deploy`; then `/days-to-go/support/` and `/days-to-go/privacy/` open without login. Reviewers and users open them | **Done 2026-09-26**: `/days-to-go/`, `/support/` and `/privacy/` return 200 on verden.watch (checked after the owner's deploy). The landing page's store button says "Coming soon" until `storeUrl` is set |
| 10 | Price confirmed | Paid, the lowest tier (USD 2.00, shown as $1.99 in the US, same as HeroFace and HeroSet), (ADR-002). The risk is on record: 15 paid countdown faces all at 10 downloads or fewer | Decided; confirm at submit |
| 11 | Baseline recorded | Download buckets, review counts and ratings of HeroSet and HeroFace on the submission day, plus their store links, written in `CHANGELOG.md` or the memory file | **Open** |
| 12 | Tests green | `tools/fit_all.sh` and `tools/run_tests.sh fr965` pass on the commit you submit | Last sweep: 42 tests, ten sizes, fenix6pro, venu2s and the two rectangles (simulator) |

## Timing

- **Earliest sensible day:** the day after gate 5 (the wear day) and gates 1, 2, 4, 6 to 9 are done. Nothing else is time-based: there is no launch date to hit.
- **Do not** publish a build that gates 2 to 5 did not use. Export the package from the commit you wore.
- **Review takes about 72 hours** (HeroFace notes); a rejection names its reasons. Advice, not evidence: submit early in the week so any rejection lands on working days.
- **Price is set at submission.** Changing it later takes the app out of the store for re-review (SDK `Monetization/App_Sales`), so settle gate 10 first.
- A paid app is sold only on Garmin's own list of watches and countries, so the store's device list will be shorter than the manifest's 120. Never quote a watch count.

## Submit (one sitting, about 30 minutes)

1. `cd DaysToGo && monkeyc -e -r -f monkey.jungle -o dist/DaysToGo.iq -y ~/.garmin-connectiq/keys/developer_key`
2. Open https://apps.garmin.com/developer/upload, attach `dist/DaysToGo.iq`.
3. Paste each field from [`../listing/README.md`](../listing/README.md), in form order. Category: Utility. Add the price in the merchant flow.
4. Add the images from gate 7.
5. Same day, update `CHANGELOG.md` (version 1.0.0, upload date, user-facing changes, ADRs) and check that `listing/README.md` has the What's New block and the version.
6. Do not commit `dist/*.iq` or any key file.

## After approval (the day it arrives)

1. Open the live listing page. Check the title, description, images and price. Check the support and privacy links open.
2. **Price review date:** approval date + 45 days. Write "Price review due <date>" in `../CLAUDE.md` (project file) and add it to the memory index. Then follow [`spec.md`](spec.md) "Price review": email Connect IQ developer support before any flip, never cancel the merchant account, proposed rule to confirm: fewer than 5 sales in 45 days and a download bucket of 10 or lower.
3. In `site/src/apps/days-to-go/app.ts` set `storeUrl`; add the live store's device list to `facts.ts` only once it is shown there. Rebuild and redeploy the site.
4. Update the root `README.md` status and `CLAUDE.md` price line.
5. Day 60: run the success test in `spec.md` (the day-45 price review comes first).

## If the review rejects it

The rejection lists reasons. Fix the named item in the listing or build, bump the version if the package changes, re-submit. Do not change the price in the same step.
