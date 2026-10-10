# Second-platform notes (web research 2026-10-08)

Behind section 6 of `reports/Passive income plan.md`. Searches standard-mode web searches; no primary source reachable -> row says so. Re-verify fees, policies at sign-up: change yearly.

## Wear OS (Google Play)

- **Watch Face Format mandatory.** Google dev docs: as of January 2026 Watch Face Format (WFF) required to install watch faces on all Wear OS devices. 9to5Google: from 2026-01-14 legacy AndroidX/WSL faces no longer installable from Play; installed ones keep working, no updates. Watch Face Studio faces must be resubmitted with WFS 1.8.7+.
  - https://developer.android.com/training/wearables/wff
  - https://9to5google.com/?p=676523
  - https://android-developers.googleblog.com/2025/06/upcoming-changes-to-wear-os-watch-faces.html
- **WFF declarative XML, no executable code** in APK (Android dev docs). Face built in Samsung Watch Face Studio (publishes to Play after registering Play developer account) or hand-written.
  - https://developer.samsung.com/sdp/blog/en/2024/04/02/publishing-watch-faces-to-the-play-store
- **Fees.** $25 one-time registration (third-party guide, not confirmed on Google's own page in results). Service fee 15% on first $1M per year once enrolled in reduced tier (needs payments profile, account group, accept tier ToS); 30% above.
  - https://support.google.com/googleplay/android-developer/answer/10632485
  - https://www.testerscommunity.com/blog/how-much-does-it-cost-to-publish-an-app-on-google-play
- **New personal accounts: closed test, 12 opted-in testers, 14 continuous days before production.** Organisation accounts exempt (sources agree on rule, disagree on cutoff date; Google's page authoritative).
  - https://support.google.com/googleplay/android-developer/answer/14151465
  - https://androidauthority.com/google-play-app-testing-requirement-3510580
- **Earnings: unpublished.** Samsung dev forum anecdotes: one paid sale vs free installs "100 to 1"; ads at 1–3 installs a day; thread doubting anyone profited moving to Play.
  - https://forum.developer.samsung.com/t/profit/16704
  - https://forum.developer.samsung.com/t/pricing-strategies-on-the-play-store/30770
- **Watch Face Push (Wear OS 6)** lets marketplace apps (Facer, TIMEFLIK, WatchMaker, Pujie, Recreative) install WFF faces from phone app. Developer builds phone app + cloud side. Not relevant to solo publisher until face has installs.
  - https://developer.android.com/training/wearables/watch-face-push
  - https://9to5google.com/2025/05/21/facer-wear-os-6-return/

- **Watch Face Studio price:** overview page (fetched 2026-10-08) states no price or licence; "free" general knowledge, not re-verified.
  - https://developer.samsung.com/watch-face-studio/overview.html

## Facer

- Creator Partner Program **invite-only**; revenue share unpublished (community thread asked, no answer). Facer claims $1M+ paid out, designers "making a living": promotional.
  - https://www.facer.io/creator/partner
  - https://community.facer.io/t/premium-designer-program-admission-rankings-and-revenue-sharing-terms/25147
  - https://news.facer.io/celebrating-1-million-in-designer-payouts-and-launching-our-first-facer-creator-partner-program/

## Apple watchOS

- No third-party watch faces; third-party "faces" = apps or complications. **General knowledge, not re-verified 2026-10-08:** App Store Review Guidelines page (first 100k characters) names no watch-face clause either way; membership page states no fee ($99/yr general knowledge). Face sharing via CLKWatchFaceLibrary broke in watchOS 26 (developer forum thread). Not a face market.
  - https://developer.apple.com/forums/thread/811587
  - https://developer.apple.com/app-store/review/guidelines/
  - https://developer.apple.com/support/compare-memberships/

## Huawei Watch Face Store (HUAWEI Themes)

Terms read 2026-10-09 in browser (ROADMAP 17.4); developer docs JavaScript pages -> sources below do not render in plain fetch.

- **Programme.** Watch faces = one content type of HUAWEI Themes (with phone themes, fonts, wallpapers, AOD). Publishing needs HUAWEI Developer ID and **"certified designer (watch face)" permission**: qualification review of submitted works ("individual designers, design companies, illustrators, students, and on-the-job employees can apply"; "excellent color matching skills, remarkable aesthetics ... originality ... premium works continuously"). Rejected application re-submittable only after interval Huawei names; repeated submissions of same work count as malicious. Steps: Console > Content services > HUAWEI Themes > Personal Center > Qualification application; Merchant Service must be enabled for paid content. Page last updated 2021-04-08.
  - https://developer.huawei.com/consumer/en/doc/content/settlement-guidance-0000001056348857
  - https://developer.huawei.com/consumer/en/doc/content/watchface-faq-0000001174035539 (designer permission; test only with a certified HUAWEI ID)
- **Revenue share (agreement last updated 2026-09-30).** Bipartite model (publisher uploads own work): Huawei : Publisher = **30% : 70%** of RSRA, where RSRA = (Price paid by End User − Deductions) × (1 − **Operation Cost Rate**), Operation Cost Rate is "a comprehensive rate that includes channel and other operation costs", **not stated on page**. Membership (Themes VIP package) income same split with usage coefficient. Real take = 70% of unknown base; marketing page says "Get as much as 70% of all revenue".
  - https://developer.huawei.com/consumer/en/doc/content/protocol-0000001054239369
  - https://developer.huawei.com/consumer/en/huaweithemes/
- **Settlement.** Signing entity by developer registration location: Huawei Software Technologies (Chinese mainland, CNY), **Aspiegel SE for Part II countries (Europe and others; list starts "Åland Islands, Albania, Andorra, Australia, Austria, Belgium ..."; Lithuania not individually confirmed, list truncated in reader), EUR, minimum settlement €200**; Huawei Services (Hong Kong) for Part III, EUR, €200. Below minimum, amount rolls on; after six months Huawei settles what accumulated. Each settlement sheet needs confirmation and (unless self-billing with VAT number) **commercial invoice emailed within five business days**; payment within 30 days after. Taxes: VAT withheld, remitted by Huawei per country; withholding tax on developer's share where treaties apply; currency conversion at developer's cost.
  - https://developer.huawei.com/consumer/en/doc/content/checkout-process-0000001055868899
  - https://terms1.hicloud.com/agreementservice/developer/getAgreementTemplate?agrType=1003&country=ove&language=en_us&version=2021062801 (Merchant Service Agreement, 2021-06-28, PDF)
- **Tool.** Theme Studio (Huawei visual editor; watch faces built from image layers + tool's own element set), not code: second engine, nothing from Monkey C projects carries over except artwork.
  - https://developer.huawei.com/consumer/en/doc/content/themes-design-tools-0000001054531194
- **Scale claims.** October 2025 press: 100,000+ faces, "VIP packages", 17.5M MAU; one secondary source cites 2021 single-face windfall (13M RMB), not typical.
  - https://www.prnewswire.com/il/news-releases/huawei-empowers-global-designers-to-shape-wearable-brilliance-with-100-000-watch-faces-302570569.html
  - https://heyupnow.com/blogs/brand-buzz/huaweis-watch-face-store-hits-major-milestone-with-over-100-000-designs
- Market: Counterpoint Q2 2026 Huawei #1, 22% share, ~80% of it in China.
- **Verdict 2026-10-09: stays LATER.** Reachable for individual in Europe (Aspiegel SE, EUR), but costs portfolio review, second design tool, invoice per payout, €200 floor, for split whose base = undisclosed cost rate. Revisit only if Wear OS spike shows non-Garmin store delivers installs.

## Zepp OS (Amazfit)

- Paid faces through official store only from **certified corporate developers in Mainland China**; others "not supported by the official channel". Buyers outside China pay via Apple/Google; developer nets 100% − 15% Zepp − 30% store = 55%. Tiers $1.99/$2.99/$3.99.
  - https://docs.huami.com/docs/guides/faq/paid-app/

## Fitbit

- EU gallery removed third-party apps and clocks June 2024. Late-2025 developer threads: submissions unanswered for weeks. Google: new Fitbit hardware in 2026 expected on Wear OS, not Fitbit OS.
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

- Last public figures 2019: ~5,000 apps, 2,000+ developers, 10M CIQ devices, 90M downloads (updates count). No 2025/2026 figure found.
  - https://dcrainmaker.com/2019/04/garmin-connect-announcements-day.html