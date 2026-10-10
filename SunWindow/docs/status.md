# Sun Window — status and release runbook

> **Open items live only in the root [`ROADMAP.md`](../../ROADMAP.md) (18.x).** This file keeps where things stand, the evidence, the release gates and the upload steps. The task plan: [`../../reports/Sun Window build plan.md`](../../reports/Sun%20Window%20build%20plan.md). Listing text and metadata: [`../listing/paste.md`](../listing/paste.md) and [`../listing/meta.yaml`](../listing/meta.yaml). Claims: [`release-contract.md`](release-contract.md).

**Where things stand, 2026-10-10.** The app is **built and checked in the simulator only; this build has not been on a wrist and nothing is uploaded.** The FR965 spike of 2026-10-05 (a probe, not this build) passed the place, the glance and the timeout checks. The owner approved the plan's recommendations (2026-10-05, ADR-001, ADR-005 to ADR-007, ADR-013), the look (mockup rev 2, ADR-011) and, on 2026-10-10, the `widget` manifest type (ADR-008).

Simulator evidence (2026-10-10, container, simulator only): 33 unit tests pass on every one of the 65 products (30 on the three 1-bit Instincts), see [`compatibility.md`](compatibility.md); compile sweep 65 pass, 0 fail; `tools/glance-scope-check.sh` clean; screenshots of every state in [`archive/screens/`](archive/screens/); a fresh-context design review and a code review ran and their findings are fixed or recorded (below).

Next (owner): look-check the built screens and the icon (ROADMAP 18.1), the wear day ([`wear-day-checklist.md`](wear-day-checklist.md), ROADMAP 18.4), the trademark check (18.3), then merge, deploy the site and upload (18.5).

**Reviews, 2026-10-10.** Design review (`watch-design-reviewer`, simulator shots): disposition fix, all findings applied except the owner-level note that the system draws the placeholder launcher icon next to the white glance mark (OD-10, ROADMAP 18.1). Code review (`reviewer`): 21 findings. Fixed: the window on the wrong local day at UTC+13/+14 west of the date line (Apia, Kiritimati), a location request cancelled by an overlay, a place near longitude 180 that could not be stored, the sun dot drawn off the time axis, `ask()` without a guard, the 1-pixel sill on the Instinct, centring of the empty states, the glance on the Instinct E 45 mm (the sub-window covers the word row: the mark is dropped there), the stale docs. Recorded, not changed: the reason line says "Cloud cover" for a UV reading under 3 (the owner approved the wording, ADR-013; it is a plain-words gloss for a low UV index); the offset is read "now", so on a daylight-saving change day the clock edge is an hour off until the switch (night only).

## Never decide alone

The store name (decided: ADR-001, pending a trademark check); the visual identity, the mockup and built-screen looks, the launcher icon and store images; the `Positioning` permission (accepted: ADR-013); any upload to the Connect IQ store; any phone or watch test; a site deploy; any commit or merge; shipping machine translations no native speaker has read (v1 is English only, ADR-013); any claim [`release-contract.md`](release-contract.md) forbids. A general "proceed" does not cover this list.

## Device checks

Simulator is not device proof. Each row is filled with a date and "FR965 only" when it runs; MIP and Instinct stay "simulator only" (ADR-013).

| # | Check | Pass condition | Where it stands |
|---|---|---|---|
| D2 | `uvIndex` and `cloudCover` from current conditions on the FR965 | Non-null, plausible, change with the sky | **Partly seen 2026-10-05 (FR965 only, night):** current and first hourly entry both non-null (UV 0.0, cloud 87), 12 hourly entries, in the full view and in the glance. Daytime and a change with the sky still open |
| D6 | `Position.getInfo()` and `LOCATION_ONE_SHOT` from the full view, cold and glance-launched | A fix, or a clean fallback; no crash | **PASS 2026-10-05 (FR965 only, indoors, probe):** from the app list and from the glance, `getInfo()` gave a last-known position (accuracy 1) at once; no one-shot request was needed. The ADR-007 condition (a place on the watch) is met; the owner's go is plan P1.5 |
| D7 | Glance renders from a sideload; no stale state across midnight; clipped bezel | Correct state, nothing clipped | **Glance renders PASS 2026-10-05 (FR965 only, probe):** listed from a sideload, redraws, reads Storage and Weather in the glance with no crash. The focused card is a light slate-blue (not black), which confirms the white glance mark (ADR-011). Midnight still open |
| D9 | Window edges for the owner's place against the fixtures script | Within 1 minute | **Open** (wear day) |
| D11 | Gesture that opens the accent menu on the FR965 | Menu opens | **Open** (wear day) |
| D12 | Idle timeout when launched from the glance | Measured | **Measured 2026-10-05 (FR965 only, probe):** about **120 s** untouched, then the watch closes the app. Enough for the full view (two one-minute redraws); a one-shot fix slower than that is cut off, but on the FR965 `getInfo()` answered at once. Launcher-launched timeout still open |

## Ready to submit when ALL of these are true

| # | Gate | Passed looks like | Where it stands |
|---|---|---|---|
| 1 | Name cleared | Store search and a trademark search found no conflict with "Sun Window" (ADR-001) | **Partly open.** Store search clean (2026-10-04); trademark and domain check not run |
| 2 | Device checks | D2, D6, D7, D9, D11 and D12 above recorded | **Open** |
| 3 | Platform claims verified | The open and close times match the fixtures script for the owner's place, on the FR965 (D9) | **Open** |
| 4 | Look approved | Mockup approved (ADR-011), then the built screens in the simulator on a round, a rectangle (venux1) and an Instinct | **Mockup approved 2026-10-05.** Built screens shot on fr965, venu3, epix2pro47mm, fr255s, venux1 and both Instinct E sizes ([`archive/screens/`](archive/screens/)); the owner's look-check is open (ROADMAP 18.1) |
| 5 | UX checklist passed | Buttons-only navigation works; every empty state has a sentence (open once, finding location, no fix, no weather); the accent persists on the watch. The phone settings round trip is checked after approval (ADR-013) | **Partly, simulator only:** every empty state has a sentence and was shot ("Open once", "Finding your place", "No place yet / Press START"); START opens the app from the glance. The menu gesture (D11) and the accent persisting need the wrist |
| 6 | Always-on / burn-in | Not applicable: an app has no always-on mode | n/a |
| 7 | Wear day | One full day on the build that will be exported, this app only; the worn commit hash recorded in `device-test/README.md`; DST checked on the watch if the window spans 2026-10-25, otherwise simulator only | **Open** |
| 8 | Full device/fit sweep | `tools/fit_products.sh` all pass on the submitted commit | **65 of 65 pass, simulator only, 2026-10-10** ([`compatibility.md`](compatibility.md)); re-run on the commit that is uploaded |
| 9 | Export checked | Package permissions are `Positioning` only; no `Background`, `Notifications` or `Communications` in the manifest or source; device count matches the manifest | **Open** |
| 10 | Language decision | English only (ADR-013) | **Decided 2026-10-05** |
| 11 | Real assets | Launcher icon, cover, hero, device icons, store screens approved by the owner | **Open** |
| 12 | Listing written and checked | `listing/paste.md` in form order, every sentence checked against `release-contract.md`; no "vitamin D", no "no location" | **Drafted 2026-10-05**, final at upload (plan P9.4); images are drafts for the owner's look (ROADMAP 18.1) |
| 13 | Site live | `/sun-window/`, `/sun-window/support/`, `/sun-window/privacy/` open without login | **Open** |
| 14 | Price | Free, no price, no upgrade text (ADR-003) | **Decided** |
| 15 | Baseline recorded | Optional: other studio apps' download and review numbers on upload day | Optional |
| 16 | Tests green | All tests pass, zero build warnings (except the launcher-icon notice), `tools/glance-scope-check.sh` silent, on the submitted commit | **Green on the PR's code, simulator only, 2026-10-10:** 65 of 65 products pass, compile sweep 65 pass 0 fail, glance scope clean (fr965, instincte40mm); re-run on the uploaded commit |
| 17 | Design reviewed | `watch-design-reviewer` returned `disposition: ship`, or every `fix` resolved | **Ran 2026-10-10 (disposition fix); every material fix applied**; the one owner-level note (the placeholder launcher icon next to the white mark) is OD-10 |
| 18 | No "no location" | No store, site or watch text says "no location" while `Positioning` is declared | **Clean in the app, `listing/` and the site pages drafted so far** (`rg -i 'no location'`); re-check at upload |

## Store form answers (ADR-013)

- **Name:** Sun Window (ADR-001). **Category:** Utility (the owner confirms on the form).
- **Price / Monetization:** free; "No".
- **Collect user data:** No. Location is used to compute the sun's height, rounded to 0.1 degree, and stays on the watch. The watch's own weather is read on the watch. No network.
- **Languages:** English only.
- **Support and privacy URLs:** `https://verden.watch/sun-window/support/` and `/sun-window/privacy/`, once deployed. **Never change or remove a published URL.**

## Submit (owner, one sitting)

1. Merge the worktree branch to `main` and deploy the site; check the three pages open (plan P10.0, P10.4).
2. `cd SunWindow && monkeyc -e -r -f monkey.jungle -o dist/SunWindow-1.0.0.iq -y ~/.garmin-connectiq/keys/developer_key`, from the worn commit (gate 7). Any `source/` change since then needs a new wear day or the owner's waiver.
3. Open https://apps.garmin.com/developer/upload, upload as a **new** app, paste each field from `listing/paste.md` in form order, attach the images, and read the form's Compatible Devices list.
4. Same day: `CHANGELOG.md` 1.0.0 entry, `listing/meta.yaml` app id and status, this file's "Where things stand".
5. Never commit `dist/*.iq`, `bin/*.prg` or any key file.

## After approval

1. Open the live listing: title, description, images, the device tab, the support and privacy links. Record dates and the real device list here, in `CHANGELOG.md`, `compatibility.md` and `meta.yaml`.
2. Set `storeUrl` in `site/src/apps/sun-window/app.ts`; the owner deploys.
3. Add the store id to `tools/store_poll_ids.txt`.
4. Check the Garmin Connect accent round trip on the store install (ADR-013).
5. Day 30 and day 60: run the success test in [`spec.md`](spec.md); record reviews that mention a wrong state or a lost location under "Post-release" below.

## If the review rejects it

Fix the named item, bump the version if the package changed, re-submit.

## Post-release

Nothing yet.
