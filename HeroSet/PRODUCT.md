# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

2 surfaces share this record: website (sibling dir `../site`: studio home + HeroSet landing, support, privacy pages, `web` platform above) and watch app itself, native Garmin Connect IQ app (Monkey C), neither web, iOS nor Android. Watch UI follows constraints below + ADRs in [`docs/decisions.md`](docs/decisions.md), not web conventions.

## Users

Garmin watch athletes, any main sport (runners, cyclists, hikers, gym-goers) wanting short daily bodyweight strength work alongside: 100 push-ups, 100 sit-ups, 100 squats/day default — any goal 10 to 500 — counted, tracked on wrist, no phone. Own one of 67 supported round five-button Garmin watches ([`docs/compatibility.md`](docs/compatibility.md)); use mid-workout, often sweaty, on floor, glancing between reps.

## Product Purpose

HeroSet turns daily bodyweight challenge into repeatable watch ritual: start set with one button, watch counts reps, correct count before saving, progress builds via daily goals, XP, ranks, streaks. Success = user returns daily because logging set faster than skipping, trusts numbers because can always fix them.

## Positioning

Button-first daily challenge living entirely on watch: automatic rep counting (beta) learning from counts user saves ([ADR-040](docs/decisions.md#adr-040)), every set correctable before stored, plus game progression (XP, ranks, streaks) and live heart-rate/calorie readouts. Nothing leaves watch: no account, no sync, no activity recording in v1.

## Operating Context

- Workout loop: dashboard → START → pick exercise → counting starts instantly → START to finish → adjust count with UP/DOWN → START to save → dashboard with save feedback + vibration.
- Used mid-exercise: glanceable at arm's length, readable in daylight (AMOLED and MIP screens), operated by feel via bezel buttons; per-rep vibration confirms counts without looking.
- Daily reset at local midnight; streak, rank persist.
- Distribution: Garmin Connect IQ Store, paid, $2.50 tier of Garmin's price points (set in upload form; live at $2.00 tier until 1.3.1 upload, [ADR-056](docs/decisions.md#adr-056), no price number in listing or site text), no trial; Garmin's 48-hour return window only try-before-keep. Support site hosts privacy policy + support page linked from store listing.

## Capabilities and Constraints

- Exercises: push-ups, sit-ups, squats; daily goal 100 each default, user-set on watch 10 to 500, steps of 10 ([ADR-045](docs/decisions.md#adr-045)). XP still stops at 100 reps per exercise per day, so rank reflects reps done, not goals hit.
- Automatic counting beta, can miscount; accuracy numbers not claimable until launch gate 2 passes ([`docs/release-contract.md`](docs/release-contract.md)).
- Manual correction + manual logging on every path; XP only for net stored progress ([ADR-002](docs/decisions.md#adr-002)); rank derived, never stored.
- Reliability: set survives glance-launch idle kill (confirmed on FR965, exactly 120s) by resuming from periodic checkpoint, not restarting at 0 ([ADR-052](docs/decisions.md#adr-052)).
- Glance (1.2.0, [ADR-051](docs/decisions.md#adr-051)): read-only glance-list entry with today's three bars + streak, on 63 products with Connect IQ 4.0+; never writes, needs no permission.
- Live HR + calorie estimate during set; calories = change in Garmin's daily total, estimate, not medical or native session measurement.
- Store build: `Sensor` + `ComplicationPublisher` permissions only, no network, no Garmin Connect/Strava sync, no FIT activity ([ADR-033](docs/decisions.md#adr-033)). Opt-in Connect sync (one activity per workout, [ADR-043](docs/decisions.md#adr-043)) exists in dev build only, unverified; planned for v1.1.
- Watch UI: round AMOLED + MIP screens (82 products ~208 to 466 px, 2 Instinct 3 AMOLED unreleased) plus 1-bit Instinct family (7 products, ADR-055 (Instinct family)) and 3 touch-first rectangles (Venu Sq 2/Sq 2 Music/X1, ADR-057 (rectangular watches)); min Connect IQ API 3.4.0; one class per file; text fit measured, never guessed ([ADR-018](docs/decisions.md#adr-018)); render only in `onUpdate`.
- Input: five physical buttons; no long-press gestures ([ADR-029](docs/decisions.md#adr-029)); on-screen hints name bezel buttons (`START`, `UP/DOWN`, `BACK`). Touch works where watch passes it through, never required.
- Languages: English (fallback), German, French, Spanish, Italian, Portuguese, Dutch, Polish, Swedish, Danish, Norwegian Bokmål, Finnish, Turkish, Lithuanian, Ukrainian. Russian intentionally unsupported.
- Site: `../site`, multi-app static site (prerendered, no client JS) shared with future Verden apps; live at https://verden.watch (Firebase Hosting); must match actual app behavior.

## Brand Commitments

- Name: HeroSet. Store title: "HeroSet — Bodyweight Rep Counter" ("Bodyweight Counter" reads like body-weight scale app).
- Voice: game coach. Short, upbeat, game vocabulary where mechanic needs name (missions, ranks, XP, streaks); never cheesy, never medical, never overpromising. Watch copy terse uppercase.
- Support contact: `hello@verden.watch`.
- Launcher icon: `resources/drawables/launcher_icon.svg`.
- Claims bounded by [`docs/release-contract.md`](docs/release-contract.md) (allowed + forbidden claims); check before any user-facing copy.

## Evidence on Hand

- On-watch trial data from 1 FR965 owner ([`docs/validation-log.md`](docs/validation-log.md)), not yet enough to claim accuracy.
- Site: `../site/src/apps/heroset/` (landing, support, privacy).
- Listing screenshots: simulator captures of store build in `listing/` ([ADR-039](docs/decisions.md#adr-039)). No mockups.
- None exist, must not be invented: user reviews, testimonials, ratings, user counts, press, accuracy percentages, partnerships, Garmin endorsement.

## Product Principles

1. Honest by default: say only what build does today; beta stays beta until gate says otherwise.
2. Next set 1 press away: speed wrist to counting beats features.
3. User's count is truth: every set correctable before saving, watch learns from what user saves.
4. Everything stays on watch: no account, no network, nothing shared.
5. Works by feel: every action reachable with buttons alone, glanceable mid-exercise, confirmed by vibration.

## Accessibility & Inclusion

- Fully usable without touch; no long-press; hints name physical buttons.
- State never relies on color alone (e.g. finished rows read `PUSH-UPS DONE`).
- Text must fit, stay legible on every supported screen size + all 15 languages; MIP screens need daylight contrast (unverified on a wrist).
- Vibration feedback for reps, goal crossings, mission completion, so progress perceivable without looking.