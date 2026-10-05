# Simulator QA, 2026-10-05: plan, how to run it, results

**Verdict:** DayArc and DayArc Pro are fit to submit tonight (no open defect above Low). Two defects found and fixed on the wrist photos (F1, F2) are verified here; one website defect (F7) and one tooling defect (F6) were fixed during the pass; one owner question (F3, ROADMAP 13.30).

A manual QA pass over all five watch projects in the Connect IQ simulator (SDK 9.2.0, container, `docker/`), run the evening
DayArc and DayArc Pro go to the store, so DayArc was tested deepest. **Simulator only: nothing here is device proof.** The
simulator's own data is canned (weather 66 °F, stress and Body Battery random, sun times fixed), so these tests prove layout,
states and logic, never readings. Real-watch evidence is in each project's `docs/status.md` (DayArc: the owner's photos, same day).

## How to run (every command from the repo root)

| Need | Command | Output |
|---|---|---|
| Face at given clock times, default settings, 12-hour (the simulator's default) | `docker/capture.sh <Project> /ciq-docker/qa_shots.sh <jungle> <device> <tag> 07:15 13:15 ...` | `<Project>/bin/qa/<tag>-<device>-<HHMM>.png` and `-window.png` (the window's status bar shows memory used/limit) |
| Same in 24-hour | a tag starting with `h24` (environment variables do not reach the container) | `...-24h.png` |
| Always-on, its drift, and the 24-hour burn-in verdict | `docker/capture.sh <Project> /ciq-docker/edge_states.sh <jungle> <device> ["YYYY-MM-DD HH:MM:SS"] [tag]` | `<Project>/bin/edge/` |
| An app driven through its screens (HeroSet) | `docker/capture.sh HeroSet tools/drive_screens.sh <device> btn store.jungle <p,s,q> <detected> glance all [act]` | `HeroSet/bin/drive-<device>-<step>.png` |
| Unit and screen-fit tests | `<Project>/tools/run_tests.sh <device> <jungle>`; HeroSet: `MC_FLAGS="" docker/run.sh HeroSet /ciq-docker/ciq-test.sh <device> monkey.jungle` | `PASSED (...)` |
| Every product compiles, zero warnings | `<Project>/tools/compile_sweep.sh` | `bin/compile-sweep-*.txt` |
| Package contents | `<Project>/tools/check_free_package.sh --build`; DayArc `tools/check_package.sh` | `OK` |
| Website on phones | `site/scripts/check-overflow.mjs` (see `site/README.md`) | "no horizontal overflow" |

Several containers run at once (each has its own simulator), but never two builds in the same project folder at once.
More on the simulator: `docker/SIMULATOR.md`.

## Device matrix (why each one)

| Device | Screen | Why |
|---|---|---|
| fr965 | 454 round AMOLED | the owner's watch; the reference |
| venu441mm | 390 round AMOLED | a smaller AMOLED, other fonts |
| fr265 | 416 round AMOLED | the middle size |
| fenix7 | 260 round MIP | a memory-in-pixel screen, 64 colours |
| fr255s | 218 round MIP | the smallest round screen in DayArc and Two Suns |
| venusq2 | 320 x 360 rectangle | the only non-round shape |
| instincte40mm | 166 1-bit, round window | black and white, the smallest memory (64 KB) |

## Test cases

### A. Every face (DayArc, HeroFace, Days To Go, Two Suns; both tiers)

| ID | What | How | Expected |
|---|---|---|---|
| A1 | Installs and draws | `qa_shots.sh` on each matrix device | the face draws within 25 s, no crash in the simulator log, no blank screen |
| A2 | Nothing clipped or overlapping | look at every capture; the unit fit test runs the widest strings | no text cut by the bezel or the Instinct window, no two rows touching |
| A3 | 12-hour clock | default captures (the simulator starts 12-hour) | hour without a leading zero (`1:15`, `8:00`), no AM/PM needed |
| A4 | 24-hour clock | tag `h24...` | `13:15`, `00:05` with the zero |
| A5 | Empty / first-day data | default captures (no history, zero steps, simulator nulls) | `--` or a sentence for a missing reading, `0` for a real zero, never a fake value |
| A6 | Always-on | `edge_states.sh` | dim grey, drifts each minute, no colour fields |
| A7 | Burn-in | `edge_states.sh` | "no screen burn-in detected", peak luminance well under 10% |
| A8 | Memory | the window capture's status bar on the Instinct (64 KB) and fr965 | well under the limit |
| A9 | All products build | `compile_sweep.sh` | every product, both tiers, zero warnings |

### B. DayArc specifics

| ID | What | How | Expected |
|---|---|---|---|
| B1 | Four windows | captures at 07:15, 13:15, 20:00, 02:00 | morning: Feels like + condition icon + high/low line; midday: Stress + gauge; evening: Body Battery + bolt + gauge; night: time and date only |
| B2 | Window boundaries | captures at 04:59, 05:00, 09:29, 09:30, 16:59, 17:00, 22:59, 23:00 | the window switches exactly at 05:00, 09:30, 17:00, 23:00 |
| B3 | Arc progress | the same captures | the arc fills through each window; empty at its start, nearly full at its end; none at night |
| B4 | Pro grid | Pro captures | pills fit; a missing value is `--`; an empty calendar is "None" |
| B5 | Accent setting | listing captures (accent blue, purple) | one hue for arc, hero icon, value and gauge |

### C. HeroSet (watch app)

| ID | What | How | Expected |
|---|---|---|---|
| C1 | Glance, first run | `drive_screens.sh` step `0b-glance` | "NO STREAK YET" and three empty bars |
| C2 | Dashboard, counting, end menu, review, save | `drive_screens.sh ... all` | each screen draws; START finishes, UP adjusts, START saves; the review's `+N` is the big number |
| C3 | Mission complete | seed `100,100,100` | green rows, "MISSION COMPLETE", the streak starts |
| C4 | Instinct | `instincte45mm` | the XP ring in the window; no `STREAK 0` row on day one |

## Results

Legend: PASS, FAIL (fixed: see Findings), NOTE (works as designed, worth knowing). Captures are in each project's
untracked `bin/qa/` and `bin/edge/`; re-run the commands above to see them.

### DayArc and DayArc Pro (final build, 2026-10-05 evening; 70 captures)

| Case | Result | Evidence |
|---|---|---|
| A1 installs and draws | PASS | 7 devices x 4 windows x 2 tiers, all drawn, no crash |
| A2 nothing clipped | PASS | all captures looked at; the unit fit tests pass on fr965, fr255s, venusq2, instincte40mm |
| A3 12-hour clock | PASS (after F1) | `7:16`, `1:16`, `8:01`, `2:01`, midnight `12:00` |
| A4 24-hour clock | PASS | `07:16`, `13:16`, midnight `00:00` with the date rolling to `Tue 06` (fr965, fr255s) |
| A5 empty data | PASS | Pro grid zeros on a fresh day (steps 0, calories 0, intensity 0); respiration `--` on the wrist photo |
| A6 always-on | PASS | dim time only, drifts each minute (fr965) |
| A7 burn-in | PASS | 24 h simulation: peak luminance 2.52%, no burn-in (limit 10%); the highest of the four faces |
| A8 memory | PASS, NOTE (F4) | store-style (`-r`) build on instincte40mm, limit 59.8 kB: Pro 38.0 / 37.6 / 37.1 kB (morning, midday, evening), Simple 32.5 / 31.4 / 31.4 kB |
| A9 all products build | PASS | compile sweep 72/72, both tiers, zero warnings |
| B1 four windows | PASS | Feels like + condition icon / Stress + gauge / Body Battery + bolt + gauge / time and date |
| B2 window boundaries | PASS | 05:00 morning, 09:30 midday, 17:00 evening, 23:00 night; one minute of load time, so each boundary was checked at its first minute |
| B3 arc progress | PASS | empty at a window's start, about 50% mid-window, nearly full at 16:59 and 22:59, none at night |
| B4 Pro grid | PASS, NOTE (F3) | pills fit on every device; Venu Sq 2 morning drops the grid to keep the "Feels like" label |
| B5 accent | PASS | listing captures in blue and purple: one hue for arc, icon, value and gauge |

### HeroFace, Days To Go, Two Suns (both tiers; 37 captures at 10:09, 12-hour, plus 24-hour)

| Case | HeroFace | Days To Go | Two Suns |
|---|---|---|---|
| Devices | fr965, venu441mm, fenix7, fr55, instincte40mm (Pro), instinct2 (Free) | fr965, venu441mm, fenix7, fr55, venusq2, instincte40mm / instinct2 | fr965, venu441mm, fenix7, fr255s, venusq2, instincte45mm |
| A1 draws | PASS | PASS | PASS |
| A2 nothing clipped | PASS | PASS (Venu Sq 2 shortens the date to `→ Jan 1`, by design) | PASS |
| A3 12-hour | PASS (`10:09`) | PASS | PASS |
| A4 24-hour | PASS (`13:16`) | PASS (`13:16`, fr965 and venusq2) | PASS (`20:41`) |
| A5 first day | PASS: zeros, empty bars, no streak row, the time moved down in Free (13.9) | PASS: counts to its default New Year (88 days) until an event is set | PASS: no position in the simulator, so canned sun times (`Sunrise 12:18`); Pro curve is one dot (no history yet) |
| Free vs Pro | Free has no temperature; Pro shows `68°` | identical first face | Free has no date row or curve; Pro has both |
| fr55 (8 colours) | accent becomes cyan, MOVE stands in for floors (no floors sensor) | mint ring becomes cyan (documented in `DaysToGo/docs/compatibility.md`) | not in the manifest |

No new defects in these three.

### Website (verden.watch, live)

| Case | Result | Evidence |
|---|---|---|
| No horizontal scroll on phones | PASS | `check-overflow.mjs`, every page, 320/360/375/414 px (after the 2026-10-05 fix) |
| Watch lists match the builds | PASS (after F7) | every app page lists its manifests' products: HeroSet 87, HeroFace 124, Days To Go 127, Two Suns 72, DayArc 72 |
| Images current | PASS | watch-framed captures on every page |

### HeroSet (dev and store builds; earlier the same day)

| Case | Result | Evidence |
|---|---|---|
| C1 glance first run | PASS | fr965, fr970, fr265, fenix847mm, epix2pro47mm: "NO STREAK YET", three empty bars |
| C2 counting, review, save | PASS, NOTE (F5) | fr965 and epix2pro47mm: count, `CAL --` until 1, review `+24` as the big number; START saves |
| C3 mission complete | PASS | fr265 and fr965, seed 100/100/100 |
| C4 Instinct | PASS | instincte45mm: XP ring in the window, no `STREAK 0` row |
| tests | PASS | 116 (store 103) on fr965, fr255s, venu3, instincte40mm, instinct2 |

### Always-on and burn-in, all four faces (fr965, earlier the same day)

| Face | Always-on frame | 24 h burn-in peak luminance |
|---|---|---|
| Days To Go Pro | time and count, dim, drifts | 0.84% |
| Two Suns Pro | time, Body Battery, sun line, dim, drifts | 1.09% |
| HeroFace Pro | time only, dim, drifts | 1.23% |
| DayArc Pro | time only, light grey, drifts | 2.52% (its grey is the brightest: ROADMAP 13.25) |

## Findings and fixes

| ID | Severity | Where | Finding | Status |
|---|---|---|---|---|
| F1 | High | DayArc, 12-hour watches | The hour was zero-padded, so 13:02 read `01:02` and the 18:54 sunset `06:54` (before the 07:32 sunrise). Found on the owner's wrist photos | **Fixed** `5bb9557`; verified here (A3) |
| F2 | Medium | DayArc Pro, no calendar event | The pill cut "No upcoming event" to "No up..." | **Fixed** `5bb9557` ("None") |
| F3 | Low | DayArc Pro on Venu Sq 2 (rectangle) | Since the "Feels like" label (13.28), the morning keeps the label and drops the Pro grid on this screen, by the rule "the hero label is never traded for a grid row" (DayArc ADR-017). The Instinct already worked this way (owner-approved, 1.18) | **Open, owner** (ROADMAP 13.30) |
| F4 | Info | DayArc, Instinct memory | Store-style memory grew from 31.2 to 38.0 kB (Pro) with today's condition icons and tables; 64% of the limit, 21.8 kB free | Accepted; watch it if more fields come |
| F5 | Low | HeroSet review on epix Pro (Gen 2) | No number font fits the review band there, so `+24` stays in the large text font (still the biggest line) | Accepted |
| F6 | Medium | QA tooling | `H24=1` never reached the container, so a "24-hour" run was 12-hour | **Fixed**: a tag starting with `h24` selects 24-hour (`docker/qa_shots.sh`) |
| F7 | Medium | Website | Days To Go, Two Suns, DayArc and DayArc Pro had no watch list; HeroFace listed 117 of 124 products (2 of 7 Instinct); HeroSet hid its Instinct list though 1.3.0 is live (owner noticed) | **Fixed** `37f6c0e`: lists generated from the manifests (`site/scripts/watch-families.py`) |

(Earlier fixes the same day, from the owner's photos and the design critique, are in `reports/Design critique 2026-10-05.md`.)
