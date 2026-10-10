# Verification of "Sun Window build plan"

Audit of `reports/Sun Window build plan.md` (315 lines), 2026-10-05. Read-only, fresh context, sceptical. Evidence is file:line in this worktree unless marked otherwise. "SDK" means the local `~/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/`. Nothing here ran on a watch or in a simulator. The only commands run were reads and `jq`/`rg` over the SDK data.

**Bottom line.** The platform facts hold up well: 22 of the 23 spot-checks pass and one is misattributed. The plan's weak points are four. A storage-shape bug (high) and a dependency cycle around OD-6 (high). The plan never schedules a commit or a merge, but the site deploy and "the worn commit" both need one (medium). And four of the 22 "owner decisions" are agent defaults or are not decisions at all.

## 1. Verified correct (brief)

| # | Claim (plan line) | Evidence | Result |
|---|---|---|---|
| V1 | 74 of 75 API 5.1+ `compiler.json` files list no `widget` type; only `etrextouch` does (l.51) | `jq` over `Devices/*/compiler.json`, max `partNumbers[].connectIQVersion` ≥ 5.1: 75 devices, `widget` only in `etrextouch` (5.1.1) | Correct |
| V2 | 66 target watches = 75 − 8 Edge − `etrextouch` (l.53, P3.1) | Same scan: edge1040/1050/540/550/840/850/explore2/mtb = 8 | Correct |
| V3 | All 66 targets are live-glance (`liveUpdates: true`) (l.67) | `Devices/<id>/simulator.json`: 66 × `true` | Correct |
| V4 | 32 KB glance ids: instincte40mm, instincte45mm, instinct3solar45mm (l.34, OD-9) | `compiler.json` `appTypes[type=glance].memoryLimit = 32768` for exactly these three; the other 71 glance devices have 65536 | Correct |
| V5 | Lowest simulator watchdog is fr255s at 120,000 (P6.4) | `simulator.json` `watchdogCount`: fr255 and fr255s 120000, all others 240000 | Correct (tied with fr255) |
| V6 | `getSettingsView()` "is only applicable to watch faces and data fields" (l.57) | SDK `doc/Toybox/Application/AppBase.html` (local copy of the cited URL) | Correct |
| V7 | Properties topic: "Device applications, widgets, and audio content providers all accept user input…" (l.57) | SDK `doc/docs/Core_Topics/Properties_and_App_Settings.html` | Correct, verbatim |
| V8 | "Automatically switch app type to watch-app when compiling a widget and targetting a 4.x device" since 4.0.0 (l.51) | SDK `doc/docs/Readme/History.html`, in the 4.0.0 block | Correct |
| V9 | "must create a glance if you want the widget to show in the glance list" (l.51) | SDK `Core_Topics/Application_and_System_Modules.html` | Correct |
| V10 | `watch-app` permission map is a strict superset of `widget` (l.51) | SDK `bin/projectInfo.xml` `<permissionMap>`: widget ⊂ watch-app; watch-app adds ComplicationPublisher, Fit, FitContributor, Notifications, PersistedLocations, SensorLogging | Correct |
| V11 | `uvIndex` / `cloudCover` are API 5.1.0 (l.30) | SDK `Toybox/Weather/CurrentConditions.html` and `HourlyForecast.html`: both "Since: API Level 5.1.0"; `observationTime` 3.2.0 | Correct. Note: `uvIndex` is documented as a Float in the range [0–10] |
| V12 | Math trig returns Double only for Long/Double input; `Math.PI` is Float (l.164) | SDK `Toybox/Math.html` ("Float if input is Number or Float, Double if input is Long or Double"); `bin/api.mir:4420` `const PI as Float = 3.1415927f` | Correct |
| V13 | `api.mir` has no glance flag (l.67) | `rg ':glance' bin/api.mir` → none | Correct |
| V14 | The test runner disables the watchdog (l.164) | `History.html` 2.3.x: "Disabled watchdog timer for the RunNoEvil Test Framework" | Correct |
| V15 | TwoSuns `cosHourAngle`, `halfDay`, `declinationAndEquationOfTime` exist; Float only; once per local date (l.162) | `TwoSuns/source/TwoSunsSun.mc:41,63,70`; `fSin`…`fAcos` `.toFloat()` at :95–113 | Correct (see E-L1 on zenith) |
| V16 | Per-instant day count `days = dayNumber − 10957 − 0.5 + (minuteOfDay − offset)/1440` (l.164) | `TwoSunsConfig.mc:21–22` (10957 = 2000-01-01 00:00 UT); at minuteOfDay = 720 the formula reduces exactly to `TwoSunsSun.mc:17–18` | Correct |
| V17 | NONE TODAY condition (implied by `cosHourAngle(45, …) > 1`) | cos 45 / (cosφ cosδ) − tanφ tanδ > 1 ⇔ cos(φ−δ) < cos 45 ⇔ \|φ−δ\| > 45 ⇔ 90 − \|φ−δ\| < 45. A 45° "all day" case is impossible (needs \|φ+δ\| ≥ 135) | Correct |
| V18 | Fixture seasons: Vilnius Apr 15–Aug 27 (135), Reykjavik May 16–Jul 26 (72); named cases 10:26–16:16, 12:08–14:59, Singapore 86.588; ceil/floor; Sydney 04-19 knife edge | `research_notes/Vitamin D window/solar_elevation_fixtures.md:36,41,42,61,27,329,334,342,348` | Correct |
| V19 | `TwoSunsPlace`: round to 0.1, `isUsable`, `fromStorage` | `TwoSuns/source/TwoSunsPlace.mc:10–54` | Correct, with the shape caveat in E-H1 |
| V20 | HeroSet glance pattern: `(:glance)` AppBase, empty `onStart`, `disableGlanceCheck` getters, `FONT_GLANCE`, `drawState`, `getSubscreen` guard, "outlive midnight"; `glance-scope-check.sh` loops `monkey store` | `HeroSet/source/app/HeroSetApp.mc:8,18–23,31`; `HeroSetGlanceView.mc:16,34,45–48,54`; `HeroSet/tools/glance-scope-check.sh:21` | Correct |
| V21 | `docker/ciq-test.sh` defaults to `monkey.jungle`, falls back to `monkey.simple.jungle` (l.152) | `docker/ciq-test.sh:8` | Correct |
| V22 | `compile_sweep.sh` lines 15–18 are the two-manifest diff (P3.2) | `TwoSuns/tools/compile_sweep.sh:15–18` | Correct, but incomplete (E-L3) |
| V23 | Site: one folder + registry; `applicationCategory: 'HealthApplication'` hard-coded; `App` type has `platform` and `storeUrl?`; deploy on push to main (~30 s) | `site/src/entry-server.tsx:18`; `site/src/apps/types.ts:18,23`; `site/CLAUDE.md:10` | Correct |
| V24 | ROADMAP: 12.x, 13.x and 14.x are in use, 15.x is free, M12 is free; "main's ROADMAP has moved" | Worktree `ROADMAP.md` uses 12.1 and 14.1. The main checkout's `/Users/mbp/dev/garmin/ROADMAP.md` also uses 13.1–13.12 (status 2026-10-05). The highest milestone is M11 | Correct |
| V25 | Task count 66; 13 phases | 8+5+6+3+6+6+7+4+2+5+4+5+5 = 66 | Correct |
| V26 | Glance areas 151×63, 140×79, 299×148, 359×130, 154×61; `FONT_GLANCE` 19 px (fr255s) to 42 px (fr965); theme card up to `#525252` | `design_and_ux.md:90–105,111`; HeroSet `codebase_fit_and_impact.md:295` | Consistent with the notes (simulator-sourced) |
| V27 | No studio code has logged `uvIndex`/`cloudCover` on a watch | `device-test/TwoSuns-weather-RESULTS.md` logs condition, temperature and observation age only | Correct |
| V28 | Probes are `watchface` type | `.../probe/on-watch/manifest-{N,P}.xml:3`, `Two Suns temperature research/probe/manifest.xml:3` | Correct |

Not reproduced: the 2026-10-04 compile probe results (widget→watch-app on `etrextouch`, `-l 3` scope messages), forum threads 351754 and 368041, the store label "Device App", and the Garmin review-guidelines wording. The plan labels each of these correctly as [compile probe], [forum] or a fetch summary.

## 2. Errors

| ID | Sev | Location | Problem | Evidence | Exact fix text |
|---|---|---|---|---|---|
| E-H1 | **High** | P5.3 (l.183) vs P4.3 (l.170) and the ADR-010 closure (l.69) | P5.3 stores `[lat, lon, epoch]`, but P4.3 copies `TwoSunsPlace.fromStorage`, which returns null unless `stored.size() == 2`. The glance reads only through `fromStorage`, so it would show "open once" forever, and so would the full view on a cold launch. No task ever reads the epoch. | `TwoSuns/source/TwoSunsPlace.mc:45`; `TwoSunsSources.mc:144` stores 2 elements | P5.3: replace "store `[lat, lon, epoch]` only when moved more than 0.1 degree" with "store `[lat, lon]` (the TwoSuns shape, key `place`) only when `shouldReplace` says it moved more than 0.1 degree; no timestamp in v1 (a staleness rule would be a new ADR)". Add to P4.3 Done: "a test that `fromStorage` accepts exactly what `SunWindowSources` writes". |
| E-H2 | **High** | OD-6 (l.71, l.84), P5.2 (l.182), P6.3 (l.194) | Dependency cycle: P5.2 needs OD-6, OD-6's stated input is P6.3, and P6.3 needs P6.1, which needs P5.\*. P2.5's "answer OD-6 if the mockup shows disagreement" covers only one branch. | Plan l.71 "P6.3's build-stats numbers are the input"; l.182; l.192–194 | P5.2: replace "(if OD-6 says so) current conditions" with "current conditions behind one `(:glance)` constant `GLANCE_READS_WEATHER` in `SunWindowConfig`, default `false` (ADR-010)". P6.3: "measure the build with the constant `false` and `true`". OD table row OD-6, Blocks column: replace "P5.2, P6.3" with "P6.5, P7.1 (the build that is worn)". |
| E-M1 | Med | l.67, ADR-010 rationale | Misattributed evidence. HeroSet's `onStart` crash was a `(:glance)` **scope** violation (`HeroSetStore` is not glance code), which its doc calls "not a glance bug". Garmin's Glances topic says glance mode supports "accessing application storage". The decision (the glance never writes) is fine; the stated reason is wrong. | `HeroSet/docs/development.md:93`; SDK `Core_Topics/Glances.html` ("Best Practices") | Replace the sentence "HeroSet's lessons also say the glance must not write Storage: …" with: "The glance has no reason to write: the full view owns the place. HeroSet's `onStart` crash ('Class not available to Glance', [HeroSet development.md][hsdev]) was a scope violation, the class `tools/glance-scope-check.sh` catches, not a Storage ban; Garmin's Glances topic allows storage access in glance mode [SDK doc]." |
| E-M2 | Med | P7.4 (l.209) | "New app, tick Beta App, no price" does not say which app id. The studio's only Beta upload used its **own** beta app id, not the production UUID. P7.4 also has no build input. | `/Users/mbp/dev/garmin/device-test/README.md:15` ("Pro, Beta App id (`31bfdf1c-...`)", "no (own beta id)") | P7.4 Inputs: "OD-16; P7.1; a beta manifest copy with its own UUID (Days To Go precedent, device-test README); never upload the production UUID as a beta". |
| E-L1 | Low | l.162 | TwoSuns `cosHourAngle` and `halfDay` take a **zenith**, not an elevation. `45.0` works only because zenith 45 equals elevation 45. A copied call with another elevation would silently be wrong. | `TwoSunsSun.mc:62–70`; `TwoSunsConfig.mc:29–31` (`ZENITH_*`) | Add: "(both take a zenith angle; 45° zenith = 45° elevation, so name the constant `ZENITH_WINDOW = 90 − ELEVATION_DEG`)". |
| E-L2 | Low | P4.1–P4.4 | `TwoSunsSun`, `TwoSunsPlace` and `TwoSunsWeatherSource` are `(:pro)`-annotated, and `TwoSunsSettings` has `(:pro)`/`(:free)` twins. A verbatim copy compiles out. | `TwoSunsSun.mc:10`, `TwoSunsPlace.mc:7`, `TwoSunsWeatherSource.mc:9`, `TwoSunsSettings.mc:26–58` | Add to P4.1 Done: "no `(:pro)`/`(:free)` annotation survives the copy (`rg '\(:(pro\|free)\)' SunWindow/source` empty)". |
| E-L3 | Low | P3.2 | `compile_sweep.sh` also defaults to both jungles at line 25 (`monkey.free.jungle monkey.jungle`), so deleting lines 15–18 alone leaves a broken default. | `TwoSuns/tools/compile_sweep.sh:25` | "delete the two-manifest diff (lines 15–18) and set the default jungle list (line 25) to `monkey.jungle`". |
| E-L4 | Low | l.75 | The quoted "any permission with a privacy cost" is in neither ROADMAP nor TwoSuns status. It comes from the template `SunWindow/docs/plan.md`. TwoSuns lists "the `Positioning` permission" explicitly. | `ROADMAP.md:14`; `TwoSuns/docs/status.md:34`; `SunWindow/docs/plan.md` Phase 1 | Replace the quote with: names, prices, icons, looks, uploads, translations, site deploys ([ROADMAP][roadmap]); "the `Positioning` permission", any upload, any phone or watch test ([TwoSuns status][tsstatus]). |
| E-L5 | Low | P10.1 Done | "no inline style" overstates the CSP. Inline `style=""` attributes are allowed; inline `<style>` and `data:` are blocked. | `site/CLAUDE.md` Rules, CSP bullet | "CSP rules kept (no inline `<style>` element, no `data:` URI, no external origin)". |
| E-L6 | Low | l.23 | "NONE TODAY the normal state for most of the northern year" over-generalises. The fixtures say this for Vilnius and London; Phoenix has 247 in-window days. | `solar_elevation_fixtures.md:329,423` | "…the normal state for most of the year at Vilnius and London latitudes (above about 50° N)". |
| E-L7 | Low | P0.2 | `SunWindow/CLAUDE.md:42` says "`Sun Window` prefix" (with a space). The class prefix is `SunWindow`. P0 fixes line 3 only. | `SunWindow/CLAUDE.md:42` | Add to P0.2: "and line 42 to `SunWindow` prefix". |

## 3. Inconsistencies

| ID | Sev | Where | Issue | Fix |
|---|---|---|---|---|
| I-M1 | Med | P10.4 vs P11.2 | The site deploys on push to `main` (`site/CLAUDE.md:10`). The pages exist only on this worktree branch, and the only merge (P11.2) depends on P11.1, which depends on P10.4. P10.4 cannot be done as ordered. | New task P10.0 (Owner): "merge or cherry-pick `site/src/apps/<slug>/` + `index.ts` (with P10.2's docs) to `main`". Or move P11.2's merge before P10.4. Recommend one merge of the whole worktree after P9.5, since DayArc pages went live before release (site/CLAUDE.md table). |
| I-M2 | Med | Every task; P11.1 "On the worn commit" | `git status` shows all of `SunWindow/`, both reports and both note folders untracked, and every task forbids agent commits. "The worn commit" cannot exist without a commit, and the plan names no commit point. | Add owner commit checkpoints: end of P0, after P2.6, at the P7.1 build (the worn commit, hash recorded in `device-test/README.md`), and at P11.1. |
| I-M3 | Med | Spine (l.104) vs P11.1 | P8 (strings) and P9.1 (final launcher icon) may overlap P7, so the package can change after the wear day. That breaks "On the worn commit". | Either P8.1 and P9.1 precede P7.1, or P11.1 adds: "a delta since the worn commit limited to `resources*/strings` and the launcher icon is accepted; any `source/` change needs a new wear day or the owner's waiver". |
| I-M4 | Med | P0.1, P5.5 | ADR-008, 009 and 010 are written "Open (proposed)" and P5.5 builds on ADR-009, but no task makes them Active and no gate names who does. | P1.5 Done: "ADR-007 Active or parked; **ADR-008 to ADR-010 Active** (SDK-sourced technical corrections; an agent may activate them once the owner's go is recorded)". |
| I-L1 | Low | OD table vs task inputs | ODs that block a task but are missing from its Inputs column: OD-4 in P5.4; OD-1 in P9.1–P9.3 (only the phase prose names it); OD-16 and OD-17 in P11.1; OD-13 in P0.7 (it writes the Location claim). | Add each to the Inputs column. |
| I-L2 | Low | "Mockup … before Monkey C" (l.137) vs P1.1 and P2.1 | Both are Monkey C written before P2.5. The plan scopes the rule to `SunWindow/source/` (l.3), but a strict reader of root CLAUDE.md can flag it. | One sentence in P1 and P2: "throwaway probes outside `SunWindow/source/` are measurement, not product code, and are exempt from the mockup-first rule". |
| I-L3 | Low | ADR-002 title "v1 is a widget" vs ADR-008 `watch-app` | Read alone, the ADRs look contradictory. | P0.1: add to ADR-002 "(widget-style: glance + full view; manifest type per ADR-008)". |
| I-L4 | Low | ADR-002 context vs ADR-008 | ADR-002 says `Notifications` is unavailable to `widget`. Under `watch-app` it is available (V10), so the stated platform reason for "no nudge" disappears and only the owner's reason remains. | Note in ADR-008: "watch-app type makes `Notifications`/`Background` available; v1 still declares neither (ADR-002, owner)". |
| I-L5 | Low | P0.2 Done | Copying the 22-row OD table into `SunWindow/CLAUDE.md` duplicates it. ROADMAP is the studio's single to-do list. | "CLAUDE.md lists the open ODs by number and links the report; ROADMAP (P0.6) holds the items". |

Binding owner decisions: no contradiction found. No Pro surface (the "Deferred to any later Pro" row at l.45 is internal only). No nudge, `Background` or `Notifications`. No watch-face work. The accent is in Free. The DAG has no other cycle; every OD referenced exists (OD-1..22), and ADR-011 and ADR-012 are introduced where first used.

## 4. Vague tasks (cold-agent test)

| Task | What is missing |
|---|---|
| P0.6 | "rebase on main first": the worktree has no commits and agents may not rebase. Should read "draft the entries against the main checkout's current `ROADMAP.md` (13.x is in use there); the owner applies them". |
| P1.1 | The pass conditions for the probe's own log format are unstated (what the glance draws when `getInfo()` throws). "Zero warnings at `-w -l 3`" may be unrealistic: HeroSet notes `-l 3` prints many unrelated type errors (`glance-scope-check.sh:5–6`). Say "zero scope messages; type errors listed". |
| P2.3 | "Instinct 166/176 with keep-out": name the keep-out source (`getSubscreen()` values from P2.1). |
| P4.4 | "overcast band" has no starting number. Give one (e.g. `cloudCover >= 90`) so tests can be written before OD-18. |
| P5.3 | "accuracy at or above `QUALITY_LAST_KNOWN` (tune)": with what data? Say "start at `QUALITY_LAST_KNOWN`; D6 decides". |
| P6.5 | "find a glance capture route" is open-ended, and P9.2 needs a glance store screen from it. Give a fallback: "if none is found in a timebox (e.g. 1 h), the glance store screen is a `drawState` bitmap from a test, labelled as such in `screenshots.md`". |
| P12.4 | "Read recorded" where? Name the ROADMAP id (15.x) and the status.md section. |

## 5. Gaps

| Gap | Why it matters | Suggested task text |
|---|---|---|
| DST on the wrist | Europe/Vilnius DST ends **2026-10-25**. Neither wear day is told to cross it, and P4.5 tests DST only in the simulator. | P7.1 checklist: "if the wear window spans 2026-10-25, check the state and times the morning after; otherwise mark DST simulator-only". |
| Travel / stale place / time-zone change | The glance uses the stored place with the **new** offset. If the user never opens the full view after travelling, the state is wrong without warning. Nothing in the spec covers it. | Spec line (P0.2): "v1 has no staleness rule: the place updates whenever the full view opens; after travel the glance may be wrong until then". Add a Support FAQ line in P10.1. |
| Memory note at release | P0.8 only. Approval and the app id never reach memory. | P12.1: "update `memory/sun-window-widget.md` (app id, approval date, store URL)". |
| ROADMAP ticks | ROADMAP is the single to-do list, but only P0.6 touches it. | "Each phase end: tick its 15.x items (owner commits)". |
| Package checks | P11.1 checks permissions and product count. It does not check that no `Background`/`Notifications`/`Communications` permission or `(:background)` code is present (binding ADR-002). | Add to P11.1: "`rg -n 'Background\|Notifications\|Communications' SunWindow/manifest.xml SunWindow/source` empty". |
| Glance store screen route | P9.2 lists "the glance" as a required screen, but P6.5 says no capture route is known. | See P6.5 fallback above. |
| Second accent route on mono | P5.5 hides the menu on MONO, so on Instinct `onMenu` has nothing to show. Behaviour is unspecified (ignore, or a plain "About" line). | P5.5: "on MONO `onMenu` returns false". |
| `etrextouch`/Edge exclusion check | P0.2 excludes them; nothing verifies the manifest list after P3.1. | P3.1 Done: "manifest has 66 ids (or 63 without Instinct); no `edge*`/`etrextouch`". |

Checked and not a gap: app UUID (P3.1), product list (P3.1), permissions text (P0.7, P10.1), privacy page (P10.1), launcher icon placeholder and final (P3.1, P9.1), worktree merge (P11.2, mis-ordered: I-M1), Instinct (OD-9), midnight (P4.5 plus recompute per draw), southern hemisphere (P4.5), polar (closed form; a 45° "all day" is impossible, V17), ±180 and null island (P4.3). Location sources: Position only, with no Activity or Weather fallback. That matches spec l.54: both are null on the FR965 (`device-test/LocationProbe-RESULTS.md` Q1/Q2), so it is not a gap.

## 6. Over-scope (ponytail lens)

| Item | Cut / simplify | Add back when |
|---|---|---|
| `epoch` in the stored place (P5.3) | Drop it. It is also the E-H1 bug. | A staleness rule is decided |
| P4.4: 5-minute cache plus "keep last good" | Read the weather fresh each minute; null means no demotion. A kept "last good" can demote with stale cloud data, which is wrong in the direction the spec cares about. | Build stats or the watchdog show reads are costly |
| P4.4: hourly-entry preference plus 3-hour current-conditions fallback | One read path: `getCurrentConditions()` for both views, which also settles OD-6 with no disagreement. Use hourly only if D2 shows current `uvIndex` is null while the hourly one is not. | D2 says so |
| P4.2 return-date bisection plus P6.4 timing for it | Pick OD-5 = "nothing beyond the sentence". No search code. | Reviews ask "when does it come back" |
| `cloudCover` cut-off alongside `uvIndex` | If D2 shows the watch's `uvIndex` already falls with cloud, UV < 3 alone is enough: one constant, one test row. | UV is often null or does not track cloud |
| P6.7, a second owner look sitting | Fold into P9.5 (`owner_approvals`): same screens, one sitting. | The built screens differ visibly from the P2.5 mockup |
| P8 translations | English only (DayArc precedent); P8 and OD-22 become dormant. | The owner wants languages |
| P12.3 poll id | Trivial, keep. | — |
| OD-19, OD-20 | Not decisions (see the table): remove from the OD list. Use 15.x/M12 by default; ADR-004 is already Active. | — |

Kept deliberately (not over-scope): the G1 spike (cheapest risk cut), the glance and full-view fit tests (the studio's bezel lesson), the P6.6 reviewer (studio gate 17), status.md gates.

## 7. Decision picks

The test for "truly owner" is the two never-decide lists. ROADMAP.md:14: names, prices, icons, looks, uploads, translations, site deploys. TwoSuns/docs/status.md:34: `Positioning`, any upload, any phone or watch test, a site deploy, unread translations. ROADMAP's NEXT ACTION says its Decide list is "down to three items", and this plan adds 22. Moving the agent-defaultable ones to "agent default, owner may override" shrinks that load to about 14.

| OD | Truly owner? | Pick | One-line reason |
|---|---|---|---|
| OD-1 name/slug | **Owner** (name) | Keep "Sun Window" / `sun-window`; run a quick trademark search before P9 | The store search is clean, and the slug freezes at P10, so decide before then |
| OD-2 go/no-go | **Owner** (product) | Go, if D6 gives a place; the weather filter is optional (geometry-only is still a product) | A small free build whose difference is restraint; SunIQ is paid |
| OD-3 vitamin D | **Owner** (legal/brand) | A: nowhere | Lowest guideline 1b/1c review risk; B can be added to the description later without a new package |
| OD-4 times in full view | Owner (interprets his own "open/closed only") | Yes, full view only | Clock times are not a dose; the spec default; reversible |
| OD-5 NONE TODAY content | Wording: owner (look). Content: agent default | Wording only, no extra number or date | Zero new code, no timing risk; add the return date later if asked |
| OD-6 sky filter in glance | Agent default (technical, measured) | Yes: one shared `getCurrentConditions()` read in both views, settled after D2 and P6.3 | Glance and app always agree; no hourly allocation; small object |
| OD-7 look approval | **Owner** (looks) | — (approve at P2.5) | Binding studio rule |
| OD-8 accent list / default / reason line | List and default: **owner** (looks). Reason line: agent default | The roster's Free six, Sky `#55AAFF` default; reason line "Opens 11:10" before, "Cloud cover" for the sky, nothing after closing | Roster precedent; a time is more useful than a cause before opening |
| OD-9 Instinct | Agent default with evidence (scope, reversible before upload) | Include, if P6.3 shows the glance well under 32 KB and fit passes | TwoSuns and HeroSet precedent (Instinct included, simulator-only label) |
| OD-10 icons and images | **Owner** (icons) | — | Never-decide list |
| OD-11 languages | **Owner** (translations) | English only for v1 | DayArc precedent; ADR-005 wording risk in machine drafts |
| OD-12 store category | Agent default (owner confirms at upload) | Utility | Two Suns precedent; lowers 1b/1c "health app" reading |
| OD-13 `Positioning` + "collect data: No" | **Owner** (permission) | Accept; "No", with the Two Suns Pro wording | Without it the app cannot work (Activity and Weather location are null on the FR965) |
| OD-14 monetization answer | **Owner** (studio-wide ROADMAP 2.8) | "No" | Free, no in-app payments; same as the other Free listings |
| OD-15 JSON-LD category | Agent default | Optional `category?` on `App`, defaulting to `HealthApplication`; Sun Window uses `UtilitiesApplication` | About 3 lines; keeps the site from labelling a "not a health tool" app as health |
| OD-16 Beta round trip | **Owner** (upload) | Check after approval | The on-watch menu is the primary route; a beta needs its own id (E-M2) and an upload |
| OD-17 FR965-only evidence | **Owner** (risk acceptance, watch tests) | Accept, with MIP and Instinct labelled "simulator only" | Two Suns gate 6 precedent (owner accepted submitting without a full wear day) |
| OD-18 UV/cloud cut-offs | Agent default from D2 data; owner informed | UV < 3 demotes; `cloudCover` only if D2 shows UV ignores cloud (then ≥ 90) | UV 3 is the sourced sunburn line; one constant is easier to explain |
| OD-19 ROADMAP ids | Not a decision (housekeeping) | 15.x and M12 | Free on main (V24); ROADMAP says add new work at the end of the right section |
| OD-20 keep 45° | Not open (ADR-004 is Active) | Keep; drop from the OD list | Nothing blocks on it |
| OD-21 deploy and upload timing | **Owner** (site deploy, upload) | Merge and deploy the site, check the 3 URLs, upload the same day | The reviewer needs live support and privacy URLs |
| OD-22 native reads | **Owner** (translations) | Not applicable if OD-11 = English | No translated store copy in v1 |
