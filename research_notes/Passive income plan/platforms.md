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

## Huawei Watch Face Store (HUAWEI Themes)

Terms read 2026-10-09 in a browser (ROADMAP 17.4); the developer docs are JavaScript pages, so the sources below do not render in a plain fetch.

- **Programme.** Watch faces are one content type of HUAWEI Themes (with phone themes, fonts, wallpapers, AOD). Publishing needs a HUAWEI Developer ID and the **"certified designer (watch face)" permission**: a qualification review of submitted works ("individual designers, design companies, illustrators, students, and on-the-job employees can apply"; "excellent color matching skills, remarkable aesthetics ... originality ... premium works continuously"). A rejected application can be re-submitted only after the interval Huawei names; repeated submissions of the same work count as malicious. Steps: Console > Content services > HUAWEI Themes > Personal Center > Qualification application; Merchant Service must be enabled for paid content. Page last updated 2021-04-08.
  - https://developer.huawei.com/consumer/en/doc/content/settlement-guidance-0000001056348857
  - https://developer.huawei.com/consumer/en/doc/content/watchface-faq-0000001174035539 (designer permission; test only with a certified HUAWEI ID)
- **Revenue share (agreement last updated 2026-09-30).** Bipartite model (publisher uploads own work): Huawei : Publisher = **30% : 70%** of the RSRA, where RSRA = (Price paid by End User − Deductions) × (1 − **Operation Cost Rate**), and the Operation Cost Rate is "a comprehensive rate that includes channel and other operation costs", **not stated on the page**. Membership (Themes VIP package) income uses the same split with a usage coefficient. So the real take is 70% of an unknown base; the marketing page says "Get as much as 70% of all revenue".
  - https://developer.huawei.com/consumer/en/doc/content/protocol-0000001054239369
  - https://developer.huawei.com/consumer/en/huaweithemes/
- **Settlement.** Signing entity by the developer's registration location: Huawei Software Technologies (Chinese mainland, CNY), **Aspiegel SE for Part II countries (Europe and others; the list starts "Åland Islands, Albania, Andorra, Australia, Austria, Belgium ..."; Lithuania not individually confirmed, the list is truncated in the reader), EUR, minimum settlement €200**; Huawei Services (Hong Kong) for Part III, EUR, €200. Below the minimum, the amount rolls on; after six months Huawei settles what accumulated. Each settlement sheet needs a confirmation and (unless self-billing with a VAT number) a **commercial invoice emailed within five business days**; payment within 30 days after that. Taxes: VAT withheld and remitted by Huawei per country; withholding tax on the developer's share where treaties apply; currency conversion at the developer's cost.
  - https://developer.huawei.com/consumer/en/doc/content/checkout-process-0000001055868899
  - https://terms1.hicloud.com/agreementservice/developer/getAgreementTemplate?agrType=1003&country=ove&language=en_us&version=2021062801 (Merchant Service Agreement, 2021-06-28, PDF)
- **Tool.** Theme Studio (Huawei's visual editor; watch faces are built from image layers and the tool's own element set), not code: a second engine, nothing from the Monkey C projects carries over except the artwork.
  - https://developer.huawei.com/consumer/en/doc/content/themes-design-tools-0000001054531194
- **Scale claims.** October 2025 press: 100,000+ faces, "VIP packages", 17.5M MAU; one secondary source cites a 2021 single-face windfall (13M RMB), not typical.
  - https://www.prnewswire.com/il/news-releases/huawei-empowers-global-designers-to-shape-wearable-brilliance-with-100-000-watch-faces-302570569.html
  - https://heyupnow.com/blogs/brand-buzz/huaweis-watch-face-store-hits-major-milestone-with-over-100-000-designs
- Market: Counterpoint Q2 2026 has Huawei #1 at 22% share, about 80% of it in China.
- **Verdict 2026-10-09: stays LATER.** Reachable for an individual in Europe (Aspiegel SE, EUR), but it costs a portfolio review, a second design tool, an invoice per payout and a €200 floor, for a split whose base is an undisclosed cost rate. Revisit only if the Wear OS spike shows that a non-Garmin store delivers installs.

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
