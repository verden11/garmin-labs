# Improvements backlog: status against current repo (2026-09-25)

Scope: every item in `reports/Improvements backlog.md` (IB) checked against working tree at HEAD `4791782` (git status clean at start). Read-only: greps, file reads, inspection of existing `site/dist/` build. Nothing built, run, compiled -> no Monkey C claim here compiler- or device-verified. Source for every finding = repo file cited (path:line); no web sources, no SDK claim needed outside checking (see Gaps).

## Q1. For each backlog item: done on main, open, superseded, or wrong?

### Takeaway
21 entries: 13 done/still true on main, 4 still open (all small), 3 superseded or stale, 1 factually wrong in stated risk (divide-by-zero). IB's own "Done" bodies partly stale: three (CTA fix, CSP, HSTS) describe dropped branch implementation, not main. Preface corrects this correctly; bodies should be trimmed.

### Cited Findings

Status table. Paths relative to `/Users/mbp/dev/garmin/`.

| # | IB item | Status | Evidence on current tree |
|---|---|---|---|
| D1 | CTA button invisible (`.field a` specificity) | DONE on main, different fix | `site/src/styles/global.css:125` `.field a:not(.button) { color: inherit; }`; `.button` rule at :131. IB body still says `.field :where(a)` (branch fix, not on main). Backlog text stale, code fine. |
| D2 | JSON-LD SoftwareApplication | DONE, as written | `site/src/entry-server.tsx:13-22` (fields name/description/category/OS/url/sameAs), emitted only for `landing` at :40 and :83 with `</script` escape. Built `dist/heroset/index.html` contains it; `dist/index.html` has 0 `ld+json`. |
| D3 | HSTS + Permissions-Policy | DONE, IB body wrong on values | `site/firebase.json`: `max-age=31536000` (no `includeSubDomains`); IB body still says `63072000; includeSubDomains`. Preface right. Permissions-Policy present as described. |
| D4 | vite 8.3.0 -> 8.3.1 | NOT on main (dropped) | `site/package-lock.json:1211-1212` and `node_modules/vite/package.json` both 8.3.0; `package.json:20` `^8.3.0`. Branch-only change lost. 8.3.1 existence not checked (no `npm outdated`/registry call). |
| D5 | OG / Twitter / canonical | DONE | `entry-server.tsx:65-80`; `og:image`+`twitter:image` from `app.ogImage` (`apps/heroset/app.ts:18`, `apps/heroface/app.ts:17`); `twitter:card` switches summary/summary_large_image. Commit `4d275e7` in history. |
| D6 | robots.txt + sitemap.xml | DONE | `site/public/robots.txt` (Allow + Sitemap line); `entry-server.tsx:48-51` `sitemap()`; `prerender.ts:15` writes `dist/sitemap.xml`; file in `dist/`. |
| D7 | `complication_label`/`_short` untranslated | DONE, stronger than IB says | `HeroSet/resources/strings/strings.xml:79-82` now `translatable="false"` with comment "never translate or change it" (added by code-quality review S13). IB's cited lines stale: match now `HeroFaceLink.mc:95` against `HeroFaceConfig.mc:39` `HEROSET_COMPLICATION_LABEL = "HeroSet"` (IB said `HeroFaceLink.mc:86`); comment was at 76-77, now 79-80. Conclusion unchanged, correct. |
| D8 | CSP header | SUPERSEDED | `firebase.json` ships `Content-Security-Policy-Report-Only` with `default-src 'none'; style-src 'self'; style-src-attr 'unsafe-inline'; ...`, not IB's enforced `'unsafe-inline'` policy. Enforcement pending deploy-preview check (also open in code-quality review Outcome). |
| D9 | Screenshot width/height | DONE | `apps/types.ts:7-8` optional `size`; `apps/heroface/facts.ts:32-33` `size: 240`; render at `components/AppSections.tsx:30` `width={shot.size ?? 454}`. IB says "both `Landing.tsx` files"; render since deduplicated into `AppSections.tsx` (code-quality W8). |
| D10 | HeroFace DESIGN.md accent-white | DONE | `HeroFace/DESIGN.md:12-14` only blue/cyan/magenta tokens; :124 "three user-selectable accents"; :130 alternatives cyan+magenta. No `accent-white` anywhere. |
| O1 | HeroFace two `dc.drawText` bypasses | OPEN, with corrected premise (see Q2) | Still bypass: `HeroFace/source/HeroFaceView.mc:111` (seconds) and `HeroFace/source/HeroFaceSleep.mc:21`. Only other `drawText` inside `HeroFaceDraw.text` (:16-30). Lines moved from IB's :108. |
| O2 | `HeroFaceFooter.iconSize(layout)` dead param | OPEN, confirmed | `HeroFace/source/HeroFaceFooter.mc:38-40` body never uses `layout`; call sites :45, :52 (IB says 3 call sites at :39,45,52; :39 is definition, so 2 real call sites). `grep iconSize` shows no other users. |
| O3 | `HeroSetMissionBars.drawBar` divide by `goal` | WRONG as a risk (see Q2) | Now `HeroSet/source/ui/dashboard/HeroSetMissionBars.mc:116-120` (moved from :106). Division provably unreachable for goal <= 0 given `done` test above it. |
| O4 | Cyrillic word `Українська` falls back to system font | OPEN, decision only | Still present: `site/src/apps/heroset/facts.ts:20`, `apps/heroface/facts.ts:25`. Archivo package ships only `vietnamese`, `latin-ext`, `latin` (`node_modules/@fontsource-variable/archivo/unicode.json`; no cyrillic file in `files/`). No note in `site/DESIGN.md`, `CLAUDE.md` or `README.md` (grep Cyrillic/Ukrain: no hits). Font stack falls to `system-ui` (`DESIGN.md:25`). |
| V1 | Two HeroSet/HeroFace source passes "clean" | STILL TRUE, with caveat | `grep drawText` outside `HeroSetDraw.mc` in `HeroSet/source`: empty. TODO/FIXME/XXX/HACK grep across both source trees: empty. Caveat: "no un-guarded edge case" claim mostly right, but review found real null/throw hazards IB missed (all since fixed per code-quality Outcome: S1, F2, S5). So "clean" over-confident, not wrong on what it checked. |
| V2 | Chromium pass: no console errors, one h1, etc. | UNVERIFIED (not re-run) | Not re-run (no build/browser). Structure consistent with tree: `<title>` and one landing per route in `entry-server.tsx`; `dist/` has 7 routes + 404. Treat numbers (182KB, 18-45ms) as historical. |
| V3 | axe scan found only CTA bug | UNVERIFIED (not re-run), plausible | Same. The one axe finding it explains is fixed (D1). Code-quality review says "no axe run", found separate low-severity focus-ring contrast (W10); not contradictory. |
| V4 | `noUncheckedIndexedAccess` not worth flipping | STILL TRUE | `site/tsconfig.json`: `strict`, `noUnusedLocals`, `noUnusedParameters` present, flag absent. Nothing in tree changed that. |
| V5 | No legacy-URL gaps | STILL TRUE | Routes come only from registry (`entry-server.tsx:27-44`, `apps/index.ts`); code-quality W9 requires byte-identical paths. Not re-diffed against git history. |
| V6 | `font-display: swap` present, no preload | SUPERSEDED: preload now exists | `site/index.html:7` `<link rel="preload" ... archivo-latin-wdth-normal.woff2 crossorigin>`; built `dist/heroset/index.html` rewrites it to `/assets/archivo-latin-wdth-normal-DY7AcnAa.woff2`. `font-display:swap` occurs 3 times in `dist/assets/*.css`. Landed in `8a40cb6` (2026-09-24 "website UI"), so IB "not done this pass" stale. |
| N1 | Not investigated: onUpdate/onPartialUpdate battery/allocation profiling | OPEN, needs device/simulator profiler | Not doable read-only. Also listed as unmeasured in code-quality review "Limits". |
| N2 | `HeroSetStoreTest.mc` over budget, unlisted in architecture §8 | DONE | `HeroSet/docs/architecture.md:188` lists it ("HeroSetStore.mc is ~340 lines (budget 250); HeroSetStoreTest.mc 377 lines") with reason. Now 339 / 378 lines. Code-quality S18 did this. |

Other IB claims sanity-checked ("riskiest verified/unverified" ones):
- "Text fit is measured, never guessed: draw through `HeroFaceDraw.text`" quoted from CLAUDE.md accurate (`HeroFace/CLAUDE.md:49`).
- `HeroFaceDraw.text` wrapper behaviour (records only when `misfits`/`boxes` non-null) accurate: `HeroFace/source/HeroFaceDraw.mc:16-30`.
- `getGoal()` fallback and `clampGoal` claims accurate: `HeroSet/source/data/HeroSetStore.mc:161-166`, `HeroSet/source/domain/HeroSetRules.mc:87-94`. `clampGoal(0)` returns MIN (pinned by `HeroSetRulesTest.mc:123`).
- Store/preface claims "taken as written": Twitter/og:image/JSON-LD/screenshot size/DESIGN.md all confirmed above.

### Inferences
- IB "Done" section should be rewritten as one short "shipped on main" table; keeping branch-specific bodies (CSP enforced, HSTS 2yr, `:where(a)`, vite bump) misleads next reader.
- IB "Open" really only O1 (narrowed), O2, O4, plus vite lockfile nit (D4). O3 should be closed as declined.

### Gaps
- V2/V3 numbers (Chromium, axe, transfer sizes) not reproduced: re-running needs build and headless browser, out of bounds.
- D4: not verified vite 8.3.1 exists (no `npm view`).
- V5 not re-diffed against git history of `src/apps/`.

## Q2. Sanity-check of the riskiest claims (divide-by-zero, Monkey C, perf numbers)

### Takeaway
Divide-by-zero note wrong in conclusion: recommended guard cannot change behaviour, because `done = count >= goal` short-circuits every goal <= 0 case before division. O1's stated fix half-redundant (seconds path), half-valuable (sleep path). "monkeyc would flag the dead parameter" claim unsupported.

### Cited Findings
- **O3 divide-by-zero**: `HeroSet/source/ui/dashboard/HeroSetMissionBars.mc:117-120`: `var done = count >= goal;` then `var fill = done ? width : (count <= 0 ? 0 : width * count / goal);`. Division runs only if `count < goal` and `count > 0`, so `goal > count >= 1`, i.e. `goal >= 2`. For `goal == 0` (or negative) and any `count >= 0`, `done` true; for `count < 0`, `count <= 0` branch returns 0. No goal value reaches zero divisor. IB's claim "throws on integer divide-by-zero if `goal` is ever 0" false; zero goal would instead draw every bar full and `HeroSetRules.missionComplete` (`HeroSetRules.mc:80-82`, `>= goal`) would report complete, a different (visual/semantic) issue, already blocked upstream by `getGoal()`'s `<= 0` fallback and `clampGoal` [10,500] (`HeroSetConfig` MIN/MAX). Proposed one-line change `(done || goal <= 0)` behaviour-neutral. Recommendation: decline, or at most no-op.
- IB states line `:106`; now `:120` (file evolved: `drawBar` now reads `_goal` into local at :116). IB's "checked every constructor call of `HeroSetDashboardState`" plausible: tests use `DEFAULT_MISSION_GOAL` (`HeroSetScreenFitTest.mc:31-32`); `HeroSetView.mc:45` passes `state.goal`.
- **O1 harness claim**: IB says "`HeroFaceScreenFitTest.mc` only calls `view.drawState(...)` ... never calls `onPartialUpdate` or `HeroFaceSleep.draw`". Partly out of date: `HeroFace/source/test/HeroFaceScreenFitTest.mc:187` now calls `view.onPartialUpdate(dc)`, but only after `view.disableSeconds()` (lines 148-193 test `disabledSecondsDrawNoSecondsBox`), so `_secondsBox` null and method returns at `HeroFaceView.mc:104-106` before `drawText` at :111. Draw line still never executed under test; IB's core conclusion (swapping call alone adds no coverage) holds. `HeroFaceSleep.draw` never referenced from `test/` (grep `Sleep|_sleeping|onEnterSleep` in `test/`: no hits).
- **O1 seconds path redundant to instrument**: seconds drawn in full frame via `HeroFaceDraw.text(... FONT_XTINY, seconds, JUSTIFY_LEFT)` at `HeroFaceClock.mc:34`, returns `[x, y, width, height]` used as `_secondsBox`; `onPartialUpdate` (`HeroFaceView.mc:111`) redraws at `box[0], box[1]` with same font and justify. Geometry identical to path fit test already measures, so only sleep path carries new fit risk. (Font/justify identity confirmed by reading both lines; runtime equality not tested.)
- **O1 sleep path = real gap**: `HeroFaceSleep.mc:16-21` draws `FONT_NUMBER_MEDIUM` centered at `centerX + dx` with `dx,dy` in `BURN_IN_GRID`/`BURN_IN_STEP_PX` steps (`HeroFaceConfig`); nothing measures clip against round chord on any screen. Reached only when `_sleeping && _burnIn` (`HeroFaceView.mc:61-65`). Only place a small-round AMOLED could clip an always-on clock without any test noticing. Not verified to actually clip.
- **O2 "monkeyc would just flag statically"**: unsupported. Whether compiler warns on unused parameter not verified (no SDK run, no Garmin doc citation found). Treat as hand-edit, compile check needed anyway. IB cites line correctly (:38) but miscounts call sites (2 real: :45, :52).
- **HSTS commentary in IB body**: says "safe since HSTS only affects HTTP(S)" and `includeSubDomains`; main deliberately dropped it (preface). Not a code issue.
- Performance numbers in IB (182KB heaviest page, 95KB lightest, 18-45ms DCL): not reproducible read-only; built `dist/assets` fonts 88.0K latin + 84.2K latin-ext + 33.7K vietnamese (only latin/latin-ext fetched per page, others skipped via unicode-range per IB), consistent with ~182KB for page pulling latin file plus CSS/HTML/images. Plausible, not measured here.

### Inferences
- If maintainer wants O1, do only sleep half (route `HeroFaceSleep` through `HeroFaceDraw.text` plus one test case setting `_sleeping`/`_burnIn` and driving `onUpdate`, capturing `misfits`). Skip seconds half.

### Gaps
- No SDK/API doc consulted for unused-parameter warning; no compile allowed.
- Whether `HeroFaceDraw.text` behaves identically when clip set (partial update) not checked in SDK; it only calls `dc.drawText` first, so runtime behaviour should be unchanged, unverified.

## Q3. Ranked list of what is genuinely still worth doing

### Takeaway
Everything left small. Nothing here is defect a user would hit today. Best gain per effort: close Cyrillic decision with one doc line, then sleep-path fit coverage.

### Cited Findings
De-duplicated, ranked by gain/effort. Effort = my estimate. "Needs sim" = needs local monkeyc/simulator.

| Rank | Item | One-line action | Effort | Notes |
|---|---|---|---|---|
| 1 | O4 Cyrillic fallback | Add one line to `site/DESIGN.md` typography stating `Українська` intentionally falls back to `system-ui` (recommended (b); no Cyrillic subset exists in package) | 5 min | Design decision; doc-only; removes unowned known break of "one grotesque" rule. |
| 2 | O1 (narrowed to sleep) | Send `HeroFaceSleep.mc:21` through `HeroFaceDraw.text` and add one `(:test)` driving `onUpdate` with `_sleeping && _burnIn` (drift position varies with minute, so also loop `clock.min` values or assert at max offsets) | 45-90 min, needs sim | Only unmeasured text path in HeroFace. Overlaps code-quality F1/F6 (always-on/burn-in) and review's Limits (no device proof). Skip seconds swap (redundant). |
| 3 | D4 vite lockfile | `cd site && npm update vite` (then confirm build) | 2 min | Only if 8.3.1 exists; verify with `npm outdated`. Trivial gain (patch). |
| 4 | O2 dead param | Drop `layout` from `HeroFaceFooter.iconSize` and its 2 call sites (:45, :52) | 5 min, needs compile | Cosmetic; must compile since not sure monkeyc flags it. |
| 5 | D8/CSP enforce | After deploy-preview shows no violations, rename `Content-Security-Policy-Report-Only` to `Content-Security-Policy` in `firebase.json` | 10 min plus deploy check | Already tracked as HeroSet go-to-market C2 (per IB preface) and in code-quality Outcome; not new, just biggest remaining hardening. Report-only has no `report-uri`, so violations only show in browser console. |
| 6 | N1 profiling | Profile `onPartialUpdate` power/`onUpdate` allocations on a device | hours, needs device | Real but unmeasured; overlaps review "partial-update cost unmeasured". |
| Decline | O3 divide guard | None. Close as not a bug (`done` short-circuit, see Q2) | 0 | Optionally add one-line comment; no behaviour change. |
| Decline | V4 `noUncheckedIndexedAccess` | None | 0 | No hit today. |

IB housekeeping (not product work): rewrite "Done" bodies for D1/D3/D8 to match main, delete vite "shipped" claim or re-apply it, refresh stale line numbers (`HeroMissionBars` :106 -> :120, `HeroFaceView` :108 -> :111, `HeroFaceLink` :86 -> :95, strings comment 76-77 -> 79-80), move V6 from "not done" to "done".

Overlaps with `/Users/mbp/dev/garmin/reports/Verden code quality review.md` (CQ), for final report to merge:
- D5/D6 (OG/canonical/sitemap) = CQ W6, fixed (CQ Outcome "W2-W13 Fixed"). Same work, don't list twice.
- D8 (CSP) and D3 (Permissions-Policy) = CQ W12; both list same open step (report-only -> enforcing after deploy preview).
- D7 (`complication_label`) = CQ S13 (`translatable="false"`, fixed); IB's "no action needed" claim predates it.
- D9 (screenshot size) = CQ W14 ("240 declared as 454" part fixed via `size`; "Screenshot pending" always-on slot and re-capture at 454 px remain open in CQ; still visible via `AppSections.tsx:31`).
- D10 (DESIGN.md accents) overlaps CQ F5 (HeroFace plan.md "4-6 accents", stale docs), also fixed.
- O1 (draw bypass, harness gap) overlaps CQ F1/F6 (always-on/burn-in on `venu`, unverified) and CQ F7 (test gaps in `HeroFaceScreenFitTest`), and "must not churn" note that `HeroSetDraw.text` is only draw path.
- N2 (StoreTest budget) = CQ S18, fixed.
- V1 "source clean" conflicts in tone with CQ's 20+ HeroSet findings (S1 uncaught `updateComplication`, S5 flag reset, etc.). IB did not look at typing (`-l 3`), so its "clean" scoped to house-rule layering, not robustness.
- V6 preload and V4 tsconfig: no CQ equivalent; unique to IB.
- O3 and O2 and O4: no CQ equivalent; unique to IB.

### Inferences
- After housekeeping IB adds only four genuinely unique open items (O1-sleep, O2, O4, D4). Everything else shipped or already in CQ.
- "Simulator passing is not device proof" (repo house rule) applies to items 2 and 4; no item here has device evidence.

### Gaps
- No prior session's device evidence for HeroFace sleep-path fit; assumed none (per `MEMORY.md` FR965 all-day wear only).
- Effort figures estimates, not measured.