# Repair listings, prove accuracy, then build

**As of 2026-09-25, studio next moves cheap, unglamorous, sequential: repair both store listings, prove HeroSet counts better than Garmin's free native counter, answer four Garmin/dashboard questions before any new feature.** HeroSet 1.1.1, HeroFace 1.0.1 both live with **1 and 0 downloads, 0 reviews** ([HeroSet](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/54bbf625-82af-4715-8af0-f2f16a5d1377?countryCode=US), [HeroFace](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/ad04d1e1-8e30-45cb-bbd6-82374f77b116?countryCode=US)), yet almost no free listing levers from research applied: HeroSet still category 219 not Strength Training; HeroFace live description **166 characters**. Largest strategic risk: HeroSet differentiator, counting accuracy, unproven: launch gate waived (ADR-042) and only one 35-rep set exists. Corrections that change decisions: break-even **~59 sales a year, not 48**; paid watch apps **54 of 120, not 103**; paid faces **34 of 120, not 51**; Ready cannot exist as watch app; anything below CIQ 3.4 cannot be sold; "80 watches" site claim (117 for HeroFace) now exceeds store listing (66 and 69). Code review essentially closed in code; remaining: proof on hardware (nothing below has device evidence beyond FR965) and two zero-code checks, original-Venu burn-in rule and site-versus-store device counts. Nothing in notes supports building new product yet: no demand signal for either live app, new listing restarts 6-24 month traction clock.

## What is verified, what is only simulated, and what nobody knows

Verified core: Garmin's own rules, store shape. Garmin keeps **15% of tax-exclusive price**, charges **$100 non-refundable annual fee**, pays monthly at **$10 minimum** after 48-hour return window, limits merchants by country ([App Sales](https://developer.garmin.com/connect-iq/articles/monetization/App_Sales.html), [Merchant Onboarding](https://developer.garmin.com/connect-iq/articles/monetization/Merchant_Onboarding.html)) [verified 2026-09-25]. Web purchasing ended **2025-11-20**; Connect IQ mobile app sole route to buy or install ([Garmin announcement](https://forums.garmin.com/developer/connect-iq/b/news-announcements/posts/changes-to-the-connect-iq-store)) [verified]. Trials exist for apps only via developer-run HTTPS unlock server, and "not for watch faces" ([Trial Apps](https://developer.garmin.com/connect-iq/articles/core-topics/Trial_Apps.html)) [verified]. Rank lists cap 120 rows; rank not lifetime installs: #1 Goals in 100k bucket, #2 Face It in 5M ([store pull](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps?startPageIndex=0&pageSize=30&sortType=mostPopular&countryCode=US&appType=WATCHFACE)) [verified]. Top 120 faces: **34 paid, 99 over a year old, 3 under 90 days, none has trial mode**; only 2 of 34 paid faces reach 100k bucket, 26 sit at 10k [verified]. New apps at zero downloads on day three normal [verified locally, feed skews to last week]. No indie has published Connect IQ revenue [verified negative finding].

Best-evidenced market gap: execution, not category. Across 2,544 one- and two-star reviews of top 30 faces, device fit (14.8%), paywall or key friction (14.4%), settings not saving (8.4%) dominate; accessibility, "calm minimal", HRV, Training Readiness do not [verified 2026-09-22 from review corpus; 94% of reviews for superseded versions, treat shares as floors]. HeroFace already on that gap with one honest $2.00 price, 10-size fit suite. No note supplies demand: no conversion, revenue or ARPU figure anywhere, no evidence goal-bar-plus-streak face converts. Fitness niche incumbent Push-Up Hero **4.3 stars over 905 reviews**, 63 one-star texts almost all about counting accuracy; nobody sells one multi-exercise app that counts well [verified locally]. Strength Training shelf 101 apps, **13 of top 20 free**, already past research's own 40% "real pressure" threshold [verified 2026-09-25].

Everything engineering-side marked fixed is fixed in code and simulator only. Code review fix list essentially complete: all High and Medium items fixed in repo at HEAD `3cc2dee`; staged-site hazard (W1) avoided because "80 watches" copy reached `main` after 1.1.1 went live; remaining: original-Venu burn-in item (F1/F6), part of CSP (W12), HeroFace screenshots (W14), low-value hygiene. But HeroSet 1.1.1 shipped with device checks deferred by owner decision (ADR-050 (owed device checks are owner call)), so dashboard START fix on `d2airx10`, `onKey` commit path (no automated test, `KeyEvent` cannot be constructed), touch behaviour on 13 products are **live but unverified on hardware**. Only FR965 has run either app. Simulator passing not device proof; every "fixed" in this report inherits that limit.

Five things stay unknown, carried as gaps, not upgraded: whether listing text still drives discovery in **mobile** app (web endpoint verified; mobile app use not); whether paid listings hidden from search on fēnix 9 and FR170 (single unanswered forum report, [thread 444114](https://forums.garmin.com/developer/connect-iq/f/connect-iq-web-store/444114/paid-listings-filtered-out-of-store-search-on-58-of-115-devices-including-forerunner-170-and-fenix-9-is-there-a-published-monetization-device-list)); what Garmin does to reviews and downloads on paid-to-free switch (docs silent); whether text-only listing edit needs re-review or resets release date; whether adding permission re-prompts existing users. Native rep-count accuracy on current hardware also unmeasured; 3.0-67.5% error figure from four older watches, study year unconfirmed [plausible at best].

## Corrections: figures and claims in the local docs that are wrong or stale

Table: old value, corrected value, local file carrying error. Where grade not marked, verified against primary source 2026-09-25.

| Topic | Old claim | Corrected | Carried by |
|---|---|---|---|
| Break-even | ~48 sales/yr for the $100 fee; ~5 sales to first $10 | **~59 and ~6** ($2.00 x 0.85 = $1.70, before FX/DST); may be later if $10 applies per paying entity [plausible] | `reports/Selling HeroSet and HeroFace.md` |
| Paid watch apps | 103 of top 120 (58 at 2.49 EUR) | **54 paid / 66 free**, 27 at 2.49 EUR; modal price holds, "paid is the norm" does not | Selling report; `research_notes/Selling HeroSet and HeroFace/fitness_app_niche.md` |
| Paid watch faces | 51/120 (17/30, 29/60) | **34/120** (12/30, 16/60) | `reports/Garmin watch face market gap.md`; its `popular_faces.md` note |
| Face ranking | "Sticky lifetime-installs sort" | Velocity/recency-like, formula undocumented [unverified] | market-gap report, `marketing_channels.md` |
| Discovery | Off-rank apps reachable only by exact name; 4-page cap | Token relevance search over title and description ignores installs; browse lists cap 120, search returns up to 1,000 rows | market-gap report sections 3 and 5 |
| HeroFace 1.0.1 | "not live yet" | Live since 2026-09-24 15:41 UTC (confirm in dashboard) | `HeroFace/docs/status.md` |
| HeroFace 1.0.1 fixes | Code review notes read "store still served 1.0.0" | Same stale-doc source; two independent API pulls show 1.0.1 | code-review note citing that doc |
| Missing devices | 14/80 (HeroSet) and 48/117 (HeroFace) are "store-side policy", unexplained | **Largely explained** by Garmin paid-app allow-list (lowest tier CIQ 3.4); not fully | both `docs/status.md` (item 1, A4) |
| Trial for apps | "unconfirmed inference" that trials work | Yes for apps, only with own unlock server; ADR-039 (no in-app trial) stands | Selling report |
| AOD rule | "10% of pixels" | Since Venu 2: <10% of screen luminance and no pixel lit over 3 consecutive minutes; breaking either blanks screen | `Garmin IQ store face gaps/gaps.md`, `trends.md` |
| Seconds on AMOLED | 20 ms partial update works | `onPartialUpdate` is MIP-only; disallowed on AMOLED always-on | store-gaps note; possible tension with `HeroFace/docs/archive/plan.md` |
| Sensor access | Faces cannot read sensors, Body Battery, sunrise | `SensorHistory` (3.3.0) and complications (4.2.0) give Body Battery and stress; live compass/GPS is blocked part | store-gaps note |
| API levels | "CIQ 9 needs API 6.0; excludes FR965" | FR965 = 5.2; fēnix 9, Venu 4, FR570, FR70 = 6.0 ([compatible devices](https://developer.garmin.com/connect-iq/compatible-devices/)) | `platform_constraints_monetization.md` |
| Store change date | June 2026 | **2025-11-20** | `trends.md` (market gap) |
| Clone policy | "Policy changed" | Enforcement tightened; older apps not removed; "similar" undefined ([thread 413172](https://forums.garmin.com/developer/connect-iq/f/discussion/413172/policies-have-changed-regarding-the-use-of-original-garmin-watchface-designs-future-watchfaces-can-not-use-the-original-designs-anymore)) | store-gaps note |
| Review time | "about 72 hours" | No SLA; observed 1 day (HeroFace) to 10+ days reported | `HeroFace/docs/status.md` [unsourced] |
| Accessibility gap | Top gap | Refuted: 1.45% of complaints, 0 colour-blindness | `gaps_unmet_demand.md` |
| Ready (Opp. backlog) | Reads Training Status in a watch app | **Impossible**: only watch faces may subscribe to complications | `reports/Opportunities backlog.md` |
| Stress API | `ActivityMonitor.Info.stress` "confirmed" | Field is `stressScore`, API 5.0.0; zones2 is 5.2.2; sunrise needs `Positioning` permission | Opportunities backlog |
| Pre-3.4 device wave | "Smallest lift" | Unsellable while paid (App Sales lowest tier 3.4) | Opportunities backlog |
| Instinct AMOLED for HeroSet | Excluded as sub-window cut-out | Cut-out applies only to two MIP semi-octagon models; three AMOLED are round 390/416 px | `HeroSet/docs/compatibility.md` |
| HeroSet category | `listing/paste.md` says Strength Training | **Live category is 219** after 1.1.1 | `HeroSet/listing/paste.md` |
| Divide-by-zero risk (O3) | `drawBar` can divide by zero | Unreachable: `done` short-circuits goal of 0 | `reports/Improvements backlog.md` |
| Improvements "done" bodies | CSP enforced, HSTS 2 years with subdomains, vite 8.3.1, font preload "not done" | CSP is Report-Only; HSTS 1 year, no subdomains; vite is 8.3.0; preload shipped | Improvements backlog |
| Housekeeping drift | Tests 94/85; `architecture.md` 377 lines; ADR-044 "50 of 67 + 17"; "67 round five-button"; "nothing is committed" | 99/88; 378; 63 + 17 = 80; 80; all committed | `HeroSet/docs/status.md:9`, `architecture.md:188`, `decisions.md:266`, `PRODUCT.md`, code-quality report "Outcome" |
| HeroFace docs | "smallest 64 KB", `:setAntiAlias`, "device run blocks everything", "not yet in a HeroSet store build" | 96 KB; unused; already done; 1.1.1 is live | `HeroFace/docs/archive/plan.md:31,89,164`, `go-to-market.md:52`, `compatibility.md` |

Two unchecked claims suspect, not corrected: Reddit ad minima (three agency blogs give $20, $25, $50) and "Hot & Fresh is the only new-release surface" lore, resting on one 2023 developer thread. Do not quote single Garmin market share; Counterpoint (5.6%) and Omdia (~15%) measure different things.

## Where the notes disagree, and which one wins

**Break-even, 48 versus ~59 versus ~60.** 48 came from multiplying tax-inclusive 2.49 EUR by 0.85; Garmin splits tax-exclusive price point, so $2.00 x 0.85 = $1.70, fee needs 58.8 sales. Market note's "about 60" same number rounded. Trust **59**, per merchant year because fee annual. Still optimistic: FX and digital service taxes withheld, payouts arrive separately from Garmin International and Garmin Europe, so $10 minimum may bite per entity for mostly European buyer base [plausible, unverified].

**HeroFace 1.0.1 live status.** Three notes read store API today, see 1.0.1 (changed ~2026-09-24 15:41 UTC); code-review note repeats local doc's "still 1.0.0". Trust API; doc is stale party. Still not done: description; live text remains 166-character version. So fixes F2, F3, F4, F10 live but simulator-verified only.

**Why devices missing from store.** Go-to-market note: Garmin paid-app allow-list largely explains; opportunities note agrees only partly. Both right. Allow-list (API 6.0, 5.2, 5.1, 5.0, one 3.4 set, "subject to change") accounts for HeroFace's CIQ 3.x gaps and HeroSet's fēnix 6S, Enduro 1, FR945 LTE. It does **not** account for Descent MK2/MK2S, MARQ Gen 1, D2 Air X10, which are on list yet absent, while FR70 and FR170 shown though unnamed in SDK tiers. Raw API counts (93 and 96 device-type IDs) different unit from 66 and 69 products, settle nothing. Unresolved; only Garmin can close; ask about those three families specifically.

**Paid-share numbers.** Not in conflict; different populations. Faces: 34 of 120 paid, 86 free, free ones hold 500k-5M buckets. Watch apps: 54 of 120 paid. Strength Training shelf: 27 paid of 101. Use population matching decision: HeroFace price -> face census; HeroSet -> shelf (73% free).

**Is search still a lever?** Market note trusts live `/apps/keywords` endpoint; go-to-market note flags one forum poster says Garmin removed app search after web store closed. Endpoint verified, mobile application unverified. HeroSet ranks **#3 of 982 for "rep counter" at zero to one installs**, so listing text plainly works on web index. Treat "listing repair moves rank" as best available hypothesis; test on phone before investing beyond free edits.

**FR965 API level.** Compatible-devices page and SDK profile say 5.2.0; HeroSet's own log records crash on "CIQ 6.0.2". Runtime firmware may report newer than compile baseline. Plan on 5.2: anything needing 6.0 (Sleep Score) cannot be dogfooded on wrist. Unresolved.

**Sequencing between notes.** Go-to-market note wants listing repair with real version bump (HeroSet 1.1.2, or fold into 1.2.0 only if ships within two weeks); opportunities note ranks Connect sync 1.2.0 first, Instinct AMOLED bundle for next upload. Merge: first find out whether dashboard edits category and description in place, may need no binary at all; do not delay listing waiting for 1.2.0; add three Instinct AMOLED products only after Garmin answers device-list question, because manifest addition the store then filters buys zero reach.

## Open owner decisions

**Accuracy claims versus the release contract.** `release-contract.md` forbids promising measured counting accuracy; gate 2 waived. Go-to-market stop-rule (if HeroSet does not beat native, stop all marketing, fix detector) currently unevaluated. Recommendation: run test before amending anything; publish method only, without numbers, unless HeroSet wins, only then amend contract.

**Measuring outcomes versus "no analytics".** Site promises zero client JS, no analytics. Recommended: keep promise this month, attribute by store-dashboard install timing and per-channel redirect counts, postpone landing-to-store handoff metric; at these volumes nothing else readable anyway.

**Category: fix in place or in next upload.** README and live listing disagree; dashboard decides.

**What site's device count means.** Options: "manifest count", or "N in the store today, see Compatible Devices". List "subject to change", so prefer link over number. Not the W1 timing problem; it is the 80-versus-66 and 117-versus-69 mismatch.

**Instinct AMOLED for HeroSet.** Confirm exclusion was only about semi-octagon cut-out. If so, three products half-day change.

**Policy on shipping with owed device checks.** ADR-050 (owed device checks are owner call) made it owner call; durable rule (which checks block release) would stop re-arguing each time.

**Deferred with triggers, no action now:** free HeroFace twin (reach argument: free listing not confined to paid allow-list, though restarts reviews; wait for Garmin's paid-to-free answer and 30-day ratio); Cyrillic fallback (document as deliberate `system-ui` fallback, five minutes); on-watch settings path for HeroFace (editor exposure to third-party faces unverified).

## Merged priority list

Effort is notes' estimate, not measured. Tags: **W** needs physical watch, **S** simulator, **D** store dashboard or Garmin contact, **P** phone with Connect IQ app, **C** desk/code only.

| # | Action | Effort | Needs | Why here |
|---|---|---|---|---|
| 1 | Dashboard sweep: confirm HeroFace 1.0.1 live, category and description editable without a binary, USD-capable payout account, merchant renewal date, first sales report, install stats | 30 min | D | Settles three open items; changes shape of step 5 |
| 2 | Read Garmin's App Review Guidelines on titles and trademarks (never read; HeroFace's checklist item unticked) | 30 min | C | Rejection costs ~72 h; device names in titles unproven [top listings already do it] |
| 3 | Mobile findability test: both apps by keyword on the FR965-paired phone and a second device model; fēnix 9 or FR170 selection for the paid-search bug; tap an `apps.garmin.com/apps/<id>` link | 1 h | P | Most decision-relevant unverified item |
| 4 | Email Garmin developer support: paid-to-free consequences, why Descent MK2/MARQ Gen 1/D2 Air X10 are missing, category editing, paid-search bug | 30 min | D | Only Garmin can answer; blocks free-twin and device-wave decisions |
| 5 | HeroFace burn-in: simulator File > View Screen Heat Map on `venu`, `venud`, `d2air`, one per AMOLED size; if it trips, step both axes each minute or thin the font. Verify what "seconds" does on AMOLED at the same time | 30-60 min | S | Only unmitigated store-visible risk; FR965 proves nothing about original-Venu rule [plausible, unmeasured] |
| 6 | Listing repair, one bundled submission each. HeroSet: category 277, exercise nouns in title, singular and plural forms, reviewed description, cumulative What's New. HeroFace: paste the 1,822-character block, device tokens only for tested devices, HeroSet link, What's New | 3-5 h + 44-72 h review each | D | Free levers with best evidence; this approval date is day 0 of exposure test |
| 7 | Recapture HeroFace screenshots at 454 px plus missing always-on shot | 1-2 h | S | Feeds listing and "Screenshot pending" site slot; "doesn't look like the screenshots" its own complaint theme |
| 8 | HeroSet accuracy proof on FR965: 3 x 10 reps per exercise at slow, medium, fast, plus one 30+ rep set, hand-counted, against native Strength; log in `validation-log.md` | 3-4 h over a week | W | Whole differentiation rests on it; stops or releases all marketing |
| 9 | HeroFace settings round-trip on store build; owed device checks: FR965 START save (B1), `d2airx10` START and Menu2 (B3), `venu441mm` by hand (B2), relink, stored mode 2, F-to-C rounding | wear time | W (B3, B2 need those products or simulator) | Settings loss 8.4% of complaints; converts fixed-in-simulator to proven |
| 10 | Site: fix the 80/117 wording; enforce CSP after deploy-preview console check; doc-drift batch (94/85, 377, `plan.md` lines, `HeroFaceSleep.mc:5-7` comment); trim stale "done" bodies in improvements report | ~45 min | C | Public claims and hygiene, cheap |
| 11 | Instrument: daily poll of both appIds and ~20-term rank basket; Showcase thread per app; answer every review and the Venu 4 buyer; monthly threat watch (Garmin firmware, Strafe, F3b, free share of shelf) | 30 min setup, ~10 min/week | C/P | Organic seeding after step 6 approves; first 3-5 reviews buy visibility on highest-rated sort |
| 12 | Day-30 readout (about 2026-10-25): compute HeroSet-to-HeroFace download ratio, reviews, shelf rank, Garmin's answers; decide free twin, funnel, or positioning fix. Ads only from month 2, only if step 8 passed and measurement settled | 1-2 h | D | Nothing sequential readable earlier |
| 13 | HeroSet 1.2.0 Connect sync: step-0 FR965 spike, then device acceptance (10 checks), `Fit`/`FitContributor` in store manifest, same-session privacy, support and contract edits | 3-5 days | W | Second-largest complaint cluster against Push-Up Hero, but parity not differentiator; competes with step 8 for wrist time, so do it second |
| 14 | HeroSet wave 6: Instinct 3 AMOLED 45/50 mm and Instinct Crossover AMOLED | 0.5-1 day | C/S | Only after step 4 and decision on Instinct; accelerometer and HR unchecked |
| 15 | HeroFace 1.1 data bundle: Body Battery mission slot via complication (no new permission, 66 of 117 products); battery-days fallback | 2-4 days | S + W | Body Battery in 38 of top-100 face descriptions; skip `SensorHistory` fallback in v1 |
| 16 | Localise both listings (15 locales, separate submission); native-speaker read of deu/lit/pol touch hints and Portuguese `RANK` | outside help | D | Locale count correlates with scale [plausible only] |
| 17 | Engineering hygiene, only if file touched: route `HeroFaceSleep` text through `HeroFaceDraw.text` with test that sets `_sleeping && _burnIn`; type 38 view members; midnight Storage write from `onUpdate` (low); `iconSize` dead param; vite patch check; other trivial items | 2-4 h total | S/C | Low-value; review itself says churn exceeds gain |
| 18 | Process captures in CLAUDE.md files: tie public copy to store upload, not code session; site device counts are store-listed or say "manifest"; type every `var` member; read Throws on every SDK call; run `fit-sweep.sh` per language (HeroFace has no equivalent); one source for test counts | 15 min | C | Dominant root cause: second place updated by hand |

Deferred, in this order after readout: HeroSet glance view (1-3 days, needs capability sweep row, low value at zero installs), reset-detector-learning menu (only if accuracy testing shows learning traps), faster manual entry, sunrise/sunset row (needs new `Positioning` permission; decide deliberately), background nudge (1.3 at earliest), rest timer, HeroFace rectangle and Instinct MIP layouts ("if reviews ask").

## Never build, or cut

**Never:** Pace Face (most crowded category, wrong API names); Ready as watch app (platform-blocked, medical-claim clause, release contract forbids medical claims); any paid product aimed below CIQ 3.4; fourth HeroSet exercise; day history and best-set-today unless owner overrides with new reasoning; second HeroSet complication; in-app trial (ADR-039 (no in-app trial), needs payment-style backend); clones of Garmin stock faces; accessibility, calm-minimal, Training Readiness/HRV, women's health, CGM, golf and swim positioning; full-brightness always-on, live compass, weather radar.

**Cut or merge:** Rank Face (duplicates HeroFace's HeroSet mode, HeroSet has about one download); Verden Habits and Field Face (no-go until funnel ratio proves second product carries; if second face ever built, make it free HeroFace); phone-disconnected, DND, moon icons; approaching-goal haptic; barrel kits until second app exists; family accent ADR and studio page (real fix is link in HeroFace's description); seconds half of draw-bypass fix and divide guard (behaviour-neutral); flipping `noUncheckedIndexedAccess`; chasing `-l 3` to zero.

**Do not this month:** flip either listing to free, rename HeroSet, cancel merchant account (demonetizes both apps, requires repaying fee), spend on ads. $75 test buys roughly 2-9 installs, cannot show product sells. Do not quote 103/120, 51/120 or 48 sales in any doc.

## Conclusion

Research's largest correction is sequence, not fact: studio has thought about what to build next, evidence says next unit of value is inside two existing listings and one measurement. Search only surface zero-install newcomer controls, free; accuracy result only thing deciding whether HeroSet deserves marketing at all; rest of local backlog done, platform-blocked, or below noise floor.

Realistic year-one result: small loss against $100 fee; notes give no route to 100k tier only two paid faces reach. Month 12 becomes deliberate renewal decision, not default; Garmin answers (paid to free, device list) highest-leverage emails studio can send. Two open risks that could still surprise live customer both cheap to close this week: original-Venu burn-in rule in simulator, and device counts site claims but store does not list.