# Garmin's own words, and what is known about accuracy

Read 2026-09-26 in a browser. Paraphrased; short quotes only.

## Body Battery (garmin.com/en-US/garmin-technology/health-science/body-battery/)

- **What it is:** an energy estimate "powered by the Garmin Human Performance Lab" that "makes the combined influences of physical activity, stress, rest and the restorative power of sleep visible". (The earlier Garmin blog post says it is powered by the **Firstbeat** analytics engine.)
- **How it works:** "continuously analyzing combinations of heart rate, heart rate variability (HRV) and movement data while you wear your device" to tell awake from asleep, active periods, and stress during inactivity.
- **Charges:** rest and sleep. All-day stress runs 0 to 100; **below 25 is rest (Body Battery charges, parasympathetic, lower HR, higher HRV); above 25 it drains**. Naps give a boost; "a good night's sleep is the single greatest opportunity to recharge".
- **Drains:** physical activity (intensity and duration) and stress, including positive stress ("eager anticipation and big-day jitters").
- **Sleep pressure:** builds from waking through the day and dissipates during sleep; "your Body Battery is not automatically increasing just because you are resting". A short night after a long day leaves it lingering.
- **Shape of a day:** "fullest in the morning when you wake up"; activity and stress drain it through the day; the page advises against "ending the day with lots of energy in reserve" as a habit, and against reading low battery as alarm: "the occasional low-energy day is no cause for alarm".
- **Fitness:** better fitness means exercise and stress cost less relative energy.
- **Scale:** 0 to 100 (the technology page does not state the scale; Garmin's manuals and third-party explainers give 0 or 1 to 100). Introduced 2018 on the vívosmart 4 (third-party history, not from this page).
- **Caveat on the page:** compatible devices give "personalized insight" and the feature depends on "activity tracking accuracy" (footnote).

**What this means for a face:** Body Battery is a *daily curve*: high on waking, a slow fall, a rise at night. A single number hides that; the shape is the information. And low is not a failure state (Garmin says so itself), which is the lesson of the Pokémon Sleep complaint.

## The Sunrise and Sunset glance (support.garmin.com/en-US/?faq=jI2sb8OuP77rHLmrrKx2K6)

- Shows **dawn, sunrise, sunset and dusk**; extra pages on some watches: a **map** of the sun's position relative to you (activates GPS), a **graph** of the sun's current position and how high it will rise, and information on **astronomical and nautical** dawn and dusk.
- Can show **another date, another location** (current GPS, coordinates, map, saved locations, city search) and **another time**; "Sun position is not available before dawn or after dusk."
- The article says nothing about how the times are computed, which zenith angle is used, or which location a *watch face* may read. **That is the gap the rival faces fall into**, and it is why a face should show Garmin's own sunrise and sunset (via Complications) rather than its own.

## Accuracy: what is and is not known

- **Body Battery as a whole has not been independently validated**: a review of 14 composite health scores across 10 manufacturers found none had rigorous peer-reviewed independent validation (search-result summary of PMC12706116; not read in full).
- **HRV, one of its inputs**: a peer-reviewed study of nocturnal HRV on 5 wearables against ECG (13 adults, 536 nights, PMC12367097) found Oura Gen 4 concordance 0.99, Oura Gen 3 0.97, WHOOP 0.94, **Garmin fēnix 6 0.87** (older generation than the Oura devices; small sample; Garmin excluded from the resting-HR comparison). Read from the search summary, not the paper.
- Sources also compare Body Battery with WHOOP Recovery and Oura Readiness (sensai.fit, athletedata.health): they weight inputs differently (HRV explains about 56% of WHOOP Recovery variance and under 5% of Oura Readiness, by their account). Not verified.
- **Consequence for claims:** the face may say it shows "your watch's Body Battery, as Garmin reports it". It must not claim the number is accurate, must not say what it means for health, and must not name a threshold as good or bad. Garmin's review guidelines make medical claims a documentation burden.

## Third-party explainer (context only)

the5krunner, Android Authority, WearableBeat and others describe morning scores of about 75 and above as "good" and give 4 inputs (HRV, stress, sleep, activity). These are opinions, not Garmin's definition; the spec does not use them.

## Sources

- https://www.garmin.com/en-US/garmin-technology/health-science/body-battery/
- https://www.garmin.com/en-US/blog/fitness/body-battery-thrive/ (via fetch)
- https://support.garmin.com/en-US/?faq=jI2sb8OuP77rHLmrrKx2K6
- https://forums.garmin.com/developer/connect-iq/f/discussion/290009/display-body-battery
- https://forums.garmin.com/developer/connect-iq/f/discussion/290927/fenix-7-doesn-t-support-weather-getsunrise (needs CIQ 4.1.x or 3.3.x; the simulator's fēnix 7 profile was 4.0)
- https://forums.garmin.com/outdoor-recreation/outdoor-recreation-archive/f/enduro/291786/sunrise-sunset-exist-in-the-garmin-widget-but-can-t-be-accessed-in-downloaded-watchfaces (workaround: run a GPS activity once)
- https://forums.garmin.com/developer/connect-iq/f/discussion/3078/sun-rise-sunset/43566 (accuracy complaints with custom code; barrels)
- https://github.com/haraldh/SunCalc (LGPL-2.1 Monkey C widget: dawn, dusk, golden hour, blue hour; LGPL is awkward for a closed-source compiled face, and the NOAA formulas are public, so write our own)
- https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12367097/ and /PMC12706116/ (validation; search summaries)
- SDK 9.2.0 docs: `Toybox/SensorHistory`, `Toybox/Weather`, `Toybox/Complications`, `Toybox/Position`, `docs/Core_Topics/Trial_Apps`, `docs/Monetization/Price_Points`, `docs/App_Review_Guidelines/Overview`.
