# HeroSet listing — notes

What sits behind [`README.md`](README.md), the paste-ready copy. Nothing here is pasted into the form. Paths are relative to `HeroSet/listing/`. Release history: [`../CHANGELOG.md`](../CHANGELOG.md).

## Economics and rules

Paid, USD 2.00 (→ $1.99 US), no trial ([ADR-039](../docs/decisions.md#adr-039); Garmin's 48-hour return window is the only try-before-keep). Garmin takes 15% of the tax-exclusive price; $100/yr merchant fee; $10 minimum payout (re-verify, values change). Merchant approved 2026-09-18.

Garmin expects every listed product tested, screenshots matching the app, permissions justified. Accepted gap: 79 of 80 simulator-verified only ([ADR-039](../docs/decisions.md#adr-039), [ADR-048](../docs/decisions.md#adr-048)). Refs: [monetization](https://developer.garmin.com/connect-iq/monetization/), [publishing](https://developer.garmin.com/connect-iq/core-topics/publishing-to-the-store/), [app review](https://developer.garmin.com/connect-iq/app-review-guidelines/).

Live listing: https://apps.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377. Support page (not a form field): https://verden.watch/heroset/support/. Site source: `../../site`.

## Upload file

Upload `dist/HeroSet-store.iq` (re-exported 2026-10-04 from main at c2f41eb, after the bezel-corner and START: MENU fixes ([ADR-055](../docs/decisions.md#adr-055) amendment); the 2026-10-03 export had the clipped footer (kept as `dist/old/HeroSet-store-1.3.0-prefix-bezel-bug-DO-NOT-UPLOAD.iq`) and the first 2026-10-04 one shortened START: MENU (`dist/old/HeroSet-store-1.3.0-before-hint-fix.iq`): 87 products, 134 device variants, same app id `568d5c9b-eb10-4678-bf28-0080c3efbbc1`, permissions exactly `Sensor` + `ComplicationPublisher`; the 1.2.0 export is in `dist/old/HeroSet-store-1.2.0-shipped.iq`). Re-export if any source changes first ([`../docs/development.md`](../docs/development.md); `dist/` holds only the current export; `bin/` is scratch). 1.1.1 was uploaded from `bin/HeroSet-store-next.iq` (exported 2026-09-24, 126 device variants, includes the 13 touch-first products). Never upload `bin/HeroSet-store-1.0.0-shipped.iq`.

## Form limits and options

Saved page, 2026-09-19: Title 50, Description 4000, What's New 4000, App Version 20.

- **Category options:** Beliefs, Business, Celestial, Communication, Education, Entertainment, Finance, Food & Drink, Games, Golf, Health & Fitness, Home Automation, Lifestyle, Marine, Medical, Navigation, Social, Sports, Strength Training, Tools, Travel, Weather, Wellness. The API read 219 (Health & Fitness) on 2026-09-25: see the open item in [`../docs/go-to-market.md`](../docs/go-to-market.md).
- **Subcategory options:** Cycling, Geocaching, Hiking, Other, Running, Swimming, Walking. No strength option.

## Why each answer

| Field | Reason |
|---|---|
| Description | Plain text, keep line breaks; the first line is what list views show. Checked against the forbidden claims in [`../docs/release-contract.md`](../docs/release-contract.md) on 2026-09-22, and again on 2026-09-26 for the glance line (63 of 80 watches, no reminder/alert wording) (the 2026-09-19 check predates the daily-goal line and the current contract); submitted for 1.2.0 on 2026-09-27. |
| App Version | Free text, not read from the manifest; bump on every upload (patch for fixes, minor for features). 1.1.1 live ([ADR-050](../docs/decisions.md#adr-050)); the glance build ([ADR-051](../docs/decisions.md#adr-051)) was submitted as **1.2.0**, not the 1.1.2 it was called during development ([ADR-053](../docs/decisions.md#adr-053)); Connect sync (1.3.0) is shelved, [ADR-054](../docs/decisions.md#adr-054). |
| Collects user data | No: the store build has no network access, no activity recording, no sync ([ADR-033](../docs/decisions.md#adr-033)). The privacy policy is still linked (gate 6). |
| Cover Image | Shield + name only: it shows at about 100 px in browse, so no screen text. |
| Screen Images | Simulator captures of the store build ([ADR-039](../docs/decisions.md#adr-039)), no mockups; the app's own pixels are never altered. Chassis+strap style, 2026-09-27: real full-window captures cropped to 720² and white-padded, background then keyed to transparent (connected-component flood fill from the corners) — the only post-capture edit, cosmetic only. If a shot shows a changed UI, re-take it and update the site copy in `../../site/public/heroset/screens/`. |
| Email | The dedicated support address, also on the site's support and privacy pages. |
| App Migration | No: support is an explicit list of products (80 live, 87 from 1.3.0; [`../docs/compatibility.md`](../docs/compatibility.md), [ADR-034](../docs/decisions.md#adr-034)/[035](../docs/decisions.md#adr-035)/[037](../docs/decisions.md#adr-037)/[038](../docs/decisions.md#adr-038)/[048](../docs/decisions.md#adr-048)); don't let the store add untested devices. |
| Monetization | Paid through the store. |

## Image sources

- **Framed** (`framed/`, 1300×1300, watch frame around the store screens): marketing extras for ads and social. Not part of the store form. Only copy of the art, no source file.
- **Hero** (`hero-1440x720.png`): real store-build screens from `screens/`, no watch frame. Source `src/hero.html`. Re-render after re-taking screens:

  ```sh
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 --window-size=1440,720 --screenshot="$PWD/hero-1440x720.png" "file://$PWD/src/hero.html"
  ```

- **Cover** (`cover-500-designed.png`, 500×500): source `src/cover.html`, rendered the same way with `--window-size=500,500`.
- **Device icons:** launcher shield on black. Render `src/icon.html` at window 128×128 for the 24-bit icon, then `python3 src/quantize64.py icon-24-128.png icon-64-128.png`.

## What's New: history and copy rules

Copy rules: the glance is "on watches with Connect IQ 4.0 or later" (66 of 87 products, 63 of 80 before the Instinct E and Instinct 3 Solar; the Instinct 2 family has none; never "all watches", never "reminder"/"alert", [ADR-051](../docs/decisions.md#adr-051)); any HeroFace mention needs the qualifier "On watches running Connect IQ 4.2 or later" ([ADR-044](../docs/decisions.md#adr-044)); keep the reliability line unspecific, because naming the defect advertises it and [`../docs/release-contract.md`](../docs/release-contract.md) already says adjust, never fix.

**1.2.0**

```text
- New glance: add HeroSet to your watch's glance list to see today's push-ups, sit-ups, squats and your streak without opening the app. On watches with Connect IQ 4.0 or later.
```

**1.1.1**

```text
- Now on touchscreen watches: Venu 2, 2 Plus, 2S, 3, 3S and 4, vívoactive 5 and 6, Approach S50 and S70, and D2 Air X10. Swipe up or down to adjust a count, then press START to save.
- A stray tap on the counting or adjust screen can no longer end or save a set, on any watch. Only the START button does.
- Text fits better on smaller screens in several languages.
- If the motion sensor can't start, the workout screen now says so instead of staying at 0.
- HeroFace, our watch face, is now in the Connect IQ Store. On watches with Connect IQ 4.2 or later, it can show today's HeroSet progress.
- Reliability improvements.
```

**1.1.0**

```text
- Set your own daily goal on the watch: anything from 10 to 500 reps, no phone needed.
- Reliability and performance improvements when saving a set.
```

**1.0.0:** `First release.`
