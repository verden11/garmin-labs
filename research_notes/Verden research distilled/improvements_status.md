# Improvements backlog: status against current repo (2026-09-25)

Scope: every item in `/Users/mbp/dev/garmin/reports/Improvements backlog.md` (IB) checked against the working tree at HEAD `4791782` (git status clean at start). Read-only: greps, file reads, and inspection of the existing `verden-site/dist/` build. Nothing was built, run, or compiled, so no Monkey C claim here is compiler- or device-verified. Source for every finding is the repo file cited (path:line); there are no web sources, because no SDK claim needed outside checking (see Gaps).

## Q1. For each backlog item: done on main, open, superseded, or wrong?

### Takeaway
Of 21 entries, 13 are done/still true on main, 4 are still open (all small), 3 are superseded or stale, and 1 is factually wrong in its stated risk (the divide-by-zero). The IB's own "Done" bodies are partly stale: three of them (CTA fix, CSP, HSTS) describe the dropped branch implementation, not main. The preface corrects this correctly; the bodies should be trimmed.

### Cited Findings

Status table. Paths relative to `/Users/mbp/dev/garmin/`.

| # | IB item | Status | Evidence on current tree |
|---|---|---|---|
| D1 | CTA button invisible (`.field a` specificity) | DONE on main, different fix | `verden-site/src/styles/global.css:125` `.field a:not(.button) { color: inherit; }`; `.button` rule at :131. IB body still says `.field :where(a)` (branch fix, not on main). Backlog text stale, code fine. |
| D2 | JSON-LD SoftwareApplication | DONE, as written | `verden-site/src/entry-server.tsx:13-22` (fields name/description/category/OS/url/sameAs), emitted only for `landing` at :40 and :83 with `</script` escape. Built `dist/heroset/index.html` contains it; `dist/index.html` has 0 `ld+json`. |
| D3 | HSTS + Permissions-Policy | DONE, IB body wrong on values | `verden-site/netlify.toml:22-23`: `max-age=31536000` (no `includeSubDomains`); IB body still says `63072000; includeSubDomains`. Preface is right. Permissions-Policy present as described. |
| D4 | vite 8.3.0 -> 8.3.1 | NOT on main (dropped) | `verden-site/package-lock.json:1211-1212` and `node_modules/vite/package.json` both 8.3.0; `package.json:20` `^8.3.0`. Branch-only change was lost. Whether 8.3.1 exists was not checked (no `npm outdated`/registry call). |
| D5 | OG / Twitter / canonical | DONE | `entry-server.tsx:65-80`; `og:image`+`twitter:image` from `app.ogImage` (`apps/heroset/app.ts:18`, `apps/heroface/app.ts:17`); `twitter:card` switches summary/summary_large_image. Commit `4d275e7` exists in history. |
| D6 | robots.txt + sitemap.xml | DONE | `verden-site/public/robots.txt` (Allow + Sitemap line); `entry-server.tsx:48-51` `sitemap()`; `prerender.ts:15` writes `dist/sitemap.xml`; file is in `dist/`. |
| D7 | `complication_label`/`_short` untranslated | DONE, stronger than IB says | `HeroSet/resources/strings/strings.xml:79-82` now `translatable="false"` with comment "never translate or change it" (added by code-quality review S13). IB's cited lines are stale: match is now `HeroFaceLink.mc:95` against `HeroFaceConfig.mc:39` `HEROSET_COMPLICATION_LABEL = "HeroSet"` (IB said `HeroFaceLink.mc:86`); comment was at 76-77, now 79-80. Conclusion unchanged and correct. |
| D8 | CSP header | SUPERSEDED | `netlify.toml:26` ships `Content-Security-Policy-Report-Only` with `default-src 'none'; style-src 'self'; style-src-attr 'unsafe-inline'; ...`, not IB's enforced `'unsafe-inline'` policy. Enforcement is pending a deploy-preview check (also open in code-quality review Outcome). |
| D9 | Screenshot width/height | DONE | `apps/types.ts:7-8` optional `size`; `apps/heroface/facts.ts:32-33` `size: 240`; render at `components/AppSections.tsx:30` `width={shot.size ?? 454}`. Note IB says "both `Landing.tsx` files"; the render was since deduplicated into `AppSections.tsx` (code-quality W8). |
| D10 | HeroFace DESIGN.md accent-white | DONE | `HeroFace/DESIGN.md:12-14` only blue/cyan/magenta tokens; :124 "three user-selectable accents"; :130 alternatives cyan+magenta. No `accent-white` anywhere. |
| O1 | HeroFace two `dc.drawText` bypasses | OPEN, with a corrected premise (see Q2) | Still bypass: `HeroFace/source/HeroFaceView.mc:111` (seconds) and `HeroFace/source/HeroFaceSleep.mc:21`. Only other `drawText` is inside `HeroFaceDraw.text` (:16-30). Lines moved from IB's :108. |
| O2 | `HeroFaceFooter.iconSize(layout)` dead param | OPEN, confirmed | `HeroFace/source/HeroFaceFooter.mc:38-40` body never uses `layout`; call sites :45, :52 (IB says 3 call sites at :39,45,52; :39 is the definition, so 2 real call sites). `grep iconSize` shows no other users. |
| O3 | `HeroSetMissionBars.drawBar` divide by `goal` | WRONG as a risk (see Q2) | Now `HeroSet/source/ui/dashboard/HeroSetMissionBars.mc:116-120` (moved from :106). Division is provably unreachable for goal <= 0 given the `done` test above it. |
| O4 | Cyrillic word `Українська` falls back to system font | OPEN, decision only | Still present: `verden-site/src/apps/heroset/facts.ts:20`, `apps/heroface/facts.ts:25`. Archivo package ships only `vietnamese`, `latin-ext`, `latin` (`node_modules/@fontsource-variable/archivo/unicode.json`; no cyrillic file in `files/`). No note in `verden-site/DESIGN.md`, `CLAUDE.md` or `README.md` (grep for Cyrillic/Ukrain: no hits). Font stack falls to `system-ui` (`DESIGN.md:25`). |
| V1 | Two HeroSet/HeroFace source passes "clean" | STILL TRUE, with caveat | `grep drawText` outside `HeroSetDraw.mc` in `HeroSet/source`: empty. TODO/FIXME/XXX/HACK grep across both source trees: empty. Caveat: the "no un-guarded edge case" claim is mostly right but the review found real null/throw hazards the IB missed (all since fixed per code-quality Outcome: S1, F2, S5). So "clean" was over-confident, not wrong on what it checked. |
| V2 | Chromium pass: no console errors, one h1, etc. | UNVERIFIED (not re-run) | Not re-run (no build/browser). Structure is consistent with tree: `<title>` and one landing per route in `entry-server.tsx`; `dist/` contains 7 routes + 404. Treat numbers (182KB, 18-45ms) as historical. |
| V3 | axe scan found only the CTA bug | UNVERIFIED (not re-run), plausible | Same. The one axe finding it explains is fixed (D1). Code-quality review says "no axe run" and found separate low-severity focus-ring contrast (W10); not contradictory. |
| V4 | `noUncheckedIndexedAccess` not worth flipping | STILL TRUE | `verden-site/tsconfig.json`: `strict`, `noUnusedLocals`, `noUnusedParameters` present, flag absent. Nothing in the tree changed that. |
| V5 | No legacy-URL gaps | STILL TRUE | Routes come only from registry (`entry-server.tsx:27-44`, `apps/index.ts`); code-quality W9 requires byte-identical paths. Not re-diffed against git history. |
| V6 | `font-display: swap` present, no preload | SUPERSEDED: preload now exists | `verden-site/index.html:7` `<link rel="preload" ... archivo-latin-wdth-normal.woff2 crossorigin>`; built `dist/heroset/index.html` rewrites it to `/assets/archivo-latin-wdth-normal-DY7AcnAa.woff2`. `font-display:swap` occurs 3 times in `dist/assets/*.css`. Landed in `8a40cb6` (2026-09-24 "website UI"), so the IB "not done this pass" is stale. |
| N1 | Not investigated: onUpdate/onPartialUpdate battery/allocation profiling | OPEN, needs device/simulator profiler | Not doable read-only. Also listed as unmeasured in code-quality review "Limits". |
| N2 | `HeroSetStoreTest.mc` over budget, unlisted in architecture §8 | DONE | `HeroSet/docs/architecture.md:188` lists it ("HeroSetStore.mc is ~340 lines (budget 250); HeroSetStoreTest.mc 377 lines") with the reason. Now 339 / 378 lines. Code-quality S18 did this. |

Other IB claims sanity-checked (the "riskiest verified/unverified" ones):
- "Text fit is measured, never guessed: draw through `HeroFaceDraw.text`" quoted from CLAUDE.md is accurate (`HeroFace/CLAUDE.md:49`).
- `HeroFaceDraw.text` wrapper behaviour (records only when `misfits`/`boxes` non-null) is accurate: `HeroFace/source/HeroFaceDraw.mc:16-30`.
- `getGoal()` fallback and `clampGoal` claims are accurate: `HeroSet/source/data/HeroSetStore.mc:161-166`, `HeroSet/source/domain/HeroSetRules.mc:87-94`. `clampGoal(0)` returns MIN (pinned by `HeroSetRulesTest.mc:123`).
- Store/preface claims about which entries are "taken as written": Twitter/og:image/JSON-LD/screenshot size/DESIGN.md are all confirmed above.

### Inferences
- The IB "Done" section should be rewritten as one short "shipped on main" table; keeping the branch-specific bodies (CSP enforced, HSTS 2yr, `:where(a)`, vite bump) will mislead the next reader.
- IB "Open" is really only O1 (narrowed), O2, O4, plus the vite lockfile nit (D4). O3 should be closed as declined.

### Gaps
- V2/V3 numbers (Chromium, axe, transfer sizes) were not reproduced: re-running needs a build and a headless browser, which were out of bounds.
- D4: not verified that vite 8.3.1 exists (no `npm view`).
- V5 not re-diffed against git history of `src/apps/`.

## Q2. Sanity-check of the riskiest claims (divide-by-zero, Monkey C, perf numbers)

### Takeaway
The divide-by-zero note is wrong in its conclusion: the guard it recommends cannot change behaviour, because `done = count >= goal` short-circuits every goal <= 0 case before the division. O1's stated fix is half-redundant (seconds path) and half-valuable (sleep path). The "monkeyc would flag the dead parameter" claim is unsupported.

### Cited Findings
- **O3 divide-by-zero**: `HeroSet/source/ui/dashboard/HeroSetMissionBars.mc:117-120`: `var done = count >= goal;` then `var fill = done ? width : (count <= 0 ? 0 : width * count / goal);`. The division runs only if `count < goal` and `count > 0`, so `goal > count >= 1`, i.e. `goal >= 2`. For `goal == 0` (or negative) and any `count >= 0`, `done` is true; for `count < 0`, the `count <= 0` branch returns 0. So no goal value can reach a zero divisor. IB's claim "throws on integer divide-by-zero if `goal` is ever 0" is false; a zero goal would instead draw every bar as full and `HeroSetRules.missionComplete` (`HeroSetRules.mc:80-82`, `>= goal`) would report complete, which is a different (visual/semantic) issue, and already blocked upstream by `getGoal()`'s `<= 0` fallback and `clampGoal` [10,500] (`HeroSetConfig` MIN/MAX). The proposed one-line change `(done || goal <= 0)` is behaviour-neutral. Recommendation: decline, or at most no-op.
- IB states line is `:106`; it is now `:120` (file evolved: `drawBar` now reads `_goal` into a local at :116). The IB's "checked every constructor call of `HeroSetDashboardState`" is plausible: tests use `DEFAULT_MISSION_GOAL` (`HeroSetScreenFitTest.mc:31-32`); `HeroSetView.mc:45` passes `state.goal`.
- **O1 harness claim**: IB says "`HeroFaceScreenFitTest.mc` only calls `view.drawState(...)` ... never calls `onPartialUpdate` or `HeroFaceSleep.draw`". Partly out of date: `HeroFace/source/test/HeroFaceScreenFitTest.mc:187` now calls `view.onPartialUpdate(dc)`, but only after `view.disableSeconds()` (lines 148-193 test `disabledSecondsDrawNoSecondsBox`), so `_secondsBox` is null and the method returns at `HeroFaceView.mc:104-106` before the `drawText` at :111. So the draw line is still never executed under test; the IB's core conclusion (swapping the call alone adds no coverage) still holds. `HeroFaceSleep.draw` is never referenced from `test/` (grep `Sleep|_sleeping|onEnterSleep` in `test/`: no hits).
- **O1 seconds path is redundant to instrument**: seconds are drawn in the full frame via `HeroFaceDraw.text(... FONT_XTINY, seconds, JUSTIFY_LEFT)` at `HeroFaceClock.mc:34`, which returns `[x, y, width, height]` used as `_secondsBox`; `onPartialUpdate` (`HeroFaceView.mc:111`) redraws at `box[0], box[1]` with the same font and justify. Geometry is identical to a path the fit test already measures, so only the sleep path carries new fit risk. (Font/justify identity confirmed by reading both lines; runtime equality not tested.)
- **O1 sleep path is the real gap**: `HeroFaceSleep.mc:16-21` draws `FONT_NUMBER_MEDIUM` centered at `centerX + dx` with `dx,dy` in `BURN_IN_GRID`/`BURN_IN_STEP_PX` steps (`HeroFaceConfig`); nothing measures clip against the round chord on any screen. Reached only when `_sleeping && _burnIn` (`HeroFaceView.mc:61-65`). This is the one place a small-round AMOLED could clip an always-on clock without any test noticing. Not verified to actually clip.
- **O2 "monkeyc would just flag statically"**: unsupported. Whether the compiler warns on an unused parameter was not verified (no SDK run, no Garmin doc citation found). Treat as a hand-edit with compile check needed anyway. Also the IB cites the line correctly (:38) but miscounts call sites (2 real: :45, :52).
- **HSTS commentary in IB body**: says "safe since HSTS only affects HTTP(S)" and `includeSubDomains`; main deliberately dropped it (preface). Not a code issue.
- Performance numbers in IB (182KB heaviest page, 95KB lightest, 18-45ms DCL): not reproducible read-only; the built `dist/assets` fonts are 88.0K latin + 84.2K latin-ext + 33.7K vietnamese (only latin/latin-ext fetched per page, others skipped via unicode-range per IB), consistent with ~182KB for a page pulling the latin file plus CSS/HTML/images. Plausible, not measured here.

### Inferences
- If the maintainer wants O1, do only the sleep half (route `HeroFaceSleep` through `HeroFaceDraw.text` plus one test case that sets `_sleeping`/`_burnIn` and drives `onUpdate`, capturing `misfits`). Skip the seconds half.

### Gaps
- No SDK/API doc was consulted for the unused-parameter warning; no compile was allowed.
- Whether `HeroFaceDraw.text` behaves identically when a clip is set (partial update) was not checked in the SDK; it only calls `dc.drawText` first, so runtime behaviour should be unchanged, unverified.

## Q3. Ranked list of what is genuinely still worth doing

### Takeaway
Everything left is small. Nothing here is a defect a user would hit today. The best gain per effort is closing the Cyrillic decision with one doc line, then the sleep-path fit coverage.

### Cited Findings
De-duplicated, ranked by gain/effort. Effort is my estimate. "Needs sim" = needs local monkeyc/simulator.

| Rank | Item | One-line action | Effort | Notes |
|---|---|---|---|---|
| 1 | O4 Cyrillic fallback | Add one line to `verden-site/DESIGN.md` typography stating `Українська` intentionally falls back to `system-ui` (recommended (b); no Cyrillic subset exists in the package) | 5 min | Design decision; doc-only; removes an unowned known break of the "one grotesque" rule. |
| 2 | O1 (narrowed to sleep) | Send `HeroFaceSleep.mc:21` through `HeroFaceDraw.text` and add one `(:test)` that drives `onUpdate` with `_sleeping && _burnIn` (drift position varies with minute, so also loop `clock.min` values or assert at max offsets) | 45-90 min, needs sim | Only unmeasured text path in HeroFace. Overlaps code-quality F1/F6 (always-on/burn-in) and the review's Limits (no device proof). Skip the seconds swap (redundant). |
| 3 | D4 vite lockfile | `cd verden-site && npm update vite` (then confirm build) | 2 min | Only if 8.3.1 exists; verify with `npm outdated`. Trivial gain (patch). |
| 4 | O2 dead param | Drop `layout` from `HeroFaceFooter.iconSize` and its 2 call sites (:45, :52) | 5 min, needs compile | Cosmetic; must compile since not sure monkeyc flags it. |
| 5 | D8/CSP enforce | After deploy-preview shows no violations, rename `Content-Security-Policy-Report-Only` to `Content-Security-Policy` in `netlify.toml:26` | 10 min plus a deploy check | Already tracked as HeroSet go-to-market C2 (per IB preface) and in code-quality Outcome; not a new item, just the biggest remaining hardening. Note report-only has no `report-uri`, so violations only show in the browser console. |
| 6 | N1 profiling | Profile `onPartialUpdate` power/`onUpdate` allocations on a device | hours, needs device | Real but unmeasured; overlaps review "partial-update cost unmeasured". |
| Decline | O3 divide guard | None. Close as not a bug (`done` short-circuit, see Q2) | 0 | Optionally add a one-line comment; no behaviour change. |
| Decline | V4 `noUncheckedIndexedAccess` | None | 0 | No hit today. |

IB housekeeping (not product work): rewrite the "Done" bodies for D1/D3/D8 to match main, delete the vite "shipped" claim or re-apply it, refresh stale line numbers (`HeroMissionBars` :106 -> :120, `HeroFaceView` :108 -> :111, `HeroFaceLink` :86 -> :95, strings comment 76-77 -> 79-80), and move V6 from "not done" to "done".

Overlaps with `/Users/mbp/dev/garmin/reports/Verden code quality review.md` (CQ), for the final report to merge:
- D5/D6 (OG/canonical/sitemap) = CQ W6, fixed (CQ Outcome "W2-W13 Fixed"). Same work, don't list twice.
- D8 (CSP) and D3 (Permissions-Policy) = CQ W12; both list the same open step (report-only -> enforcing after deploy preview).
- D7 (`complication_label`) = CQ S13 (`translatable="false"`, fixed); IB's "no action needed" claim predates it.
- D9 (screenshot size) = CQ W14 (the "240 declared as 454" part is fixed via `size`; the "Screenshot pending" always-on slot and re-capture at 454 px remain open in CQ; still visible via `AppSections.tsx:31`).
- D10 (DESIGN.md accents) overlaps CQ F5 (HeroFace plan.md "4-6 accents", stale docs), which is also fixed.
- O1 (draw bypass, harness gap) overlaps CQ F1/F6 (always-on/burn-in on `venu`, unverified) and CQ F7 (test gaps in `HeroFaceScreenFitTest`), and the "must not churn" note that `HeroSetDraw.text` is the only draw path.
- N2 (StoreTest budget) = CQ S18, fixed.
- V1 "source clean" conflicts in tone with CQ's 20+ HeroSet findings (S1 uncaught `updateComplication`, S5 flag reset, etc.). The IB did not look at typing (`-l 3`), so its "clean" is scoped to house-rule layering, not robustness.
- V6 preload and V4 tsconfig: no CQ equivalent; unique to IB.
- O3 and O2 and O4: no CQ equivalent; unique to IB.

### Inferences
- After housekeeping the IB adds only four genuinely unique open items (O1-sleep, O2, O4, D4). Everything else is either shipped or already in CQ.
- "Simulator passing is not device proof" (repo house rule) applies to items 2 and 4; no item here has device evidence.

### Gaps
- No prior session's device evidence for HeroFace sleep-path fit; assumed none (per `MEMORY.md` FR965 all-day wear only).
- Effort figures are estimates, not measured.
