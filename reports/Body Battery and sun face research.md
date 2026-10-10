# Body Battery and sun face research

Research snapshot: **2026-09-26**. Store figures: Connect IQ store's own backend API. Platform claims: installed SDK 9.2.0 docs, compiler and simulator probes written for this report, Garmin's own pages, Garmin forum threads. Sun-time accuracy: US Naval Observatory. Every substantive claim carries source in `research_notes/Body Battery and sun face research/`. Product it leads to: specified in [`TwoSuns/docs/spec.md`](../TwoSuns/docs/spec.md), planned in [`TwoSuns/docs/archive/plan.md`](../TwoSuns/docs/archive/plan.md).

## What's in which file

| File | What it holds |
|---|---|
| `platform.md` | Permissions (compiler-checked), simulator probe results, local-day behaviour of `Weather.getSunrise`, location-vs-Positioning result, sun accuracy vs Naval Observatory, device tiers |
| `market_and_pricing.md` | 1,378 faces surveyed: who ships Body Battery and sun faces, downloads, price, permissions, paid vs free |
| `rival_reviews.md` | What reviewers of sun and Body Battery faces say |
| `garmin_sources.md` | What Garmin says about Body Battery and sunrise/sunset glance; known accuracy |
| `naming.md` | Name candidates, store collisions |
| `reference_sun_times.tsv` | 27 place/date cases with USNO reference times, for tests |
| `store_survey.csv`, `key_rival_reviews.tsv`, `probe/` | Raw data, reproducible probes |

## Executive summary

**A face showing sky's day and your energy on one dial is unclaimed; sun half is where every rival breaks.**

- **Combination exists only as dashboards.** 282 of 1,378 faces mention both Body Battery and sunrise; almost all 14-to-40-field dashboards. Leaders where sun or Body Battery *is* the idea: Sundance and Sun Dial 24 (10,000 each), HandsFive (100,000), two Pokémon Sleep faces (600,000 combined) whose pose follows Body Battery. None relates the two. Freshest direct rival, Vesper Solar (sun-following "ember" for AMOLED): three days old, 3 reviews. Expect copying: moat = correctness and finish.
- **Sun faces fail on numbers.** 904 reviews of 12 sun faces; 71 discuss sun times; same failures everywhere: sunrise shown in UTC ("Sunrise is at 6.10 but it shows 10.10"), hour off in Hawaii, "randomly switches during the day", "gets dark at noon", blank fields, `?GPS?`, battery empties in a day. About a third of 1★-3★ reviews (39 of 123) = crashes, `IQ!` errors, "won't load".
- **Rivals' bugs not API's.** First reading of simulator sweep suggested `Weather.getSunrise` returned UTC-date events, which would explain "it shows UTC" and "switches during the day". **Hourly sweep shows it returns watch's local calendar day** (flips at 00:00 on watch's clock, not 00:00 UTC). So those complaints = formatting and DST mistakes in rivals' own code; API usable (simulator evidence only; on-watch probe logs it). Not first choice: Complications give Garmin's own numbers, no location.
- **Fix available, cheap.** `Complications` (API 4.2+) gives Garmin's own **sunrise and sunset as local seconds since midnight, and Body Battery, no location at all**, so face can match watch's native glance, which reviewers compare it to. For everything Garmin does not give (tomorrow's sunrise, dawn, dusk, golden hour, solar noon), plain NOAA calculation within **1 minute of Naval Observatory on 27 place-and-date cases** (2 at Tromsø on equinox), known edges at polar-circle transitions.
- **Location is the hard part; in simulator it follows Positioning permission.** Compiler accepts `Activity.currentLocation` and whole `Weather` module without permission, but at runtime `Weather.getCurrentConditions().observationLocationPosition` was **non-null only when Positioning declared (3 of 3 alternating runs with, 0 of 3 without)**; `Position.getInfo()` kills app, uncatchably, without it. `Activity.currentLocation` null in simulator either way, so behaviour untested. Without location, face can still show Garmin's sunrise and sunset (Complications need none) but cannot compute tomorrow's sunrise, dawn, dusk, golden hour. **Owner's "yes" to Positioning stands as working assumption; two on-watch probes (with and without permission) decide whether real watch needs it.** Face never getting location degrades to Garmin's numbers, never blank.
- **Body Battery = daily curve, not number.** Garmin: fullest on waking, drained by activity and stress, recharged by rest and sleep, sleep pressure building from waking. Single number hides shape; low not failure ("the occasional low-energy day is no cause for alarm", Garmin). Pokémon face reviewers love the link, ask to control it: 59 of 505 ask for background or colour choice, 9 ask to pick or turn off mood, one reviewer with chronic illness found sad pose upsetting. **Show as number and neutral picture, never as mood.**
- **Paid proven for finish, not single idea.** Circles 2 (3.49 €, 10,000+, 1,716 reviews, 4.8★) shows paid works for polished customisable face. Among faces built around Body Battery or sun, about 75 paid (after removing faces named for watch models); 2 reached 1,000 downloads (Body Info, Epic Sun). Same finding as countdown research, same risk; owner's paid-at-lowest-tier decision stands, with same 45-day review and 60-day test.
- **Device reach is a choice.** By API level, 72 watch-face products can subscribe to Complications (API 4.2+, 51 AMOLED); 23 more (API 3.4 to 4.1: fēnix 6, MARQ Gen 1, Enduro, FR55...) have Body Battery history and `Weather` but no Complications. SDK's own device lists omit fēnix 9 family, FR70, FR170; doc lag, not missing API.

**Recommendation.** Build **Two Suns** (working name): 24-hour ring for sky's sun, 24-hour Body Battery curve under time, two plain numbers, *light left* and *energy now*. **v1 for 69 Complications-capable products** (excluding three Instinct as Days To Go did): Garmin's own numbers where they exist, tested NOAA calculation for rest, remembered location, honest empty state for every failure. Tier B (fēnix 6 family and friends) in 1.1, once location probe has spoken. Paid at lowest tier, as decided.

## 1. What makes this "absolutely brilliant" and not a 283rd dashboard

Eight requirements, each traced to evidence. Face meeting them differs in kind from rivals; one missing any picks up same low-star reviews.

1. **One question, answered at a glance: "how much light and how much energy do I have left?"** Runners, hikers, photographers plan by both (same buyers as HeroSet and HeroFace). Nobody shows them together; they show fields side by side.
2. **Numbers match Garmin's.** Users compare against native Sunrise/Sunset glance and Body Battery widget. Take values from `Complications`, local time, show times in watch's own clock.
3. **Never blank.** Every failure has a sentence: "Sun does not set today", "No place yet", "Body Battery unavailable". Top sun-face complaints: `--:--` and `?GPS?`.
4. **Body Battery as its shape.** 24-hour curve, current point marked, = honest picture of what Garmin describes. One number each for light and energy next to it.
5. **No verdicts.** No sad face, no red "low", no "rest" advice, no thresholds. Optional colour by level only if neutral in default. Pokémon lesson, and Garmin's own.
6. **Light on battery.** One redraw a minute; sun geometry recomputed once a day and on location change; Body Battery history read every five minutes, kept as 96-bucket array. Two top sun faces reviewed as battery hogs; face saying nothing about battery until measured cannot be accused of it.
7. **Always-on respects display.** Time and two numbers, dim, drifting, no ring or curve (Days To Go ADR-007 (always-on burn-in limits): at most 10% of pixels lit and pixel on for at most three updates, else whole screen goes dark).
8. **Contrast and restraint.** One accent, black ground, contrast checked on bright-sun display case; no layer overlaps another (Sun Watch Toutou steps-bar-over-sun-times complaint).

## 2. The design in one paragraph

Thin 24-hour ring around bezel, noon at top, day running clockwise like clock: night dim, daylight lit, part of day already gone a little dimmer, marker for sun's position, ticks at sunrise and sunset, and (setting) warm arc for golden hour. Time = hero, large, middle third. Under it 24-hour Body Battery curve, current point marked, value beside it. At bottom one line: *light left* in daylight ("3:42 of daylight"), *the next sunrise* at night ("Sunrise 06:41"), or honest sentence at poles. Always-on: time and two numbers. Visual identity = owner's call, as in Days To Go; direction, not mock-up (spec, "Design brief").

## 3. Data: what the face reads, in what order

| Need | Source, in order | Permission | Empty state |
|---|---|---|---|
| Sunrise, sunset today | `Complications` SUNRISE / SUNSET (Garmin's numbers, local seconds) → calculation from a location | ComplicationSubscriber | "Sun does not set/rise today" (both null and location says polar) or "No place yet" |
| Tomorrow's sunrise, dawn, dusk, golden hour, solar noon, sun height | NOAA calculation from a location (tomorrow = calculated tomorrow + Garmin-today − calculated-today) | none | not shown |
| Location | `Activity.getActivityInfo().currentLocation` → `Weather.getCurrentConditions().observationLocationPosition` (**simulator: needs Positioning**) → `Position.getInfo()` (needs Positioning) → last good place saved rounded to 0.1° in `Application.Storage` | **Positioning, provisional until the probes report** | "No place yet" |
| Body Battery now | last valid sample of history → `Complications` BODY_BATTERY | SensorHistory, ComplicationSubscriber | "--" and no curve |
| Body Battery curve | `SensorHistory.getBodyBatteryHistory({:period => Duration(24 h)})`, values outside 0 to 100 dropped (127 = not worn), each sample's own `when` (never `getNewestSampleTime`) | SensorHistory | no curve |

## 4. What was verified and what was not

Verified:
- Store data (API, 2026-09-26).
- Which calls need which permission at compile time (compiler's own error list, on probe face); at runtime, in simulator: `Position.getInfo` without Positioning ends app, Weather's observation location appears only with Positioning (alternating runs, 3 of 3).
- `Weather.getSunrise/getSunset` follow watch's local calendar day (simulator, hourly sweep over both midnights, three places); both null at Tromsø on 21 December and 21 June.
- NOAA calculation vs Naval Observatory: 27 cases, ≤ 2 min.
- Garmin's Body Battery page and Sunrise and Sunset Glance article, as read on 2026-09-26.

**Not verified:**
- **Anything on a wrist.** Owner's FR965 has not run any of this. Unknown specifically: what `Position.getInfo()`, `Activity.currentLocation`, Weather's observation location return to watch face on real firmware, with and without Positioning; whether `Weather.getSunrise` follows watch's local day on real firmware; whether Body Battery history really oldest-first and future-dated as in simulator; Body Battery history cadence and how many samples 24 hours holds; whether `Complications` sun values equal native glance to the minute; battery cost.
- Body Battery accuracy: no independent validation of composite score in what was read; HRV input, on the one study seen, less concordant with ECG for fēnix 6 than for Oura or WHOOP (13 adults, search summary).
- 26 products SDK lists omit (fēnix 9, FR70, FR170, older CIQ 3.x) and whole of tier B (no Complications).
- Trademark search; look of any face on any screen; whether simulator's fr965 sun day being 7 minutes longer than USNO's holds on a watch.
- Vesper Solar face itself (only its listing).

## 5. Corrections to what was said earlier in the session and in earlier reports

- **Two claims made earlier in this session were wrong, corrected here.** (1) "Positioning may buy nothing": compiler does not flag `Weather`'s location, but simulator withholds it without permission; earlier "flaky" reading was permission tracking exactly. (2) "`Weather.getSunrise` returns UTC-date events": 6-hour sweep spanned both midnights, misread; hourly sweep shows watch's local day. Both caught by independent review of logs; alternating-run and hourly experiments rerun.
- **`Weather.getSunrise(location, now)` for far-away place** returns events on *watch's* local day, so "sunset" can be that place's previous evening. Irrelevant for person at own location; relevant if face ever shows another city.
- Earlier market-gap notes were right that Body Battery available through `SensorHistory` (API 3.3+) and, as current value, through Complications (4.2+); left open sunrise/sunset, marked "possible". Possible, but only after two facts this research adds: which location source a face may read, and that its location follows Positioning at runtime.
- Earlier notes (`Garmin IQ store face gaps`) said sunrise/sunset "often left to glances; not a store hole so much as a layout choice". Reviews say opposite for faces that do show it: store full of sun faces with wrong or blank times, so *correct* one is the gap.

## Sources

Store API endpoints, SDK paths, forum threads in `research_notes/Body Battery and sun face research/README.md` and `garmin_sources.md`. Garmin pages read 2026-09-26: Body Battery technology page; Sunrise and Sunset Glance support article; blog "How Garmin's Body Battery Can Teach You to Thrive". Reference: US Naval Observatory `aa.usno.navy.mil/api/rstt/oneday`. Earlier repo reports used: `Countdown face research.md`, `Garmin watch face market gap.md`, notes under `research_notes/Garmin IQ store face gaps/`.