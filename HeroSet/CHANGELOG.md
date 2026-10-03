# HeroSet changelog

One entry per Connect IQ Store publication, newest first. The store's
"What's New" text for each version is in [`listing/README.md`](listing/README.md); the why is in
the ADRs named. Dates are upload dates; review status follows.

## Unreleased, drafted as 1.3.0 (fix for a bug in 1.2.0; not uploaded, the version number is the owner's call)

- **Fix:** after saving a short set (for example 4 push-ups), starting the same exercise again began from that count instead of 0. Cause: Finish, quick-Save and Discard cleared the recoverable draft ([ADR-052](docs/decisions.md#adr-052)), then the workout view hid and its hide-time checkpoint wrote the just-saved count back as a new draft; sets longer than 15 s were unaffected because a periodic checkpoint had already recorded the count. The view now remembers that its set ended and never checkpoints after that. Found by the owner on a watch, 2026-10-02. Two regression tests (dev build). 114/114 dev, 101/101 store (unchanged, the new tests are dev-only), fr965 simulator only.
- Launcher icon (shield) and complication icon redrawn on whole-number vertices (pixel-grid pass, TODO I3); no What's New line needed.
- Ready 2026-10-03: What's New and App Version `1.3.0` drafted in `listing/README.md`; fresh `dist/HeroSet-store.iq` exported. Needs only the owner's upload ([`docs/go-to-market.md`](docs/go-to-market.md) G); 1.2.0 on the store still has the bug.

## Unreleased, drafted as 1.3.0 (Instinct family, merged to main 2026-10-03, not uploaded)

- **Instinct 2 family, proposed** (`instinct2`, `instinct2s`, `instinct2x`, Descent G1, Instinct E 40/45 mm, Instinct 3 Solar 45 mm): subscreen-aware layout, black-and-white palette, the XP gauge in the window ([ADR-055](docs/decisions.md#adr-055)). Round products draw exactly as before. Look approved by the owner 2026-10-03, simulator evidence only (no watch available); no What's New text yet, no release-contract or site change.
- Long translations are cut with a `.` (titles, hints, mission labels, centered rows) instead of overlapping; a finished mission row shows DONE where its count was when name + DONE + count overflows. Instinct E and Instinct 3 Solar also get the glance (66 of 87 products).
- Tests: 115 defined (102 in the store build): +1 layout test here, +2 dev-only draft tests from the fix above. 112/112 dev and 101/101 store on fr965 remain the last full measured run (1.2.0 entry below).

## 1.2.0 — uploaded 2026-09-27, approved (owner reported 2026-10-01; the approval date itself is not recorded)

Submitted as `1.2.0`, not `1.1.2` as this build was called during development — App Version is free text on the upload form, not read from the manifest, so nothing in the package changed ([ADR-053](docs/decisions.md#adr-053)). No Connect sync in this release; sync (which would have been 1.3.0) is shelved the same day — Garmin Connect doesn't render the developer fields it needed ([ADR-054](docs/decisions.md#adr-054)).

- **Glance:** a HeroSet entry for the glance list on the 63 watches with Connect IQ
  4.0 or later: today's push-ups, sit-ups and squats as three bars, and the streak
  (a check and `MISSION COMPLETE` once all three goals are met). Read-only; selecting
  it opens HeroSet. Not on fēnix 6, MARQ Gen 1, Descent Mk2, FR945 LTE, Enduro (Gen 1; Enduro 3 has it)
  ([ADR-051](docs/decisions.md#adr-051)).
- **A set no longer vanishes if the watch idles too long after opening HeroSet from
  the glance.** Garmin kills an app launched from the glance list after a period of
  inactivity (confirmed on FR965: exactly 120 s); counting now checkpoints
  periodically, so starting that exercise again picks up where it left off instead
  of restarting at 0 ([ADR-052](docs/decisions.md#adr-052)). Found, fixed and
  confirmed on FR965 the same day, before upload.
- Internal: HeroSet no longer builds its store when the glance loads; the day
  rollover and the HeroFace publish now run when the app's first screen is
  requested ([ADR-051](docs/decisions.md#adr-051)/[044](docs/decisions.md#adr-044)).
- Evidence: simulator and compiler only for the glance itself, confirmed on a real
  FR965 for the glance appearing, a saved set updating it, and HeroFace matching it
  (112/112 dev, 101/101 store tests on fr965, all passing; suite passes on one
  product per glance screen width; all 80 products build). The recoverable-draft
  fix (ADR-052) is confirmed on FR965. **Owner call, 2026-09-27: uploaded without
  E2b (saved-set/midnight/streak through the glance), E4 (simulator visual pass) or
  E5 (crash log, battery comparison)** — see
  [`docs/go-to-market.md`](docs/go-to-market.md) for exactly what did and didn't
  run first.

## 1.1.1 — uploaded 2026-09-24, live 2026-09-24

- **Touchscreen watches:** 13 new products (Venu 2, 2 Plus, 2S, 3, 3S, 4 41/45 mm;
  vívoactive 5, 6; Approach S50, S70 42/47 mm; D2 Air X10), 80 in total. A swipe
  replaces UP/DOWN; START saves ([ADR-048](docs/decisions.md#adr-048)).
- **Taps never commit:** on every watch, a tap on the workout or picker screen
  no longer finishes or saves a set. Only the START button does ([ADR-048](docs/decisions.md#adr-048)).
- **Text fit on 360 px screens** in seven languages (dashboard labels, titles,
  shorter Dutch/French/Portuguese wording) — a bug in 1.1.0 ([ADR-049](docs/decisions.md#adr-049)).
- Back after a set whose only rep was learned as getting up leaves directly
  instead of offering a "0 reps" save ([ADR-050](docs/decisions.md#adr-050)).
- `NO SENSOR` shown when the motion sensor fails to start.
- Reliability: publishing to HeroFace can no longer crash the app; a failed
  storage write stays flagged for the whole save ([ADR-010](docs/decisions.md#adr-010)/[044](docs/decisions.md#adr-044)).
- Evidence: simulator only (99 dev / 88 store tests, all 80 products); device
  checks deferred by owner call ([`docs/go-to-market.md`](docs/go-to-market.md), "Next session" B).

## 1.1.0 — uploaded 2026-09-21, live 2026-09-22

- Daily goal set on the watch, 10–500 ([ADR-045](docs/decisions.md#adr-045)).
- Fix for the save crash (watchdog) in 1.0.0 ([ADR-046](docs/decisions.md#adr-046)/[047](docs/decisions.md#adr-047)).
- Publishes today's progress to HeroFace on Connect IQ 4.2+ ([ADR-044](docs/decisions.md#adr-044)).

## 1.0.0 — live 2026-09-21

- First release: 67 round five-button watches, automatic rep counting that
  learns from saved counts, XP, rank, streaks, 15 languages.
