# Sun Window — status and release runbook

> **Open items live only in the root [`ROADMAP.md`](../../ROADMAP.md) (16.x).** This file keeps where things stand, the evidence, the release gates and the upload steps. The task plan: [`../../reports/Sun Window build plan.md`](../../reports/Sun%20Window%20build%20plan.md). Listing text and metadata: [`../listing/paste.md`](../listing/paste.md) and [`../listing/meta.yaml`](../listing/meta.yaml). Claims: [`release-contract.md`](release-contract.md).

**Where things stand, 2026-10-05.** Spec and decisions are written; the owner approved the plan's recommendations on 2026-10-05 (ADR-001, ADR-005 to ADR-007, ADR-013). **No code exists, and nothing about Sun Window has run on a watch or in the simulator.** Next: plan phase P1 (the FR965 device spike) and P2 (mockup and look approval), in parallel. Product code (P3) starts only after the spike yields a place on the watch (ADR-007) and the owner approves the look (ADR-011).

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
| D12 | Idle timeout when launched from the glance | Measured | **Open** (spike) |

## Ready to submit when ALL of these are true

| # | Gate | Passed looks like | Where it stands |
|---|---|---|---|
| 1 | Name cleared | Store search and a trademark search found no conflict with "Sun Window" (ADR-001) | **Partly open.** Store search clean (2026-10-04); trademark and domain check not run |
| 2 | Device checks | D2, D6, D7, D9, D11 and D12 above recorded | **Open** |
| 3 | Platform claims verified | The open and close times match the fixtures script for the owner's place, on the FR965 (D9) | **Open** |
| 4 | Look approved | Mockup approved (ADR-011), then the built screens in the simulator on a round, a rectangle (venux1) and an Instinct | **Open** |
| 5 | UX checklist passed | Buttons-only navigation works; every empty state has a sentence (open once, finding location, no fix, no weather); the accent persists on the watch. The phone settings round trip is checked after approval (ADR-013) | **Open** |
| 6 | Always-on / burn-in | Not applicable: an app has no always-on mode | n/a |
| 7 | Wear day | One full day on the build that will be exported, this app only; the worn commit hash recorded in `device-test/README.md`; DST checked on the watch if the window spans 2026-10-25, otherwise simulator only | **Open** |
| 8 | Full device/fit sweep | `tools/fit_products.sh` all pass on the submitted commit | **Open** |
| 9 | Export checked | Package permissions are `Positioning` only; no `Background`, `Notifications` or `Communications` in the manifest or source; device count matches the manifest | **Open** |
| 10 | Language decision | English only (ADR-013) | **Decided 2026-10-05** |
| 11 | Real assets | Launcher icon, cover, hero, device icons, store screens approved by the owner | **Open** |
| 12 | Listing written and checked | `listing/paste.md` in form order, every sentence checked against `release-contract.md`; no "vitamin D", no "no location" | **Open** (skeleton only) |
| 13 | Site live | `/sun-window/`, `/sun-window/support/`, `/sun-window/privacy/` open without login | **Open** |
| 14 | Price | Free, no price, no upgrade text (ADR-003) | **Decided** |
| 15 | Baseline recorded | Optional: other studio apps' download and review numbers on upload day | Optional |
| 16 | Tests green | All tests pass, zero build warnings (except the launcher-icon notice), `tools/glance-scope-check.sh` silent, on the submitted commit | **Open** |
| 17 | Design reviewed | `watch-design-reviewer` returned `disposition: ship`, or every `fix` resolved | **Open** |
| 18 | No "no location" | No store, site or watch text says "no location" while `Positioning` is declared | **Open** |

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
