# HeroFace — Connect IQ Store listing

Everything marked **FILL** needs you. Everything else is drafted and checked
against what the build actually does (`../go-to-market.md`, "Claims allowed and
forbidden").

## The basics

| Field | Value |
|---|---|
| App name | HeroFace |
| Type | Watch face |
| Price | USD 2.00 (shows as $1.99 in the US) |
| Category | Watch Faces (the store's own list; if it asks for a sub-category too, pick the one HeroSet used) |
| Version | 1.0.0 |
| Developer name | Verden — same credit as HeroSet's live listing, so the two show as one studio. Change it here first if you want a different one. |
| Email | hello@verden.watch (same address as HeroSet, and the one on both site pages) |
| Support URL | https://verden.watch/heroface/support/ |
| Privacy URL | https://verden.watch/heroface/privacy/ |
| Website | https://verden.watch/heroface/ |
| Languages | English, Dansk, Deutsch, Español, Français, Italiano, Lietuvių, Nederlands, Norsk bokmål, Polski, Português, Suomi, Svenska, Türkçe, Українська |

## Short description

> The time first, and today's goals right under it. Steps, intensity minutes
> and floors as three bars you can change, a progress ring for the whole day,
> and a streak worth keeping.

Other languages: `descriptions.md`.

## Full description

> **HeroFace puts the time first.**
>
> The time is the largest thing on the screen, in the largest size your watch
> can fit. Under it sit today's three goals as bars: steps, intensity minutes
> and floors, or whichever three you choose. The ring around the bezel is the
> whole day at once, and it turns green when every goal is met.
>
> **Set it up the way you read it.**
>
> Each of the three bars can show steps, calories, intensity minutes, distance,
> floors or the move bar. Pick your accent colour, turn seconds on or off, show
> or hide the temperature. All from the Garmin Connect app.
>
> **It shows what your watch actually measures.**
>
> No watch has every sensor. Without a barometer there is no floor count, and
> older watches have no weather. HeroFace fills each bar with the first thing
> your watch really measures and leaves out what it cannot know — no empty
> bars, no invented numbers.
>
> **A streak worth keeping.**
>
> Meet your step goal and a gold line counts the days in a row. Miss one and it
> quietly steps aside.
>
> **Made for every round Garmin.**
>
> One design that measures itself, from a 208-pixel Forerunner 55 to a
> 466-pixel fēnix. Always-on watches get a dim, drifting clock that respects
> your watch's always-on rules.
>
> **Better with HeroSet.**
>
> If you own HeroSet, the daily push-up, sit-up and squat app, HeroFace can
> show today's reps, your rank and your HeroSet streak instead, and a hold on
> the face opens the app. Everything stays on the watch. Without HeroSet,
> nothing is missing.
>
> **Nothing leaves your watch.** No account, no internet, no analytics, no ads.
>
> Support and answers: https://verden.watch/heroface/support/

## What's new (version 1.0.0)

> First release.

## Keywords / tags

Paste these if the form asks, most relevant first; trim from the end if it
caps the count:

> watch face, steps, daily goals, intensity minutes, floors, streak,
> always-on, minimal, data face, HeroSet

Every one of them is something the face actually does, which is the rule in
`../go-to-market.md`: a keyword the build does not deliver reads as a false
claim in review.

## Screenshots

Captured, in `../../listing/screens/`, upload in the numbered order. One
device is enough — HeroSet shipped five shots from a single device and passed
review; there is no per-device-family requirement. The cover, hero and device
icons sit alongside them in `../../listing/`. Still **FILL**: the always-on
shot, which has to come off the FR965. See `screenshots.md`.

## The rest of the form

The fields the copy above does not cover, answered the way HeroSet answered
them (`../../../HeroSet/docs/store-release.md`, filled against the live form
2026-09-19). The watch-face form may not show all of them.

| Field | Answer |
|---|---|
| App Migration (auto-add new compatible devices) | **No.** Support is the explicit 117-product list in `../compatibility.md`; letting the store add untested devices would ship a layout nobody has run. |
| Does your app collect user data? | **No.** Nothing leaves the watch (privacy page says the same). Still paste the privacy URL. |
| ANT+ profiles | No. |
| Regional limits | No. |
| Source Code URL | Leave blank — not open source. |
| Review Notification | Yes. |
| Monetization | Paid, USD 2.00. |
| Companion App / Additional Hardware | Leave blank. HeroSet is not a companion app — it is a separate paid app the face can read on the watch. |
| Cover Image (500×500) | `../../listing/cover-500.png` |
| Hero Image (1440×720) | `../../listing/hero-1440x720.png` |
| Screen Images | `../../listing/screens/`, in numbered order |
| Device icons (optional, 128×128) | `../../listing/icon-64-128.png` (64 colour) and `icon-24-128.png` (24 bit) |

## Before you submit

- [x] Support and privacy URLs resolve — all three `/heroface/` pages returned
      200 on 2026-09-20
- [ ] The `.iq` package is built from the current source
- [ ] Gate 1 in `../go-to-market.md` is done: the device session
- [ ] HeroSet's own update is ready to submit in the same window (decided
      2026-09-20)
- [ ] Read Garmin's App Review Guidelines (SDK docs → Reference Guides)
