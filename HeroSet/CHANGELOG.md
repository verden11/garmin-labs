# HeroSet changelog

One entry per Connect IQ Store publication, newest first. The store's
"What's New" text for each version is in `listing/README.md`; the why is in
the ADRs named. Dates are upload dates; review status follows.

## 1.1.1 — uploaded 2026-09-24 (in review)

- **Touchscreen watches:** 13 new products (Venu 2, 2 Plus, 2S, 3, 3S, 4 41/45 mm;
  vívoactive 5, 6; Approach S50, S70 42/47 mm; D2 Air X10), 80 in total. A swipe
  replaces UP/DOWN; START saves (ADR-048).
- **Taps never commit:** on every watch, a tap on the workout or picker screen
  no longer finishes or saves a set. Only the START button does (ADR-048).
- **Text fit on 360 px screens** in seven languages (dashboard labels, titles,
  shorter Dutch/French/Portuguese wording) — a bug in 1.1.0 (ADR-049).
- Back after a set whose only rep was learned as getting up leaves directly
  instead of offering a "0 reps" save (ADR-050).
- `NO SENSOR` shown when the motion sensor fails to start.
- Reliability: publishing to HeroFace can no longer crash the app; a failed
  storage write stays flagged for the whole save (ADR-010/044).
- Evidence: simulator only (99 dev / 88 store tests, all 80 products); device
  checks deferred by owner call (`docs/go-to-market.md` 5b).

## 1.1.0 — uploaded 2026-09-21, live 2026-09-22

- Daily goal set on the watch, 10–500 (ADR-045).
- Fix for the save crash (watchdog) in 1.0.0 (ADR-046/047).
- Publishes today's progress to HeroFace on Connect IQ 4.2+ (ADR-044).

## 1.0.0 — live 2026-09-21

- First release: 67 round five-button watches, automatic rep counting that
  learns from saved counts, XP, rank, streaks, 15 languages.
