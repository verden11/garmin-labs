# Store release

Paid, USD 2.00 (→ $1.99 US), no trial (ADR-039; Garmin's 48-hour return window is the only try-before-keep). Garmin takes 15% of tax-exclusive price; $100/yr merchant fee; $10 minimum payout (re-verify, values change). Merchant approved 2026-09-18.

Garmin expects every listed product tested, screenshots matching the app, permissions justified. Accepted gap: 66 of 67 simulator-verified only (ADR-039). Refs: [monetization](https://developer.garmin.com/connect-iq/monetization/), [publishing](https://developer.garmin.com/connect-iq/core-topics/publishing-to-the-store/), [app review](https://developer.garmin.com/connect-iq/app-review-guidelines/).

## Upload form — copy/paste answers

For `apps.garmin.com/en-US/developer/upload`, step 2. Upload a freshly exported `bin/HeroSet-store.iq` (`development.md`; older `.iq` files in `bin/` are stale).

| Field | Value |
|---|---|
| Title | `HeroSet - Bodyweight Rep Counter` (32/50 chars). Form limits (saved page, 2026-09-19): Title 50, Description 4000, What's New 4000, App Version 20. |
| Description | Block below. Plain text, keep line breaks; first line is what list views show. Checked against `release-contract.md` forbidden claims 2026-09-19. |
| App Version | `1.0.0`. Free text, not read from manifest; bump every upload (patch for fixes, minor for features). |
| What's New | `First release.` |
| Hero Image | `listing/hero-1440x720.png`: real store-build screens from `listing/screens/`, no watch frame. Source `listing/src/hero.html` (cover: `src/cover.html` → `cover-500-designed.png`, 500×500); re-render after re-taking screens: `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --hide-scrollbars --allow-file-access-from-files --virtual-time-budget=5000 --window-size=1440,720 --screenshot="$PWD/listing/hero-1440x720.png" "file://$PWD/listing/src/hero.html"` |
| Category | **Strength Training**. Options (2026-09-19): Beliefs, Business, Celestial, Communication, Education, Entertainment, Finance, Food & Drink, Games, Golf, Health & Fitness, Home Automation, Lifestyle, Marine, Medical, Navigation, Social, Sports, Strength Training, Tools, Travel, Weather, Wellness. |
| Subcategory | **Other** (options: Cycling, Geocaching, Hiking, Other, Running, Swimming, Walking; no strength option). Not marked required; leave blank if form allows. |
| Does your app collect user data? | **No.** Store build no network access, no activity recording, no sync (ADR-033). Still link privacy policy (gate 6). |
| Privacy policy URL | https://verden.watch/heroset/privacy/ (site repo `../verden-site`). Support page: https://verden.watch/heroset/support/. |
| ANT+ profiles? | No (not used). |
| Regional limits? | No. |
| Cover Image (500×500) / Screen Images | Cover `listing/cover-500-designed.png` (shield + name: shows ~100 px in browse, so no screen text); screens `listing/screens/` in upload order (`1-dashboard` … `4-saved`, `5-menu` optional). Simulator captures of store build (ADR-039), no mockups. UI change shown in a shot → re-take it, and update the site copy in `../verden-site/public/heroset/screens/`. |
| Device icons (optional, 128×128) | Yes. 64 Color: `listing/icon-64-128.png`; 24 bit: `listing/icon-24-128.png`. Launcher shield on black; render `listing/src/icon.html` (window 128×128) → 24-bit, then `python3 listing/src/quantize64.py listing/icon-24-128.png listing/icon-64-128.png`. |
| Email Address | `hello@verden.watch` (dedicated support address, also on the Verden site support and privacy pages). |
| Source Code URL | Leave blank (not open source). |
| Review Notification | Yes. |
| App Migration (new compatible devices) | **No** — support is explicit list of 67 products (`docs/compatibility.md`, ADR-034/035/037/038); don't let store auto-add untested devices. |
| Monetization | **Paid:** Yes, USD 2.00. |
| Companion App / Additional Hardware | Leave blank — not applicable. |

### Description

```text
100 push-ups, 100 sit-ups and 100 squats a day — or your own goal, 10 to 500 — counted on your wrist.

- Start a set, do your reps: HeroSet counts them with the watch's motion sensor.
- After every set, check the count and adjust it with UP/DOWN before it's saved. HeroSet learns from the counts you save, so it gets closer to how you move with every set.
- Earn XP for every rep up to 100 per exercise a day, climb ranks and keep your streak alive. Rank reflects the reps you do, not the goal you pick.
- Set your own daily goal on the watch: 10 to 500 reps, no phone needed.
- Live heart rate and calories during each set.
- Available in multiple languages.

Everything stays on your watch. HeroSet has no network access, records no activity and sends nothing to Garmin Connect.

Good to know: counting depends on how you wear the watch and how you move, so the number can be off. Calories are the change in Garmin's own daily total, an estimate. Not a medical device.
```
