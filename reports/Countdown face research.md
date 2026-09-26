# Countdown face research

Research snapshot: **2026-09-26**. Store figures come from the Connect IQ store's own backend API; platform claims from the installed SDK 9.2.0
documentation and from Garmin forum threads; code claims from a build-and-test run in the SDK 9.2.0 simulator. Every substantive claim carries its source in
`research_notes/Countdown face research/`. The product it leads to is specified in [`DaysToGo/docs/spec.md`](../DaysToGo/docs/spec.md) and planned in
[`DaysToGo/docs/plan.md`](../DaysToGo/docs/plan.md).

## What's in which file

| File | What it holds |
|---|---|
| `rival_reviews.md` | 349 text reviews of the countdown leaders: what breaks, what people ask for |
| `market_and_pricing.md` | The countdown niche: who is there, permissions, staleness, free vs paid, paid-app rules |
| `settings_and_dates.md` | Why the phone's date setting fails, Beta Apps, settings on the watch, the verified date arithmetic |
| `devices_and_platform.md` | Device set and shapes, measured memory, fonts, always-on and MIP rules, review guidelines |
| `naming_and_listing.md` | Name candidates with collision data, the listing form, languages |

## Executive summary

A countdown face is a real, served niche whose leaders are bad at the one thing it is for, and the failure is specific and fixable.

- **The niche exists and is served.** Four leaders hold 10,000 to 100,000 downloads each. Three are stale (last updated 2019, 2020, 2023). The live one (Event Countdown, 2026-03) is a 14-metric dashboard that asks for location, sensor history and profile.
- **The leaders fail at setting the date.** Of Countdown!'s 49 low-star reviews, **32 (65%) are about setting or saving the event date**, continuously from 2021 to 2024 on a version that never changed; the developer blames the Garmin Connect phone app, whose `date` picker shows an empty value or 1 January 1970 on iOS and Android. time2race's numeric fields failed the same way. Both failures are on the **phone**, not the watch.
- **They also get the day wrong.** New Year Countdown launched a day off (about twenty 1★ in days); Event Countdown counted tomorrow as two (2022). Every such bug is a calendar bug, and calendar arithmetic on whole days removes the class.
- **People ask for less.** "I just want a simple countdown face" appears in reviews of both live leaders.
- **A paid countdown face has not broken out.** 15 paid countdown listings exist; all are at 10 downloads or fewer (weak evidence about a *good* paid face). Free faces out-reach paid ones roughly 10× across the store. The owner chose **paid $1.99** and that stands; this is flagged as the main commercial risk, and free is the fallback (harder to undo).
- **Two platform findings change the design.** (1) **Beta Apps** let a watch face be installed with its real phone settings *before* release, so the phone round trip can be tested first (the earlier belief that a sideloaded face has no settings was true only of plain sideloads). (2) `AppBase.getSettingsView` lets the face host its own **on-watch** date picker, which removes the phone from the critical path.
- **The date arithmetic is verified.** Reference code passes **15 of 15** unit tests in the simulator on three devices (fr965 AMOLED, fenix6pro MIP, venu2s), including every day of 1970–2100, leap days, boundaries, impossible dates and each rival bug above. Two tests failed first and each found a real bug in the first draft.

**Recommendation.** Build **Days To Go**: countdown-first, list-based settings plus an on-watch picker, a working default (New Year's Day), no permissions, at the owner's price ($1.99). Test the phone and watch round trip on the FR965 with a beta build **before** any design work (plan phase 3), because it is the assumption most likely to be wrong.

## 1. The niche

Store API, 2026-09-26: 464 unique faces returned by nine countdown queries, 174 mention countdowns. The top of the niche:

| Face | Downloads | Reviews / ★ | Updated | Permissions |
|---|---|---|---|---|
| Countdown! | 100,000 | 204 / 4.1 | 2019-10 | none |
| New Year Countdown | 50,000 | 76 / 3.5 | 2023-12 | Positioning, SensorHistory, UserProfile |
| Event Countdown | 10,000 | 32 / 4.4 | 2026-03 | Positioning, SensorHistory, UserProfile |
| time2race | 10,000 | 79 / 4.0 | 2020-03 | SensorHistory, UserProfile |

The differentiator that is true of none of them: **countdown-first, no permissions**. It is also the honest privacy line ("nothing leaves your watch").

## 2. What the reviews say

Full quotes in `rival_reviews.md`. The three failures to design against:

1. **Cannot set or save the date** (Countdown!: "stuck on 09/18/2019", "goes back to 1970", "tap all over the blank white space below to finally hit the hidden save button"; time2race: "must be between 0 and 0").
2. **Wrong day** (New Year Countdown: "a whole day off"; Event Countdown: "when I enter tomorrow, it counts two days"; time2race: "a day starts at midnight, not at the event time").
3. **Too much on the face** (Event Countdown 3★ and 4★: "delete useless things like steps, calories, battery %", "time and countdown only").

Requests worth honouring in v1: long horizons (an 88th birthday, 753+ weeks), hours in the last day, a free-text name (a triathlon named "70.3"), clearing an old event, new watches on day one.

## 3. The date setting problem, and the chosen fix

`type="date"` maps to a UTC number and Garmin Connect's picker on both platforms often shows an empty value or January 1970 and forgets the date when other settings change (the Countdown! developer, forum, and the SDK note that values are UTC). Numeric min/max broke time2race. **Chosen:** list settings for month, day, year and hour (a list has nothing to validate), a default event so the face is never empty, and a second entry route on the watch (Picker in `getSettingsView`). **Not settled** (documented nowhere found, so it is plan phase 3's job): whether the phone overwrites what the watch writes, whether Garmin Connect shows it, and whether the on-watch route exists on the newest watches or the older ones (the SDK's list covers 94 of the 117 products; it omits the fēnix 9 family, FR70, FR170 and older CIQ 3.x products).

## 4. Price

The owner chose **paid, $1.99**; it stands. The risk, measured: free leaders 10,000 to 100,000 downloads; 15 paid countdown listings all at 10 or fewer (weak evidence about a good one); store-wide, free out-reaches paid by a median 10× (`Selling HeroSet and HeroFace.md`). Paid also reaches fewer watches and countries (the SDK's App_Sales lists, lowest tier CIQ 3.4) and Garmin keeps 15%. In favour of paid: free does not rank better, and free→paid locks existing users out while paid→free is undocumented, so free is the harder choice to undo. The code is identical either way; the choice is made at submission and the 60-day test in the spec judges it.

## 5. Name

"Days To Go": no exact or containing match in the store search (2026-09-26); "Big Day" and "T-Minus" also clear; "Days Left" is close to a battery face; "Countdown" is taken by a 100,000-download face. The search is relevance-capped, so the owner should confirm by eye; no trademark search was done. The site slug would be `days-to-go` and is permanent.

## 6. Devices

145 watch-face products in SDK 9.2.0; HeroFace's 117 round products (CIQ 3.0+) are the recommended set (same evidence method, all 84 round products at CIQ 3.4+ included). Instinct (semi-octagon, 64 KB) and rectangles (Venu Sq 2, Venu X1) are a later pass. **Memory is not a constraint**: a face with the settings menu, three pickers, the logic and ~100 setting strings used 12 KB of 110 KB on the fēnix 6 Pro (simulator, normal run; a test run reports the harness's own 8 MB and is not meaningful).

## 7. Design

Not a mock-up (the owner uses a design tool for that). The brief: one number, black ground, one accent, a draining year ring, an always-on frame of number and time only. Limits carried over from HeroFace: primitives and system fonts, measured text fit, 64-colour-safe values, the always-on pixel and burn-in rules.

## 8. Corrections to what was said earlier in the session

- "`utcInfo()` fixes the off-by-one in Countdown!" was **wrong**: the bug is in the phone's picker, not in how the watch reads the value. The fix is not to use the picker.
- "No rival shows a price, so paid demand is unproven" was **incomplete**: paid countdown faces exist (15) and none has traction.
- "A sideloaded face has no settings, so the phone round trip needs the store" was **incomplete**: Beta Apps solve it.
- The first draft of the date arithmetic had two real bugs (a specific 29 Feb 2027 was clamped to 28 Feb instead of being invalid; an every-year 31 April was counted to 1 May). Tests and a review caught them.
- An earlier count of "36 of 49 low-star reviews" included four false positives; the corrected figure is 32 of 49 (65%).

## 9. What was verified, and what was not

Verified: the store data (API, 2026-09-26); the SDK facts (read from the installed docs); the date arithmetic (15 unit tests, three devices); the strict-type build of the settings resources and the on-watch picker for several devices; the memory figure (one device, simulator).
**Not verified:** anything on a wrist (the owner's FR965 has never run this app); Garmin Connect's behaviour with lists, negative values (avoided by design), the Picker route, and phone/watch overwrites; the on-watch settings route on the 23 products the SDK list omits; the west-of-UTC behaviour of the date line (reasoned, not run); real store traffic; a trademark search; the native quality of any translation.

## Sources

Store API endpoints and the SDK paths are in `research_notes/Countdown face research/README.md`. Forum threads (accessed 2026-09-26): Countdown! showcase (`forums.garmin.com/developer/connect-iq/f/showcase/2204/watchface-countdown/17073`), "Date picker in settings issue (UTC?)" (`.../discussion/215934`), "Watch face with settings does not show settings" (`.../discussion/406806`), "CIQ watch face settings can not be saved" (`.../connect-iq-store-ios/407851`). One further bug-report page could not be fetched (title only). Earlier repo reports used: `Selling HeroSet and HeroFace.md`, `Garmin watch face market gap.md`.
