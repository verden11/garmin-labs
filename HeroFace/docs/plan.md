# HeroFace — plan

Status: 2026-09-26. Live in the store since 2026-09-22 (1.0.1 since 2026-09-24). Watch face from studio Verden, companion to HeroSet (`../HeroSet`).

**Built and shipped:** the round face (117 products), its settings, always-on, the screen-fit suite, both sides of the HeroSet link, all 15 languages, the store listing and the three website pages in `../../site`. **Left:** the open device checks in [`go-to-market.md`](go-to-market.md), and the other screen shapes (phase 4 below). History: [`../CHANGELOG.md`](../CHANGELOG.md), `git log`.

## Goal

A complete, practical daily watch face in HeroSet's visual language: a progress ring around the bezel, three "mission" bars and big time in the middle, on as many Garmin watches as practical.

**Standalone first, HeroSet is a bonus.** Most people who install it won't own HeroSet. Without HeroSet the face has to be a good everyday face in its own right: time, date, battery, HR, notifications and daily goals, all configurable. When HeroSet is installed on a capable watch, the missions can switch to live HeroSet reps, rank and streak.

## Facts that shape the plan

Taken from SDK 9.2.0 `Devices/*/compiler.json` and the SDK docs.

**Device reach by `minApiLevel`** (all 145 SDK products that accept watch faces):

| minApiLevel | Products | What the extra ones are |
|---|---|---|
| 1.2.0 | 145 | fēnix 3, FR230/235/630/920XT, vívoactive (Gen 1), FR45: 48–64 KB, 4-bit colour, no `Storage`/`Properties` |
| 2.4.0 | 133 | vívoactive HR, FR735XT, Approach S60 |
| **3.0.0** | **130** | fēnix 5 family, FR645/935/945/245/745, vívoactive 3/4, Venu, Venu Sq, D2, Descent MK1, Instinct 2/3/E |
| 3.4.0 | 95 | HeroSet's current floor |
| 4.2.0 | 72 | Every product running CIQ 5+ in this SDK |

The 130 products at 3.0.0 break down as 117 round, 8 semi-octagon (Instinct family, with a sub-window) and 5 rectangle (Venu Sq/X1): 74 MIP, 54 AMOLED, 2 LCD. The smallest watch-face memory of the round ones is 96 KB.

**Native data a face can read at the 3.0 floor:**

| Data | API | Caveat |
|---|---|---|
| `ActivityMonitor.Info.steps` / `stepGoal` | 1.0.0 | `stepGoal` can be 0 or null → treat as "no goal" |
| `activeMinutesDay` / `activeMinutesWeek` / `activeMinutesWeekGoal` | 2.1.0 | No daily goal exists; daily target = weekly goal ÷ 7 |
| `floorsClimbed` / `floorsClimbedGoal` | 2.1.0 | **Null on watches without a barometer** (many FRs, vívoactive) |
| `calories`, `distance`, `moveBarLevel` | 1.0.0 | — |
| `ActivityMonitor.getHistory()` | 1.0.0 | Last 7 days of steps + goal → streak without HeroSet |
| `System.Stats.battery` | 1.0.0 | `batteryInDays` is 3.3+, behind `has` |
| `DeviceSettings.notificationCount`, `phoneConnected` | 1.x | — |
| `doNotDisturb` | 2.1.0 | — |
| `Weather.getCurrentConditions()` | 3.2.0 | Behind `has`; slot hidden when missing |
| `Application.Properties.getValue` (user settings) | 2.4.0 | OK at the 3.0 floor. Replaces the template's deprecated `getProperty` |
| `Activity.Info.currentHeartRate` | 1.0.0 | Often null in low-power face mode; the face falls back to the latest `ActivityMonitor.getHeartRateHistory` sample |

**The watch face can't read HeroSet's storage directly.** Each app's `Storage` is private to that app. The only supported bridge is **Complications** (CIQ 4.2+): HeroSet publishes (`ComplicationPublisher`, up to four), the face subscribes (`ComplicationSubscriber`), `access="private"` limits the data to apps signed with the same developer key (`~/.garmin-connectiq/keys/developer_key`), and `Complications.exitTo(id)` opens HeroSet with a hold. The complications resource must be scoped to CIQ 4.2+ products only, which a shared `resources/` folder is not (HeroSet [ADR-044](../../HeroSet/docs/decisions.md#adr-044)).

## Two modes, one build

| Mode | When | Ring | Missions | Status line |
|---|---|---|---|---|
| **Everyday** (default) | Always available, all 117 products | The day as a whole (average of the goal-bearing missions) | Steps · Intensity min · Floors, each with a fallback (below) | Goal streak (from `getHistory`) · battery · HR |
| **HeroSet** | CIQ ≥ 4.2 (66 of them), HeroSet installed, user picks it (or `Auto`) | Rank progress (XP) | Push-ups · Sit-ups · Squats today | Rank · HeroSet streak |

`Auto` = HeroSet mode when the complication exists, otherwise Everyday. While unlinked the face looks for HeroSet once a minute, so installing HeroSet links a face that is already running. If HeroSet is uninstalled (`ComplicationNotFoundException`), the face drops back to Everyday on its own. It never shows an empty or "install HeroSet" state. HeroSet's CIQ 3.4 watches (fēnix 6, MARQ Gen 1, FR945 LTE, Enduro, Descent MK2) only get Everyday.

### Missions are slots, not hardcoded metrics

Each mission slot holds an ordered list of providers. At startup the face picks the first provider that this device supports (`has` check plus one null probe) and keeps it. That keeps one layout with no per-device resources, and no watch ever draws an empty bar.

| Slot | Default chain |
|---|---|
| 1 | Steps → Calories |
| 2 | Intensity minutes (day, vs weekly goal ÷ 7) → Distance |
| 3 | Floors → Move bar (inverted: "stay active") → Calories |

Users can override each slot in settings.

### User settings (`resources/settings`, `Application.Properties`)

Kept deliberately short, since each setting costs memory on the smallest watches:
- Mode: Auto / Everyday. A third entry, HeroSet, shipped in 1.0 and did exactly what Auto does; it was removed 2026-09-24 and a stored value of 2 still reads as Auto.
- Slot 1–3 metric (list above, "Auto" default)
- Accent colour: three choices from the Garmin 64-colour palette
- Seconds on/off (shown on every product; ignored where `onPartialUpdate` is missing)
- Weather on/off (shown on every product; the row stays empty where `Toybox has :Weather` is false, CIQ 3.2+; default on)
- 12/24 h follows the system setting and isn't a face setting

## Decisions

1. **`minApiLevel` 3.0.0.** 130 products qualify; the 117 round ones ship ([`compatibility.md`](compatibility.md)). Going to 1.x/2.x adds 15 old watches with 48–64 KB and 4-bit colour, and missing `Properties`/`Storage` would mean a second render path. Not worth it. Anything newer than 3.0 goes behind a `has` check (`Toybox has :Complications`, `:Weather`, `Dc has :setAntiAlias`).
2. **Everyday mode is the product; HeroSet mode is an upgrade.** Store copy, screenshots and defaults all assume no HeroSet. HeroSet is mentioned once as "works even better with".
3. **One build, capability-checked.** The layout is proportional like HeroSet's `HeroSetLayout`, with text fit measured and never guessed (HeroSet [ADR-018](../../HeroSet/docs/decisions.md#adr-018)).
4. **Draw with primitives, no bitmaps.** Arcs, rectangles and system fonts keep memory well under the 96 KB floor. Colours come from Garmin's 64-colour palette (HeroSet [ADR-035](../../HeroSet/docs/decisions.md#adr-035)).
5. **HeroSet publishes one private complication** carrying one packed string (contract below).
6. **Mirror HeroSet's house rules** (typed functions, no magic numbers, one class per file, `HeroFace` prefix, comments explain why).
7. **Name: HeroFace.** It stands on its own; "HeroSet Face" would read as an accessory.
8. **Price: paid at the lowest tier, USD 2.00 (shown as $1.99 US)**, the same as HeroSet. Garmin's 48-hour return window is the only try-before-keep. The listing must sell Everyday mode, because most buyers won't own HeroSet.
9. **Built for translation** (all 15 languages shipped at launch):
   - All visible text lives in `strings.xml`: labels and the "done" text. Nothing is baked into drawings or code. Weekday and month strings come from the system's own date formatting, so they are already translated on every watch.
   - Text fit is measured with the longest wording that fits, as in HeroSet, so longer languages (German, Finnish) shrink or pick a short form instead of overflowing. `everyLabelFitsThisLanguage` renders the live language's labels, so a long translation fails a test rather than a wrist.
   - Every label gets a short form (`Steps` / `St`) for small screens and long words.
   - A language is a `resources-<lang>/` folder plus manifest `<iq:languages>`, following HeroSet's 15 (Russian excluded). No code change.
10. **Weather is optional.** It's drawn only where the device has `Toybox.Weather` (CIQ 3.2+) and the user hasn't turned it off. When conditions are null (no phone sync yet), the slot is hidden rather than showing a placeholder.

## HeroSet → HeroFace data contract

HeroSet publishes complication id `0`, `access="private"`, whenever stored progress changes (save, app start, day rollover):

```
value = "1|20260920|37|52|100|4|63|12|20260919|100"
         v  dayKey   push sit squat rank rankPct streak lastDoneDay goal
```

- `v` = contract version. The face ignores unknown versions and stays in Everyday mode.
- The face zeroes the day counts when `dayKey` ≠ today, because HeroSet only publishes while it runs.
- The face shows the streak as 0 when `lastDoneDay` is older than yesterday. This mirrors `HeroSetRules.activeStreak`.
- Rank is published, not re-derived, so the rank curve lives only in HeroSet ([ADR-031](../../HeroSet/docs/decisions.md#adr-031)).
- The field order never changes. New fields go on the end, and the version only bumps on a breaking change.
- `goal` (the tenth field) is HeroSet's user-set daily goal per exercise, appended without a version bump (HeroSet [ADR-045](../../HeroSet/docs/decisions.md#adr-045)): an unknown *version* makes the face drop the whole value, while an unknown *field* is simply ignored. The face falls back to 100 when an older HeroSet omits it or publishes 0, so the bars are never divided by nothing.

## Screen (round)

```
        ╭─── ring (the day │ rank XP) ───────╮
       ╱   🔔3  ᛒ        streak 12   72°     ╲
      │               10:42                  │
      │             SAT 20 SEP               │
       ╲  ▮▮▮▮▯ STEPS  ▮▮▯▯▯ INT  ▮▮▮▮▮ ✓ FL  ╱
        ╰─────────── 84% · ♥ 62 ─────────────╯
```

The layout rules and measurements are in [`../DESIGN.md`](../DESIGN.md). What the plan owns:

- Time is the biggest element. Everything else is secondary and must be readable in one glance.
- **Always-on / low power:** AMOLED sleep mode keeps under 10% of pixels lit and shows the time only. The ring is dropped entirely (a static arc is exactly what Garmin's burn-in rules are about) and the time shifts 4 px a minute, the most Garmin's guidance allows. MIP keeps the full face and updates once a minute. Everything except the time and seconds is gathered once a minute, not every second.
- **Ring:** the day as a whole, not steps again (the left mission bar already is the steps bar).
- **Streak:** a zero streak prints nothing (rank alone in HeroSet mode), never `0-DAY STREAK` or `0D`.
- **Notifications in the footer** are part of the design: a daily face that hides unread messages is less practical.
- **Accessibility:** a finished mission shows a check mark and label, not colour alone. Icons are drawn with primitives plus a text label on small screens. Three accents only; red is the attention role inherited from HeroSet.

## Phase 4: other shapes — not started

Rectangle (Venu Sq ×4, Venu X1): stacked layout. Instinct semi-octagon (8): put streak or battery in the sub-window. Each needs its own row stack, not a scaled round one. Taken up only if the reviews ask for it.

Deliberately not planned: a second complication for HeroSet (one packed value is enough), per-device resources, and any on-face configuration UI (settings live in Garmin Connect).
