# Build Sun Window in thirteen gated phases

Sun Window v1 is a free Connect IQ app. It has a glance and a full-screen view and answers one question: is the sun at or above 45 degrees right now. The answer is **OPEN**, **CLOSED** or **NONE TODAY**. The plan below covers it from idea to post-approval in **13 phases (P0 to P12) and 69 stable-numbered tasks**, and every task lists the files it touches, its inputs, its done-criteria and whether the owner or an agent does it. Three things in the current spec are wrong for the platform, and the plan fixes each with a proposed ADR before any code is written: on every API 5.1+ watch a "widget" is compiled as a **watch-app with a glance**, so the manifest should say `watch-app` with `getGlanceView()` [SDK doc, SDK data, compile probe]; **`getSettingsView()` only works for watch faces and data fields**, so the on-watch accent setting has to be a `Menu2` opened from `onMenu()` [SDK doc]; and the glance should **work out the state from the clock and the stored place every time it draws**, never store a "last-known state" and never write Storage [studio code, inference]. Two gates run in parallel and must both pass before any Monkey C goes into `SunWindow/source/`: **G1**, a one-day device spike on the owner's FR965 (are UV and cloud cover ever filled in, does location work from the app and the glance, does the glance draw at all), and **G2**, the studio's design gate (a mockup at real pixel sizes, a browser screenshot, then the owner's approval of the look). The plan lists 20 decisions. Six are technical and **picked by the agent** (reversible, owner may override). Fourteen stay with the owner, each with a **recommended pick**; an agent never records an owner pick as decided. **Nothing about Sun Window has run on a watch.** Every simulator result below is simulator-only, and the only device evidence it cites comes from other studio apps on the FR965.

**Revision 2 (2026-10-05): verified by a fresh-context agent** ([plan_verification.md][verif]): 23 checks passed against the SDK data, the SDK docs, the fixtures and the repo. The fixes applied in this revision are listed below.

| Fix | What changed |
|---|---|
| Stored-place format (high) | P5.3 now stores `[lat, lon]`. The copied `TwoSunsPlace.fromStorage` accepts exactly two elements (`TwoSuns/source/TwoSunsPlace.mc:45`), so the old `[lat, lon, epoch]` would have left the app on "open once" forever. |
| OD-6 dependency cycle (high) | The glance's weather read is now one config constant. P6.3 measures memory with it on and off, and OD-6 now blocks P6.5 and P7.1, not P5.2. |
| Merge and commit points | P0.9 is a new owner commit checkpoint. P10.0 merges before the site deploy. P7.1 records the hash of the commit that is worn, and P11.1 limits what may change after it. |
| ADR activation | P1.5 now makes ADR-008 to ADR-010 Active. |
| Evidence corrections | The ADR-010 Storage reasoning, the zenith/elevation naming, the `(:pro)` annotations and `compile_sweep.sh` line 25 are corrected. |
| Gaps closed | Travel and stale place, the DST change on 2026-10-25, the package check for `Background`/`Notifications`, the glance screenshot fallback, `onMenu` on Instinct, the Beta App id, and memory/ROADMAP upkeep. |
| Scope cut | One weather read path (UV below 3, current conditions). No weather cache. No return-date search. P8 stays dormant while v1 is English only. The built-screen look-check (P6.7) and the icon (P6.8) share one owner sitting before the wear build. |

**Evidence tags used throughout:**

| Tag | Meaning |
|---|---|
| [SDK doc] | Garmin documentation in the local SDK 9.2.0 copy |
| [SDK data] | Device and compiler data files shipped with the SDK |
| [compile probe] | A throwaway build made on 2026-10-04 that was never run |
| [studio code] / [studio doc] | This repo's code or docs |
| [sim] | Connect IQ simulator |
| [FR965 device] | The owner's real watch, with another app |
| [forum] | Garmin forum posts, paraphrased |
| [owner] | An owner instruction |
| [inference] | The planner's reasoning, not a source |

## What v1 is, and what it deliberately is not

The product rule fits in one line. At each moment, compute the sun's height from the date, the time and a stored location, then compare it with one named constant: 45 degrees ([ADR-004][adr]). **OPEN** means the sun is at or above 45 degrees now and the sky filter passes; **CLOSED** means today's highest sun reaches 45 degrees but not now (before opening, after closing, or demoted by the weather); **NONE TODAY** means the noon sun stays below 45 degrees. Weather can only demote OPEN to CLOSED, never promote it, using the watch's own `Weather.getCurrentConditions().uvIndex` (below 3 demotes; null means no demotion). `cloudCover` (90 or above demotes) is used only if device check D2 shows `uvIndex` is null or does not fall with cloud. Both cut-offs are starting values to tune on a wrist, not sourced numbers ([spec][spec]). The owner fixed the boundaries on 2026-10-04: no watch face and no notification, nudge or background process ([ADR-002][adr]), and Free only, with no Pro, price or upgrade text ([ADR-003][adr]) [owner].

The 45-degree rule is a display convention, not a fact of biology. It makes NONE TODAY the normal state for most of the year at Vilnius and London latitudes (above about 50° N); Phoenix has 247 in-window days. In the 2026 fixture data, the noon sun reaches 45 degrees only on **Apr 15 to Aug 27 in Vilnius (135 days)** and **May 16 to Jul 26 in Reykjavik (72 days)** ([fixtures][fix]). That is why NONE TODAY gets the same design care as OPEN.

| Feature | v1 status | Evidence / source |
|---|---|---|
| Glance: state word plus a non-colour shape mark | **In** | [spec][spec]; design note §2 [inference on the shape] |
| Full view: state word, shape mark, today's open and close clock times | **In**; the times wait on owner decision OD-4 ([ADR-006][adr]) | [spec][spec] |
| Three states, worked out on the watch in `Double` precision | **In** | [ADR-004][adr] |
| Weather demotion: `uvIndex` below 3 from current conditions (API 5.1.0+); `cloudCover` only as a D2 fallback | **In**; dropped if device check D2 shows the fields are always empty | [spec][spec]; [WPA §6][wpa] [SDK doc] |
| NONE TODAY: a sentence only, no return date and no extra number | **In** (agent pick on OD-5 content; owner sets the wording at P2.5) | [verification §6][verif] |
| Place refresh after travel: no staleness rule; the place updates whenever the full view opens | **In**, stated in the spec and the support FAQ | [verification §5][verif] |
| Location from `Position.getInfo()` in the full view, rounded to 0.1 degree and stored on the watch | **In** (`Positioning` permission) | [spec][spec]; [TwoSuns ADR-005][tsadr] [FR965 device] |
| First-run, finding-location, no-fix and no-weather states, each a plain sentence | **In** | [design note §4][dux]; [SunWindow/CLAUDE.md][swc] |
| Accent colour as a list (append-only ids), on the watch and in Garmin Connect, Free tier | **In**; hidden on 1-bit Instinct | [studio CLAUDE.md "Studio direction"][rootc] [owner]; [owner-steering][steer] |
| Instinct E / 3 Solar (32 KB glance, 1-bit screen) | **In, provisional** (agent pick OD-9: kept if the glance stays well under 32 KB in P6.3 and the fit tests pass) | [WPA §7][wpa] [SDK data] |
| Languages beyond English | **Not in v1** (recommended for OD-11; owner decides) | [release note §6][rls] |
| Notification / nudge, `Background`, `Notifications` | **Not in v1** | [ADR-002][adr] [owner] |
| Pro build, price, "Pro adds" text, upgrade link | **Not in v1** | [ADR-003][adr] [owner] |
| Anything on a watch face (TwoSuns / DayArc indicator) | **Not in v1** | [ADR-002][adr] [owner] |
| Minutes, dose, IU, burn time, goal, streak; any state called good, safe or enough | **Never** | [spec][spec]; [ADR-005][adr] |
| Colour keyed to a state (green OPEN, red CLOSED, or a glance theme chosen by state) | **Never** | [spec][spec]; [design note §2][dux] |
| "Vitamin D" in the title, screenshots or watch UI | **Never**. The description body waits on OD-3 | [ADR-005][adr] |
| Network calls, phone companion, account, analytics | **Never** | [spec][spec] |
| API 3.2 to 5.0 watches (Venu 2, FR945/745/245, fēnix 6) | **Deferred** (no `uvIndex`/`cloudCover`) | [spec][spec] [SDK doc] |
| Edge cycling computers and eTrex Touch | **Out** (not watches; eTrex Touch has no glance) | [WPA §1, §7][wpa] [SDK data] |
| "Worse later" hourly line, sun-height list | **Deferred** to any later Pro | intake report, superseded by [ADR-003][adr] |

## Three spec corrections, proposed as ADR-008 to ADR-010

### ADR-008 (proposed): declare `type="watch-app"` with a glance, not `widget`

The spec says "A Connect IQ **widget** with a glance and a full-screen view" ([spec][spec]), and `SunWindow/CLAUDE.md` line 3 says "A Garmin widget". The platform no longer has that type on any target watch. **In 74 of the 75 API 5.1+ device files, `compiler.json` lists no `widget` app type**; only the handheld `etrextouch` does ([WPA §1][wpa]) [SDK data]. Since SDK 4.0.0 the compiler has "automatically switch[ed] app type to watch-app when compiling a widget and targetting a 4.x device" ([SDK release notes][sdkhist]) [SDK doc], and Garmin's core topic says an app "must create a glance if you want the widget to show in the glance list" ([Application and System Modules][sdkapp]) [SDK doc]. The 2026-10-04 compile probe built a `type="widget"` manifest cleanly for `fr965` and `instincte40mm` and treated it as `watch-app` even for `etrextouch` ([WPA §1][wpa]) [compile probe]. HeroSet already ships the `watch-app` plus `getGlanceView()` shape ([HeroSet/manifest.xml][hsman]) [studio code], the `watch-app` permission map is a strict superset of the `widget` one ([WPA §1][wpa]) [SDK data], and a forum thread shows the type of a released app is hard to change ([forum 351754][f351754]) [forum], so the choice must be right before the first upload.

**Proposed decision:** `type="watch-app"`, `minApiLevel="5.1.0"`, permission `Positioning` only, entry class `SunWindowApp` with both `getInitialView()` and `getGlanceView()`. The spec's "What it does" changes "widget" to "app with a glance (the studio may still call it a widget)", and line 3 of `SunWindow/CLAUDE.md` changes to match. The user-visible consequence is that the app is reachable from the app launcher as well as the glance list, so the full view must work when opened cold with no glance having run first ([design note §2][dux]) [forum, inference]. How the store labels the type ("Device App" in a snippet-grade source) is confirmed only on the upload form ([WPA §1 gaps][wpa]). The `watch-app` type makes `Notifications` and `Background` available, so ADR-002's platform reason for "no nudge" goes away. v1 still declares neither permission, because the owner decided so (ADR-002). ADR-002's title gains "(widget-style: glance + full view; manifest type per ADR-008)".

### ADR-009 (proposed): accent setting through `onMenu` and `Menu2`, not `getSettingsView`

The spec's Settings table says the accent reaches the watch through "on-watch `getSettingsView` (Customize)". It adds "Sideloaded builds get no phone settings, so `getSettingsView` is required" ([spec][spec]). Garmin's AppBase reference says the opposite for this app type: `getSettingsView()` "is only applicable to watch faces and data fields" ([AppBase][sdkappbase]) [SDK doc]. The Properties topic adds that "Device applications, widgets, and audio content providers all accept user input that allow them to implement on-device settings in the app" ([Properties and App Settings][sdkprops]) [SDK doc].

The research notes disagree on this point. `repo_patterns_and_reuse.md` §6 and §10 tell the builder to copy DayArc's `getSettingsView` plus `DayArcAccentDelegate`, and `design_and_ux.md` §3 repeats "getSettingsView is required". **The SDK document wins.** Every studio `getSettingsView` is in a watch face, and HeroSet, the only watch-app, has none ([repo note §6][rpr]) [studio code].

**Proposed decision:** one `Application.Properties` key `Accent` (a number), so Garmin Connect can edit it for store installs, and a `Menu2` with one "Accent" list pushed from `SunWindowDelegate.onMenu()`. **Reuse DayArc's delegate logic** (clamp, `Properties.setValue`, `requestUpdate`, `popView`) from [DayArc/source/DayArcAccentDelegate.mc][dayarcdel], **but mount it from `onMenu`, not `getSettingsView`**. `onSettingsChanged()` only requests a redraw. On mono Instinct the menu item is hidden and the settings folder is left out of that product's `resourcePath` ([owner-steering][steer]; [TwoSuns/monkey.free.jungle][tsjungle]). Phone settings never reach a sideloaded `.prg` ([device-test README][devtest]) [studio doc], but an in-app menu should still work there, so the on-watch accent check can fit the FR965 wear day and only the Garmin Connect round trip needs a Beta App or a store install [inference]. A new device check, **D11**, asks which gesture triggers `onMenu` on two-button touch models such as Venu and vívoactive, since no Garmin text names it ([WPA §4 gaps][wpa]). A kit follow-up for the owner, outside this plan: the kit's `platform-facts.md` "Settings" entry needs the same face-only gloss.

### ADR-010 (proposed): the glance recomputes at each draw, never writes Storage, never calls Position by default

The spec's data-sources table has Storage hold "Location, last-known state for the glance" ([spec][spec]). A stored state goes stale across midnight unless it carries its own date. That is device check D7's failure class, and HeroSet already met it: "a live glance can outlive midnight" ([HeroSetGlanceView.mc][hsglance]) [studio code].

Computing is cheaper. **All 66 target watches use the live glance model** (`liveUpdates: true`) ([VDW platform §6][vdwp]) [SDK data]; the compiler's scope model blocks none of `Position`, `Weather`, `Storage` or `Math` from glance code (`api.mir` has no glance flag, and the probe compiled them at `-l 3`) ([WPA §2][wpa]) [SDK data, compile probe]; and the sun maths is a closed form of a few dozen trig calls ([WPA §8][wpa]) [inference]. The glance has no reason to write, because the full view owns the place. HeroSet's `onStart` crash ("Class not available to 'Glance'", [HeroSet development.md][hsdev]) [sim] was a scope violation, the kind `tools/glance-scope-check.sh` catches, not a ban on Storage. Garmin's Glances topic allows storage access in glance mode [SDK doc].

**Proposed decision:** the `(:glance)` closure is `SunWindowApp`, `SunWindowGlanceView`, `SunWindowConfig`, `SunWindowCalendar`, `SunWindowLocalTime`, `SunWindowSun`, `SunWindowPlace.fromStorage`, `SunWindowState` and `SunWindowPalette`. The glance reads the stored place and the clock at every `onUpdate` and draws the result; with no stored place it shows the "open once" sentence; and it never calls `Position`, even though the compiler allows it, because whether that returns a fix on a watch is unmeasured ([WPA §5][wpa]). The spec drops "last-known state for the glance" from the Storage row and rewords D6 to "`Position.getInfo()` and `LOCATION_ONE_SHOT` from the full view, cold-launched and glance-launched; optionally `getInfo()` from a glance, for information only". It also gains **D12**, the idle timeout of an app launched from the glance, which is undocumented ([WPA §3][wpa]) and a "hard gate" in HeroSet's release contract ([design note §3][dux]).

**OD-6, whether the glance applies the sky filter (agent pick: yes).** If the glance reads geometry only while the full view also applies the filter, the two can disagree: the glance shows OPEN and the app shows CLOSED. Both views therefore read the same small `Weather.getCurrentConditions()` object; the hourly list is not read in v1. The read sits behind one `(:glance)` constant, `GLANCE_READS_WEATHER` in `SunWindowConfig`. P6.3 measures glance memory with it on and off, and it is switched off only if the 32 KB Instinct ids cannot afford it ([WPA §6][wpa]) [inference].

## Decisions: six picked by the agent, fourteen for the owner

The studio's "never decide alone" list covers names, prices, icons, looks, uploads, translations and site deploys ([ROADMAP][roadmap]), plus "the `Positioning` permission", any upload, and any phone or watch test ([TwoSuns status][tsstatus]) [studio doc]. A blanket "proceed" does not cover it ([TwoSuns status][tsstatus]).

Decisions outside that list are technical and reversible, so the agent picks them (the owner may override any of them). Every pick that touches the owner list stays a **recommendation**: an agent never records it as decided, and placeholders stay as `<WHAT>` under `owner_approvals` in `meta.yaml` ([listing template][ltpl]). OD numbers are stable. OD-19 and OD-20 are retired because neither is a decision: the 16.x ROADMAP id family and M13 are both free on main, and ADR-004 (45°) is already Active.

### Agent picks (applied in this plan; owner may override)

| OD | Decision | Pick | Why | Lands in |
|---|---|---|---|---|
| OD-5 | NONE TODAY content | A sentence only. No return date, no peak time, no extra number. The owner approves the exact wording at P2.5 | No search code and no watchdog risk; times-style numbers stay limited to OD-4. Add the date back if reviews ask "when does it come back" | ADR-006 extension, DESIGN.md |
| OD-6 | Sky filter in the glance | Yes. Both views read the same `getCurrentConditions()`, behind the `GLANCE_READS_WEATHER` constant | The glance and the full view always agree. Switch it off only if P6.3 shows the 32 KB Instinct glance cannot afford it | ADR-010 |
| OD-9 | Instinct E 40/45 and Instinct 3 Solar 45 | Include, lean: text plus a shape, no bitmap, accent menu hidden. Drop them if P6.3 or the fit tests fail | TwoSuns and HeroSet already ship Instinct; HeroSet's glance measured about 5.6 KB of 32 KB | new ADR-012, compatibility.md |
| OD-12 | Store category | Utility (owner confirms on the upload form, P11.3) | Two Suns precedent; avoids reading as a health app (guidelines 1b/1c) | `listing/paste.md` |
| OD-15 | Site JSON-LD category | An optional `applicationCategory` field on `App`, set to `UtilitiesApplication` for Sun Window; other apps unchanged | About 3 lines; stops the site calling a "for information only" app a health app | `site/src/apps/types.ts`, `site/src/entry-server.tsx` |
| OD-18 | UV and cloud cut-offs | Starting values: demote when `uvIndex < 3`. Add `cloudCover >= 90` only if D2 shows `uvIndex` null or not falling with cloud. Final values come after the P7 wear data | One constant and one test row; the starting numbers let tests be written now | `SunWindowConfig`, ADR-004 note |

### Owner decisions, each with a recommended pick

| OD | Decision | Recommended pick | Why | Lands in | Blocks |
|---|---|---|---|---|---|
| OD-1 | Name and slug | Keep **"Sun Window"**, `sun-window`. Run a quick trademark and domain check before P9 | The store search is clean; the slug freezes once the site URLs go into a listing | [ADR-001][adr] | P9, P10, P11 |
| OD-2 | Go / no-go against SunIQ | **Go to the P1 spike now**; build (P3+) only if D6 yields a place on the FR965 | The geometry alone is a product; SunIQ is paid; the spike costs one wear day | [ADR-007][adr] | P3 onward |
| OD-3 | "Vitamin D" mention | **A: nowhere** | Lowest review risk under guidelines 1b/1c; it can be added to the description body later, never the reverse | [ADR-005][adr] | P0.7, P9.4, P10.1 |
| OD-4 | Open and close clock times | **Yes, in the full view only**; the glance shows the word | Clock times are not a dose; this is already the spec default | [ADR-006][adr] | P2.5, P4.5, P5.4 |
| OD-7 | Look approval of the mockup | (no pick; studio rule) | — | new ADR-011, DESIGN.md | P3 |
| OD-8 | Accent list, default accent, CLOSED reason line | The roster's **Free six, Sky `#55AAFF` default**; reason line **"Opens 11:10"** before the window, **"Closed for today"** after it, **"Cloud cover"** when the sky demotes | Roster precedent; a cool default; the sun or sky is the subject (ADR-005) | ADR-011, DESIGN.md | P3.1, P4.6 |
| OD-10 | Launcher icon, cover, hero, device icons, store screens | (no pick; agent drafts, owner approves) | — | ADR-011, `listing/meta.yaml` | P9 |
| OD-11 | Languages | **English only for v1**; P8 stays dormant | DayArc precedent; a translation could turn "open" into "good" or "safe" | `listing/NOTES.md`, status.md | P8, P11 |
| OD-13 | Accept `Positioning`; "collect user data" answer | **Accept; answer "No"** (the place stays on the watch) | The app cannot work without a place on the FR965; Two Suns Pro precedent | release-contract.md, paste.md | P0.7, P9.4, P10.1 |
| OD-14 | Monetization answer | **"No"** (no ads, no payments), in the studio-wide wording from [ROADMAP 2.8][roadmap] | The app is free | paste.md | P9.4 |
| OD-16 | Garmin Connect settings round trip | **Check after approval**; no Beta App upload | The on-watch menu is the main route and is checked on the wear day; a beta needs its own app id | status.md gate 5 | P7.4, P11.1 |
| OD-17 | Accept FR965-only (AMOLED) evidence | **Accept**, with MIP and Instinct labelled "simulator only" in every report | The owner has only the FR965; Two Suns precedent | status.md, [spec][spec] | P11.1 |
| OD-21 | Deploy and upload timing | **Merge (P10.0), deploy the site, upload the same day** | The reviewer must be able to open the support and privacy pages | — | P10.0, P10.4, P11.3 |
| OD-22 | Native reads before translated store copy | Not applicable while OD-11 is English only | — | `listing/NOTES.md` | P12.5 |

## The task ledger, phase by phase

Paths in the ledger are relative to the worktree root unless absolute. "Agent" means any Claude session and "Owner" the owner's hands or decision. No agent stages, commits, stashes or merges unless asked, and simulator runs go through the container (`<Project>/tools/run_tests.sh`, `docker/shot.sh`), never the host simulator, unless the owner agrees ([root CLAUDE.md][rootc]). "Looked at" means a visual check of the PNG by eye, because scripted capture proves the capture ran, not that the screen is right ([docker/SIMULATOR.md][simdoc]). The dependency spine runs **P0** (docs and corrections, then owner commit P0.9) first; then **G1** (P1, device spike) and **G2** (P2, design) in parallel; then the owner's **OD-2** (go/no-go) and **OD-7** (look approval); then **P3 to P6** (build and simulator verification); then the final launcher icon (P9.1) and any strings (P8), so the package is final **before** **P7** (wrist verification on a recorded commit); then **P9.2 to P10** (listing, site), which need OD-1 and OD-3; then **P10.0** (owner merge), P10.4 (deploy), **P11** (release) and **P12** (after approval).

**Where agents write.** Every agent file write for this project goes inside the git worktree `/Users/mbp/dev/garmin/.claude/worktrees/vitamin-d-window-intake` (`<worktree>`, branch `worktree-vitamin-d-window-intake`), including the git-ignored `<worktree>/device-test/`, scratch probes, and the ROADMAP draft (`<worktree>/research_notes/Sun Window build plan/roadmap_draft.md`). The main checkout `/Users/mbp/dev/garmin` is read-only for agents; it changes only through the owner's merge. The only writes outside any repo are the session memory note and, at P2.6, the kit's `owner-steering.md` (a separate repo the owner commits).

**Commits and merges.** The whole worktree is untracked, and agents never stage, commit or merge. The owner commits at four points: end of P0 (P0.9), after P2.6, at the P7.1 build (the worn commit; its hash goes in `device-test/README.md`), and at P11.1. The owner merges the worktree to `main` at P10.0. **ROADMAP upkeep:** at the end of each phase, the agent drafts ticks for that phase's 16.x items, and the owner commits them.

**Probe exemption.** The throwaway probes in P1.1 and P2.1 live outside `SunWindow/source/`. They are measurement, not product code, so the "mockup before Monkey C" rule does not apply to them.

### P0 — Bring the scaffold to studio shape and record the corrections

The `SunWindow/` scaffold came from the design-kit template, not from the studio layout. It lacks `docs/status.md` and `docs/README.md`, uses `listing/README.md` where the studio uses `paste.md` + `meta.yaml` + `NOTES.md`, has no code at all, keeps an unfilled `docs/plan.md` that `publish-checklist.md` points to for "Implementation status", and its build line writes `bin/Sun Window.prg` with a space that breaks the unquoted shell command ([release note §1][rls]; [repo note §1][rpr]) [studio doc]. The template's checklist also still says "Tier and flip rule" in gate 14, although the day-45 flip rule was retired studio-wide on 2026-10-04 ([root CLAUDE.md][rootc]).

| ID | Task | Files touched | Inputs / depends on | Done when | Who |
|---|---|---|---|---|---|
| P0.1 | Write ADR-008, ADR-009 and ADR-010 as **Open (proposed)**, with the evidence above; add them to the ADR table. Gloss ADR-002's title "(widget-style: glance + full view; manifest type per ADR-008)". Record the six agent picks (OD-5, 6, 9, 12, 15, 18) in the ADRs they land in, marked "agent default, owner may override" | `SunWindow/docs/decisions.md` | This report; [WPA §1, §2, §4][wpa] | Three ADRs present, each citing its SDK page; the `GLANCE_READS_WEATHER` constant is named in ADR-010 | Agent |
| P0.2 | Apply the spec corrections: "widget" wording; Settings row to `onMenu` + `Menu2` + Properties; drop "last-known state" from Storage; weather row to `getCurrentConditions().uvIndex < 3` (cloud only as the D2 fallback); reword D6; add D11 (`onMenu` gesture) and D12 (glance-launch timeout); exclude Edge and `etrextouch` under Device reach; add the line "v1 has no staleness rule: the place updates whenever the full view opens; after travel the glance may be wrong until then" | `SunWindow/docs/spec.md`, `SunWindow/CLAUDE.md` lines 3 and 42 (`SunWindow` prefix, no space) | P0.1 | Spec and CLAUDE.md match the proposed ADRs; CLAUDE.md lists the open ODs by number and links this report; ROADMAP holds the items | Agent |
| P0.3 | Create `docs/status.md`. Fold in the 17 gates from `publish-checklist.md`: gate 6 "n/a, an app has no always-on mode"; gate 14 "Free, no price ([ADR-003][adr])"; gate 15 optional; new gate "device checks D2/D6/D7/D9/D11/D12"; new gate "no 'no location' wording while `Positioning` is declared". No checkboxes. Then archive or delete `publish-checklist.md` | `SunWindow/docs/status.md` (new), `SunWindow/docs/publish-checklist.md` | [release note §1 table][rls]; [TwoSuns/docs/status.md][tsstatus] as the model | status.md has gates, evidence slots, upload steps and the never-decide-alone list (adding `Positioning`) | Agent |
| P0.4 | Create `docs/README.md` (folder index); fix `docs/development.md` to `bin/SunWindow.prg` / `dist/SunWindow-<ver>.iq`; replace the unfilled `docs/plan.md` with a pointer to this report (move it to `docs/archive/` once built) and fix the "Implementation status" pointer | `SunWindow/docs/README.md`, `SunWindow/docs/development.md`, `SunWindow/docs/plan.md` | [root README "Layout"][rootreadme] | No path with a space; no `{{...}}` in plan.md; index lists every doc | Agent |
| P0.5 | Replace `listing/README.md` with `listing/paste.md` (form-order skeleton, `<WHAT>` placeholders) and `listing/meta.yaml` (copy the shape of `TwoSuns/listing-free/meta.yaml`, `status: drafted`); fix the What's New pointer in `SunWindow/CLAUDE.md` and the `CHANGELOG.md` header | `SunWindow/listing/*`, `SunWindow/CLAUDE.md`, `SunWindow/CHANGELOG.md` | [listing template][ltpl]; [TwoSuns/listing-free/meta.yaml][tsmeta] | No file references `listing/README.md` | Agent |
| P0.6 | ROADMAP entries: draft them against the **main checkout's** current `ROADMAP.md` (main has moved since this worktree branched; agents do not rebase). Add a 16.x Sun Window family in Decide / Your hands / Agent / Waiting, and an M13 ship sequence listing these P-ids | `/Users/mbp/dev/garmin/ROADMAP.md` (draft as a patch for the owner) | [release note §4][rls] | Entries drafted, tagged `[you]`/`[agent]`/`[both]` | Agent drafts, Owner applies |
| P0.7 | Fill the `release-contract.md` "May claim" and "Data and privacy" sections. May claim: sun height computed on the watch; rounded location stored on the watch only; the watch's weather read on the watch; no network. Must not: "no location", any health or safety claim, "vitamin D" outside OD-3's choice | `SunWindow/docs/release-contract.md` | [spec][spec]; [ADR-005][adr]; written against the recommended OD-3 (A) and OD-13 (accept, "No") picks, each line marked "pending owner" until decided | No `{{placeholder}}` remains | Agent |
| P0.8 | Update the memory note `sun-window-widget.md` with the corrections and the OD list | `/Users/mbp/.claude/projects/-Users-mbp-dev-garmin/memory/sun-window-widget.md` | P0.1 | Note names ADR-008 to ADR-010 and the open ODs | Agent |
| P0.9 | Commit checkpoint: commit `SunWindow/`, both reports and both notes folders on the worktree branch | git | P0.1–P0.8 | One commit on `worktree-vitamin-d-window-intake` | **Owner** |

### P1 — Gate G1: a one-day device spike on the FR965 before any build

The spec's stop test is explicit: stop if "the device spike fails (no location in a glance and no clean fallback, or `uvIndex`/`cloudCover` always null so the weather filter is dead weight), or the owner decides SunIQ makes it pointless" ([spec][spec]).

No studio code has ever logged `uvIndex` or `cloudCover` on a watch ([repo note §4][rpr]). No studio glance has ever run in glance mode on a watch ([HeroSet ADR-051 evidence][hsadr]). This spike therefore buys the most certainty for the least work, and it reuses probes that already exist: `research_notes/Body Battery and sun face research/probe/on-watch/PosProbe-*.mc` with `manifest-P.xml`, and `research_notes/Two Suns temperature research/probe/`, both `watchface` type today ([repo note §3, §4][rpr]) [studio code].

| ID | Task | Files touched | Inputs / depends on | Done when | Who |
|---|---|---|---|---|---|
| P1.1 | Build the spike probe. Copy the PosProbe and WeatherProbe sources and change the manifest to `type="watch-app"`, `minApiLevel 5.1.0`, `Positioning`. Add a `(:glance)` AppBase with a GlanceView that draws: `Position.getInfo()` accuracy and age; `uvIndex`/`cloudCover` from current conditions and the current-hour hourly entry; and a counter. The full view also tries `enableLocationEvents(LOCATION_ONE_SHOT)` and logs time to fix | `research_notes/Sun Window build plan/probe/` (new) | P0.2; [WPA §5, §6][wpa] | Zero glance-scope messages at `-l 3` (other type errors listed, not fixed); a thrown `getInfo()` or a null field draws as text (`ERR`, `null`), never a crash; runs in the container simulator without crashing (no GPS there) [sim] | Agent |
| P1.2 | Build an fr965 debug `.prg` into this worktree's git-ignored `device-test/` (never the main checkout), add a README row there, and write `checklists/SunWindow-spike-CHECKLIST.md`: D2 (sunny vs overcast, current and hourly), D6 (view cold, view from glance, glance first run), D7 part (glance appears in the glance loop from a sideload and draws), D12 (idle timeout, stopwatch), battery for information only | `<worktree>/device-test/README.md`, `<worktree>/device-test/checklists/` (git-ignored) | P1.1; [device-test README][devtest] | Checklist lists each pass condition from the spec table | Agent |
| P1.3 | Sideload and wear for one day, no other app swaps that day; fill in the checklist | FR965 | P1.2; [FR965 testing style][devtest] | Checklist filled; photos if possible | **Owner** |
| P1.4 | Record the results: status.md gate rows, compatibility.md, ADR-010 evidence; state whether any stop condition fired. Everything "FR965 only" | `SunWindow/docs/status.md`, `docs/compatibility.md`, `docs/decisions.md` | P1.3 | Each of D2/D6/D7-part/D12 marked passed, failed or unknown with the date | Agent |
| P1.5 | Go / no-go (OD-2), with the spike results and [ADR-007][adr]. After the owner's go is recorded, the agent marks ADR-008 to ADR-010 Active (SDK-sourced technical corrections) | `SunWindow/docs/decisions.md` | P1.4 | ADR-007 Active (go) or the project parked; ADR-008 to ADR-010 Active | **Owner** decides, Agent records |

### P2 — Gate G2: mockup, browser screenshot, owner look-approval

The studio rule is binding: "Mockup, browser screenshot and owner look-approval come before Monkey C" ([root CLAUDE.md][rootc]) [owner]. The rule exists because real fonts beat assumptions. On 176 px Instinct, `FONT_XTINY` and `FONT_TINY` both measure 23 px, and a mockup drawn at 15 px "promised a footer that does not fit" ([kit Instinct notes][kitinst]) [sim]. The kit's watch-design-lead skill owns this phase. The free-and-pro pair from WP2 is replaced by **glance + full view** ([design note §1][dux]).

No studio project has mocked a glance in HTML before, so drawing a glance card is new ([design note §1 gaps][dux]). The glance content area runs from **151×63 px (fēnix 7S) and 140×79 (FR255S) up to 359×130**, with **154×61 on Instinct E 40 mm**. Measured `FONT_GLANCE` runs from **19 px on the FR255S to 42 px on the FR965** ([design note §2][dux]; [HeroSet glance research][hsglres]) [SDK data, sim].

| ID | Task | Files touched | Inputs / depends on | Done when | Who |
|---|---|---|---|---|---|
| P2.1 | Font and area probe: a throwaway stub (scratchpad, not the repo) with a `(:glance)` GlanceView and a full view, run in the container on fr965, venu3, fenix7s, fr255s, venux1, instincte40mm and instincte45mm. Log the glance dc size, `FONT_GLANCE*` and `FONT_*` heights, the width of every candidate state word and sentence, and `getSubscreen()` on Instinct | scratchpad; results table into `SunWindow/DESIGN.md` draft | P0.2; [HeroSet glance research method][hsglres] | Table of measured sizes per device, tagged [sim] | Agent |
| P2.2 | Design brief per the watch-design-lead skill: read [owner-steering][steer]. Name the reserved role colours (white text, muted `#AAAAAA`, any horizon/track grey). Accent candidates are the Free six from the [accent roster][roster], checked against black, the AMOLED-dimmed form, any track (HeroFace 3:1 rule) **and the glance theme card up to `#525252`**, which the roster does not cover. Propose a cool default (Sky `#55AAFF` precedent) and never a warm or red one. State shapes must pass a greyscale render (e.g. filled disc = OPEN, outline = CLOSED, below-line or absent = NONE TODAY; outlines at least 2 px for 1-bit). Draft sentences for first-run, finding-location, no-fix and no-weather. List OD-4, OD-5 and OD-8 as questions | `SunWindow/DESIGN.md` (draft) | P2.1; [design note §4, §6][dux] | Brief names one focal read, the accent rule ("colour marks nothing"), every empty state and the open questions | Agent |
| P2.3 | Mockup: one self-contained HTML/SVG file at real pixel sizes. Glance on a themed card at 151×63, 140×79, 299×148 and Instinct beside the sub-window. Full view on 454 round, 240 MIP, 218 MIP, venux1 448×486 and Instinct 166/176, with the keep-out taken from P2.1's `getSubscreen()` values. Every state: OPEN; CLOSED before / after / cloud (OD-8 reason lines); NONE TODAY (sentence only, OD-5); open once; finding location; no fix; no weather. An accent strip. Title with a revision number | `SunWindow/docs/mockup.html` | P2.2 | All frames drawn with fonts from P2.1 | Agent |
| P2.4 | Screenshot with host headless Chrome (`--headless=new --screenshot`, the [DayArc render script][dayarcrender] mechanism), look at it, run an optional `impeccable` critique, iterate. Say "no detector ran" | `research_notes/Sun Window build plan/mockup-<date>.png` | P2.3 | A screenshot reviewed by eye; any fix applied | Agent |
| P2.5 | Look approval of the screenshot (OD-7); answer OD-4 and OD-8, and approve the NONE TODAY wording (OD-5) | — | P2.4 | Owner says approved, with a revision number | **Owner** |
| P2.6 | Record it: design ADR-011 (approval date and revision); fill `DESIGN.md` (tokens, type roles, accent id table with append-only ids, failure wording, Instinct section, craft sentence); append a dated line to [owner-steering][steer]; move the mockup to `docs/archive/`. Owner commit checkpoint follows | `SunWindow/DESIGN.md`, `SunWindow/docs/decisions.md`, `SunWindow/docs/archive/mockup.html`, `/Users/mbp/dev/watch-design-kit/knowledge/owner-steering.md` | P2.5 | DESIGN.md has no `{{...}}`; ADR-011 Active | Agent (owner commits, including the kit file) |

### P3 — Project skeleton and tooling

This phase starts only after OD-2 (go) and OD-7 (look) are answered. The studio's tooling depends on exact names: `docker/ciq-test.sh` **defaults to `monkey.jungle`**, falling back to `monkey.simple.jungle` ([repo note §7][rpr]) [studio code]. A free-only app needs one manifest and one jungle, and none of TwoSuns' tier-split machinery ([repo note §1][rpr]).

| ID | Task | Files touched | Inputs / depends on | Done when | Who |
|---|---|---|---|---|---|
| P3.1 | Manifest and resources. `manifest.xml`: new app UUID, `type="watch-app"`, `minApiLevel="5.1.0"`, `<iq:uses-permission id="Positioning"/>`, products = the 66 API 5.1+ watch ids minus OD-9's choice, language `eng` (more after OD-11). `monkey.jungle` with the Instinct `resourcePath` leaving out settings. `resources/strings/strings.xml` with `scope="glance"` on glance strings. `resources/settings/properties.xml` + `settings.xml` (one `Accent` list, ids from ADR-011). `resources/drawables/drawables.xml` + placeholder `launcher_icon.svg` (copied from TwoSuns) | `SunWindow/manifest.xml`, `monkey.jungle`, `resources/**` | P1.5, P2.6, OD-9 (agent pick: include) | `monkeyc -w --typecheck 3` builds for fr965 with only the launcher-icon notice; manifest has 66 ids (63 without Instinct) and no `edge*`/`etrextouch` | Agent |
| P3.2 | Tools. Copy `TwoSuns/tools/run_tests.sh` verbatim. `compile_sweep.sh`: delete the two-manifest diff (lines 15–18) and set the default jungle list (line 25) to `monkey.jungle`. `fit_all.sh` with the P2.1 device set. `fit_products.sh` as is. `glance-scope-check.sh` from HeroSet (jungle loop `monkey` only). `gen_sun_tests.py` adapted to read a TSV exported from `solar_elevation_fixtures.py`. Not needed: `check_free_package.sh`, `gen_settings.py`, `weather_conditions.sh` | `SunWindow/tools/*` | P3.1; [repo note §7, §10][rpr] | Each script runs against the skeleton | Agent |
| P3.3 | First test: `Math.sin(0.5d) instanceof Double` and `Math.sin(0.5) instanceof Float`. Written in the compile probe, never run ([WPA §8][wpa]) | `SunWindow/source/test/SunWindowMathTest.mc` | P3.2 | `tools/run_tests.sh fr965` prints PASSED [sim] | Agent |

### P4 — Pure logic and its tests

The solar maths reuses TwoSuns almost entirely. TwoSuns' `cosHourAngle(45.0, …) > 1` already means "the sun never reaches 45 degrees" and `halfDay(45.0, …)` is the window's half-width. Both take a **zenith** angle; 45° zenith equals 45° elevation, so name the constant `ZENITH_WINDOW = 90 − ELEVATION_DEG` to keep a future change correct. TwoSuns runs in 32-bit Float, evaluated once at local noon and rounded to whole minutes ([TwoSuns/source/TwoSunsSun.mc][tssun]) [studio code], so it must be ported to Double.

Three traps sit in the port. **`Math` trig returns a Double only when given a Long or Double**, and `Math.PI` is a Float constant ([Toybox.Math][sdkmath]; [WPA §8][wpa]) [SDK doc, SDK data]. The fixtures put the opening minute at the ceiling of the crossing and the closing minute at its floor ([fixtures][fix]). And an elevation at an arbitrary moment needs a per-instant day count, `days = dayNumber − 10957 − 0.5 + (minuteOfDay − offset)/1440`, which the repo note derived by reasoning and a fixture test must pin ([repo note §2][rpr]) [inference]. The test runner turns the watchdog off, so tests cannot catch a watchdog trip ([SDK release notes][sdkhist]). HeroSet 1.0.0 shipped a watchdog trip on a real FR965 that the simulator never showed ([HeroSet ADR-046][hsadr]) [FR965 device].

| ID | Task | Files touched | Inputs / depends on | Done when | Who |
|---|---|---|---|---|---|
| P4.1 | Copy `TwoSunsCalendar` and `TwoSunsLocalTime` with the needed constants; `SunWindowConfig` holds the keys, `ELEVATION_DEG = 45.0d`, a Double π, and the tolerances; all `(:glance)` | `source/SunWindowConfig.mc`, `SunWindowCalendar.mc`, `SunWindowLocalTime.mc` | P3.3; [TwoSuns sources][tssun] | Builds at `--typecheck 3`; the TwoSuns calendar tests are ported and pass [sim]; no `(:pro)`/`(:free)` annotation survives the copy (`rg '\(:(pro\|free)\)' SunWindow/source` is empty) | Agent |
| P4.2 | `SunWindowSun`: Double port of the NOAA/Meeus chain; `elevationAt(days, lat, lon, utcMin)`; `windowFor(date, place, offset)` returning open/close minutes (ceil/floor) or none; one refinement pass of declination at the edge. No return-date search (OD-5) | `source/SunWindowSun.mc` | P4.1; [repo note §2][rpr]; [fixtures][fix] | Generated fixture tests within **0.02 degrees and 1 minute**, never asserting an exact edge date (skip Sydney 2026-04-19). Named cases pass: Vilnius 2026-06-21 window 10:26–16:16; Vilnius 2026-03-20 none; Reykjavik 2026-07-15 window 12:08–14:59; Singapore 2026-03-20 13:00 at 86.588 (`acos` edge) [sim] | Agent |
| P4.3 | `SunWindowPlace`: copy `TwoSunsPlace` (round to 0.1, `isUsable`, `fromStorage`), also reject exact ±180 (forum placeholder report); `fromStorage` `(:glance)` | `source/SunWindowPlace.mc`, `source/test/SunWindowPlaceTest.mc` | P4.1; [TwoSunsPlace][tsplace] | Ported TwoSuns place tests plus the ±180 case pass; a test shows `fromStorage` accepts exactly what P5.3 writes (`[lat, lon]`) [sim] | Agent |
| P4.4 | `SunWindowWeather` (`(:glance)`): the TwoSuns weather-source guards (`has :Weather`, try/catch) around one fresh `getCurrentConditions()` read per draw, with no cache and no "keep last good" (stale cloud must not demote OPEN). A pure `demotes(uv, cloud)`: `uv != null && uv < UV_DEMOTE (3)`; `cloud >= CLOUD_DEMOTE (90)` only when `USE_CLOUD_FALLBACK` is true (set after D2); any null means no demotion (OD-18) | `source/SunWindowWeather.mc`, `source/test/SunWindowWeatherTest.mc` | P4.1; [TwoSuns weather source][tsweather]; P1.4 (D2) | Truth table incl. every null combination passes [sim] | Agent |
| P4.5 | `SunWindowState`: a pure function of (now, offset, place or null, weather tuple, locating flag) → OPEN / CLOSED(before, after, sky) / NONE TODAY / OPEN-ONCE / LOCATING / NO-FIX, plus times per OD-4 | `source/SunWindowState.mc`, `source/test/SunWindowStateTest.mc`, `source/test/SunWindowTestStates.mc` | P4.2–P4.4; OD-4, OD-5 | Tests cover midnight rollover, DST offsets (Vilnius +2/+3), southern hemisphere, null place and null weather; no `Time.now()` or `Position` inside tested code [sim] | Agent |
| P4.6 | `SunWindowSettings` (TwoSuns `within`/`read` for `Accent`), `SunWindowPalette` (id → colour, clamp, MONO), `SunWindowAccentTest` (64-colour channels; at least 3:1 on black; dimmed at least 3:1 and not equal to muted; not equal to reserved roles; at least 3:1 on the `#525252` card if the accent is drawn on the glance) | `source/SunWindowSettings.mc`, `SunWindowPalette.mc`, `source/test/SunWindowAccentTest.mc` | P2.6 (ADR-011 list) | Accent test passes for every shipped id [sim] | Agent |

### P5 — Views, the location reader and the menu

The glance follows HeroSet's pattern closely ([HeroSetApp.mc][hsapp]; [HeroSetGlanceView.mc][hsglance]) [studio code]: a `(:glance)` AppBase with an empty `onStart`, `(:typecheck(disableGlanceCheck))` on the foreground getters, `FONT_GLANCE` with no background fill (painting the card black loses the device's themed gradient ([forum 368041][f368041]) [forum]), a longest-first word list, `drawState` split out so tests can draw into a bitmap, and a `getSubscreen()` guard for Instinct. The default build is silent when glance code reaches foreground code, and **only a `-l 3` build reports "not available in all function scopes"** ([WPA §2][wpa]) [compile probe]. The full view runs one 60,000 ms repeating timer, started in `onShow` and stopped in `onHide`, and draws only in `onUpdate` ([WPA §3][wpa]) [inference].

| ID | Task | Files touched | Inputs / depends on | Done when | Who |
|---|---|---|---|---|---|
| P5.1 | `SunWindowApp`: `(:glance)`, empty `onStart`, `getGlanceView` → `[new SunWindowGlanceView()]`, `getInitialView` with `disableGlanceCheck`, `onSettingsChanged` → `requestUpdate`; `getGlanceTheme` fixed (DEFAULT or one chosen in ADR-011, never keyed to state) | `source/SunWindowApp.mc` | P4.* | `tools/glance-scope-check.sh` prints nothing | Agent |
| P5.2 | `SunWindowGlanceView`: per draw, read the place from Storage, the clock, and current conditions behind the `(:glance)` constant `GLANCE_READS_WEATHER` (default `true`, OD-6), then compute the state and draw the word plus the shape mark. Never write Storage, never call Position | `source/SunWindowGlanceView.mc` | P5.1 | Draws every state in the glance fit test (P5.6) | Agent |
| P5.3 | `SunWindowSources` (foreground only). The single `Position.getInfo()` call site: accept `position != null` and accuracy at or above `QUALITY_LAST_KNOWN` (starting value; D6 decides), and `isUsable`; round; store `[lat, lon]` (the TwoSuns shape, key `place`) only when `shouldReplace` says it moved more than 0.1 degree. No timestamp in v1; a staleness rule would be a new ADR. With no usable place, start `enableLocationEvents(LOCATION_ONE_SHOT)`, show LOCATING, and disable it in `onHide` | `source/SunWindowSources.mc` | P4.3; [TwoSunsSources][tssources] | A sim run with a PREP-seeded place shows the state; a run without one shows LOCATING then NO-FIX (the sim has no GPS) [sim] | Agent |
| P5.4 | `SunWindowView`, `SunWindowLayout`, `SunWindowDraw` (measured text, shorter wording before a smaller font), one-minute timer in `onShow`/`onHide` | `source/SunWindowView.mc`, `SunWindowLayout.mc`, `SunWindowDraw.mc` | P5.3, P2.6, OD-4 | Matches the approved mockup, or the mismatch is written in DESIGN.md as "what moved and why" | Agent |
| P5.5 | `SunWindowDelegate` (`onMenu` → accent `Menu2`; on MONO `onMenu` returns `false`; `onSelect` = retry location in NO-FIX), `SunWindowAccentDelegate` (DayArc logic: clamp, `Properties.setValue`, `requestUpdate`, `popView`) | `source/SunWindowDelegate.mc`, `SunWindowAccentDelegate.mc` | P4.6; ADR-009 | The menu opens and the colour changes in the sim on fr965 and venu3 (gesture noted for D11) [sim] | Agent |
| P5.6 | Fit tests: a glance fit test over every distinct glance content area with that product's fonts (HeroSet has 32 areas over 63 products); full-view `everyStateFitsThisDisplay` (no text outside, no overlap, nothing under the Instinct sub-window) | `source/test/SunWindowGlanceFitTest.mc`, `SunWindowScreenFitTest.mc` | P5.2, P5.4 | Pass on `tools/fit_all.sh` [sim] | Agent |

### P6 — Simulator verification and design review

| ID | Task | Files touched | Inputs / depends on | Done when | Who |
|---|---|---|---|---|---|
| P6.1 | Compile sweep of every manifest product in the build image (`CIQ_IMAGE=verden-ciq-build:9.2.0 docker/run.sh SunWindow tools/compile_sweep.sh`) | `SunWindow/docs/compatibility.md` | P5.* | Zero warnings except the launcher-icon notice | Agent |
| P6.2 | `tools/fit_products.sh` on every product | `SunWindow/bin/fit-products.txt`, `docs/compatibility.md` | P6.1 | All pass, recorded with commit and date [sim] | Agent |
| P6.3 | Glance memory: `--build-stats 0` (store-like `-r`) on fr965 and instincte40mm, with `GLANCE_READS_WEATHER` `true` and `false`; HeroSet measured about 5.4 KB of 64 KB ([HeroSet ADR-051][hsadr]) | `docs/compatibility.md`, ADR-010/012 evidence | P6.1 | Numbers recorded; OD-6 and OD-9 picks confirmed or switched (agent; under 50% of 32 KB keeps both) | Agent |
| P6.4 | Timing: run the full view without `-t` on `fr255s` (the lowest simulator watchdog count, 120,000) across a full-day compute | `docs/status.md` | P5.4 | No watchdog trip [sim]; device proof still pending (P7) | Agent |
| P6.5 | Screenshots: `docker/shot.sh SunWindow monkey.jungle <devices>` with `FAKETIME` per state and a `PREP` patch that seeds the stored place (the sim has no GPS). Check whether the round sim opens on the glance or the full view (unrecorded; only Instinct is known to open on the glance) and look for a glance capture route, timeboxed to 1 hour. Fallback: the glance store screen is a `drawState` bitmap rendered from a test, labelled as such in `screenshots.md` | `SunWindow/bin/shot-*.png` (not committed), `docs/development.md` (recipe) | P5.6, P6.3 (OD-6 settled) | Every state on the P2.1 device set looked at; canned sim weather never presented as a reading | Agent |
| P6.6 | Fresh-context `watch-design-reviewer` with DESIGN.md, decisions.md, spec.md and labelled screenshots; fix and repeat | `docs/status.md` gate 17 | P6.5 | `disposition: ship`, or every `fix` resolved | Agent (fresh context) |
| P6.7 | Look-check of the **built** screens (P6.5 screenshots), before the wear build, so no visual change lands after the worn commit. One sitting together with the P6.8 icon | — | P6.6 | Owner approves, or names changes | **Owner** |
| P6.8 | Final launcher icon before the wear build (moved up from P9.1 so the worn package is the shipped package); P8 strings likewise if OD-11 asks for languages | see P9.1 | P6.6, OD-1, OD-10 | Icon approved | Agent drafts, **Owner** approves |

### P7 — Wrist verification on the FR965

The success test asks for "a full day on at least one AMOLED and one MIP watch" ([spec][spec]). The owner has only the FR965 (AMOLED), so the MIP half is a stated gap (OD-17). Instinct stays simulator-only, which the owner accepts only "on the condition that every report says it is simulator-only" ([owner-steering][steer]) [owner].

| ID | Task | Files touched | Inputs / depends on | Done when | Who |
|---|---|---|---|---|---|
| P7.1 | Build `SunWindow-fr965.prg` (debug) into this worktree's `device-test/`, add a README row, write `checklists/SunWindow-CHECKLIST.md`: D2 again with the real filter; D6 reworded; D7 (state across local midnight, clipped bezel); D9 (three window edges for the owner's place against the `solar_elevation_fixtures.py` output for that place and date); D11 (`onMenu` on FR965); D12; the three states seen live; accent changed on the watch; travel note (the place updates when the full view opens); DST: if the wear window spans 2026-10-25 (Vilnius DST ends), check the state and times the next morning, otherwise mark DST simulator-only; battery for information only. The owner commits first; record the worn commit hash in the README row | `<worktree>/device-test/**` (git-ignored) | P6.7, P6.8 | Checklist written; commit hash recorded | Agent (owner commits) |
| P7.2 | Wear day on the production-equivalent build, no swaps | FR965 | P7.1 | Checklist filled | **Owner** |
| P7.3 | Record evidence, dated and "FR965 only"; MIP and Instinct "simulator only"; propose final UV and cloud cut-offs from the D2 readings | `docs/status.md`, `docs/compatibility.md`, `CHANGELOG.md` "Unreleased", ADR-004 note | P7.2 | Gates 2, 3, 7 and the D-gate filled | Agent; **Owner** confirms OD-18 |
| P7.4 | Optional Beta App upload ("new app, tick Beta App, no price") to check the Garmin Connect settings round trip | dashboard | OD-16 (recommended: skip); P7.1; a beta manifest copy with its **own** UUID (Days To Go precedent, `device-test/README.md`); never upload the production UUID as a beta | Accent changed from the phone reaches the watch | **Owner** |

### P8 — Translations, only if OD-11 says so (dormant under the recommended English-only pick)

The studio's other apps ship English plus 14 machine-drafted languages that no native speaker has read ([release note §6][rls]). For Sun Window the wording rules make a native read more important than for a face: no translation may turn "open" into "good" or "safe" ([release note §6][rls]) [inference]. HeroSet's 15-language sweep found Italian and Portuguese wider than the Instinct glance row ([HeroSet decisions][hsadr]) [sim].

| ID | Task | Files touched | Inputs / depends on | Done when | Who |
|---|---|---|---|---|---|
| P8.1 | Draft the 14 `strings.xml` files (`scope="glance"` kept, AppName in each), each checked against ADR-005's wording rules; adapt `check_strings.py` (drop TwoSuns ids and tier rules) and `fit_languages.sh` (drop TIER); run on fr255s, venux1 and instincte40mm | `SunWindow/resources-<lang>/strings/strings.xml`, `tools/check_strings.py`, `tools/fit_languages.sh`, manifest/jungle language lines | OD-11, P6.2 | Parity check and per-language fit pass [sim] | Agent |
| P8.2 | Approve shipping the on-watch drafts | `listing/NOTES.md` "Languages" | P8.1 | Recorded | **Owner** |

### P9 — Store images and listing text

Listing work waits for OD-1 (name), OD-2 (go) and OD-3 (vitamin D). Sun Window's listing differs from every live studio Free listing in two ways ([release note §2][rls]). It declares `Positioning`, so the Two Suns Free sentence "No location … It stores no place" must not be copied and the Two Suns Pro "Location" paragraph is the model. And it carries the guideline 1c line: Garmin's review guidelines say an app that does not diagnose, treat or prevent disease must be positioned as "intended for informational purposes only", and guideline 1b bars a "false sense of security" ([Garmin App Review Guidelines][garminrg]) (fetch-tool summary, not verbatim). Listing text rules from 2026-10-04 also apply: no refund wording, no language names or counts, no watch model names, no price ([ROADMAP 10.23][roadmap]) [owner].

| ID | Task | Files touched | Inputs / depends on | Done when | Who |
|---|---|---|---|---|---|
| P9.1 | Final launcher icon: one SVG mark, compiled per device (38–70 px across the 66 targets; the compiler scales), Instinct sized 62×62 or accepting the scaling notice | `resources/drawables/launcher_icon.svg`, `listing/src/mark.svg` | OD-1, OD-10; done at P6.8, before the wear build | Owner-approved mark; 1-bit render looked at | Agent drafts, **Owner** approves |
| P9.2 | Store screens via `docker/capture.sh SunWindow tools/listing_shots.sh` (faketime, 24-hour, PREP-seeded place, native pixels, under 150 KB each): OPEN, CLOSED with times, NONE TODAY, the glance, and Instinct if OD-9 keeps it | `SunWindow/tools/listing_shots.sh`, `listing/screens/`, `listing/screenshots.md`, `meta.yaml` `assets.screens` | P6.5 (glance route or fallback), OD-1, OD-9 | Each screen looked at; no "vitamin D"; canned data noted in `owner_approvals` | Agent |
| P9.3 | Cover 500×500 (under 300 KB, coloured ground, never black), hero 1440×720 (under 2048 KB), device icons 128×128 at 24-bit and 64-colour (`quantize64.py`) via the [DayArc render script][dayarcrender] | `listing/src/{cover,hero,icon}.html`, `listing/*.png`, `tools/render_listing_images.sh` | P9.1, OD-1 | Sizes checked with `ls -l`/`sips` | Agent renders, **Owner** approves |
| P9.4 | `paste.md` in form order. Title (OD-1). Description: the promise with the sun as subject, the three states, times (OD-4), the accent, the 1c line, the Location and Weather paragraph, the review sentence, "Multi-language support…" only if OD-11, support URL last. App Version 1.0.0. What's New blank. Category (OD-12). Collect data (OD-13). ANT+ No. Regional No. Email `hello@verden.watch`. Source URL blank. Review notification Yes. App Migration No. Monetization (OD-14). Hardware field = the bare site URL. `NOTES.md` claim table against the release contract | `listing/paste.md`, `listing/NOTES.md`, `listing/meta.yaml` | OD-1, OD-3, OD-12–14, P0.7; [Two Suns Free paste.md][tspaste] as the model | 10.23 greps clean; every claim traces to the release contract; no Pro lines | Agent |
| P9.5 | Answer the `owner_approvals` items (store assets and text only; the screens were approved at P6.7, so a visual change here means a new wear day or the owner's waiver) | `listing/meta.yaml` | P9.4 | All approvals dated | **Owner** |

### P10 — Site pages under the frozen slug

A new app on the site is one folder plus one registry line. Routes, prerendered pages, the sitemap and the nav all follow from the registry, and `appUrl()` is "the only place app URLs are spelled … must never change" ([release note §3][rls]; [site/src/urls.ts][siteurls]) [studio code]. The listing links `/<slug>/support/` and the reviewer must be able to open it without logging in, so the site goes live before upload ([TwoSuns status gate 12][tsstatus]).

| ID | Task | Files touched | Inputs / depends on | Done when | Who |
|---|---|---|---|---|---|
| P10.0 | Merge the worktree branch to `main` (whole worktree, after P9.5 and P10.1–P10.3; DayArc precedent: pages went live before release), with P11.2's registration rows drafted first | git | P9.5, P10.1–P10.3, P11.2 draft, OD-21 | Branch merged | **Owner** |
| P10.1 | Create `site/src/apps/<slug>/` with `app.ts` (`platform` describing an app with a glance, not "Watch face"; `storeUrl` unset), `facts.ts` (`appName` constant, `permissions: Positioning`, `languages`), `Landing.tsx`, `Support.tsx` (FAQ: open once, NONE TODAY in winter, why OPEN can show CLOSED on a cloudy day, after travel open the app once to update the place, the 1c line, changing the accent from the menu), `Privacy.tsx` (Location rounded to about 0.1 degree and kept on the watch, the current weather read on the watch with no cache, nothing shared; the Two Suns Pro model), `Mark.tsx`; register in `site/src/apps/index.ts`; `npm run build` | `site/src/apps/<slug>/*`, `site/src/apps/index.ts` | OD-1, OD-3, OD-13, P0.7 | Build passes; CSP rules kept (no inline `<style>` element, no `data:` URI, no external origin); no "no location" anywhere | Agent |
| P10.2 | Add a linked-apps row to `site/CLAUDE.md`, a "Sun Window specifics" section to `site/README.md`, a colour token in `site/src/styles/global.css` + `site/DESIGN.md`; optionally `site/src/site.ts` intro and `public/favicon.svg` | those files | P10.1 | Registry and docs agree | Agent |
| P10.3 | JSON-LD category (OD-15, agent pick): add the optional `applicationCategory` field to `App` in `types.ts`, read it in `entry-server.tsx`, set `UtilitiesApplication` for Sun Window | `site/src/apps/types.ts`, `site/src/entry-server.tsx` | OD-15 (owner may override) | Landing JSON-LD matches the pick; other apps unchanged | Agent |
| P10.4 | Deploy by push to `main` (GitHub Action, about 30 s); check that `/slug/`, `/support/` and `/privacy/` open without login | git | P10.0, OD-21 | Pages live | **Owner** |

### P11 — Release

Observed studio review times run from same day to about four days (Days To Go submitted 2026-09-26, approved 2026-09-28; Two Suns submitted 2026-09-27, approved 2026-09-28) ([release note §7][rls]; [TwoSuns CHANGELOG][tscl]). There is no published Garmin SLA.

| ID | Task | Files touched | Inputs / depends on | Done when | Who |
|---|---|---|---|---|---|
| P11.1 | On the worn commit (P7.1 hash): tests green and zero warnings; `monkeyc -e -r -f monkey.jungle -o dist/SunWindow-1.0.0.iq -y ~/.garmin-connectiq/keys/developer_key`; package check (permissions = `Positioning` only; `rg -n 'Background\|Notifications\|Communications' SunWindow/manifest.xml SunWindow/source` empty; product count against the manifest; no test code). Any `source/` change since the worn commit needs a new wear day or the owner's waiver | `SunWindow/dist/` (never committed), `listing/meta.yaml` `package` | P7.3, P9.5, P10.4, OD-16, OD-17 | Gates 8, 9 and 16 filled in status.md | Agent |
| P11.2 | Repo registration, drafted before the P10.0 merge: root `README.md` (project table, Layout header, Build line without a space), root `CLAUDE.md` project-table row (simulator-only and FR965 status), `reports/README.md` entries for "Vitamin D window" and this report | those files | P9.5 | Rows present before P10.0 | Agent drafts, **Owner** commits |
| P11.3 | Upload as a **new** app at `apps.garmin.com/developer/upload`, paste fields in order, attach images, read the form's Compatible Devices list (it is authoritative) | dashboard | P11.1, OD-21 | Submitted | **Owner** |
| P11.4 | The same day: `CHANGELOG.md` 1.0.0 entry (upload date, changes, ADRs); `meta.yaml` `app_id`, store URLs, `next.status: uploaded`; status.md "Uploaded" | `CHANGELOG.md`, `listing/meta.yaml`, `docs/status.md` | P11.3 | Files agree on date and id | Agent |
| P11.5 | If rejected: fix the named item, bump the version if the package changed, resubmit | per finding | Garmin's reasons | Resubmitted | Both |

### P12 — After approval

| ID | Task | Files touched | Inputs / depends on | Done when | Who |
|---|---|---|---|---|---|
| P12.1 | Open the live listing (title, description, images, device tab, links); record approval dates and the real device list | `CHANGELOG.md`, `meta.yaml`, `docs/status.md`, `docs/compatibility.md`, memory `sun-window-widget.md` (app id, approval date, store URL) | Approval | Dates, device list and memory note recorded | **Owner** opens, Agent records |
| P12.2 | Set `storeUrl` in `site/src/apps/<slug>/app.ts`; deploy | site | P12.1 | "Get it on the Connect IQ Store" shows | Agent edits, **Owner** deploys |
| P12.3 | Add the store id to `tools/store_poll_ids.txt` for the daily poll | `tools/store_poll_ids.txt` | P12.1 | A row appears in `poll.csv` | Agent |
| P12.4 | Day-30 and day-60 reads (ROADMAP 6.4 pattern); mine reviews for "wrong state" or "lost location"; evaluate the spec's success test, including the MIP gap | ROADMAP 16.x "Waiting" item, `docs/status.md` "Post-release" section | Time | Read recorded in both places | Both |
| P12.5 | Optional store-description translations, only with a native read (OD-22) | dashboard, `listing/NOTES.md` | OD-22 | Added per language | **Owner** |

## Conclusion

The research changes where the risk sits. Once ADR-008 to ADR-010 are adopted, the hard platform questions in the old spec are no longer open: the app type is a fact of the device data, the settings route is a fact of Garmin's own reference, and the stale-glance bug disappears if the glance computes rather than remembers. Three kinds of uncertainty remain, and the plan puts each in front of the work it could waste: **whether the watch actually fills `uvIndex` and `cloudCover`** and whether location and glances behave on a real wrist, which the one-day spike (P1) checks before any project code exists; **whether the design survives real fonts on a 151×63 glance and a 1-bit Instinct**, which the measured mockup gate (P2) catches just as early; and **product judgement only the owner holds**, since the go/no-go, the name and how NONE TODAY reads in winter decide whether the app has a reason to exist next to SunIQ.

The less obvious implication is that most of v1's engineering is already written elsewhere in the repo. The new code is small: the 45-degree window, `elevationAt`, the weather demotion and two views; the rest is reuse of TwoSuns, HeroSet and DayArc. The cost of the project therefore lies in the gates, not the build: two wear days on the only available watch, a look approval, and listing and site wording. Agents should treat the gates as the plan and the code as its smallest part.

[spec]: ../SunWindow/docs/spec.md
[adr]: ../SunWindow/docs/decisions.md
[swc]: ../SunWindow/CLAUDE.md
[wpa]: ../research_notes/Sun%20Window%20build%20plan/widget_platform_architecture.md
[dux]: ../research_notes/Sun%20Window%20build%20plan/design_and_ux.md
[rls]: ../research_notes/Sun%20Window%20build%20plan/release_listing_site.md
[rpr]: ../research_notes/Sun%20Window%20build%20plan/repo_patterns_and_reuse.md
[verif]: ../research_notes/Sun%20Window%20build%20plan/plan_verification.md
[vdwp]: ../research_notes/Vitamin%20D%20window/platform_and_permissions.md
[fix]: ../research_notes/Vitamin%20D%20window/solar_elevation_fixtures.md
[rootc]: ../CLAUDE.md
[rootreadme]: ../README.md
[roadmap]: ../ROADMAP.md
[ltpl]: listing-template.md
[roster]: ../research_notes/Free%20and%20Pro%20ladder/accent_roster.md
[steer]: file:///Users/mbp/dev/watch-design-kit/knowledge/owner-steering.md
[kitinst]: file:///Users/mbp/dev/watch-design-kit/knowledge/instinct-and-1bit-displays.md
[simdoc]: ../docker/SIMULATOR.md
[devtest]: file:///Users/mbp/dev/garmin/device-test/README.md
[tsadr]: ../TwoSuns/docs/decisions.md
[tsstatus]: ../TwoSuns/docs/status.md
[tsmeta]: ../TwoSuns/listing-free/meta.yaml
[tspaste]: ../TwoSuns/listing-free/paste.md
[tscl]: ../TwoSuns/CHANGELOG.md
[tssun]: ../TwoSuns/source/TwoSunsSun.mc
[tsplace]: ../TwoSuns/source/TwoSunsPlace.mc
[tssources]: ../TwoSuns/source/TwoSunsSources.mc
[tsweather]: ../TwoSuns/source/TwoSunsWeatherSource.mc
[tsjungle]: ../TwoSuns/monkey.free.jungle
[hsman]: ../HeroSet/manifest.xml
[hsapp]: ../HeroSet/source/app/HeroSetApp.mc
[hsglance]: ../HeroSet/source/ui/glance/HeroSetGlanceView.mc
[hsadr]: ../HeroSet/docs/decisions.md
[hsdev]: ../HeroSet/docs/development.md
[hsglres]: ../research_notes/HeroSet%20glance%20view%20research/glance_design_and_ux.md
[dayarcdel]: ../DayArc/source/DayArcAccentDelegate.mc
[dayarcrender]: ../DayArc/tools/render_listing_images.sh
[siteurls]: ../site/src/urls.ts
[sdkhist]: file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Readme/History.html
[sdkapp]: file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Application_and_System_Modules.html
[sdkprops]: file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Core_Topics/Properties_and_App_Settings.html
[sdkappbase]: https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html
[sdkmath]: https://developer.garmin.com/connect-iq/api-docs/Toybox/Math.html
[garminrg]: https://developer.garmin.com/connect-iq/articles/app-review-guidelines/Overview.html
[f351754]: https://forums.garmin.com/developer/connect-iq/f/discussion/351754/is-it-possible-to-change-the-app-type-of-a-released-app
[f368041]: https://forums.garmin.com/developer/connect-iq/f/discussion/368041/glance-background-gradient
