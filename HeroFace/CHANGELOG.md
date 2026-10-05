# HeroFace changelog

One entry per Connect IQ Store publication, newest first. The store's
"What's New" text for each version is in [`listing/paste.md`](listing/paste.md).

## Unreleased (next upload of both)

Design critique 2026-10-05 (owner said "do your picks"; ROADMAP 13.8 to 13.12; simulator only, nothing on a wrist):

- **The streak and the temperature are one centred group** under the time, so the temperature no longer jumps from the row's centre to its right edge when a streak shows (Pro), and the streak is no longer pinned left.
- **No empty band under the time:** when that row has nothing (no streak yet, no temperature), the time moves down half a row (Free's first days).
- **Icons instead of clipped words:** footprints, flame, a pulse line and stairs replace `STEP`, `CAL`, `INT`, `FLR` (drawn, so nothing to translate). Distance, MOVE and HeroSet's exercises keep their words.
- **MOVE shows no value until it alerts:** `OK` is gone; the alert stays the red word GO.
- Both listing sets recaptured.

Rectangular watches, 2026-10-05 (ADR-005, proposed; simulator only, nothing on a wrist; the look needs the owner's approval before upload):

- **Five rectangular products join both builds (129 instead of 124):** Venu Sq and Sq Music (`venusq`, `venusqm`), Venu Sq 2 and Sq 2 Music (`venusq2`, `venusq2m`), Venu X1 (`venux1`). The ring becomes a frame along the screen's edges, open at the bottom for the footer, filling clockwise from the lower left; rows use the width inside it. HeroSet mode needs Connect IQ 4.2+, so the two first-generation Venu Sq stay in Everyday mode.
- **Square design pass (same day, ADR-005 amendment):** the time is as large as the frame allows, sized by its digits rather than its font box (Venu Sq 2 from the smallest number font to the second largest, Venu X1 and Venu Sq to the largest), and the rows are spaced evenly so no empty band sits under it. With Pro's seconds on, the time steps down a size on the Venu Sq 2 and X1 to leave them room; Free is never smaller for them. The frame sits further in from the glass and its corners follow the X1's rounded glass, so the margin is even all the way round.
- Pro is sold only on Garmin's paid-app list: Venu Sq 2, Sq 2 Music and X1 are on it; Venu Sq and Sq Music are not, so only the Free build reaches them. No model names in listing text.

## Free 1.0.0 and Pro 1.1.0 — uploaded 2026-10-04 by the owner, in Garmin review

Built 2026-10-01 against the Free + Pro plan; the owner approved the ladder on 2026-10-04 (`docs/decisions.md` ADR-001, the Free + Pro ladder, Active) and uploaded both the same day. Simulator only; nothing on a wrist. Approval dates are recorded here when Garmin reports them.

### HeroFace (Free) 1.0.0 — uploaded 2026-10-04 by the owner, in review (a new app; developer page https://apps-developer.garmin.com/apps/890dd680-20e6-4205-b9bf-cd98ea02849d; the public store URL works once Garmin approves)

- First release of the Free twin: the same 117 round watches, 15 languages and permission as the paid app. The time, the progress ring, three mission bars (steps, intensity minutes and floors, each falling back to what the watch has), the date, the step-goal streak, battery, heart rate, notifications, always-on, and HeroSet mode on Connect IQ 4.2+ watches with HeroSet installed.
- Settings: Missions (HeroSet when installed, or everyday goals) and Accent colour (Blue, Cyan, Magenta).
- Not in Free (Pro only): choosing the metric of each bar, seconds, and the temperature.
- **Instinct family, added 2026-10-03 (124 products instead of 117; ADR-002, accepted 2026-10-04, simulator only):** `instinct2`, `instinct2s`, `instinct2x`, `descentg1`, `instincte40mm`, `instincte45mm`, `instinct3solar45mm`. Black and white; the ring becomes a gauge in the round window; no footer, temperature, seconds or Accent setting on these watches. The visible area on an Instinct is a circle about 98 px in radius, which the layout and the fit test now model. On the Instinct 2 family (CIQ 3.4, no Complications) the face stays in Everyday mode. Evidence: `docs/compatibility.md` "Instinct family".
- Launcher icon redrawn on the pixel grid (whole-number vertices; same look, crisper edges; no What's New line needed).
- App id `be68898f-995b-45d9-860e-42ad508bd7fd` (generated 2026-10-01). Store name and title: "HeroFace" (confirmed 2026-10-04).
- ADRs: 001 (Free + Pro ladder), 002 (Instinct family), 003 (Magenta recolour); all accepted 2026-10-04.
- Evidence: compiled for both jungles with `-w --typecheck 3` and swept across every manifest product (`tools/compile_sweep.sh`); the Free package's contents checked (`tools/check_free_package.sh`: Mode and Accent only, no "Pro" anywhere). Simulator, 2026-10-01: the 24 Free tests PASSED on fr965, fenix5s and fr55, including `freeMissingPropertyKeyThrows` (the simulator throws `InvalidKeyException` for a key missing from the properties file) and the Magenta known-issue test (since replaced by the passing `magentaWasRecolouredToClearTheTrackRule`). The ten-size screen-fit loop and the memory view on fenix5s and vivoactive3 ran 2026-10-04 (`docs/compatibility.md`). Nothing has run on a wrist, and a Free app id receiving HeroSet's private complication is untested on a watch.

### HeroFace Pro 1.1.0 — uploaded 2026-10-04 by the owner, in review (an update of the existing paid app id; $2.50 tier)

- The paid app is renamed on the watch to "HeroFace Pro" (name confirmed 2026-10-04). Behaviour, settings, ids and defaults are the same as 1.0.1: `resources-pro/settings` is the old shared settings file unchanged.
- **Instinct family, added 2026-10-03** (124 products; ADR-002, accepted 2026-10-04, simulator only), as in the Free entry above; Pro on an Instinct has no seconds, no temperature and no footer, and no Accent setting.
- Accent **Magenta** is now a paler magenta (`#FFAAFF`, was `#FF55FF`): it clears the face's own 3:1 rule against the bar track (4.42:1, was 2.84:1). Same setting, same id and name; a user who chose Magenta sees the lighter shade (ADR-003, owner decision 2026-10-04). Needs a line in the 1.1.0 What's New. The plan's other Pro additions (more accent colours, an alternate layout) are **not built**.
- Launcher icon redrawn on the pixel grid (whole-number vertices; same look, crisper edges; no What's New line needed).
- Build change: Pro is now `monkey.jungle` with `resources;resources-pro` and `(:free)` code excluded. The strict compile (`-w --typecheck 3`) is now clean: type-only fixes in `HeroFaceLink`, `HeroFaceSettings`, `HeroFaceStreak` (no behaviour change).
- ADRs: 001 (Free + Pro ladder, accepted 2026-10-04), 003 (Magenta recolour). The ladder replaces plan decision 8 (the price); the Pro price is the $2.50 tier, set in the upload form with the 1.1.0 upload (004, price: the $2.50 tier for every paid app; no price number in listing text).
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
