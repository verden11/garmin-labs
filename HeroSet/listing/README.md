# HeroSet — Connect IQ Store listing

Everything the store form needs, paste-ready: upload-form answers, the description, and What's New per version (newest first). Images are in this folder (`screens/`, `src/`, the PNGs); release history in `CHANGELOG.md`. Paths below are relative to `HeroSet/`.

Paid, USD 2.00 (→ $1.99 US), no trial (ADR-039; Garmin's 48-hour return window is the only try-before-keep). Garmin takes 15% of tax-exclusive price; $100/yr merchant fee; $10 minimum payout (re-verify, values change). Merchant approved 2026-09-18.

Garmin expects every listed product tested, screenshots matching the app, permissions justified. Accepted gap: 79 of 80 simulator-verified only (ADR-039, ADR-048). Refs: [monetization](https://developer.garmin.com/connect-iq/monetization/), [publishing](https://developer.garmin.com/connect-iq/core-topics/publishing-to-the-store/), [app review](https://developer.garmin.com/connect-iq/app-review-guidelines/).

## Upload form — copy/paste answers

For `apps.garmin.com/en-US/developer/upload`, step 2. **1.1.1: upload `bin/HeroSet-store-next.iq`** (exported 2026-09-24, 126 device variants, includes the 13 touch-first products). Otherwise upload a freshly exported `bin/HeroSet-store.iq` (`docs/development.md`; older `.iq` files in `bin/` are stale). For 1.1.0 that export was made 2026-09-21 23:45, 105/105 device variants; the shipped 1.0.0 artifact is kept beside it as `bin/HeroSet-store-1.0.0-shipped.iq` — never upload that one.

| Field | Value |
|---|---|
| Title | `HeroSet - Bodyweight Rep Counter` (32/50 chars). Form limits (saved page, 2026-09-19): Title 50, Description 4000, What's New 4000, App Version 20. |
| Description | Block below. Plain text, keep line breaks; first line is what list views show. Re-checked against `docs/release-contract.md` (2026-09-21) forbidden claims on 2026-09-22 — the 2026-09-19 check predates both the daily-goal line and the current contract. |
| App Version | **`1.1.1`** (uploaded 2026-09-24; ADR-050). `1.1.0` live since 2026-09-22. Next after this: `1.2.0` (Connect sync). History in `CHANGELOG.md`. Free text, not read from manifest; bump every upload (patch for fixes, minor for features). 1.0.0 was approved and went live 2026-09-21. |
| What's New | **1.1.1 block below.** Earlier blocks kept as used. (1.0.0 was `First release.`) |
| Hero Image | `listing/hero-1440x720.png`: real store-build screens from `listing/screens/`, no watch frame. Source `listing/src/hero.html` (cover: `src/cover.html` → `cover-500-designed.png`, 500×500); re-render after re-taking screens: `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 --window-size=1440,720 --screenshot="$PWD/listing/hero-1440x720.png" "file://$PWD/listing/src/hero.html"` |
| Category | **Strength Training**. Options (2026-09-19): Beliefs, Business, Celestial, Communication, Education, Entertainment, Finance, Food & Drink, Games, Golf, Health & Fitness, Home Automation, Lifestyle, Marine, Medical, Navigation, Social, Sports, Strength Training, Tools, Travel, Weather, Wellness. |
| Subcategory | **Other** (options: Cycling, Geocaching, Hiking, Other, Running, Swimming, Walking; no strength option). Not marked required; leave blank if form allows. |
| Does your app collect user data? | **No.** Store build no network access, no activity recording, no sync (ADR-033). Still link privacy policy (gate 6). |
| Privacy policy URL | https://verden.watch/heroset/privacy/ (site in `../verden-site`). Support page: https://verden.watch/heroset/support/. |
| ANT+ profiles? | No (not used). |
| Regional limits? | No. |
| Cover Image (500×500) / Screen Images | Cover `listing/cover-500-designed.png` (shield + name: shows ~100 px in browse, so no screen text); screens `listing/screens/` in upload order (`1-dashboard` … `4-saved`, `5-menu` optional). Simulator captures of store build (ADR-039), no mockups. UI change shown in a shot → re-take it, and update the site copy in `../verden-site/public/heroset/screens/`. |
| Device icons (optional, 128×128) | Yes. 64 Color: `listing/icon-64-128.png`; 24 bit: `listing/icon-24-128.png`. Launcher shield on black; render `listing/src/icon.html` (window 128×128) → 24-bit, then `python3 listing/src/quantize64.py listing/icon-24-128.png listing/icon-64-128.png`. |
| Email Address | `hello@verden.watch` (dedicated support address, also on the Verden site support and privacy pages). |
| Source Code URL | Leave blank (not open source). |
| Review Notification | Yes. |
| App Migration (new compatible devices) | **No** — support is explicit list of 80 products (`docs/compatibility.md`, ADR-034/035/037/038/048); don't let store auto-add untested devices. |
| Monetization | **Paid:** Yes, USD 2.00. |
| Companion App / Additional Hardware | Leave blank — not applicable. |

### Description

```text
100 push-ups, 100 sit-ups and 100 squats a day, or your own goal from 10 to 500. Your Garmin counts the reps.

- Start a set, do your reps: HeroSet counts them with the watch's motion sensor.
- Runs on the watch's buttons: START and UP/DOWN, or START and a swipe on touchscreen watches. No phone, no account.
- After every set, check the count and adjust it before it's saved. Only the START button saves, so a stray tap can't.
- HeroSet learns from the counts you save, so counting adapts to how you move.
- Earn XP for every rep up to 100 per exercise a day, climb ranks and keep your streak alive. Rank reflects the reps you do, not the goal you pick.
- Set your own daily goal on the watch: 10 to 500 reps, no phone needed.
- Live heart rate and a calorie estimate during each set.
- In 15 languages, including German, French, Spanish, Italian, Polish and Ukrainian.

Everything stays on your watch. HeroSet has no network access, records no activity and sends nothing to Garmin Connect. The store lists "Communication & Data Transmission" because HeroSet hands today's progress to our HeroFace watch face on the same watch; nothing is sent anywhere.

Good to know: counting depends on how you wear the watch and how you move, so the number can be off. Calories are the change in Garmin's own daily total, an estimate. Not a medical device.
```

### What's New (1.1.1)

```text
- Now on touchscreen watches: Venu 2, 2 Plus, 2S, 3, 3S and 4, vívoactive 5 and 6, Approach S50 and S70, and D2 Air X10. Swipe up or down to adjust a count, then press START to save.
- A stray tap on the counting or adjust screen can no longer end or save a set, on any watch. Only the START button does.
- Text fits better on smaller screens in several languages.
- If the motion sensor can't start, the workout screen now says so instead of staying at 0.
- HeroFace, our watch face, is now in the Connect IQ Store. On watches with Connect IQ 4.2 or later, it can show today's HeroSet progress.
- Reliability improvements.
```

Paste the description block above too: its button line changed for touchscreen watches. After review, check the listing's Compatible Devices tab shows the 13 new products.

### What's New (1.1.0)

```text
- Set your own daily goal on the watch: anything from 10 to 500 reps, no phone needed.
- Reliability and performance improvements when saving a set.
```

No HeroFace line: the watch face has no store listing yet (`../HeroFace/docs/go-to-market.md`), and release notes must not point at something a buyer cannot get. When it does list, the bullet is **`On watches running Connect IQ 4.2 or later, today's progress can appear on our HeroFace watch face.`** — the qualifier matters, the complication is CIQ 4.2+ only (ADR-044). The reliability line stays deliberately unspecific: naming the defect advertises it, and `release-contract.md` already says adjust, never fix.

**Before pasting:** open the live listing and compare its description to the block
above. 1.0.0 was uploaded 2026-09-19 and the daily-goal line was added 2026-09-20,
so any goal wording already published is ahead of the shipped build — 1.1.0 makes
it true. Re-check the whole block against `docs/release-contract.md` the same session.

**After 1.1.0 clears review:** set `storeUrl` in
`../verden-site/src/apps/heroset/app.ts` and close gate 6
([`docs/go-to-market.md`](../docs/go-to-market.md) item 8).
