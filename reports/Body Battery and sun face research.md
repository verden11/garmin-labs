# Body Battery and sun face research

Research snapshot: **2026-09-26**. Store figures come from the Connect IQ store's own backend API; platform claims from the installed SDK 9.2.0 documentation, from compiler and simulator probes written for this report, from Garmin's own pages, and from Garmin forum threads; sun-time accuracy from the US Naval Observatory. Every substantive claim carries its source in `research_notes/Body Battery and sun face research/`. The product it leads to is specified in [`TwoSuns/docs/spec.md`](../TwoSuns/docs/spec.md) and planned in [`TwoSuns/docs/plan.md`](../TwoSuns/docs/plan.md).

## What's in which file

| File | What it holds |
|---|---|
| `platform.md` | Permissions (compiler-checked), simulator probe results, the local-day behaviour of `Weather.getSunrise` and the location-vs-Positioning result, sun accuracy against the Naval Observatory, device tiers |
| `market_and_pricing.md` | 1,378 faces surveyed: who ships Body Battery and sun faces, downloads, price, permissions, paid vs free |
| `rival_reviews.md` | What reviewers of the sun and Body Battery faces say |
| `garmin_sources.md` | What Garmin says about Body Battery and the sunrise/sunset glance, and what is known about accuracy |
| `naming.md` | Name candidates and store collisions |
| `reference_sun_times.tsv` | 27 place/date cases with USNO reference times, for tests |
| `store_survey.csv`, `key_rival_reviews.tsv`, `probe/` | Raw data and reproducible probes |

## Executive summary

**A face that shows the sky's day and your energy on one dial is unclaimed, and the sun half is where every rival breaks.**

- **The combination exists only as dashboards.** 282 of 1,378 faces mention both Body Battery and sunrise; almost all are 14-to-40-field dashboards. The leaders where sun or Body Battery *is* the idea: Sundance and Sun Dial 24 (10,000 each), HandsFive (100,000), and the two Pokémon Sleep faces (600,000 combined) whose pose follows Body Battery. None relates the two. The freshest direct rival, Vesper Solar (a sun-following "ember" for AMOLED), is three days old with 3 reviews. Expect copying: the moat is correctness and finish.
- **Sun faces fail on the numbers.** In 904 reviews of 12 sun faces, 71 discuss sun times, and the failures are the same everywhere: sunrise shown in UTC ("Sunrise is at 6.10 but it shows 10.10"), an hour off in Hawaii, "randomly switches during the day", "gets dark at noon", blank fields, `?GPS?`, and a battery that empties in a day. About a third of the 1★-3★ reviews (39 of 123) are crashes, `IQ!` errors and "won't load".
- **The rivals' bugs are not the API's.** A first reading of a simulator sweep suggested `Weather.getSunrise` returned UTC-date events, which would have explained "it shows UTC" and "switches during the day". **An hourly sweep shows it returns the watch's local calendar day** (it flips at 00:00 on the watch's clock, not at 00:00 UTC). So those complaints are formatting and DST mistakes in the rivals' own code, and the API is usable (simulator evidence only; the on-watch probe logs it). It is not the first choice: Complications give Garmin's own numbers with no location.
- **The fix is available and cheap.** `Complications` (API 4.2+) gives Garmin's own **sunrise and sunset as local seconds since midnight, and Body Battery, with no location at all**, so a face can match the watch's native glance, which is what reviewers compare it to. For everything Garmin does not give (tomorrow's sunrise, dawn and dusk, golden hour, solar noon), a plain NOAA calculation is within **1 minute of the Naval Observatory on 27 place-and-date cases** (2 at Tromsø on the equinox), with known edges at the polar-circle transitions.
- **Location is the hard part, and in the simulator it follows the Positioning permission.** The compiler accepts `Activity.currentLocation` and the whole `Weather` module without a permission, but at runtime `Weather.getCurrentConditions().observationLocationPosition` was **non-null only when Positioning was declared (3 of 3 alternating runs with, 0 of 3 without)**, and `Position.getInfo()` kills the app, uncatchably, without it. `Activity.currentLocation` is null in the simulator either way, so its behaviour is untested. Without a location a face can still show Garmin's sunrise and sunset (Complications need none) but cannot compute tomorrow's sunrise, dawn, dusk or golden hour. **The owner's "yes" to Positioning stands as the working assumption; two on-watch probes (with and without the permission) decide whether a real watch needs it.** A face that never gets a location degrades to Garmin's numbers, never to a blank.
- **Body Battery is a daily curve, not a number.** Garmin: fullest on waking, drained by activity and stress, recharged by rest and sleep, with sleep pressure building from the moment you wake. A single number hides the shape, and low is not a failure ("the occasional low-energy day is no cause for alarm", Garmin). Reviewers of the Pokémon faces love the link and ask to control it: 59 of 505 ask for background or colour choice, 9 ask to pick or turn off the mood, and one reviewer with a chronic illness found the sad pose upsetting. **Show it as a number and a neutral picture, never as a mood.**
- **Paid is proven for finish, not for a single idea.** Circles 2 (3.49 €, 10,000+, 1,716 reviews, 4.8★) shows paid works for a polished customisable face. Among faces built around Body Battery or sun, about 75 are paid (after removing faces named for watch models) and 2 have reached 1,000 downloads (Body Info, Epic Sun). Same finding as the countdown research and the same risk; the owner's paid-at-the-lowest-tier decision stands, with the same 45-day review and 60-day test.
- **Device reach is a choice.** By API level, 72 watch-face products can subscribe to Complications (API 4.2+, 51 AMOLED); 23 more (API 3.4 to 4.1: fēnix 6, MARQ Gen 1, Enduro, FR55...) have Body Battery history and `Weather` but no Complications. The SDK's own device lists omit the fēnix 9 family, FR70 and FR170; that is doc lag, not a missing API.

**Recommendation.** Build **Two Suns** (working name): a 24-hour ring for the sky's sun, a 24-hour Body Battery curve under the time, and two plain numbers, *light left* and *energy now*. **v1 for the 69 Complications-capable products** (excluding the three Instinct as Days To Go did), Garmin's own numbers where they exist, a tested NOAA calculation for the rest, a remembered location, and an honest empty state for every failure. Tier B (fēnix 6 family and friends) in 1.1, once the location probe has spoken. Paid at the lowest tier, as decided.

## 1. What makes this "absolutely brilliant" and not a 283rd dashboard

Eight requirements, each traced to evidence. A face that meets them is different in kind from the rivals; one that misses any of them will pick up the same low-star reviews.

1. **One question, answered at a glance: "how much light and how much energy do I have left?"** Runners, hikers and photographers plan by both (the same buyers as HeroSet and HeroFace). Nobody shows them together; they show the fields side by side.
2. **The numbers match Garmin's.** Users compare against the native Sunrise/Sunset glance and the Body Battery widget. Take the values from `Complications`, in local time, and show times in the watch's own clock.
3. **Never blank.** Every failure has a sentence: "Sun does not set today", "No place yet", "Body Battery unavailable". The top sun-face complaints are `--:--` and `?GPS?`.
4. **Body Battery as its shape.** Its 24-hour curve, with the current point marked, is the honest picture of what Garmin describes. One number for each of light and energy sits next to it.
5. **No verdicts.** No sad face, no red "low", no "rest" advice, no thresholds. Optional colour by level only if it stays neutral in the default. This is the Pokémon lesson, and Garmin's own.
6. **Light on battery.** One redraw a minute; the sun geometry recomputed once a day and on a location change; Body Battery history read every five minutes and kept as a 96-bucket array. Two of the top sun faces are reviewed as battery hogs; a face that says nothing about battery until measured cannot be accused of it.
7. **Always-on that respects the display.** Time and the two numbers, dim, drifting, no ring or curve (Days To Go ADR-007: at most 10% of pixels lit and a pixel on for at most three updates, else the whole screen goes dark).
8. **Contrast and restraint.** One accent, black ground, contrast checked on the bright-sun display case; no layer overlaps another (the Sun Watch Toutou steps-bar-over-sun-times complaint).

## 2. The design in one paragraph

A thin 24-hour ring around the bezel, noon at the top and the day running clockwise like a clock: night dim, daylight lit, the part of the day already gone a little dimmer, a marker for the sun's position, ticks at sunrise and sunset, and (setting) a warm arc for the golden hour. The time is the hero, large, in the middle third. Under it a 24-hour Body Battery curve with the current point marked and its value beside it. At the bottom one line: *light left* in daylight ("3:42 of daylight"), *the next sunrise* at night ("Sunrise 06:41"), or an honest sentence at the poles. Always-on: time and two numbers. Visual identity is the owner's call, as in Days To Go; this is a direction, not a mock-up (spec, "Design brief").

## 3. Data: what the face reads, in what order

| Need | Source, in order | Permission | Empty state |
|---|---|---|---|
| Sunrise, sunset today | `Complications` SUNRISE / SUNSET (Garmin's numbers, local seconds) → calculation from a location | ComplicationSubscriber | "Sun does not set/rise today" (both null and the location says polar) or "No place yet" |
| Tomorrow's sunrise, dawn, dusk, golden hour, solar noon, sun height | NOAA calculation from a location (tomorrow = calculated tomorrow + Garmin-today − calculated-today) | none | not shown |
| Location | `Activity.getActivityInfo().currentLocation` → `Weather.getCurrentConditions().observationLocationPosition` (**simulator: needs Positioning**) → `Position.getInfo()` (needs Positioning) → last good place saved rounded to 0.1° in `Application.Storage` | **Positioning, provisional until the probes report** | "No place yet" |
| Body Battery now | last valid sample of the history → `Complications` BODY_BATTERY | SensorHistory, ComplicationSubscriber | "--" and no curve |
| Body Battery curve | `SensorHistory.getBodyBatteryHistory({:period => Duration(24 h)})`, values outside 0 to 100 dropped (127 = not worn), each sample's own `when` (never `getNewestSampleTime`) | SensorHistory | no curve |

## 4. What was verified and what was not

Verified:
- The store data (API, 2026-09-26).
- Which calls need which permission at compile time (the compiler's own error list, on a probe face); at runtime, in the simulator: `Position.getInfo` without Positioning ends the app, and Weather's observation location appears only with Positioning (alternating runs, 3 of 3).
- `Weather.getSunrise/getSunset` follow the watch's local calendar day (simulator, hourly sweep over both midnights, three places); both null at Tromsø on 21 December and 21 June.
- The NOAA calculation against the Naval Observatory: 27 cases, ≤ 2 min.
- Garmin's Body Battery page and the Sunrise and Sunset Glance article, as read on 2026-09-26.

**Not verified:**
- **Anything on a wrist.** The owner's FR965 has not run any of this. Specifically unknown: what `Position.getInfo()`, `Activity.currentLocation` and Weather's observation location return to a watch face on real firmware, with and without Positioning; whether `Weather.getSunrise` follows the watch's local day on real firmware; whether Body Battery history is really oldest-first and future-dated as in the simulator; Body Battery history cadence and how many samples 24 hours holds; whether the `Complications` sun values equal the native glance to the minute; battery cost.
- Body Battery accuracy: no independent validation of the composite score exists in what was read; the HRV input, on the one study seen, is less concordant with ECG for a fēnix 6 than for Oura or WHOOP (13 adults, search summary).
- The 26 products the SDK lists omit (fēnix 9, FR70, FR170, older CIQ 3.x) and the whole of tier B (no Complications).
- A trademark search; the look of any face on any screen; whether the simulator's fr965 sun day being 7 minutes longer than USNO's holds on a watch.
- The Vesper Solar face itself (only its listing).

## 5. Corrections to what was said earlier in the session and in earlier reports

- **Two claims made earlier in this session were wrong and are corrected here.** (1) "Positioning may buy nothing": the compiler does not flag `Weather`'s location, but the simulator withholds it without the permission; the earlier "flaky" reading was the permission tracking exactly. (2) "`Weather.getSunrise` returns UTC-date events": a 6-hour sweep spanned both midnights and was misread; an hourly sweep shows the watch's local day. Both were caught by an independent review of the logs, and the alternating-run and hourly experiments were rerun.
- **`Weather.getSunrise(location, now)` for a far-away place** returns the events on the *watch's* local day, so the "sunset" can be that place's previous evening. Irrelevant for a person at their own location; relevant if a face ever shows another city.
- The earlier market-gap notes were right that Body Battery is available through `SensorHistory` (API 3.3+) and, as a current value, through Complications (4.2+); what they left open was sunrise/sunset, marked "possible". It is possible, but only after two facts this research adds: which location source a face may read, and that its location follows Positioning at runtime.
- The earlier notes (`Garmin IQ store face gaps`) said sunrise/sunset "often left to glances; not a store hole so much as a layout choice". The reviews say the opposite for the faces that do show it: the store is full of sun faces with wrong or blank times, so a *correct* one is the gap.

## Sources

Store API endpoints, the SDK paths and the forum threads are in `research_notes/Body Battery and sun face research/README.md` and `garmin_sources.md`. Garmin pages read 2026-09-26: Body Battery technology page; Sunrise and Sunset Glance support article; blog "How Garmin's Body Battery Can Teach You to Thrive". Reference: US Naval Observatory `aa.usno.navy.mil/api/rstt/oneday`. Earlier repo reports used: `Countdown face research.md`, `Garmin watch face market gap.md`, and the notes under `research_notes/Garmin IQ store face gaps/`.
