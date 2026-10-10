# Countdown face research

Research snapshot: **2026-09-26**. Store figures from Connect IQ store's own backend API; platform claims from installed SDK 9.2.0 documentation + Garmin forum threads; code claims from build-and-test run in SDK 9.2.0 simulator. Every substantive claim carries source in
`research_notes/Countdown face research/`. Product it leads to specified in [`DaysToGo/docs/spec.md`](../DaysToGo/docs/spec.md), planned in
[`DaysToGo/docs/archive/plan.md`](../DaysToGo/docs/archive/plan.md).

## What's in which file

| File | What it holds |
|---|---|
| `rival_reviews.md` | 349 text reviews of countdown leaders: what breaks, what people ask for |
| `market_and_pricing.md` | Countdown niche: who is there, permissions, staleness, free vs paid, paid-app rules |
| `settings_and_dates.md` | Why phone's date setting fails, Beta Apps, settings on watch, verified date arithmetic |
| `devices_and_platform.md` | Device set + shapes, measured memory, fonts, always-on + MIP rules, review guidelines |
| `naming_and_listing.md` | Name candidates with collision data, listing form, languages |

## Executive summary

Countdown face = real, served niche; leaders bad at the one thing it is for; failure specific, fixable.

- **Niche exists, served.** Four leaders, 10,000 to 100,000 downloads each. Three stale (last updated 2019, 2020, 2023). Live one (Event Countdown, 2026-03) = 14-metric dashboard asking location, sensor history, profile.
- **Leaders fail at setting date.** Of Countdown!'s 49 low-star reviews, **32 (65%) about setting or saving event date**, continuously 2021 to 2024 on a version that never changed; developer blames Garmin Connect phone app, whose `date` picker shows empty value or 1 January 1970 on iOS and Android. time2race's numeric fields failed same way. Both failures on **phone**, not watch.
- **Also get day wrong.** New Year Countdown launched a day off (about twenty 1★ in days); Event Countdown counted tomorrow as two (2022). Every such bug = calendar bug; calendar arithmetic on whole days removes the class.
- **People ask for less.** "I just want a simple countdown face" appears in reviews of both live leaders.
- **Paid countdown face not broken out.** 15 paid countdown listings exist; all at 10 downloads or fewer (weak evidence about a *good* paid face). Free faces out-reach paid ~10× across store. Owner chose **paid $1.99**, stands; flagged as main commercial risk, free = fallback (harder to undo).
- **Two platform findings change design.** (1) **Beta Apps** let watch face be installed with real phone settings *before* release, so phone round trip testable first (earlier belief that sideloaded face has no settings true only of plain sideloads). (2) `AppBase.getSettingsView` lets face host own **on-watch** date picker, removing phone from critical path.
- **Date arithmetic verified.** Reference code passes **15 of 15** unit tests in simulator on three devices (fr965 AMOLED, fenix6pro MIP, venu2s), incl. every day of 1970–2100, leap days, boundaries, impossible dates, each rival bug above. Two tests failed first, each found real bug in first draft.

**Recommendation.** Build **Days To Go**: countdown-first, list-based settings plus on-watch picker, working default (New Year's Day), no permissions, at owner's price ($1.99). Test phone and watch round trip on FR965 with beta build **before** any design work (plan phase 3), because assumption most likely wrong.

## 1. The niche

Store API, 2026-09-26: 464 unique faces returned by nine countdown queries, 174 mention countdowns. Top of niche:

| Face | Downloads | Reviews / ★ | Updated | Permissions |
|---|---|---|---|---|
| Countdown! | 100,000 | 204 / 4.1 | 2019-10 | none |
| New Year Countdown | 50,000 | 76 / 3.5 | 2023-12 | Positioning, SensorHistory, UserProfile |
| Event Countdown | 10,000 | 32 / 4.4 | 2026-03 | Positioning, SensorHistory, UserProfile |
| time2race | 10,000 | 79 / 4.0 | 2020-03 | SensorHistory, UserProfile |

Differentiator true of none: **countdown-first, no permissions**. Also honest privacy line ("nothing leaves your watch").

## 2. What the reviews say

Full quotes in `rival_reviews.md`. Three failures to design against:

1. **Cannot set or save date** (Countdown!: "stuck on 09/18/2019", "goes back to 1970", "tap all over the blank white space below to finally hit the hidden save button"; time2race: "must be between 0 and 0").
2. **Wrong day** (New Year Countdown: "a whole day off"; Event Countdown: "when I enter tomorrow, it counts two days"; time2race: "a day starts at midnight, not at the event time").
3. **Too much on face** (Event Countdown 3★ and 4★: "delete useless things like steps, calories, battery %", "time and countdown only").

Requests worth honouring in v1: long horizons (88th birthday, 753+ weeks), hours in last day, free-text name (triathlon named "70.3"), clearing old event, new watches day one.

## 3. The date setting problem, and the chosen fix

`type="date"` maps to UTC number; Garmin Connect's picker on both platforms often shows empty value or January 1970, forgets date when other settings change (Countdown! developer, forum, SDK note that values are UTC). Numeric min/max broke time2race. **Chosen:** list settings for month, day, year, hour (list has nothing to validate), default event so face never empty, second entry route on watch (Picker in `getSettingsView`). **Not settled** (documented nowhere found, so plan phase 3's job): whether phone overwrites what watch writes, whether Garmin Connect shows it, whether on-watch route exists on newest watches or older ones (SDK's list covers 94 of 117 products; omits fēnix 9 family, FR70, FR170, older CIQ 3.x products).

## 4. Price

Owner chose **paid, $1.99**; stands. Risk, measured: free leaders 10,000 to 100,000 downloads; 15 paid countdown listings all at 10 or fewer (weak evidence about good one); store-wide, free out-reaches paid by median 10× (`Selling HeroSet and HeroFace.md`). Paid also reaches fewer watches and countries (SDK's App_Sales lists, lowest tier CIQ 3.4); Garmin keeps 15%. For paid: free does not rank better; free→paid locks existing users out while paid→free undocumented, so free = harder choice to undo. Code identical either way; choice made at submission, 60-day test in spec judges it.

## 5. Name

"Days To Go": no exact or containing match in store search (2026-09-26); "Big Day" and "T-Minus" also clear; "Days Left" close to battery face; "Countdown" taken by 100,000-download face. Search relevance-capped, so owner should confirm by eye; no trademark search done. Site slug would be `days-to-go`, permanent.

## 6. Devices

145 watch-face products in SDK 9.2.0; HeroFace's 117 round products (CIQ 3.0+) = recommended set (same evidence method, all 84 round products at CIQ 3.4+ included). Instinct (semi-octagon, 64 KB) and rectangles (Venu Sq 2, Venu X1) = later pass. **Memory not a constraint**: face with settings menu, three pickers, logic, ~100 setting strings used 12 KB of 110 KB on fēnix 6 Pro (simulator, normal run; test run reports harness's own 8 MB, not meaningful).

## 7. Design

Not a mock-up (owner uses design tool for that). Brief: one number, black ground, one accent, draining year ring, always-on frame of number and time only. Limits carried over from HeroFace: primitives and system fonts, measured text fit, 64-colour-safe values, always-on pixel and burn-in rules.

## 8. Corrections to what was said earlier in the session

- "`utcInfo()` fixes the off-by-one in Countdown!" **wrong**: bug in phone's picker, not in how watch reads value. Fix = not use picker.
- "No rival shows a price, so paid demand is unproven" **incomplete**: paid countdown faces exist (15), none has traction.
- "A sideloaded face has no settings, so the phone round trip needs the store" **incomplete**: Beta Apps solve it.
- First draft of date arithmetic had two real bugs (specific 29 Feb 2027 clamped to 28 Feb instead of invalid; every-year 31 April counted to 1 May). Tests and review caught them.
- Earlier count "36 of 49 low-star reviews" included four false positives; corrected figure 32 of 49 (65%).

## 9. What was verified, and what was not

Verified: store data (API, 2026-09-26); SDK facts (read from installed docs); date arithmetic (15 unit tests, three devices); strict-type build of settings resources and on-watch picker for several devices; memory figure (one device, simulator).
**Not verified:** anything on a wrist (owner's FR965 never ran this app); Garmin Connect's behaviour with lists, negative values (avoided by design), Picker route, phone/watch overwrites; on-watch settings route on 23 products SDK list omits; west-of-UTC behaviour of date line (reasoned, not run); real store traffic; trademark search; native quality of any translation.

## Sources

Store API endpoints and SDK paths in `research_notes/Countdown face research/README.md`. Forum threads (accessed 2026-09-26): Countdown! showcase (`forums.garmin.com/developer/connect-iq/f/showcase/2204/watchface-countdown/17073`), "Date picker in settings issue (UTC?)" (`.../discussion/215934`), "Watch face with settings does not show settings" (`.../discussion/406806`), "CIQ watch face settings can not be saved" (`.../connect-iq-store-ios/407851`). One further bug-report page could not be fetched (title only). Earlier repo reports used: `Selling HeroSet and HeroFace.md`, `Garmin watch face market gap.md`.