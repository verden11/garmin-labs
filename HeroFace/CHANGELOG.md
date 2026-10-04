# HeroFace changelog

One entry per Connect IQ Store publication, newest first. The store's
"What's New" text for each version is in [`listing/paste.md`](listing/paste.md).

## Unreleased

Everything below is **UNRELEASED**: built 2026-10-01 against the Free + Pro plan, **proposed** (`docs/decisions.md` ADR-001, the Free + Pro ladder; the owner has not signed off), nothing uploaded. Simulator only: 24 tests PASSED on each jungle on fr965, fenix5s and fr55 (2026-10-01, main thread); nothing on a wrist. The headings are the versions the owner would upload; dates and uploads are theirs.

### HeroFace (Free) 1.0.0 — UNRELEASED, a new app (new app id), not uploaded

- First release of the Free twin: the same 117 round watches, 15 languages and permission as the paid app. The time, the progress ring, three mission bars (steps, intensity minutes and floors, each falling back to what the watch has), the date, the step-goal streak, battery, heart rate, notifications, always-on, and HeroSet mode on Connect IQ 4.2+ watches with HeroSet installed.
- Settings: Missions (HeroSet when installed, or everyday goals) and Accent colour (Blue, Cyan, Magenta).
- Not in Free (Pro only): choosing the metric of each bar, seconds, and the temperature.
- **Instinct family, added 2026-10-03 (124 products instead of 117; ADR-002, proposed, simulator only):** `instinct2`, `instinct2s`, `instinct2x`, `descentg1`, `instincte40mm`, `instincte45mm`, `instinct3solar45mm`. Black and white; the ring becomes a gauge in the round window; no footer, temperature, seconds or Accent setting on these watches. The visible area on an Instinct is a circle about 98 px in radius, which the layout and the fit test now model. On the Instinct 2 family (CIQ 3.4, no Complications) the face stays in Everyday mode. Evidence: `docs/compatibility.md` "Instinct family".
- Launcher icon redrawn on the pixel grid (whole-number vertices; same look, crisper edges; no What's New line needed).
- App id `be68898f-995b-45d9-860e-42ad508bd7fd` (generated 2026-10-01). Store name and title are the owner's decision (placeholder "HeroFace").
- ADRs: 001 (Free + Pro ladder, proposed), 002 (Instinct family, proposed).
- Evidence: compiled for both jungles with `-w --typecheck 3` and swept across every manifest product (`tools/compile_sweep.sh`); the Free package's contents checked (`tools/check_free_package.sh`: Mode and Accent only, no "Pro" anywhere). Simulator, 2026-10-01: the 24 Free tests PASSED on fr965, fenix5s and fr55, including `freeMissingPropertyKeyThrows` (the simulator throws `InvalidKeyException` for a key missing from the properties file) and the Magenta known-issue test. **Not yet run:** the ten-size screen-fit loop on either jungle and the simulator memory view on fenix5s and vivoactive3. Nothing has run on a wrist, and a Free app id receiving HeroSet's private complication is untested on a watch.

### HeroFace Pro 1.1.0 — UNRELEASED, an update of the existing paid app id, not uploaded

- The paid app is renamed on the watch to "HeroFace Pro" (placeholder name; the owner decides it and the price). Behaviour, settings, ids and defaults are the same as 1.0.1: `resources-pro/settings` is the old shared settings file unchanged.
- **Instinct family, added 2026-10-03** (124 products; ADR-002, proposed, simulator only), as in the Free entry above; Pro on an Instinct has no seconds, no temperature and no footer, and no Accent setting.
- No new feature. The plan's other Pro additions (more accent colours, an alternate layout) are **not built**; Magenta's contrast against the bar track (2.84:1 against the face's own 3:1 rule) is an open design decision.
- Launcher icon redrawn on the pixel grid (whole-number vertices; same look, crisper edges; no What's New line needed).
- Build change: Pro is now `monkey.jungle` with `resources;resources-pro` and `(:free)` code excluded. The strict compile (`-w --typecheck 3`) is now clean: type-only fixes in `HeroFaceLink`, `HeroFaceSettings`, `HeroFaceStreak` (no behaviour change).
- ADRs: 001 (Free + Pro ladder, proposed). Plan decision 8 (the price) still governs until the owner signs off.
- Evidence: as above. 24 Pro tests (the 16 existing plus 8 new) PASSED in the simulator on fr965, fenix5s and fr55 (2026-10-01); the ten-size fit loop and the memory view are not yet run; nothing on a wrist.

## 1.0.1 — uploaded 2026-09-24, live 2026-09-24

- The HeroSet link connects within a minute of installing HeroSet, without
  restarting the face; a failed link setup can no longer stop the face starting.
- The "HeroSet" mode setting is gone: it did exactly what Auto does. A face that
  had it selected now reads as Auto.
- Fahrenheit is rounded, as Garmin's own widgets show it.
- Seconds never clipped by the partial-update box; dead code removed.
- Evidence: simulator only (16/16 tests on six products, 208–466 px).

## 1.0.0 — live 2026-09-22

- First release: 117 round watches, Connect IQ 3.0+, everyday mode with three
  configurable goal bars, optional HeroSet link on Connect IQ 4.2+, 15 languages.
