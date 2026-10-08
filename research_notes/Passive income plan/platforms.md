# Second-platform notes (web research 2026-10-08)

Behind section 6 of `reports/Passive income plan.md`. Searches were standard-mode web searches; where no primary source was reachable the row says so. Re-verify fees and policies at sign-up: these change yearly.

## Wear OS (Google Play)

- **Watch Face Format mandatory.** Google's developer docs: as of January 2026 the Watch Face Format (WFF) is required for installing watch faces on all Wear OS devices. 9to5Google: from 2026-01-14 legacy AndroidX/WSL faces can no longer be installed from Play; installed ones keep working, no updates. Watch Face Studio faces must be resubmitted with WFS 1.8.7+.
  - https://developer.android.com/training/wearables/wff
  - https://9to5google.com/?p=676523
  - https://android-developers.googleblog.com/2025/06/upcoming-changes-to-wear-os-watch-faces.html
- **WFF is declarative XML, no executable code** in the APK (Android developer docs). A face can be built in Samsung's Watch Face Studio (publishes to Play after registering a Play developer account) or hand-written.
  - https://developer.samsung.com/sdp/blog/en/2024/04/02/publishing-watch-faces-to-the-play-store
- **Fees.** $25 one-time registration (third-party guide, not confirmed on Google's own page in results). Service fee 15% on the first $1M per year once enrolled in the reduced tier (needs a payments profile, account group, accept the tier ToS); 30% above.
  - https://support.google.com/googleplay/android-developer/answer/10632485
  - https://www.testerscommunity.com/blog/how-much-does-it-cost-to-publish-an-app-on-google-play
- **New personal accounts: closed test with 12 opted-in testers for 14 continuous days before production.** Organisation accounts exempt (sources agree on the rule, disagree on the cutoff date; Google's page is authoritative).
  - https://support.google.com/googleplay/android-developer/answer/14151465
  - https://androidauthority.com/google-play-app-testing-requirement-3510580
- **Earnings: unpublished.** Samsung developer forum anecdotes: one paid sale against free installs "100 to 1"; ads at 1–3 installs a day; a thread doubting anyone profited from moving to Play.
  - https://forum.developer.samsung.com/t/profit/16704
  - https://forum.developer.samsung.com/t/pricing-strategies-on-the-play-store/30770
- **Watch Face Push (Wear OS 6)** lets marketplace apps (Facer, TIMEFLIK, WatchMaker, Pujie, Recreative) install WFF faces from a phone app. Developer builds the phone app and cloud side. Not relevant to a solo publisher until a face has installs.
  - https://developer.android.com/training/wearables/watch-face-push
  - https://9to5google.com/2025/05/21/facer-wear-os-6-return/

- **Watch Face Studio price:** its overview page (fetched 2026-10-08) states no price or licence; "free" is general knowledge, not re-verified.
  - https://developer.samsung.com/watch-face-studio/overview.html

## Facer

- Creator Partner Program is **invite-only**; revenue share unpublished (community thread asked, no answer). Facer claims $1M+ paid out and designers "making a living": promotional.
  - https://www.facer.io/creator/partner
  - https://community.facer.io/t/premium-designer-program-admission-rankings-and-revenue-sharing-terms/25147
  - https://news.facer.io/celebrating-1-million-in-designer-payouts-and-launching-our-first-facer-creator-partner-program/

## Apple watchOS

- No third-party watch faces; third-party "faces" are apps or complications. **General knowledge, not re-verified 2026-10-08:** the App Store Review Guidelines page (first 100k characters) names no watch-face clause either way, and the membership page states no fee ($99/yr is general knowledge). Face sharing via CLKWatchFaceLibrary broke in watchOS 26 (developer forum thread). Not a face market.
  - https://developer.apple.com/forums/thread/811587
  - https://developer.apple.com/app-store/review/guidelines/
  - https://developer.apple.com/support/compare-memberships/

## Huawei Watch Face Store

- October 2025 press: 100,000+ faces, "VIP packages" that "enable design businesses to unlock new revenue streams", 17.5M MAU claimed. **Revenue share and designer terms not found**; one secondary source cites a 2021 single-face windfall (13M RMB), not typical.
  - https://www.prnewswire.com/il/news-releases/huawei-empowers-global-designers-to-shape-wearable-brilliance-with-100-000-watch-faces-302570569.html
  - https://heyupnow.com/blogs/brand-buzz/huaweis-watch-face-store-hits-major-milestone-with-over-100-000-designs
- Market: Counterpoint Q2 2026 has Huawei #1 at 22% share, about 80% of it in China.

## Zepp OS (Amazfit)

- Paid faces through the official store only from **certified corporate developers in Mainland China**; others "not supported by the official channel". Buyers outside China pay via Apple/Google; developer nets 100% − 15% Zepp − 30% store = 55%. Tiers $1.99/$2.99/$3.99.
  - https://docs.huami.com/docs/guides/faq/paid-app/

## Fitbit

- EU gallery removed third-party apps and clocks June 2024. Late-2025 developer threads: submissions unanswered for weeks. Google: new Fitbit hardware in 2026 is expected on Wear OS, not Fitbit OS.
  - https://support.google.com/fitbit/answer/14237121
  - https://community.fitbit.com/t5/SDK-Development/Did-Fitbit-abandoned-the-Gallery-App-Manager/m-p/5789266
  - https://9to5google.com/2025/10/27/new-fitbit-2026/

## Market shares Q2 2026 (two firms, different definitions)

| Vendor | Counterpoint | Omdia |
|---|---|---|
| Apple | 20.1% | 46% |
| Huawei | 22% (record) | 7% |
| Samsung | not top 5 | 15% |
| Garmin | 5.6% (+11% YoY) | 15% |

- https://counterpointresearch.com/insights/global-smartwatch-shipments-fall-4-percent-in-q2-2026-huawei-reaches-its-record-share
- https://www.sammobile.com/news/garmin-challenges-samsung-smartwatch-market-share-q2-2026/
- https://the5krunner.com/2026/09/09/smartwatch-shipments-q2-2026/

## Garmin Connect IQ store size

- Last public figures are 2019: ~5,000 apps, 2,000+ developers, 10M CIQ devices, 90M downloads (updates count). No 2025/2026 figure found.
  - https://dcrainmaker.com/2019/04/garmin-connect-announcements-day.html
