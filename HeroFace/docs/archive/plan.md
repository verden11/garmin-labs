# HeroFace — plan

Status: 2026-10-01. Live in store since 2026-09-22 (1.0.1 since 2026-09-24). **Free twin and renamed Pro built, not uploaded (proposed, UNRELEASED: [`decisions.md`](../decisions.md) ADR-001, the Free + Pro ladder; see "Free and Pro" below).** Watch face from studio Verden, companion to HeroSet (`../HeroSet`).

**Built and shipped:** round face (117 products), settings, always-on, screen-fit suite, both sides of HeroSet link, all 15 languages, store listing, three website pages in `../../site`. **Left:** open device checks in [`go-to-market.md`](../status.md), other screen shapes (phase 4 below). History: [`../CHANGELOG.md`](../../CHANGELOG.md), `git log`.

## Goal

Complete, practical daily watch face in HeroSet's visual language: progress ring around bezel, three "mission" bars, big time in middle, on as many Garmin watches as practical.

**Standalone first, HeroSet is bonus.** Most installers won't own HeroSet. Without HeroSet face must be good everyday face alone: time, date, battery, HR, notifications, daily goals, all configurable. When HeroSet installed on capable watch, missions can switch to live HeroSet reps, rank, streak.

## Facts that shape the plan

From SDK 9.2.0 `Devices/*/compiler.json` and SDK docs.

**Device reach by `minApiLevel`** (all 145 SDK products accepting watch faces):

| minApiLevel | Products | What the extra ones are |
|---|---|---|
| 1.2.0 | 145 | fēnix 3, FR230/235/630/920XT, vívoactive (Gen 1), FR45: 48–64 KB, 4-bit colour, no `Storage`/`Properties` |
| 2.4.0 | 133 | vívoactive HR, FR735XT, Approach S60 |
| **3.0.0** | **130** | fēnix 5 family, FR645/935/945/245/745, vívoactive 3/4, Venu, Venu Sq, D2, Descent MK1, Instinct 2/3/E |
| 3.4.0 | 95 | HeroSet's current floor |
| 4.2.0 | 72 | Every product running CIQ 5+ in this SDK |

130 products at 3.0.0 = 117 round, 8 semi-octagon (Instinct family, with sub-window), 5 rectangle (Venu Sq/X1): 74 MIP, 54 AMOLED, 2 LCD. Smallest watch-face memory of round ones: 96 KB.

**Native data face can read at 3.0 floor:**

| Data | API | Caveat |
|---|---|---|
| `ActivityMonitor.Info.steps` / `stepGoal` | 1.0.0 | `stepGoal` can be 0 or null → treat as "no goal" |
| `activeMinutesDay` / `activeMinutesWeek` / `activeMinutesWeekGoal` | 2.1.0 | No daily goal; daily target = weekly goal ÷ 7 |
| `floorsClimbed` / `floorsClimbedGoal` | 2.1.0 | **Null on watches without barometer** (many FRs, vívoactive) |
| `calories`, `distance`, `moveBarLevel` | 1.0.0 | — |
| `ActivityMonitor.getHistory()` | 1.0.0 | Last 7 days steps + goal → streak without HeroSet |
| `System.Stats.battery` | 1.0.0 | `batteryInDays` 3.3+, behind `has` |
| `DeviceSettings.notificationCount`, `phoneConnected` | 1.x | — |
| `doNotDisturb` | 2.1.0 | — |
| `Weather.getCurrentConditions()` | 3.2.0 | Behind `has`; slot hidden when missing |
| `Application.Properties.getValue` (user settings) | 2.4.0 | OK at 3.0 floor. Replaces template's deprecated `getProperty` |
| `Activity.Info.currentHeartRate` | 1.0.0 | Often null in low-power face mode; face falls back to latest `ActivityMonitor.getHeartRateHistory` sample |

**Watch face can't read HeroSet's storage directly.** Each app's `Storage` private to that app. Only supported bridge: **Complications** (CIQ 4.2+): HeroSet publishes (`ComplicationPublisher`, up to four), face subscribes (`ComplicationSubscriber`), `access="private"` limits data to apps signed with same developer key (`~/.garmin-connectiq/keys/developer_key`), `Complications.exitTo(id)` opens HeroSet with hold. Complications resource must be scoped to CIQ 4.2+ products only, which shared `resources/` folder is not (HeroSet [ADR-044](../../../HeroSet/docs/decisions.md#adr-044)).

## Two modes, one build

| Mode | When | Ring | Missions | Status line |
|---|---|---|---|---|
| **Everyday** (default) | Always available, all 117 products | Day as whole (average of goal-bearing missions) | Steps · Intensity min · Floors, each with fallback (below) | Goal streak (from `getHistory`) · battery · HR |
| **HeroSet** | CIQ ≥ 4.2 (66 of them), HeroSet installed, user picks it (or `Auto`) | Rank progress (XP) | Push-ups · Sit-ups · Squats today | Rank · HeroSet streak |

`Auto` = HeroSet mode when complication exists, else Everyday. While unlinked, face looks for HeroSet once a minute, so installing HeroSet links already-running face. If HeroSet uninstalled (`ComplicationNotFoundException`), face drops back to Everyday on its own. Never shows empty or "install HeroSet" state. HeroSet's CIQ 3.4 watches (fēnix 6, MARQ Gen 1, FR945 LTE, Enduro, Descent MK2) only get Everyday.

### Missions are slots, not hardcoded metrics

Each mission slot holds ordered provider list. At startup face picks first provider device supports (`has` check plus one null probe), keeps it. One layout, no per-device resources, no watch draws empty bar.

| Slot | Default chain |
|---|---|
| 1 | Steps → Calories |
| 2 | Intensity minutes (day, vs weekly goal ÷ 7) → Distance |
| 3 | Floors → Move bar (inverted: "stay active") → Calories |

Users can override each slot in settings.

### User settings (`resources-pro/settings` and `resources-free/settings`, `Application.Properties`)

Kept short, each setting costs memory on smallest watches:
- Mode: Auto / Everyday. Third entry, HeroSet, shipped in 1.0, did exactly what Auto does; removed 2026-09-24, stored value 2 still reads as Auto.
- Slot 1–3 metric (list above, "Auto" default)
- Accent colour: three choices from Garmin 64-colour palette
- Seconds on/off (shown on every product; ignored where `onPartialUpdate` missing)
- Weather on/off (shown on every product; row stays empty where `Toybox has :Weather` false, CIQ 3.2+; default on)
- 12/24 h follows system setting, not a face setting

### Free and Pro (proposed, UNRELEASED: ADR-001, the Free + Pro ladder)

Two apps from one source, split at compile time (`(:pro)` / `(:free)`; Free is `monkey.free.jungle`, Pro is `monkey.jungle`, the live app id). Pro behaves exactly as 1.0.1; Free is new app id.

| | Free (1.0.0) | Pro (1.1.0) |
|---|---|---|
| Everyday mode and HeroSet mode (the Mode setting) | yes | yes |
| Mission slots | fixed to Auto (no setting) | Slot 1 to 3 choose the metric |
| Accent colour | ids 0 to 2 (Blue, Cyan, Magenta) | the same three |
| Seconds | no | yes (Show seconds) |
| Temperature (`Toybox.Weather`) | no | yes (Show temperature) |
| Streak, battery, heart rate, notifications, always-on, the HeroSet link | yes | yes |
| Permission | `ComplicationSubscriber` | `ComplicationSubscriber` |
| On-watch name (placeholder, owner decides) | HeroFace | HeroFace Pro |

Existing paid users lose nothing (Pro keeps every setting and behaviour of 1.0.1); Free is new, smaller app: no temperature, slots always Auto, no seconds. Free has no "Pro" word, no locked item, no upgrade text on watch or in settings. Free's description says HeroSet mode needs HeroSet installed. Alternate layout the plan mentions for Pro and any accent beyond shipped three **not built** (owner and design decisions; Magenta's 2.84:1 against track open). Names, prices, uploads are the owner's.

## Decisions

1. **`minApiLevel` 3.0.0.** 130 products qualify; 117 round ones ship ([`compatibility.md`](../compatibility.md)). Going to 1.x/2.x adds 15 old watches with 48–64 KB and 4-bit colour; missing `Properties`/`Storage` would mean second render path. Not worth it. Anything newer than 3.0 goes behind `has` check (`Toybox has :Complications`, `:Weather`, `Dc has :setAntiAlias`).
2. **Everyday mode is the product; HeroSet mode is upgrade.** Store copy, screenshots, defaults all assume no HeroSet. HeroSet mentioned once as "works even better with".
3. **One build, capability-checked.** Layout proportional like HeroSet's `HeroSetLayout`, text fit measured, never guessed (HeroSet [ADR-018](../../../HeroSet/docs/decisions.md#adr-018)).
4. **Draw with primitives, no bitmaps.** Arcs, rectangles, system fonts keep memory well under 96 KB floor. Colours from Garmin's 64-colour palette (HeroSet [ADR-035](../../../HeroSet/docs/decisions.md#adr-035)).
5. **HeroSet publishes one private complication** carrying one packed string (contract below).
6. **Mirror HeroSet's house rules** (typed functions, no magic numbers, one class per file, `HeroFace` prefix, comments explain why).
7. **Name: HeroFace.** Stands on its own; "HeroSet Face" would read as accessory.
8. **Price: paid at lowest tier, USD 2.00 (shown as $1.99 US)**, same as HeroSet. (Proposed, not signed off: ADR-001, the Free + Pro ladder, would make this app Pro beside free twin; until owner signs off this stands.) Garmin's 48-hour return window is only try-before-keep. Listing must sell Everyday mode, most buyers won't own HeroSet.
9. **Built for translation** (all 15 languages shipped at launch):
   - All visible text in `strings.xml`: labels and "done" text. Nothing baked into drawings or code. Weekday and month strings from system's own date formatting, already translated on every watch.
   - Text fit measured with longest wording that fits, as in HeroSet, so longer languages (German, Finnish) shrink or pick short form, not overflow. `everyLabelFitsThisLanguage` renders live language's labels, so long translation fails a test, not a wrist.
   - Every label gets short form (`Steps` / `St`) for small screens and long words.
   - Language = `resources-<lang>/` folder plus manifest `<iq:languages>`, following HeroSet's 15 (Russian excluded). No code change.
10. **Weather optional.** Drawn only where device has `Toybox.Weather` (CIQ 3.2+) and user hasn't turned it off. When conditions null (no phone sync yet), slot hidden, not placeholder.

## HeroSet → HeroFace data contract

HeroSet publishes complication id `0`, `access="private"`, whenever stored progress changes (save, app start, day rollover):

```
value = "1|20260920|37|52|100|4|63|12|20260919|100"
         v  dayKey   push sit squat rank rankPct streak lastDoneDay goal
```

- `v` = contract version. Face ignores unknown versions, stays in Everyday mode.
- Face zeroes day counts when `dayKey` ≠ today, because HeroSet only publishes while running.
- Face shows streak 0 when `lastDoneDay` older than yesterday. Mirrors `HeroSetRules.activeStreak`.
- Rank published, not re-derived, so rank curve lives only in HeroSet ([ADR-031](../../../HeroSet/docs/decisions.md#adr-031)).
- Field order never changes. New fields go on end, version only bumps on breaking change.
- `goal` (tenth field) = HeroSet's user-set daily goal per exercise, appended without version bump (HeroSet [ADR-045](../../../HeroSet/docs/decisions.md#adr-045)): unknown *version* makes face drop whole value, unknown *field* simply ignored. Face falls back to 100 when older HeroSet omits it or publishes 0, so bars never divided by nothing.

## Screen (round)

```
        ╭─── ring (the day │ rank XP) ───────╮
       ╱   🔔3  ᛒ        streak 12   72°     ╲
      │               10:42                  │
      │             SAT 20 SEP               │
       ╲  ▮▮▮▮▯ STEPS  ▮▮▯▯▯ INT  ▮▮▮▮▮ ✓ FL  ╱
        ╰─────────── 84% · ♥ 62 ─────────────╯
```

Layout rules and measurements in [`../DESIGN.md`](../../DESIGN.md). Plan owns:

- Time biggest element. Everything else secondary, readable in one glance.
- **Always-on / low power:** AMOLED sleep mode keeps under 10% of pixels lit (figure from forum guidance, unverified), shows time only. Ring dropped entirely (static arc is exactly what Garmin's burn-in rules are about), time shifts 4 px a minute, the most Garmin's guidance allows. MIP keeps full face, updates once a minute. Everything except time and seconds gathered once a minute, not every second.
- **Ring:** day as whole, not steps again (left mission bar already is steps bar).
- **Streak:** zero streak prints nothing (rank alone in HeroSet mode), never `0-DAY STREAK` or `0D`.
- **Notifications in footer** part of design: daily face hiding unread messages less practical.
- **Accessibility:** finished mission shows check mark and label, not colour alone. Icons drawn with primitives plus text label on small screens. Three accents only; red is attention role inherited from HeroSet.

## Phase 4: other shapes — not started

Rectangle (Venu Sq ×4, Venu X1): stacked layout. Instinct semi-octagon: built 2026-10-03 (ADR-002), with gauge in window and no footer; Venu Sq / X1 rectangles still later pass.

Deliberately not planned: second complication for HeroSet (one packed value enough), per-device resources, any on-face configuration UI (settings live in Garmin Connect).