# Store and monetization plan

## Plan

- Distribution: Garmin Connect IQ Store · paid app · target price USD 2.00
  (→ $1.99 US, per current Garmin docs) · no trial (ADR-039; Garmin's
  48-hour return window is only try-before-keep).
- Garmin share: 15% of tax-exclusive price; $100/yr non-refundable merchant
  fee; $10 minimum payout; 48-hour return window. Re-verify before onboarding —
  values change.
- Merchant onboarding, payment, tax, country eligibility all done before
  publishing.

HeroSet progress all local to watch. v1 store build record no FIT activity,
no Garmin Connect/Strava sync, no `Fit` permission (ADR-021, ADR-033); sync
only in dev build (ADR-025).

## Release requirements

- Store build signed with permanent developer key.
- Every listed product tested for advertised features. Accepted gap: 66 of
  67 simulator-verified only (ADR-039).
- Screenshots/descriptions match actual app; permissions declared/justified;
  name, branding, artwork original.
- Final package tested on simulator + physical devices.

References: [monetization](https://developer.garmin.com/connect-iq/monetization/),
[price points](https://developer.garmin.com/connect-iq/monetization/price-points/),
[merchant onboarding](https://developer.garmin.com/connect-iq/monetization/merchant-onboarding/),
[publishing](https://developer.garmin.com/connect-iq/core-topics/publishing-to-the-store/),
[app review](https://developer.garmin.com/connect-iq/app-review-guidelines/).

## Upload form — copy/paste answers

For `apps.garmin.com/en-US/developer/upload`, Step 2. Upload
`bin/HeroSet-store.iq` built with export command in `development.md`
(app id `568d5c9b-eb10-4678-bf28-0080c3efbbc1`, ADR-033). Rows marked **paid**
change between free/beta upload and paid submission.

| Field | Value |
|---|---|
| Title | `HeroSet — Bodyweight Rep Counter` |
| Description | `A daily 100 push-ups, 100 sit-ups and 100 squats challenge for Garmin watches with five buttons and a round screen, run entirely from the watch buttons. Automatic rep counting (beta) uses the watch's accelerometer with a quick 10-rep calibration per exercise; counting depends on how the watch is worn and how you move, so it can miscount, and every set can be corrected before it is saved. Earn XP, climb ranks and keep a streak. Live heart rate and calorie readouts during a set: calories are the change in Garmin's own daily total, an estimate, and this is not a medical device. Everything stays on your watch: HeroSet records no activity and sends no data anywhere.` Check against `release-contract.md` before submit. |
| What's New | `First release.` |
| Hero Image | Optional (1440×720). Skip unless real-build image exist. |
| Category | "Health & Fitness" if listed; **verify actual dropdown options against live page** — not confirmed here. |
| Subcategory | Closest to "Training"/"Exercise"; verify against dropdown. |
| Does your app collect user data? | **No.** Store build no network access, no activity recording, no sync (ADR-033). Still link privacy policy (gate 6). |
| Privacy policy URL | Public URL of `site/privacy.html` once hosted (`go-to-market.md` status item 2). |
| ANT+ profiles? | No (not used). |
| Regional limits? | No. |
| Cover Image (500×500) / Screen Images | Simulator captures of store build (ADR-039, `go-to-market.md` status item 5); no mockups. |
| Email Address | `verdenapp@gmail.com` (dedicated support address, also on `site/index.html` and `site/privacy.html`). |
| Source Code URL | Leave blank (not open source). |
| Review Notification | Yes. |
| App Migration (new compatible devices) | **No** — support is explicit list of 67 products (`docs/compatibility.md`, ADR-034/035/037/038); don't let store auto-add untested devices. |
| Monetization | **Paid:** Yes, USD 2.00, only after merchant enrollment approved and gate 2 passes (`release-contract.md`). No for free/beta upload. |
| Companion App / Additional Hardware | Leave blank — not applicable. |

If upload show "Signature check failed" again, see `go-to-market.md`
status item 4.