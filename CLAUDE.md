# HeroFace — CLAUDE.md

Garmin watch face (Connect IQ, Monkey C) from studio Verden. Time-first, in
HeroSet's visual language: bezel ring, three mission bars, gold streak.
117 round products, `minApiLevel` 3.0.0. Paid, USD 2.00, 15 languages.

**Read first:** `docs/plan.md` (what is built, what is next, and why),
`PRODUCT.md` (product truth), `DESIGN.md` (the visual system),
`docs/compatibility.md` (products and the evidence per screen size).

## Fast facts

- Works **without HeroSet**: bars are steps, intensity minutes and floors, each
  with a fallback chain so no watch draws an empty bar; the ring is the day as
  a whole; the gold line is the step-goal streak. With HeroSet installed on a
  CIQ 4.2+ watch, the bars become push-ups/sit-ups/squats and the ring the XP
  into the current rank.
- The HeroSet link is one **private complication** (HeroSet ADR-044,
  `HeroSetComplicationPublisher`). Value:
  `v|dayKey|push|sit|squat|rank|rankPct|streak|lastDoneDay|goal`. Field order
  is a cross-repo contract: changing it in one repo breaks the other. New
  fields append and stay optional on this side (`goal` did); only a breaking
  change bumps the version, which makes the face drop the value entirely. Both apps must
  be signed with the same key (`~/.garmin-connectiq/keys/developer_key`).
- One build for every product; newer APIs sit behind `has` checks
  (`Toybox has :Complications`, `:Weather`, `ActivityMonitor has
  :getHeartRateHistory`). No bitmaps, no per-device resources.
- Build: `monkeyc -d fr965 -f monkey.jungle -o bin/HeroFace.prg -y ~/.garmin-connectiq/keys/developer_key`
- Tests (14): `monkeyc -t -d fr965 …`, then `monkeydo bin/t-fr965.prg fr965 -t`.
  Trust the printed `PASSED (…)` line, not the exit code. A hung run means the
  simulator needs restarting.
- Screen check per size: `monkeydo bin/t-<device>.prg <device> -t everyStateFitsThisDisplay`.
  `heroFaceLayoutReport` prints every row's box, which is how layout is read
  without a screenshot.
- Nothing has run on a real watch yet. Simulator evidence is not device
  evidence; say so when reporting.

## House rules

Same as HeroSet (`../HeroSet/CLAUDE.md` house rules), which this repo mirrors:

- Every function: typed params and `as` return type. No `as Any`. Cast only
  after an `instanceof` or null guard.
- No magic numbers: tunables and keys in `HeroFaceConfig`, geometry in
  `HeroFaceLayout`, colours in `HeroFacePalette`, text in `strings.xml`.
- Text fit is measured, never guessed: draw through `HeroFaceDraw.text`, pick
  wording with `firstFitting`/`firstWithin`.
- Render only in `onUpdate`/`onPartialUpdate`; gather data in
  `HeroFaceReadings`, draw from a `HeroFaceState`. That split is what lets the
  screen-fit test render the widest states.
- One class per file, `HeroFace` prefix. Functions ≲30 lines, files ≲250.
- A value the watch does not have is hidden, never faked or zero-filled.
- Comments explain *why*.
- Storage key spellings never change once shipped.

## Keeping things in sync

- Behaviour change → update `docs/plan.md` (and `DESIGN.md` if it is visual).
- Contract change → both repos and HeroSet's ADR-044, same session.
- New product or layout change → run the screen-fit test for that screen size
  and update `docs/compatibility.md`.
- Test count appears in `README.md` and here; update both.
