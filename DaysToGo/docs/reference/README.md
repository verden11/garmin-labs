> **Superseded (2026-09-26).** This folder is the first verified draft. The shipped code is in `../../source/` and `../../tools/`, and it has moved on (for example every-year timed events now stay TODAY until midnight, which this copy's `DaysToGoCountdown.mc` does not). Do not copy from here. Safe to delete.

# Reference code (verified 2026-09-26, SDK 9.2.0)

Copy into the project in plan phase 1; delete this folder in phase 7. House style: typed, one class per file, `DaysToGo` prefix (rename mechanically if the name changes).

| Path | What | State |
|---|---|---|
| `source/DaysToGoConfig.mc` | constants, property keys, phase ids | compiles strict |
| `source/DaysToGoCalendar.mc` | leap years, days in month, validity, `dayNumber` | tested |
| `source/DaysToGoEvent.mc` | one event; presets; `fromSettings` (converts the raw Hour setting) | tested |
| `source/DaysToGoLocalTime.mc` | "now" on the wall clock, read once | tested (sanity) |
| `source/DaysToGoResult.mc` | plain data for the view | compiles strict |
| `source/DaysToGoCountdown.mc` | `resolve(event, now)`: the whole counting rule | tested |
| `source/test/*.mc` | 15 unit tests | **15 of 15 pass on fr965, fenix6pro, venu2s** (2026-09-26) |
| `source/settings/*.mc` | on-watch date picker (Menu2 + three-column Picker) | compiles strict; **not run**: needs the simulator's Settings > Trigger App Settings, then a watch (plan phase 3) |
| `tools/gen_settings.py` | settings.xml, properties.xml, number strings; `--ids` lists hand-written ids | output compiles strict (fr965) |
| `tools/run_tests.sh` | build + run tests on one device, restart a wedged simulator once | used for the runs above |

Do not change the logic without adding a failing test first. The rules it implements are in `../spec.md` ("Rules the count follows").
Not covered here (plan phases 2 and 4): the settings reader with fallbacks, state and readings, layout, drawing, the always-on frame, translations.
