# HeroFace — plan

Status: 2026-09-20. Watch face from studio Verden, companion to HeroSet (`../HeroSet`).

**Built so far:** phases 0, 1 and 3 (the face, its settings, always-on, the
screen-fit suite, and both sides of the HeroSet link), plus all 15 languages,
the store listing pack (`listing/`) and the three website pages in
`../../verden-site`. **Left:** the rest of the device session, screenshots
(which need a human at the simulator), submission itself, and the other screen
shapes (phase 4). Per-phase notes below.

## Goal

A complete, practical daily watch face in HeroSet's visual language: a progress ring around the bezel, three "mission" bars and big time in the middle. It runs on as many Garmin watches as practical.

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

The 130 products at 3.0.0 break down as 117 round, 8 semi-octagon (Instinct family, with a sub-window) and 5 rectangle (Venu Sq/X1). They include 74 MIP, 54 AMOLED and 2 LCD screens. The smallest watch-face memory is 64 KB.

**Native data a face can read at the 3.0 floor** (API level from the SDK docs):

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
| `Activity.Info.currentHeartRate` | 1.0.0 | Often null in low-power face mode. Fall back to the latest `ActivityMonitor.getHeartRateHistory` sample (verify in spike) |

**The watch face can't read HeroSet's storage directly.** Each app's `Storage` is private to that app. The only supported bridge is **Complications** (CIQ 4.2+):
- HeroSet publishes (`ComplicationPublisher`, up to four) and the face subscribes (`ComplicationSubscriber`).
- `access="private"` limits the data to apps signed with the same developer key (`~/.garmin-connectiq/keys/developer_key`).
- `Complications.exitTo(id)` opens HeroSet with a hold.

## Two modes, one build

| Mode | When | Ring | Missions | Status line |
|---|---|---|---|---|
| **Everyday** (default) | Always available, all 117 shipped products | The day as a whole (average of the goal-bearing missions) | Steps · Intensity min · Floors, each with a fallback (below) | Goal streak (from `getHistory`) · battery · HR |
| **HeroSet** | CIQ ≥ 4.2 (66 of them), HeroSet installed, user picks it (or `Auto`) | Rank progress (XP) | Push-ups · Sit-ups · Squats today | Rank · HeroSet streak |

`Auto` = HeroSet mode when the complication exists, otherwise Everyday. If HeroSet is uninstalled (`ComplicationNotFoundException`), the face drops back to Everyday on its own. It never shows an empty or "install HeroSet" state.

HeroSet's wave-4 watches (fēnix 6, MARQ Gen 1, FR945 LTE, Enduro, Descent MK2) stop at CIQ 3.4, so they only get Everyday.

### Missions are slots, not hardcoded metrics

Each mission slot holds an ordered list of providers. At startup the face picks the first provider that this device supports (`has` check plus one null probe) and keeps it. That keeps one layout with no per-device resources, and no watch ever draws an empty bar.

| Slot | Default chain |
|---|---|
| 1 | Steps → Calories |
| 2 | Intensity minutes (day, vs weekly goal ÷ 7) → Distance |
| 3 | Floors → Move bar (inverted: "stay active") → Calories |

Users can override each slot in settings.

### User settings (`resources/settings`, `Application.Properties`)

Kept deliberately short, since each setting costs memory on the smallest watches (96 KB for the round products that shipped):
- Mode: Auto / Everyday / HeroSet
- Slot 1–3 metric (list above, "Auto" default)
- Accent colour: 4–6 choices from the Garmin 64-colour palette
- Seconds on/off (only where `onPartialUpdate` is supported)
- Weather on/off (only shown where `Toybox has :Weather`, CIQ 3.2+; default on)
- 12/24 h follows the system setting and isn't a face setting

## Decisions

1. **`minApiLevel` 3.0.0.** 130 products qualify; 117 round ones ship first (`docs/compatibility.md`). Going to 1.x/2.x adds 15 old watches with 48–64 KB and 4-bit colour, and missing `Properties`/`Storage` would mean a second render path. Not worth it. Anything newer than 3.0 goes behind a `has` check (`Toybox has :Complications`, `:Weather`, `Dc has :setAntiAlias`).
2. **Everyday mode is the product; HeroSet mode is an upgrade.** Store copy, screenshots and defaults all assume no HeroSet. HeroSet is mentioned once as "works even better with".
3. **One build, capability-checked.** The layout is proportional like HeroSet's `HeroSetLayout`, with text fit measured and never guessed (HeroSet ADR-018).
4. **Draw with primitives, no bitmaps.** Arcs, rectangles and system fonts keep memory well under the 96 KB floor. Colours come from Garmin's 64-colour palette (HeroSet ADR-035).
5. **HeroSet publishes one private complication** carrying one packed string (contract below).
6. **Mirror HeroSet's house rules** (typed functions, no magic numbers, one class per file, `HeroFace` prefix, comments explain why).
7. **Name: HeroFace.** It stands on its own; "HeroSet Face" would read as an accessory.
8. **Price: paid at the lowest tier, USD 2.00 (shown as $1.99 US)**, the same as HeroSet. Garmin's 48-hour return window is the only try-before-keep, as for HeroSet. The listing must sell Everyday mode, because most buyers won't own HeroSet.
9. **English first, built for translation.** v1 ships English only (`resources/strings/strings.xml`), but:
   - All visible text lives in `strings.xml`: labels, weekday and month abbreviations, and the "done" text. Nothing is baked into drawings or code.
   - Text fit is measured with the longest wording that fits, as in HeroSet, so longer languages (German, Finnish) shrink or pick a short form instead of overflowing.
   - Every label gets a short form (`Steps` / `St`) for small screens and long words.
   - Languages are added later as `resources-<lang>/` folders plus manifest `<iq:languages>`, following HeroSet's 15 (Russian excluded). No code change.
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
- Rank is published, not re-derived, so the rank curve lives only in HeroSet (ADR-031).
- The field order never changes. New fields go on the end, and the version only bumps on a breaking change.
- `goal` (the tenth field) is HeroSet's user-set daily goal per exercise, appended by HeroSet 2026-09-20 (its ADR-045) without a version bump — correctly, since an unknown *version* makes the face drop the whole value while an unknown *field* is simply ignored. The face falls back to 100 when an older HeroSet omits it or publishes 0, so the bars are never divided by nothing.

## Screen (round)

```
        ╭────── ring (steps │ rank XP) ──────╮
       ╱   🔔3  ᛒ        streak 12   72°     ╲
      │               10:42                  │
      │             SAT 20 SEP               │
       ╲  ▮▮▮▮▯ STEPS  ▮▮▯▯▯ INT  ▮▮▮▮▮ ✓ FL  ╱
        ╰─────────── 84% · ♥ 62 ─────────────╯
```

- Time is the biggest element. Everything else is secondary and must be readable in one glance.
- **Always-on / low power:** AMOLED sleep mode keeps under 10% of pixels lit, shows time plus a thin ring only, and shifts position each minute. MIP keeps the full face and updates once a minute.
- **Accessibility:** a finished mission shows a check mark and label, not colour alone. Icons are drawn with primitives plus a text label on small screens.

## Phases

**0. Spike — done, except the two device checks.**
- A `minApiLevel` 3.0.0 face with settings, the slot providers and `has :Complications` guards compiles and runs on `fenix5` (3.1), `fr245` (no barometer, so the floors fallback kicks in) and `fr965`.
- The memory peak on a 64 KB product (`fenix5s`, `vivoactive3`) stays under budget **with settings + providers loaded**, not just a bare face.
- HR in low-power mode: `currentHeartRate` vs the latest `getHeartRateHistory` sample.
- HeroSet with `ComplicationPublisher` still builds for its CIQ 3.4 products.
- The face finds the private complication, receives updates, and reads the value after a reboot while HeroSet is closed. **Still open: this needs the real FR965.**
- Results: a 3.0-floor face with `ComplicationSubscriber` builds and runs on `fenix5`; HeroSet with `ComplicationPublisher` builds dev and store for `fenix6` (3.4) once the complications resource is scoped to 4.2+ products only, which a shared `resources/` folder is not (HeroSet ADR-044); the smallest round watch-face memory is 96 KB, not 64 KB (that was the rectangle/Instinct set, now out of scope).

**1. Everyday face, round (117 products) — built.** Time, date, status line, the three slot missions, steps ring, goal streak, settings, AOD. `everyStateFitsThisDisplay` passes on all ten screen sizes from 208 to 466 px (`docs/compatibility.md`).

**2. Release Everyday — partly done.** Listing copy, per-language short
descriptions and a screenshot brief are drafted in `listing/`; the landing,
support and privacy pages exist in `../../verden-site/src/apps/heroface/` and
build. Screenshots and the submission itself are left. Paid store listing (USD 2.00), screenshots from the simulator, and a page in `../verden-site/src/apps/heroface/` (support + privacy; no data leaves the watch). Shipping before HeroSet mode gets real users onto it sooner.

**3. HeroSet mode (CIQ ≥ 4.2) — built, unverified on device.** HeroSet side: `ComplicationPublisher`, `resources/complications`, a publisher called from the store's save path, and an ADR in `../HeroSet/docs/decisions.md`. Face side: subscribe, parse the contract, Auto mode, hold to launch HeroSet. Cross-link the two store listings and site pages.

**4. Other shapes — not started.** Rectangle (Venu Sq ×4, Venu X1): stacked layout. Instinct semi-octagon (8): put streak or battery in the sub-window.

## Open questions

None right now. Settled 2026-09-20: name, price, languages, weather (decisions 7–10).

## What's next

In order, smallest risk first.

1. **Device run on the FR965** (blocks everything else). Sideload the face and HeroSet's new build together and check: the private complication is found and updates on a save; the value survives a reboot while HeroSet is closed; a hold opens HeroSet; the always-on screen stays inside Garmin's burn-in rules overnight; a day's battery cost with seconds on and off. Simulator evidence is not device evidence.
2. **Existing HeroSet users and the new permission.** HeroSet now asks for `ComplicationPublisher`. Confirm on the watch whether an update re-prompts for permissions, and if it does, say so in the HeroSet store listing's update notes before publishing.
3. **Store listing and site page** (phase 2): screenshots from the simulator per screen size, listing copy that sells the everyday face, and `../verden-site/src/apps/heroface/` with support and privacy pages, cross-linked with HeroSet's.
4. **More screen sizes on the fit test** as products get added, and a pass on a watch with no barometer (`fr245`) and no weather to see the fallback chain pick its second choice.
5. **Other shapes** (phase 4): rectangle first (5 products, a stacked layout), then the Instinct sub-window (8). Each needs its own row stack, not a scaled round one.
6. ~~**Translations**~~ — done 2026-09-20: all 15 languages ship, ids and placeholders parity-checked against English, and `everyLabelFitsThisLanguage` renders the live language's labels so a long translation fails a test rather than a wrist.

Deliberately not planned: a second complication for HeroSet (one packed value is enough), per-device resources, and any on-face configuration UI (settings live in Garmin Connect).

## Finish review

A design review of the built face returned `fix` with six material items, all
applied 2026-09-20:

1. The everyday face no longer prints `0-DAY STREAK` on the day it is
   installed — the first thing a new owner sees was a zero.
2. The streak-above-time row order is now recorded with the measurement behind
   it (the top row is 209 px of usable chord on fr965; the date with a
   temperature needs 243 and would lose its month, the streak needs 155).
3. The white accent is gone: a white bar read as the clock's own material.
   Three accents remain, and red is documented as the attention role it
   inherits from HeroSet rather than an undeclared fourth colour.
4. Notifications in the footer are now part of the direction contract, with the
   reason: a daily face that hides unread messages is less practical.
5. Everything except the time and seconds is now gathered once a minute instead
   of every second. Battery is the currency on this platform.
6. The contradictory memory figure (64 KB vs 96 KB for the same products) is
   fixed: 96 KB is the floor for the 117 round products that ship.

Row order settled on the watch (2026-09-20): the date is back in the top row
and the streak moved under the time, sharing that row with the temperature.
The earlier swap was measured against the date *with* a temperature (243 px
against 208 available); the date alone needs 172, so it fits, and only the
temperature had to move. The top row is now never empty.

Found on the watch the same day and fixed: HeroSet mode showed `RANK 2  0D`
for a rank with no streak — a cryptic short form of "0 days". A zero streak now
prints the rank alone, matching what the everyday face already does, and the
`0D` wording is gone.

Also taken from the review's ceiling list: `onPowerBudgetExceeded` now turns
seconds off instead of leaving a frozen number beside the time.

## Changed while building

- The ring shows the day as a whole (the average of the goal-bearing missions), not steps again: the left mission bar already is the steps bar.
- The streak took the narrow row under the ring's top and the date moved under the time, where the month fits.
- The always-on screen drops the ring entirely; a static arc is exactly the kind of pixel Garmin's burn-in rules are about. Its time now shifts by 4 px a minute, not a twentieth of the screen: Garmin's watch-face guidance caps the move at four pixels, and the bigger jump would have read as the clock hopping.
- Decision 9's weekday and month strings come from the system's own date formatting instead of `strings.xml`, so they are already translated on every watch.
