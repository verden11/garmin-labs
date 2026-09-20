# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

Two surfaces share this record: the website (sibling directory `../verden-site`: studio home plus HeroSet landing, support and privacy pages, the `web` platform above) and the watch app itself, a native Garmin Connect IQ app (Monkey C) that is neither web, iOS nor Android. Watch UI follows the constraints below and the ADRs in `docs/decisions.md`, not web conventions.

## Users

Garmin watch athletes of any main sport (runners, cyclists, hikers, gym-goers) who want short daily bodyweight strength work alongside it: 100 push-ups, 100 sit-ups and 100 squats a day by default — any goal from 10 to 500 — counted and tracked on the wrist without reaching for a phone. They own one of the 67 supported round five-button Garmin watches (`docs/compatibility.md`) and use it mid-workout, often sweaty, on the floor, glancing between reps.

## Product Purpose

HeroSet turns a daily bodyweight challenge into a repeatable ritual on the watch: start a set with one button, let the watch count reps, correct the count before saving, and watch progress build through daily goals, XP, ranks and streaks. Success is a user who comes back every day because logging a set is faster than skipping it, and trusts the numbers because they can always fix them.

## Positioning

A button-first daily challenge that lives entirely on the watch: automatic rep counting (beta) that learns from the counts the user saves (ADR-040), with every set correctable before it is stored, plus game progression (XP, ranks, streaks) and live heart-rate/calorie readouts. Nothing leaves the watch: no account, no sync, no activity recording in v1.

## Operating Context

- Workout loop: dashboard → START → pick exercise → counting starts instantly → START to finish → adjust count with UP/DOWN → START to save → dashboard with save feedback and vibration.
- Used mid-exercise: glanceable at arm's length, readable in daylight (AMOLED and MIP screens), operated by feel through bezel buttons; per-rep vibration confirms counts without looking.
- Daily reset at local midnight; streak and rank persist.
- Distribution: Garmin Connect IQ Store, paid (USD 2.00 → $1.99 US), no trial; Garmin's 48-hour return window is the only try-before-keep. Support site hosts the privacy policy and support page linked from the store listing.

## Capabilities and Constraints

- Exercises: push-ups, sit-ups, squats; daily goal 100 each by default, user-set on the watch from 10 to 500 in steps of 10 (ADR-045). XP still stops at 100 reps per exercise per day, so rank reflects reps done, not goals hit.
- Automatic counting is beta and can miscount; accuracy numbers may not be claimed until launch gate 2 passes (`docs/release-contract.md`).
- Manual correction and manual logging on every path; XP only for net stored progress (ADR-002); rank derived, never stored.
- Live HR and calorie estimate during a set; calories are the change in Garmin's daily total, an estimate, not a medical or native session measurement.
- Store build: `Sensor` permission only, no network, no Garmin Connect/Strava sync, no FIT activity (ADR-033). Opt-in Connect sync (one activity per workout, ADR-043) exists in the dev build only, unverified; planned for v1.1.
- Watch UI: round screens only, AMOLED and MIP, 67 products from ~208 to 466 px; min Connect IQ API 3.4.0; one class per file; text fit measured, never guessed (ADR-018); render only in `onUpdate`.
- Input: five physical buttons; no long-press gestures (ADR-029); on-screen hints name bezel buttons (`START`, `UP/DOWN`, `BACK`). Touch works where the watch passes it through but is never required.
- Languages: English (fallback), German, French, Spanish, Italian, Portuguese, Dutch, Polish, Swedish, Danish, Norwegian Bokmål, Finnish, Turkish, Lithuanian, Ukrainian. Russian intentionally unsupported.
- Site: `../verden-site`, a multi-app static site (prerendered, no client JS) shared with future Verden apps; live at https://verden.watch (Netlify); must match actual app behavior.

## Brand Commitments

- Name: HeroSet. Store title: "HeroSet — Bodyweight Rep Counter" ("Bodyweight Counter" reads like a body-weight scale app).
- Voice: game coach. Short, upbeat, game vocabulary where the mechanic needs a name (missions, ranks, XP, streaks); never cheesy, never medical, never overpromising. Watch copy is terse uppercase.
- Support contact: `hello@verden.watch`.
- Launcher icon: `resources/drawables/launcher_icon.svg`.
- Claims are bounded by `docs/release-contract.md` (allowed and forbidden claims); check it before any user-facing copy.

## Evidence on Hand

- On-watch trial data from one FR965 owner (`docs/validation-log.md`), not yet enough to claim accuracy.
- Site: `../verden-site/src/apps/heroset/` (landing, support, privacy).
- Listing screenshots: simulator captures of the store build in `listing/` (ADR-039). No mockups.
- None exist and must not be invented: user reviews, testimonials, ratings, user counts, press, accuracy percentages, partnerships or Garmin endorsement.

## Product Principles

1. Honest by default: say only what the build does today; beta stays beta until the gate says otherwise.
2. The next set is one press away: speed from wrist to counting beats features.
3. The user's count is the truth: every set is correctable before saving, and the watch learns from what the user saves.
4. Everything stays on the watch: no account, no network, nothing shared.
5. Works by feel: every action reachable with buttons alone, glanceable mid-exercise, confirmed by vibration.

## Accessibility & Inclusion

- Fully usable without touch; no long-press; hints name physical buttons.
- State never relies on color alone (e.g. finished rows read `PUSH-UPS DONE`).
- Text must fit and stay legible on every supported screen size and in all 15 languages; MIP screens need daylight contrast (unverified on a wrist).
- Vibration feedback for reps, goal crossings and mission completion, so progress is perceivable without looking.
