# HeroSet listing — notes

What sits behind [`README.md`](README.md), the paste-ready copy. Nothing here is pasted into the form. Paths are relative to `HeroSet/listing/`. Release history: [`../CHANGELOG.md`](../CHANGELOG.md).

## Economics and rules

Paid, USD 2.00 (→ $1.99 US), no trial ([ADR-039](../docs/decisions.md#adr-039); Garmin's 48-hour return window is the only try-before-keep). Garmin takes 15% of the tax-exclusive price; $100/yr merchant fee; $10 minimum payout (re-verify, values change). Merchant approved 2026-09-18.

Garmin expects every listed product tested, screenshots matching the app, permissions justified. Accepted gap: 79 of 80 simulator-verified only ([ADR-039](../docs/decisions.md#adr-039), [ADR-048](../docs/decisions.md#adr-048)). Refs: [monetization](https://developer.garmin.com/connect-iq/monetization/), [publishing](https://developer.garmin.com/connect-iq/core-topics/publishing-to-the-store/), [app review](https://developer.garmin.com/connect-iq/app-review-guidelines/).

Live listing: https://apps.garmin.com/apps/54bbf625-82af-4715-8af0-f2f16a5d1377. Support page (not a form field): https://verden.watch/heroset/support/. Site source: `../../verden-site`.

## Upload file

Upload a freshly exported `dist/HeroSet-store.iq` ([`../docs/development.md`](../docs/development.md); `dist/` holds only the current export; `bin/` is scratch). 1.1.1 was uploaded from `bin/HeroSet-store-next.iq` (exported 2026-09-24, 126 device variants, includes the 13 touch-first products). Never upload `bin/HeroSet-store-1.0.0-shipped.iq`.

## Form limits and options

Saved page, 2026-09-19: Title 50, Description 4000, What's New 4000, App Version 20.

- **Category options:** Beliefs, Business, Celestial, Communication, Education, Entertainment, Finance, Food & Drink, Games, Golf, Health & Fitness, Home Automation, Lifestyle, Marine, Medical, Navigation, Social, Sports, Strength Training, Tools, Travel, Weather, Wellness. The API read 219 (Health & Fitness) on 2026-09-25: see the open item in [`../docs/go-to-market.md`](../docs/go-to-market.md).
- **Subcategory options:** Cycling, Geocaching, Hiking, Other, Running, Swimming, Walking. No strength option.

## Why each answer

| Field | Reason |
|---|---|
| Description | Plain text, keep line breaks; the first line is what list views show. Checked against the forbidden claims in [`../docs/release-contract.md`](../docs/release-contract.md) on 2026-09-22 (the 2026-09-19 check predates the daily-goal line and the current contract). |
| App Version | Free text, not read from the manifest; bump on every upload (patch for fixes, minor for features). 1.1.1 live ([ADR-050](../docs/decisions.md#adr-050)); next 1.2.0. |
| Collects user data | No: the store build has no network access, no activity recording, no sync ([ADR-033](../docs/decisions.md#adr-033)). The privacy policy is still linked (gate 6). |
| Cover Image | Shield + name only: it shows at about 100 px in browse, so no screen text. |
| Screen Images | Simulator captures of the store build ([ADR-039](../docs/decisions.md#adr-039)), no mockups. If a shot shows a changed UI, re-take it and update the site copy in `../../verden-site/public/heroset/screens/`. |
| Email | The dedicated support address, also on the site's support and privacy pages. |
| App Migration | No: support is an explicit list of 80 products ([`../docs/compatibility.md`](../docs/compatibility.md), [ADR-034](../docs/decisions.md#adr-034)/[035](../docs/decisions.md#adr-035)/[037](../docs/decisions.md#adr-037)/[038](../docs/decisions.md#adr-038)/[048](../docs/decisions.md#adr-048)); don't let the store add untested devices. |
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

Copy rules: any HeroFace mention needs the qualifier "On watches running Connect IQ 4.2 or later" ([ADR-044](../docs/decisions.md#adr-044)); keep the reliability line unspecific, because naming the defect advertises it and [`../docs/release-contract.md`](../docs/release-contract.md) already says adjust, never fix.

**1.1.0**

```text
- Set your own daily goal on the watch: anything from 10 to 500 reps, no phone needed.
- Reliability and performance improvements when saving a set.
```

**1.0.0:** `First release.`
