# Two Suns Pro: weather and temperature through the day

2026-10-03. Research and a mockup. **No Monkey C written. Nothing here is owner-approved.** Sourced notes: [`research_notes/Two Suns temperature research/`](../research_notes/Two%20Suns%20temperature%20research/README.md). Mockup: [`TwoSuns/docs/temperature-mockup.html`](../TwoSuns/docs/temperature-mockup.html).

## Rev 3 (2026-10-03): owner's decisions, small-screen fit solved

Owner decisions: weather row, with the **now icon and its number coloured**, the three ahead icons mono; **feels-like number only, no word, no actual temperature**; confirmed the face goes to five rows; override of the weather non-goal OK. Recorded as **ADR-022 (Proposed)** in `TwoSuns/docs/decisions.md`; `spec.md`, `CLAUDE.md` and `DESIGN.md` amended. Nothing built: the look still needs the owner's approval of the mockup (`TwoSuns/docs/weather-mockup.html`; screenshots `weather-rev3-*.jpg` in the research notes).

**The small-screen finding, solved with measurements** (`twoSunsLayoutReport` in the container, seven devices): the full two-line row fits on every screen measured except the 218 px FR255S and FR255S Music (35 px spare, 38 needed). Those get a **compact one-line row** the height of the date row (icon, number, three ahead icons, no hour labels; stack 145 of 158 px). Drop order: date, compact, curve, row, sun line. The FR265S (360 px) fits with only 4 px spare. Not measured: 416, 466, 320 by 360 and 448 by 486 screens; the row height is an assumption until built.

## Rev 2 (2026-10-03): the owner wants conditions, feels-like and the day ahead

New requirement: daytime only, current conditions and feels-like temperature, and what is ahead. That changes the recommendation. **Ticks (A below) now answer the wrong question** (they show a temperature trend, not conditions) and are demoted to an optional later add-on. Mockup: [`TwoSuns/docs/weather-mockup.html`](../TwoSuns/docs/weather-mockup.html), screenshot `research_notes/Two Suns temperature research/weather-row-screenshot-2026-10-03.jpg`.

**Recommendation: one new Pro "weather row" between the time and the energy band.**
- **Now cell:** condition icon, temperature, `feels 15°` underneath. Feels-like is `CurrentConditions.feelsLikeTemperature` (docs: wind chill or heat index). Shown only when it differs from the temperature by 2 or more degrees (proposal).
- **Ahead cells:** three condition icons at even steps from now to sunset, the hour under each. The hourly forecast has condition, temperature, precipitation chance, wind, UV, cloud cover and no per-hour feels-like (docs), so ahead cells show icon and hour, not a temperature. A temperature under each icon is possible but would mix actual (ahead) with feels-like (now).
- **After sunset:** the row shows tomorrow from `getDailyForecast()` (condition, high, low): weekday, icon, hi/lo, and three condition icons from the hourly list where it reaches. At night the face does not try to forecast the night.
- **Icons:** drawn from circles, lines and polygons (`DESIGN.md` says primitives only, no bitmaps). About 7 shapes cover the 38 `Weather.CONDITION_*` values: clear, partly cloudy, cloudy, rain, storm, snow, fog. Not yet mapped one by one.
- **Colour:** A1 mono (white now, grey ahead) is the quiet default. A2 gives each icon type a fixed hue (sun and bolt `#FFFF55`, rain `#00AAFF`, cloud grey): allowed by the studio rule since it follows the icon type, never the value, but `#FFFF55` is a planned accent (yellow, id 8) and `#00AAFF` sits next to the default sky accent `#55AAFF`. The owner chooses mono or colour; colour needs the accent-roster check first.
- **Hours covered:** the forecast reaches about 12 hours ahead (unverified), so from 08:00 it covers most of the day; from early morning it reaches only to mid-afternoon, and the row draws only what exists.

**Costs, said plainly**
- The face goes from four rows to five. At 454 px the stack is about 292 px of a 326 px span; it fits. The 18 MIP products and the smaller AMOLED screens are **not checked**: the row is the first candidate for the drop order (after the date row), so small MIP watches may show no weather at all until a fit sweep says otherwise.
- It is the opposite of "subtle". It replaces the previous goal ("subtle and non-intrusive") with "useful at a glance". The owner has to confirm that is the intent.
- New words: `feels` must be translated into all 15 languages (translations are the owner's call). Fallback without a word: `17° (15°)`, which is ambiguous.
- Still needs: the spec non-goal override ADR, the stale rule (hide when the observation or forecast is older than the current hour), the `Weather` module named in full inside `(:pro)`, a `(:free)` twin, fit sweep, `fit_languages.sh`, site pages. All data claims stay "simulator only (canned weather)".

**Decision for the owner:** weather row with mono icons (A1), with colour icons (A2), or only the temperature number from option C below?

## Rev 1 (earlier the same day): subtle temperature through the day

## Recommendation (read this)

**Thermal ticks.** Twelve short hourly ticks hang inward from the 24-hour ring, clockwise from the sun marker. Tick length is the temperature. One fixed colour (`#AAAAAA`), so colour never encodes the reading. The current temperature joins the date row (`Fri 3 Oct · 19°`). No new row, no new colour, no new permission.

Three things the owner must know before saying yes:

1. **"Throughout the day" is really "the next 12 hours".** Garmin's hourly forecast starts at the current hour and has no past hours. The morning half of the ring stays empty unless the face stores readings (option D below, needs its own ADR).
2. **It reverses a written non-goal.** `docs/spec.md:183` lists weather as a non-goal and `CLAUDE.md` forbids adding non-goals. The owner overrides it, we record an ADR (Proposed), then build.
3. **Ticks only fit AMOLED.** The free band between the ring and the text is about 2% of the screen, from `TwoSunsLayout`'s integer maths: 9 px on a 454 px FR965 (7 px usable after a 2 px pad), 4 px on a 218 px FR255S (2 usable). Proposed rule: under 4 px usable, no ticks, number only. By the table in `compatibility.md` that is the 51 AMOLED products (usable 5 to 7 px, from the code's integer maths) with ticks and the 18 MIP products (usable 2 to 3 px) with the number only. **The number lives in the date row** (Pro `Date` setting, default on, first row dropped when the stack is too tall): whether that row survives on the small MIP screens is **not yet checked** (needs `twoSunsLayoutReport` at 218 and 240). If it does not, those watches show no temperature unless the number moves, for example onto the sun sentence.

## What the platform gives (details and sources in the notes)

| Need | Source | Verdict |
|---|---|---|
| Hourly temperature | `Weather.getHourlyForecast()`, Celsius, 12 entries from the current hour (forum, **not in the SDK docs, unverified on a watch**) | Use |
| Current temperature | `Weather.getCurrentConditions().temperature`, with an observation time | Use |
| Today's past hours | Nothing | Gap |
| Watch sensor temperature | `SensorHistory.getTemperatureHistory` | Reject: wrist-warmed, not air |
| Complications temperature | current and "H / L" string only | No series, skip |

No new permission: `Weather` needs none in the compiler, and Pro already calls `Weather.getCurrentConditions()` today. All 69 products have `Weather` (`compatibility.md:41`). The module stays un-imported and named in full inside `(:pro)` functions. Free is untouched.

## Options

| | Look | Verdict |
|---|---|---|
| **A. Thermal ticks** | 12 inward ticks on the ring's hour positions, length = temperature | **Recommended.** Reads as a dial track, subtle, sits in the existing gap, tolerates 12 values |
| B. Etched trace | Hairline through the same 12 points | Rejected in the mockup: at night it wanders into the ring, reads as a scratch |
| C. Numbers only | `19° · 12–21°` in the date row | The fallback and the small-screen form. No eye-candy |
| D. Ticks plus stored past hours | A: full 24-hour ring, past hours from stored current-temperature samples | Later, only if the owner wants the morning half. Needs a Storage ADR and a stale rule. More code |

## How A should look and behave

- **Position.** Each tick sits at its hour on the ring's own clock (same orientation setting, same local-time maths as the ring). The first tick is the current hour, a few degrees behind the sun marker. Ticks start 2 px inside the ring's inner edge and end at the text circle, so they cannot touch a text row (mockup, magenta guide).
- **Length.** From 25% to 100% of the room. Scale runs over the window's own low to high, with a **minimum span of 6 °C** so a flat day looks flat instead of dramatic.
- **Colour.** `#AAAAAA`, 2 px, round caps, same hue whatever the number is. Same grey as the muted text role; no accent, never golden `#FF5500`, never twilight. The tick is the only encoding; a reading is never colour alone.
- **Number.** Current temperature in the date row, in the watch's unit (`temperatureUnits`; the API is Celsius, so Fahrenheit is converted). If the date row is off or dropped (it drops first when the stack is tall), the number goes and the ticks stay. The longer row (`Fri 3 Oct · 19°`) must be re-fitted in all 15 languages.
- **Midnight crossing.** From mid-afternoon the 12 hours cross midnight and land on ring positions that today's morning also uses. Read clockwise from the marker it is a normal 24-hour dial, but it is ambiguous at a glance. Owner call: accept, or clip at midnight (loses the evening).
- **Empty and stale.** Null forecast, or entries older than the current hour: draw nothing and no number. Weather has timestamps (`forecastTime`, observation time), so stale is hideable, never invented and never greyed. Hide the number if the observation is older than a window the owner sets (proposal: 3 hours).
- **Always-on (AMOLED).** Not drawn: the always-on frame draws no ring (`DESIGN.md`).
- **Settings.** Proposal: one list setting `Temperature` (Off, Ticks), appended key, default Ticks in Pro only. The studio rule says settings are lists, ids append-only, and a new feature with a visible default needs the owner's sign-off.

## Rules checked

| Rule | Result |
|---|---|
| One decisive move, not a dashboard | One mark plus one number, in existing space |
| Never a colour keyed to a reading | Passes: single fixed grey; cold-to-hot gradients rejected |
| Free tier designed first | Free unchanged; Pro adds a mark in free space |
| Accent vs reserved roles | No new accent, so nothing to collide with |
| Empty state is a design surface | Hidden, never faked; no sentence is needed as the row simply has no number |
| Simulator only | The simulator has canned weather: it proves layout and logic, never the 12-entry length, update cadence or null behaviour |

## What I could not verify

- The 12-entry length and the current-hour start: one forum thread, not the SDK docs, not a watch.
- Whether `Weather` data is present on the owner's FR965 without the Garmin weather widget: forum says the widget must exist.
- How the ticks look on a wrist, in sun, on MIP. The mockup is a browser drawing.
- Precedent: only a shallow search; no source for a ring-integrated hourly temperature mark.

## If the owner says yes, in order

1. Owner picks: A / C / D, midnight crossing, stale window, setting default.
2. ADR "Temperature in Pro (weather is a spec non-goal)" and a spec amendment, Proposed.
3. Redo the mockup with the owner's choices; browser screenshot; look-approval.
4. Build in `(:pro)` only (`Weather` named in full, no import), a `(:free)` twin that does nothing, tests for the scale, the 6 °C minimum span, the midnight wrap, null and stale; screen-fit sweep for the room rule, and `tools/fit_languages.sh` for the longer date row in all 15 languages.
5. Same session: `DESIGN.md`, `spec.md`, `compatibility.md`, the site's `two-suns` pages and the What's New block; every claim says "simulator only" until a wear day.

## Decision needed from the owner

Option A (recommended), C, or D?
