# Garmin's own words, and what is known about accuracy

Read 2026-09-26 in browser. Paraphrased; short quotes only.

## Body Battery (garmin.com/en-US/garmin-technology/health-science/body-battery/)

- **What it is:** energy estimate "powered by the Garmin Human Performance Lab" that "makes the combined influences of physical activity, stress, rest and the restorative power of sleep visible". (Earlier Garmin blog post: powered by **Firstbeat** analytics engine.)
- **How it works:** "continuously analyzing combinations of heart rate, heart rate variability (HRV) and movement data while you wear your device" -> tell awake from asleep, active periods, stress during inactivity.
- **Charges:** rest, sleep. All-day stress 0 to 100; **below 25 = rest (Body Battery charges, parasympathetic, lower HR, higher HRV); above 25 drains**. Naps boost; "a good night's sleep is the single greatest opportunity to recharge".
- **Drains:** physical activity (intensity, duration), stress, incl. positive stress ("eager anticipation and big-day jitters").
- **Sleep pressure:** builds from waking through day, dissipates during sleep; "your Body Battery is not automatically increasing just because you are resting". Short night after long day -> lingers.
- **Shape of day:** "fullest in the morning when you wake up"; activity, stress drain through day; page advises against "ending the day with lots of energy in reserve" as habit, and against reading low battery as alarm: "the occasional low-energy day is no cause for alarm".
- **Fitness:** better fitness -> exercise, stress cost less relative energy.
- **Scale:** 0 to 100 (technology page does not state scale; Garmin manuals, third-party explainers give 0 or 1 to 100). Introduced 2018 on vívosmart 4 (third-party history, not from this page).
- **Caveat on page:** compatible devices give "personalized insight"; feature depends on "activity tracking accuracy" (footnote).

**What this means for a face:** Body Battery = *daily curve*: high on waking, slow fall, rise at night. Single number hides it; shape is the information. Low not failure state (Garmin says so itself) = lesson of Pokémon Sleep complaint.

## The Sunrise and Sunset glance (support.garmin.com/en-US/?faq=jI2sb8OuP77rHLmrrKx2K6)

- Shows **dawn, sunrise, sunset, dusk**; extra pages on some watches: **map** of sun position relative to you (activates GPS), **graph** of sun's current position and how high it will rise, info on **astronomical and nautical** dawn and dusk.
- Can show **another date, another location** (current GPS, coordinates, map, saved locations, city search) and **another time**; "Sun position is not available before dawn or after dusk."
- Article says nothing on how times computed, which zenith angle used, or which location a *watch face* may read. **Gap rival faces fall into**; why face should show Garmin's own sunrise, sunset (via Complications) not its own.

## Accuracy: what is and is not known

- **Body Battery as whole not independently validated**: review of 14 composite health scores across 10 manufacturers found none had rigorous peer-reviewed independent validation (search-result summary of PMC12706116; not read in full).
- **HRV, one input**: peer-reviewed study of nocturnal HRV on 5 wearables vs ECG (13 adults, 536 nights, PMC12367097): Oura Gen 4 concordance 0.99, Oura Gen 3 0.97, WHOOP 0.94, **Garmin fēnix 6 0.87** (older generation than Oura devices; small sample; Garmin excluded from resting-HR comparison). Read from search summary, not paper.
- Sources also compare Body Battery with WHOOP Recovery, Oura Readiness (sensai.fit, athletedata.health): weight inputs differently (HRV explains about 56% of WHOOP Recovery variance, under 5% of Oura Readiness, by their account). Not verified.
- **Consequence for claims:** face may say it shows "your watch's Body Battery, as Garmin reports it". Must not claim number accurate, must not say what it means for health, must not name threshold as good or bad. Garmin review guidelines make medical claims a documentation burden.

## Third-party explainer (context only)

the5krunner, Android Authority, WearableBeat, others: morning scores about 75 and above "good"; 4 inputs (HRV, stress, sleep, activity). Opinions, not Garmin's definition; spec does not use them.

## Sources

- https://www.garmin.com/en-US/garmin-technology/health-science/body-battery/
- https://www.garmin.com/en-US/blog/fitness/body-battery-thrive/ (via fetch)
- https://support.garmin.com/en-US/?faq=jI2sb8OuP77rHLmrrKx2K6
- https://forums.garmin.com/developer/connect-iq/f/discussion/290009/display-body-battery
- https://forums.garmin.com/developer/connect-iq/f/discussion/290927/fenix-7-doesn-t-support-weather-getsunrise (needs CIQ 4.1.x or 3.3.x; simulator's fēnix 7 profile was 4.0)
- https://forums.garmin.com/outdoor-recreation/outdoor-recreation-archive/f/enduro/291786/sunrise-sunset-exist-in-the-garmin-widget-but-can-t-be-accessed-in-downloaded-watchfaces (workaround: run GPS activity once)
- https://forums.garmin.com/developer/connect-iq/f/discussion/3078/sun-rise-sunset/43566 (accuracy complaints with custom code; barrels)
- https://github.com/haraldh/SunCalc (LGPL-2.1 Monkey C widget: dawn, dusk, golden hour, blue hour; LGPL awkward for closed-source compiled face, NOAA formulas public, so write our own)
- https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12367097/ and /PMC12706116/ (validation; search summaries)
- SDK 9.2.0 docs: `Toybox/SensorHistory`, `Toybox/Weather`, `Toybox/Complications`, `Toybox/Position`, `docs/Core_Topics/Trial_Apps`, `docs/Monetization/Price_Points`, `docs/App_Review_Guidelines/Overview`.