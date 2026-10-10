# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

Only web surface: HeroFace page in `../site`. Product itself = native Garmin Connect IQ watch face (Monkey C), neither web, iOS nor Android. Watch UI follows [`docs/archive/plan.md`](docs/archive/plan.md) + HeroSet watch conventions, not web conventions.

## Users

Garmin watch wearers (runners, hikers, gym-goers, everyday wearers) wanting one face to read many times daily: time first, then how today is going. Most don't own HeroSet. HeroSet owners = smaller group, also want push-up, sit-up, squat progress on face.

## Product Purpose

Practical daily watch face in HeroSet's visual language: time, date, today's three goals as mission bars, goal streak, battery, heart rate. Useful alone. On watches with CIQ 4.2+ and HeroSet installed, can show live HeroSet reps, rank, streak instead. Success = someone keeps it as default face because it answers "what time is it, and am I on track today?" in one glance.

## Positioning

HeroSet's mission-bar and progress-ring language applied to everyday goals: steps, intensity minutes, floors. Only face that can switch those bars to HeroSet reps (private complication, same developer key).

## Operating Context

- Glanced at arm's length, many times daily, daylight and dark. Sometimes mid-workout.
- AMOLED watches use always-on (sleep) mode with burn-in limits. MIP watches show full face all the time.
- No input on face except, on CIQ 4.2+ watches, hold on missions to open HeroSet.
- Configured via Garmin Connect / Connect IQ app settings (mode, metric in each slot, accent colour, seconds, weather).

## Capabilities and Constraints

- Connect IQ watch face, `minApiLevel` 3.0.0, one build. Newer APIs behind `has` checks. Round screens first; rectangle and Instinct shapes later ([`docs/archive/plan.md`](docs/archive/plan.md) phase 4).
- Smallest watch-face memory budget among 117 shipped round products = 96 KB, so draws only with primitives + system fonts, no bitmaps. (64 KB belongs to rectangle and Instinct products, not in scope yet.)
- No network, no permissions except `ComplicationSubscriber`. Nothing leaves watch.
- Price: paid, $2.50 tier of Garmin's price points for HeroFace Pro (live at $2.00 tier until 1.1.0 upload; [ADR-004](docs/decisions.md#adr-004), price: the $2.50 tier for every paid app); HeroFace (Free) free. No price number in listing or site text. Garmin's 48-hour return window = only trial.
- Languages: English at launch; built so translations need no code change.

## Brand Commitments

- Name: HeroFace. Studio: Verden. Support contact: `hello@verden.watch`.
- Visual language inherited from HeroSet (`../HeroSet/source/ui/HeroSetPalette.mc`, [ADR-031](../HeroSet/docs/decisions.md#adr-031)). Colour roles: gold = what user keeps, blue = today's effort, green = finished goal. Black ground, Garmin 64-colour palette.
- Voice: terse uppercase watch copy, game-coach vocabulary only where mechanic needs a name (streak, rank).

## Evidence on Hand

- None yet: no reviews, users, screenshots or accuracy claims. Don't invent any.

## Product Principles

1. Time first: nothing competes with time for attention.
2. Useful without HeroSet: every slot has working default on every supported watch, no bar ever empty or broken.
3. Honest data: show only what watch measures, hide rather than fake missing value.
4. One glance: state reads from bar length and words, never colour alone.
5. Everything stays on watch.

## Accessibility & Inclusion

- Blue vs gold (not red vs green) carries main distinction. Finished goal also shows check mark and full bar.
- Red used only for attention (low battery, move bar left sitting), always beside word or number, never only signal.
- Text size measured to fit every screen; long translations fall back to shorter wording.
- Contrast chosen for MIP in daylight and AMOLED at night.