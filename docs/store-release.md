# Store and monetization plan

## Plan

- Distribution: Garmin Connect IQ Store · paid app · target price USD 2.00
  (→ $1.99 US, per current Garmin docs) · trial undecided.
- Garmin share: 15% of tax-exclusive price; $100/yr non-refundable merchant
  fee; $10 minimum payout; 48-hour return window. Re-verify before onboarding —
  values change.
- Merchant onboarding, payment, tax, and country eligibility must complete
  before publishing.

HeroSet progress is entirely local to the watch by default — no FIT activity,
no Garmin Connect/Strava sync (ADR-021). Sync is available as an explicit,
off-by-default opt-in (ADR-025): one combined FIT activity/day, no
GPS/distance.

## Release requirements

- Store build signed with the permanent developer key.
- Every listed product tested for advertised features.
- Screenshots/descriptions match the actual app; permissions declared/justified;
  name, branding, artwork original.
- Final package tested on simulator + physical devices.

References: [monetization](https://developer.garmin.com/connect-iq/monetization/),
[price points](https://developer.garmin.com/connect-iq/monetization/price-points/),
[merchant onboarding](https://developer.garmin.com/connect-iq/monetization/merchant-onboarding/),
[publishing](https://developer.garmin.com/connect-iq/core-topics/publishing-to-the-store/),
[app review](https://developer.garmin.com/connect-iq/app-review-guidelines/).

## Upload form — copy/paste answers

For `apps.garmin.com/en-US/developer/upload`, Step 2. This first upload is a
**private test/beta** pass (per Garmin's own on-page note: this appID gets
consumed by test-only distribution — a fresh UUID in `manifest.xml` is needed
for the real paid submission, see `go-to-market.md` status item 4). Answers
below assume that context; flip the flagged ones at real-submission time.

| Field | Value |
|---|---|
| Title | `HeroSet — Bodyweight Rep Counter` |
| Description | `Push-up, sit-up, and squat tracking for Forerunner 965 with daily goals, streaks, and manual correction. Automatic rep counting (beta) uses the accelerometer and per-exercise calibration; counting depends on watch placement and movement, and is not guaranteed accurate for every user, exercise, or speed. Live heart rate and calorie readouts during a set — calories are Garmin's own whole-day total delta, not a dedicated per-session measurement, and this is not a medical device. No activity is created or synced anywhere by default. An optional, off-by-default Connect Sync setting creates one combined FIT activity per day spanning that day's sets (no GPS or distance data) if you turn it on.` **Recheck the sync sentence before submitting:** one-per-day is unverified on the watch (`go-to-market.md` status item 0). |
| What's New | `Initial beta build for private testing.` |
| Hero Image | Skip for this test pass (optional; 1440×720). |
| Category | "Health & Fitness" if listed; **verify actual dropdown options against the live page** — not confirmed here. |
| Subcategory | Closest to "Training"/"Exercise"; verify against dropdown. |
| Does your app collect user data? | **No** for this private test pass (privacy policy page isn't published yet — gate 6, still open). Switch to **Yes** + the real privacy policy URL at public submission, since opt-in sync does send workout data to Garmin Connect/Strava when enabled. |
| ANT+ profiles? | No (not used). |
| Regional limits? | No. |
| Cover Image (500×500) / Screen Images | Pull from a physical-device screenshot pass (`go-to-market.md` Phase 2 step 2) — not yet taken. |
| Email Address | Use a dedicated support/publishing email, not a personal one — matches the earlier recommendation to publish under a separate Garmin account, and the form's own advice. |
| Source Code URL | Leave blank (not open source). |
| Review Notification | Yes. |
| App Migration (new compatible devices) | **No** — device support is FR965-only by design until a layout/sensor capability-matrix pass (`docs/compatibility.md`); don't let the store auto-add untested devices. |
| Monetization | **No** for this test pass — merchant onboarding (Phase 2 step 8) isn't done. Switch to **Yes** only at the real paid submission, once merchant account/payment/tax setup is complete. |
| Companion App / Additional Hardware | Leave blank — not applicable. |

The upload page also showed **"Signature check failed"** for the attached
file; status and next step are tracked in `go-to-market.md` (status item 2).