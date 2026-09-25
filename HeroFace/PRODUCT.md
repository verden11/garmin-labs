# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

The only web surface is the HeroFace page in `../verden-site`. The product itself is a native Garmin Connect IQ watch face (Monkey C), which is neither web, iOS nor Android. Watch UI follows [`docs/plan.md`](docs/plan.md) and HeroSet's watch conventions, not web conventions.

## Users

Garmin watch wearers (runners, hikers, gym-goers, everyday wearers) who want one face to read many times a day: the time first, then how today is going. Most don't own HeroSet. HeroSet owners are a smaller group who also want their push-up, sit-up and squat progress on the face.

## Product Purpose

A practical daily watch face in HeroSet's visual language: time, date, today's three goals as mission bars, a goal streak, battery and heart rate. It's useful on its own. On watches with CIQ 4.2+ and HeroSet installed, it can show live HeroSet reps, rank and streak instead. Success means someone keeps it as their default face because it answers "what time is it, and am I on track today?" in one glance.

## Positioning

The mission-bar and progress-ring language from HeroSet, applied to everyday goals: steps, intensity minutes, floors. It's the only face that can switch those bars to HeroSet reps (a private complication, same developer key).

## Operating Context

- Glanced at arm's length, many times a day, in daylight and in the dark. Sometimes mid-workout.
- AMOLED watches use always-on (sleep) mode with burn-in limits. MIP watches show the full face all the time.
- No input on the face except, on CIQ 4.2+ watches, a hold on the missions to open HeroSet.
- Configured through Garmin Connect / Connect IQ app settings (mode, the metric in each slot, accent colour, seconds, weather).

## Capabilities and Constraints

- Connect IQ watch face, `minApiLevel` 3.0.0, one build. Newer APIs sit behind `has` checks. Round screens first; rectangle and Instinct shapes come later ([`docs/plan.md`](docs/plan.md) phase 4).
- The smallest watch-face memory budget among the 117 shipped round products is 96 KB, so it draws only with primitives and system fonts and uses no bitmaps. (64 KB belongs to the rectangle and Instinct products, which are not in scope yet.)
- No network, no permissions except `ComplicationSubscriber`. Nothing leaves the watch.
- Price: paid, lowest tier USD 2.00 ($1.99 US), same as HeroSet. Garmin's 48-hour return window is the only trial.
- Languages: English at launch; built so translations need no code change.

## Brand Commitments

- Name: HeroFace. Studio: Verden. Support contact: `hello@verden.watch`.
- Visual language is inherited from HeroSet (`../HeroSet/source/ui/HeroSetPalette.mc`, [ADR-031](../HeroSet/docs/decisions.md#adr-031)). The colour roles are: gold for what the user keeps, blue for today's effort, green for a finished goal. Black ground, Garmin 64-colour palette.
- Voice: terse uppercase watch copy, game-coach vocabulary only where the mechanic needs a name (streak, rank).

## Evidence on Hand

- None yet: no reviews, users, screenshots or accuracy claims. Don't invent any.

## Product Principles

1. Time first: nothing competes with the time for attention.
2. Useful without HeroSet: every slot has a working default on every supported watch, and no bar is ever empty or broken.
3. Honest data: show only what the watch measures, and hide rather than fake a missing value.
4. One glance: state reads from bar length and words, never colour alone.
5. Everything stays on the watch.

## Accessibility & Inclusion

- Blue vs gold (not red vs green) carries the main distinction. A finished goal also shows a check mark and a full bar.
- Red is used only for attention (low battery, a move bar left sitting), always beside a word or a number, never as the only signal.
- Text size is measured to fit every screen, and long translations fall back to shorter wording.
- Contrast is chosen for MIP in daylight and AMOLED at night.
