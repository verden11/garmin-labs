# Two Suns Pro: weather and temperature through the day

2026-10-03. Research, mockup. **No Monkey C written. Nothing here is owner-approved.** Sourced notes: [`research_notes/Two Suns temperature research/`](../research_notes/Two%20Suns%20temperature%20research/README.md). Mockup: [`TwoSuns/docs/temperature-mockup.html`](../TwoSuns/docs/archive/temperature-mockup.html).

## Rev 3 (2026-10-03): owner's decisions, small-screen fit solved

Owner decisions: weather row, **now icon + number coloured**, three ahead icons mono; **feels-like number only, no word, no actual temperature**; confirmed face goes to five rows; override of weather non-goal OK. Recorded as **ADR-022 (Proposed)** in `TwoSuns/docs/decisions.md`; `spec.md`, `CLAUDE.md`, `DESIGN.md` amended. Nothing built: look still needs owner approval of mockup (`TwoSuns/docs/weather-mockup.html`; screenshots `weather-rev3-*.jpg` in research notes).

**Small-screen finding, solved with measurements** (`twoSunsLayoutReport` in container, seven devices): full two-line row fits every screen measured except 218 px FR255S and FR255S Music (35 px spare, 38 needed). Those get **compact one-line row** height of date row (icon, number, three ahead icons, no hour labels; stack 145 of 158 px). Drop order: date, compact, curve, row, sun line. FR265S (360 px) fits with only 4 px spare. Not measured: 416, 466, 320 by 360, 448 by 486 screens; row height assumption until built.

## Rev 2 (2026-10-03): the owner wants conditions, feels-like and the day ahead

New requirement: daytime only, current conditions + feels-like temperature, what is ahead. Changes recommendation. **Ticks (A below) now answer wrong question** (show temperature trend, not conditions), demoted to optional later add-on. Mockup: [`TwoSuns/docs/weather-mockup.html`](../TwoSuns/docs/archive/weather-mockup.html), screenshot `research_notes/Two Suns temperature research/weather-row-screenshot-2026-10-03.jpg`.

**Recommendation: one new Pro "weather row" between time and energy band.**
- **Now cell:** condition icon, temperature, `feels 15°` underneath. Feels-like = `CurrentConditions.feelsLikeTemperature` (docs: wind chill or heat index). Shown only when differs from temperature by 2 or more degrees (proposal).
- **Ahead cells:** three condition icons at even steps now -> sunset, hour under each. Hourly forecast has condition, temperature, precipitation chance, wind, UV, cloud cover, no per-hour feels-like (docs), so ahead cells show icon + hour, not temperature. Temperature under each icon possible but would mix actual (ahead) with feels-like (now).
- **After sunset:** row shows tomorrow from `getDailyForecast()` (condition, high, low): weekday, icon, hi/lo, three condition icons from hourly list where it reaches. At night face does not try to forecast night.
- **Icons:** drawn from circles, lines, polygons (`DESIGN.md`: primitives only, no bitmaps). About 7 shapes cover 38 `Weather.CONDITION_*` values: clear, partly cloudy, cloudy, rain, storm, snow, fog. Not yet mapped one by one.
- **Colour:** A1 mono (white now, grey ahead) = quiet default. A2 gives each icon type fixed hue (sun and bolt `#FFFF55`, rain `#00AAFF`, cloud grey): allowed by studio rule since follows icon type, never value, but `#FFFF55` is planned accent (yellow, id 8) and `#00AAFF` sits next to default sky accent `#55AAFF`. Owner chooses mono or colour; colour needs accent-roster check first.
- **Hours covered:** forecast reaches about 12 hours ahead (unverified), so from 08:00 covers most of day; from early morning reaches only mid-afternoon, row draws only what exists.

**Costs, said plainly**
- Face goes four rows -> five. At 454 px stack about 292 px of 326 px span; fits. 18 MIP products and smaller AMOLED screens **not checked**: row is first candidate for drop order (after date row), so small MIP watches may show no weather at all until fit sweep says otherwise.
- Opposite of "subtle". Replaces previous goal ("subtle and non-intrusive") with "useful at a glance". Owner must confirm intent.
- New words: `feels` must be translated into all 15 languages (translations are owner's call). Fallback without word: `17° (15°)`, ambiguous.
- Still needs: spec non-goal override ADR, stale rule (hide when observation or forecast older than current hour), `Weather` module named in full inside `(:pro)`, `(:free)` twin, fit sweep, `fit_languages.sh`, site pages. All data claims stay "simulator only (canned weather)".

**Decision for the owner:** weather row with mono icons (A1), colour icons (A2), or only temperature number from option C below?

## Rev 1 (earlier the same day): subtle temperature through the day

## Recommendation (read this)

**Thermal ticks.** Twelve short hourly ticks hang inward from 24-hour ring, clockwise from sun marker. Tick length = temperature. One fixed colour (`#AAAAAA`), so colour never encodes reading. Current temperature joins date row (`Fri 3 Oct · 19°`). No new row, no new colour, no new permission.

Three things owner must know before yes:

1. **"Throughout the day" is really "the next 12 hours".** Garmin hourly forecast starts at current hour, no past hours. Morning half of ring stays empty unless face stores readings (option D below, needs own ADR).
2. **Reverses a written non-goal.** `docs/spec.md:183` lists weather as non-goal, `CLAUDE.md` forbids adding non-goals. Owner overrides, we record ADR (Proposed), then build.
3. **Ticks only fit AMOLED.** Free band between ring and text about 2% of screen, from `TwoSunsLayout` integer maths: 9 px on 454 px FR965 (7 px usable after 2 px pad), 4 px on 218 px FR255S (2 usable). Proposed rule: under 4 px usable, no ticks, number only. By table in `compatibility.md`: 51 AMOLED products (usable 5 to 7 px, from code's integer maths) get ticks, 18 MIP products (usable 2 to 3 px) number only. **Number lives in date row** (Pro `Date` setting, default on, first row dropped when stack too tall): whether row survives on small MIP screens **not yet checked** (needs `twoSunsLayoutReport` at 218 and 240). If not, those watches show no temperature unless number moves, e.g. onto sun sentence.

## What the platform gives (details and sources in the notes)

| Need | Source | Verdict |
|---|---|---|
| Hourly temperature | `Weather.getHourlyForecast()`, Celsius, 12 entries from current hour (forum, **not in the SDK docs, unverified on a watch**) | Use |
| Current temperature | `Weather.getCurrentConditions().temperature`, with observation time | Use |
| Today's past hours | Nothing | Gap |
| Watch sensor temperature | `SensorHistory.getTemperatureHistory` | Reject: wrist-warmed, not air |
| Complications temperature | current and "H / L" string only | No series, skip |

No new permission: `Weather` needs none in compiler, Pro already calls `Weather.getCurrentConditions()` today. All 69 products have `Weather` (`compatibility.md:41`). Module stays un-imported, named in full inside `(:pro)` functions. Free untouched.

## Options

| | Look | Verdict |
|---|---|---|
| **A. Thermal ticks** | 12 inward ticks on ring's hour positions, length = temperature | **Recommended.** Reads as dial track, subtle, sits in existing gap, tolerates 12 values |
| B. Etched trace | Hairline through same 12 points | Rejected in mockup: at night wanders into ring, reads as scratch |
| C. Numbers only | `19° · 12–21°` in date row | Fallback, small-screen form. No eye-candy |
| D. Ticks plus stored past hours | A: full 24-hour ring, past hours from stored current-temperature samples | Later, only if owner wants morning half. Needs Storage ADR, stale rule. More code |

## How A should look and behave

- **Position.** Each tick at its hour on ring's own clock (same orientation setting, same local-time maths as ring). First tick = current hour, few degrees behind sun marker. Ticks start 2 px inside ring's inner edge, end at text circle, so cannot touch text row (mockup, magenta guide).
- **Length.** 25% to 100% of room. Scale over window's own low to high, **minimum span 6 °C** so flat day looks flat, not dramatic.
- **Colour.** `#AAAAAA`, 2 px, round caps, same hue whatever number. Same grey as muted text role; no accent, never golden `#FF5500`, never twilight. Tick is only encoding; reading never colour alone.
- **Number.** Current temperature in date row, in watch's unit (`temperatureUnits`; API Celsius, so Fahrenheit converted). If date row off or dropped (drops first when stack tall), number goes, ticks stay. Longer row (`Fri 3 Oct · 19°`) must be re-fitted in all 15 languages.
- **Midnight crossing.** From mid-afternoon 12 hours cross midnight, land on ring positions today's morning also uses. Read clockwise from marker = normal 24-hour dial, but ambiguous at a glance. Owner call: accept, or clip at midnight (loses evening).
- **Empty and stale.** Null forecast, or entries older than current hour: draw nothing, no number. Weather has timestamps (`forecastTime`, observation time), so stale hideable, never invented, never greyed. Hide number if observation older than window owner sets (proposal: 3 hours).
- **Always-on (AMOLED).** Not drawn: always-on frame draws no ring (`DESIGN.md`).
- **Settings.** Proposal: one list setting `Temperature` (Off, Ticks), appended key, default Ticks in Pro only. Studio rule: settings are lists, ids append-only, new feature with visible default needs owner's sign-off.

## Rules checked

| Rule | Result |
|---|---|
| One decisive move, not a dashboard | One mark + one number, in existing space |
| Never a colour keyed to a reading | Passes: single fixed grey; cold-to-hot gradients rejected |
| Free tier designed first | Free unchanged; Pro adds mark in free space |
| Accent vs reserved roles | No new accent, nothing to collide with |
| Empty state is a design surface | Hidden, never faked; no sentence needed as row simply has no number |
| Simulator only | Simulator has canned weather: proves layout and logic, never 12-entry length, update cadence, null behaviour |

## What I could not verify

- 12-entry length and current-hour start: one forum thread, not SDK docs, not a watch.
- Whether `Weather` data present on owner's FR965 without Garmin weather widget: forum says widget must exist.
- How ticks look on wrist, in sun, on MIP. Mockup is browser drawing.
- Precedent: only shallow search; no source for ring-integrated hourly temperature mark.

## If the owner says yes, in order

1. Owner picks: A / C / D, midnight crossing, stale window, setting default.
2. ADR "Temperature in Pro (weather is a spec non-goal)" + spec amendment, Proposed.
3. Redo mockup with owner's choices; browser screenshot; look-approval.
4. Build in `(:pro)` only (`Weather` named in full, no import), `(:free)` twin that does nothing, tests for scale, 6 °C minimum span, midnight wrap, null, stale; screen-fit sweep for room rule, `tools/fit_languages.sh` for longer date row in all 15 languages.
5. Same session: `DESIGN.md`, `spec.md`, `compatibility.md`, site's `two-suns` pages, What's New block; every claim says "simulator only" until a wear day.

## Decision needed from the owner

Option A (recommended), C, or D?