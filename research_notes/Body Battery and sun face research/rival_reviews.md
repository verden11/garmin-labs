# What reviewers say

Store API, 2026-09-26. Text reviews (reviewer names dropped) of 19 faces, 2,000+ in all, in `key_rival_reviews.tsv`: HandsFive (400), two Pokémon Sleep faces (505 with text), Circles 2 (118), Sundance (116), Energy Face (100), Night & Day (81), Sun Dial 24 (52), Sun Watch Toutou (45), SolarTime 2.0 (34), Body Info (30), Radian (25), Solarium (24), Daylight (24), Solarise (13), Body battery emoticon (10), My Day 24 (9), Sun | Moon | Weather (6), Vesper Solar (3).
Counts below **keyword counts over text, not hand-coded**; quotes short, from file.

## The sun faces: the numbers are wrong or missing

Of 904 reviews on 12 sun-centred faces, 71 talk about sun times; 123 are 1★ to 3★ with text.

1. **Wrong time, often UTC or wrong day.** HandsFive: "Sunrise and sunset seem to be given with UTC time. I'm in UTC + 4. Sunrise is at 6.10 but it shows 10.10." Another: sunset "off by an hour" in Hawaii, "the software thinks we do daylight savings". Another: "It randomly switches during the day." Solarise: "it tells me it gets dark at noon", "it says it's night when it's day". SolarTime 2.0 on Asia fēnix 5X: "Sunrise shows 08:44 but must be 07:17". Energy Face: "Sun rise/set not working. 5x plus in Asia." **In simulator API itself follows watch's local day (`platform.md` §3), so these look like rivals' own conversion and daylight-saving mistakes, not platform trap.**
2. **Blank or absent.** Sundance on fēnix 6: "the main feature (sun hours) - is not appearing at all"; "Follow directions from developer to get sunrise and sunset to work" (5★). HandsFive: "the bottom sunset indicator ... just shows empty data fields". Sun Dial 24: "I keep having ?GPS? coming up at the top of the watch face ... can't get rid of it" (two reviewers). Community workaround: run GPS activity once.
3. **Battery.** Sundance: German reviewer calls it "extreme energy hog" (translated), fēnix 5X "from full to empty within a day"; another, English, "terrible battery usage". Energy Face: "battery cons is huge! More than 1% per hour". 8 of 71 sun-time reviews mention battery.
4. **Crashes and `IQ!`.** SolarTime 2.0: page of "IQ! error" after switching colours, "Not work on my fenix 6x pro". Night & Day: "Can't uninstall this watch face", black screen on Forerunner 245 (French, translated). Largest single bucket of low-star reviews (39 of 123): "does not work/crash/won't load/can't uninstall".
5. **Settings that do not save or cannot be reached.** Night & Day: "settings won't save"; date format cannot be set. Body Info: "Randomly changes to a different watch face"; French reviewer finds no way to change data shown or colours (translated).
6. **The sun disappears.** Solarium on Venu X1: "the sun isn't visible for most of the day on the ring ... Just vanishes."
7. **Legibility.** Sundance: "With a white background, the yellow icons are almost unrecognizable. No contrast." Sun Dial 24: "a way to darken the middle display so the numbers are legible". Daylight: "Incomprehensible, can't read it."

## What sun-face fans ask for

- **Marker for sun's highest point** (solar noon) and golden/blue hour (Sundance: "only marking the current/next gh/bh"), "sunrise and the golden hour on the same line".
- **0/24 at top** and sun moving the way a clock does (Sun Dial 24: "sun going west to east (left to right) is a bit odd").
- **Fewer layers**: Sun Watch Toutou: steps bar overlaps sun times ("looks like strike through") on fēnix 3 and vívoactive 3.
- **24-hour time option** and colour choices (Sundance, Daylight).
- **Body Battery as field.** Sundance 5★ (twice): "Please add Body Battery as a field and it will be perfect", "why not make body battery available as a field?" (1 sun-face review in 71 asks: demand exists but small in this audience; audience wanting Body Battery is different, see below.)
- **"Just the info I like to see. I really just want a clear sun/moon position and the time"** (Sun Dial 24, 5★): restraint praised.
- "I enjoy the daylight ring" (Sundance): ring is what people like.

## The Body Battery faces: people love a face that *feels* it, and want control of it

Pokémon Sleep (505 text reviews):
- **They love the link.** "Super cute how they get tired as your body battery depletes for the day." "I'm obsessed ... the Pokémon changes its expression based on your body battery."
- **They want it controllable.** 59 ask to change background or colours; 36 ask for more Pokémon; 9 ask to pick pose or switch Body Battery sync off. One reviewer: "I hope I can set the Pokémon to a specify mood and not base on my body battery."
- **Low Body Battery must not become bad news.** 2★ from someone with chronic illness: "my body battery is always low and bulbasaur is looking stressed out and it's making me sad ... I'd love an option to pick what poses you cycle through". Face aimed at ME/CFS (5★, 4 reviews) exists, so that audience served only by small one-off faces.
- **"I want to see the number too"**: "Body Battery set to Data Field 5 ... the end of the progress bar isn't rounded" — people put number on face *and* still like picture.
- Mood only helped where poses had wide range: "the rest only have two (awake and sleeping)".

Body Info (paid, 2.99): 35 reviews, 3.7★: no way to change data or colours (French, translated), "scaled down in display size" on vívoactive 6, "it deactivates after a day". Body battery emoticon: 12 reviews, 4.7★, big numbers plus one face; simple works.

## Dashboards with a big audience

Circles 2 (1,716 reviews, 4.8★): no review text mentions Body Battery or sunrise by name; people praise customisation and polish (keyword search returned 0 hits in 118 text reviews). Reason to buy paid face at 3.49 € was *finish and configurability*, not one metric.

## What the face must do (from the above)

1. Show sunrise and sunset **in watch's local time, on right local day, and match Garmin's own glance**.
2. **Never be blank.** Every state has honest label ("Sun does not set today", "No place yet"), not `--:--` or `?GPS?`.
3. Light on battery (one update a minute, nothing recomputed that does not change).
4. Not crash or blank on old firmware: `has` guards, permissions declared.
5. Body Battery shown as **number and neutral picture**, never as mood judgement; anything emotive optional.
6. Contrast that survives sunlight and white ground.
7. Few settings that work, on phone and on watch.