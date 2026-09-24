# Verification against Garmin's live developer documentation

All pages below were rendered in Chrome (JS-rendered; plain HTTP fetch returns a nav
shell only) and observed on **2026-09-22**. Every source is a Garmin-owned domain.

---

## 1. API level and device compatibility (HIGHEST PRIORITY)

### Takeaway
**Forerunner 965 is API Level 5.2 as of 2026-09-22 per Garmin's live table, not 6.0** — so `COMPLICATION_TYPE_SLEEP_SCORE`
(API 6.0.2) is **not available on the user's own test device**. But the prior
researcher's framing is wrong in two important ways: there is no "Connect IQ 9.x line
requires API 6.0" rule on any Garmin page, and **Instinct 3 is API 6.0** (it is *not*
excluded). Critically, paid apps *are* sold on FR965 — Garmin's monetized-device list
explicitly includes an "API Level 5.2" tier with Forerunner 965 in it.

### Cited Findings
- Device reference table, verbatim rows — [Compatible Devices](https://developer.garmin.com/connect-iq/compatible-devices/) (observed 2026-09-22):
  - `Forerunner® 965  454 x 454  round  AMOLED  5.2`
  - `Forerunner® 265  416 x 416  round  AMOLED  5.2`
  - `Forerunner® 265s  360 x 360  round  AMOLED  5.2`
  - `fēnix® 7 / quatix® 7  260 x 260  round  Memory-In-Pixel (64 colors)  5.2`
  - `fēnix® 7 Pro  260 x 260  round  Memory-In-Pixel (64 colors)  5.2`
  - `Venu® 3  454 x 454  round  AMOLED  5.2`
  - `Instinct® 3 AMOLED 45mm  390 x 390  round  AMOLED  6.0`
  - `Instinct® 3 AMOLED 50mm  416 x 416  round  AMOLED  6.0`
  - `Instinct® 3 Solar 45mm / 50mm  176 x 176  semi-octagon  Memory-In-Pixel (2 colors)  6.0`
- The page's "Supported CIQ Version" filter offers: `All, 1.2, 1.4, 2.4, 3.0, 3.1, 3.2, 3.3, 3.4, 5.0, 5.1, 5.2, 6.0` — there is no "9.x" anywhere on Garmin's device pages — [Compatible Devices](https://developer.garmin.com/connect-iq/compatible-devices/)
- Devices that *are* API 6.0 include: fēnix 8 / 8 Pro / 8 Solar, fēnix 9 family, fēnix E, Forerunner 970, 570, 170, 70, Venu 4, Venu X1, vívoactive 6, Enduro 3, Instinct 3 (all), Instinct E, Instinct Crossover AMOLED, D2 Mach 2 Pro, Edge 1040/1050/540/550/840/850/MTB — [Compatible Devices](https://developer.garmin.com/connect-iq/compatible-devices/)
- `COMPLICATION_TYPE_SLEEP_SCORE 42 — API Level 6.0.2 — "Value is a non-negative number from 0 to 100 representing sleep score or null"` — [Toybox.Complications](https://developer.garmin.com/connect-iq/api-docs/Toybox/Complications.html)
- The Complications module itself is old and broadly available: `"The Complications module allows apps to both subscribe to and publish complications." Since: API Level 4.2.0` — [Toybox.Complications](https://developer.garmin.com/connect-iq/api-docs/Toybox/Complications.html)
- The previous newest complication type before sleep score is `COMPLICATION_TYPE_LAST_GOLF_ROUND_SCORE 41 — API Level 5.0.0`; everything from index 0–39 is API 4.2.0 — [Toybox.Complications](https://developer.garmin.com/connect-iq/api-docs/Toybox/Complications.html)
- Garmin sells monetized apps on a **five-tier** device list whose second tier is headed `API Level 5.2` and contains `Forerunner® 965`, `Forerunner® 265`, `fēnix® 7`, `fēnix® 7 Pro`, `Venu® 3`, `vívoactive® 5` (plus tiers for 6.0, 5.1, 5.0 and 3.4) — [Monetization → App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)

### Verdicts
- **"FR965 requires / supports API 6.0" — REFUTED.** FR965 is API Level 5.2.
- **"COMPLICATION_TYPE_SLEEP_SCORE is available on FR965" — REFUTED.** It needs 6.0.2; FR965 is at 5.2 in the live table. (API level is a live, firmware-driven value, not a documented permanent ceiling — re-check the table before acting on this long after 2026-09-22.)
- Cross-check: the per-device reference page for the FR965 was also rendered and **carries no API Level field at all** — `Id fr965`, `Screen Shape round`, `Screen Size 454 x 454`, `Display Colors 65536`, `Touch True`, and a `Watch Face` memory limit of `131072` bytes. Garmin publishes API level only on the Compatible Devices table, so that table is the single authority — [Device Reference → Forerunner 965](https://developer.garmin.com/connect-iq/device-reference/fr965/)
- **"API 6.0 excludes FR965, FR265, fēnix 7 / 7 Pro, Venu 3" — CONFIRMED** (all are 5.2).
- **"API 6.0 excludes Instinct 3" — REFUTED.** All three Instinct 3 variants are 6.0.
- **"Connect IQ 9.x line requires API level 6.0" — UNVERIFIABLE from Garmin.** No Garmin page uses a "9.x" version label for Connect IQ; the versioning Garmin publishes is API Level (…5.2, 6.0). This claim came from the5krunner/forums and has no Garmin-owned corroboration. Do not repeat it.

### Inferences
- Anything gated on API 6.0.x — sleep score complication included — cannot be dogfooded on the FR965. Development of such a product is possible in the simulator but not testable on the user's own wrist, which per this repo's house rule ("simulator passing is not device proof") is a real blocker.
- The buildable-on-FR965 ceiling is API 5.2, which still includes the entire Complications subscribe/publish surface (4.2.0), watch face config mode and `getComplicationDrawable` (5.1.0). The "whole class of product ideas" is only dead if it specifically needs sleep score or another 6.0-only API — not merely because it is a complication product.
- Monetization is orthogonal to 6.0: Garmin lists FR965 as a device that can receive paid apps.

### Gaps
- Garmin does not publish a per-API-level changelog page on developer.garmin.com that I could render; "what is new in 6.0" would have to be reconstructed from per-symbol `Since:` lines in the API docs.

---

## 2. Monetization figures

### Takeaway
All four prior figures check out against the live rendered pages, with one clarification:
"most of the EU" is Garmin's own wording, and the actual list includes several non-EU
states (UK, Switzerland, Norway, Gibraltar, Monaco, Liechtenstein, Guernsey).

### Cited Findings
- `"Garmin receives 15% of the tax-exclusive price point."` — [Monetization → App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)
- Accompanying bullets: `"Garmin adds the sales tax onto the price point."`, `"Garmin is responsible for the credit card fees."`, `"The digital service taxes (if applicable) will be withheld from your payouts."`, `"The cost of conversion to the developer payout currency will be withheld from your payouts."` — [App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)
- `"During the onboarding process, you are asked to pay the program fee. This is an annual, non-refundable fee of $100 USD."` — [Monetization → Merchant Onboarding](https://developer.garmin.com/connect-iq/monetization/merchant-onboarding/)
- `"The Connect IQ™ monetization system is available to developers with legal entities in the United States, Canada, Australia, Singapore, and most of the European Union."` — [Merchant Onboarding](https://developer.garmin.com/connect-iq/monetization/merchant-onboarding/)
- The Europe row of that table in full: `Austria, Belgium, Croatia, Cyprus, Czech Republic, Denmark, Estonia, Finland, France, Germany, Gibraltar, Greece, Guernsey, Hungary, Ireland, Italy, Latvia, Liechtenstein, Lithuania, Luxembourg, Malta, Monaco, Netherlands, Norway, Poland, Portugal, Romania, Slovakia, Slovenia, Spain, Sweden, Switzerland, and United Kingdom` (footnoted: US includes Puerto Rico; UK includes Isle of Man and Jersey) — [Merchant Onboarding](https://developer.garmin.com/connect-iq/monetization/merchant-onboarding/)
- The Price Points page exposes exactly 16 currency tabs: `ARS, AUD, CAD, CHF, CZK, DKK, EUR, GBP, MXN, NOK, NZD, RON, SEK, THB, USD, VND` — [Monetization → Price Points](https://developer.garmin.com/connect-iq/monetization/price-points/)
- Every currency table runs from `USD $2.00` to `USD $100.00`. The grid is $0.25 steps from $2.00–$10.00, $1.00 steps from $10.00–$50.00, then $60/$70/$80/$90/$100 — 78 price points — [Price Points](https://developer.garmin.com/connect-iq/monetization/price-points/)
- Note the price *point* is not the shelf price: the $2.00 point retails at `1.99 USD` in the United States, `2.25 USD` in Taiwan, `2.49 EUR` in France/Germany/Italy/Portugal/Spain, `1.99 GBP` in the UK — [Price Points](https://developer.garmin.com/connect-iq/monetization/price-points/)
- Payout mechanics (not previously claimed, but material): `"Payouts are sent on the first day of every month."`, `"Funds are not captured from customers until the 48-hour return window has passed."`, `"Payouts require a minimum $10 USD balance in your account."` — [App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)
- Re-pricing a live free app pulls it from the store: `"If you are setting a price for an app that has already been approved, the app is temporarily removed from the store so it can be reviewed again."` — [App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)
- Buyer-side reach is far wider than seller-side: the "Supported Countries for Users" tables cover most of the Americas, Africa, Europe and APAC — [App Sales](https://developer.garmin.com/connect-iq/monetization/app-sales/)

### Verdicts
- **15% of tax-exclusive price — CONFIRMED** (verbatim).
- **$100/yr non-refundable merchant fee — CONFIRMED** (verbatim; "annual, non-refundable fee of $100 USD").
- **Seller eligibility US/Canada/Australia/Singapore/"most of the EU" — CONFIRMED** verbatim, with the caveat that the actual list is broader than the EU (UK, CH, NO, GI, MC, LI, GG) and narrower in places (no Bulgaria, no Iceland, no Isle of Man as a standalone).
- **Price points $2.00–$100.00 in 16 currencies — CONFIRMED.**

### Inferences
- Effective developer take is below 85%: 15% Garmin, minus digital service taxes and FX conversion, both explicitly withheld from payouts. Credit-card fees are Garmin's, not the developer's.
- The $100/yr floor plus the $10 payout minimum means a paid face must clear roughly 60 US sales/yr at the $2.00 point ($1.69 net each after Garmin's 15%) just to break even on the program fee — before FX and DST.
- The 48-hour return window and month-boundary rollover mean first revenue lands ~5–6 weeks after launch.

### Gaps
- Garmin does not publish the Connect IQ Developer Agreement text on an open developer.garmin.com page I could render; the App Sales / Merchant Onboarding pages reference it but it sits behind the dashboard. Any claim sourced "from the developer agreement" is unverified here.
- No published refund rate, conversion rate, or sales-volume data anywhere on Garmin's developer site.

---

## 3. Trial mode

### Takeaway
**Garmin does document a native trial mechanism — and it explicitly does not work for
watch faces.** That single sentence fully explains why `hasTrialMode` is false on all 51
paid faces in the popular list: it is not developer neglect, it is a platform exclusion.

### Cited Findings
- `"The app trials feature is not supported for watch faces."` — [Core Topics → App Trials](https://developer.garmin.com/connect-iq/core-topics/trial-apps/)
- `"The app trials feature allows developers to enable a special \"trial\" mode for their app."` — Since API level 2.3.0 — [App Trials](https://developer.garmin.com/connect-iq/core-topics/trial-apps/)
- It is opt-in via manifest, and requires the developer to host an unlock endpoint: `<iq:trialMode enable="true"><iq:unlockURL>https://a.custom.unlock.url.info</iq:unlockURL></iq:trialMode>`; `"The app store will only accept secured HTTPS-URLs when uploading your iq-file."` — [App Trials](https://developer.garmin.com/connect-iq/core-topics/trial-apps/)
- Runtime surface: `"Developers can query the AppBase.isTrial() method to determine if trial mode is active"`, and `"AppBase.getTrialDaysRemaining() must return a Lang.Number that represents how many days are remaining in the trial, or null if time-based trials are to be disabled. If 0 is returned, the app will be prevented from running as the trial will be considered \"expired\"."` — [App Trials](https://developer.garmin.com/connect-iq/core-topics/trial-apps/)
- Unlock is a developer-run server flow, not Garmin checkout: the store redirects to the developer's `unlockURL` with `callbackUrl`, `appUnlockRequestId` and `appPageUrl`, and `"The callbackUrl-endpoint is secured and can only be used with a (one-legged) OAuth1-signed request."` — [App Trials](https://developer.garmin.com/connect-iq/core-topics/trial-apps/)
- Documented callback status codes: `200 OK`, `202 Accepted` (test), `401 Unauthorized`, `404 Not Found`, `409 Conflict`, `410 Gone`, `510 Internal Server Error` — [App Trials](https://developer.garmin.com/connect-iq/core-topics/trial-apps/)

### Verdicts
- **"Garmin documents a native trial mechanism" — CONFIRMED** (App Trials, API 2.3.0+).
- **"Nobody uses it on watch faces" — CONFIRMED and explained:** Garmin's own doc bars watch faces from the feature.

### Inferences
- `hasTrialMode: false` on 51/51 paid faces is therefore not a signal about developer behaviour or an untapped gap — it is the only possible value. Any product thesis built on "be the first paid face with a trial" is dead on arrival via the native mechanism.
- Even for non-watch-face app types, the feature is heavy: it requires a public HTTPS unlock endpoint, OAuth1 credentials from the dashboard, and your own payment collection. It is a *bring-your-own-monetization* bridge, entirely separate from the 15%/$100 Garmin merchant system in section 2 — which is likely why it is rare generally.
### Gaps
- Garmin publishes no statistics on trial-mode adoption.
- Whether a free "Lite"/"Trial" companion listing beside a paid face is permitted is not addressed on any Garmin page I rendered. The App Review Guidelines only require honest disclosure of payment requirements (§5), which neither permits nor forbids it. I did not render any store listing, so I make no claim about what developers actually do.

---

## 4. Always-on display design rules

### Takeaway
The 10% figure is **correct and appears verbatim in three independent Garmin sources**.
But two things the prior researcher missed are material: (a) there is a second
constraint — an individual pixel may not stay lit for more than three consecutive
minute-updates, and violating *either* rule blanks the entire screen; and (b) **since the
Venu 2 the 10% is measured as screen luminance, not as a count of lit pixels**, which
changes how a design is budgeted. Also: `onPartialUpdate` is a MIP mechanism and is
explicitly *not allowed* on AMOLED, so the 20 ms budget and `onPowerBudgetExceeded` do
not apply to an AMOLED always-on face at all.

### Cited Findings — the AMOLED rule and how it changed
- `"When the watch face enters always-on mode, the watch face will only update every minute, and each update is limited to using 10% of the available pixels of the display."` — [UX Guidelines → Watch Faces](https://developer.garmin.com/connect-iq/user-experience-guidelines/watch-faces/)
- Same page, preceding sentence: `"Because long-term display use affects the battery life and can wear down the display, Connect IQ has special rules for AMOLED always-on mode."` — [UX Guidelines → Watch Faces](https://developer.garmin.com/connect-iq/user-experience-guidelines/watch-faces/)
- `requiresBurnInProtection as Lang.Boolean` — `"This flag indicates whether the device screen requires burn-in protection. Some screens require special drawing behavior when rendering content in always-on mode. If a screen requires burn-in protection the following rules must be followed: A maximum of ten-percent of the total available screen pixels can be in use at one time. Individual pixels can be on for no more than three update cycles when updating at once-per-minute intervals. If either condition is violated all screen pixels will be turned off until the device goes into high-power mode."` — Since API Level 3.0.12 — [Toybox.System.DeviceSettings](https://developer.garmin.com/connect-iq/api-docs/Toybox/System/DeviceSettings.html)
- Garmin's own AOD design advice: `"Avoid using much white or blue. Consider using light gray instead."`, `"Use fonts with thin line weights."`, `"Minimize the use of static elements that never move (e.g., the center post of analog watch hands)."`, `"If you do have static elements, consider moving elements up to four pixels in any direction every minute while in always-on mode."` — [UX Guidelines → Watch Faces](https://developer.garmin.com/connect-iq/user-experience-guidelines/watch-faces/)
- AOD support is effectively expected, not optional: `"To avoid a poor user experience, it is expected that Connect IQ watch faces for AMOLED devices support always-on mode to keep and watch face visible in these cases."` — [UX Guidelines → Watch Faces](https://developer.garmin.com/connect-iq/user-experience-guidelines/watch-faces/)
- Third corroboration, plus the definition of a lit pixel: `"Pixels in an AMOLED display only draw power when illuminated, so a pixel is considered on when rendering any color other than black, and is considered off when and only when rendering black pixel."` and `"Burn-in protection is only activated when Connect IQ watch face is in foreground and after system enters sleep mode. Under such conditions, if more than 10% of the screen pixels are on or any pixel is on for longer than 3 minutes, the system will shut off the screen."` — Since API level 3.1.0 — [FAQ → How do I make a watch face for AMOLED products?](https://developer.garmin.com/connect-iq/connect-iq-faq/how-do-i-make-a-watch-face-for-amoled-products/)
- **The metric changed after the first AMOLED device.** `"On the original Venu® no more than 10% of the screen can be on, and no pixel can be on longer than 3 mins."` … `"Since the Venu® 2, the rule for always-on is to use less than 10% of the screen's luminance. You can use System.getDisplayMode() to determine if the display is in high power mode, low power mode, or off."` — [FAQ → AMOLED watch faces](https://developer.garmin.com/connect-iq/connect-iq-faq/how-do-i-make-a-watch-face-for-amoled-products/)
- Same page, on how common it is to fail: `"Most of the existing Connect IQ watch faces will trip the burn-in protector, however there is still hope to have an always-on watch face on AMOLED screens."` — [FAQ → AMOLED watch faces](https://developer.garmin.com/connect-iq/connect-iq-faq/how-do-i-make-a-watch-face-for-amoled-products/)
- Runtime detection is a `has` check plus a display-mode switch: `"The app can detect whether a product has screen protection enforced by checking the value of DeviceSettings.requiresBurnInProtection."`; the published code sample branches on `DeviceSettings has :requiresBurnInProtection`, then on `System has :getDisplayMode`, then on `DISPLAY_MODE_HIGH_POWER` / `DISPLAY_MODE_LOW_POWER` / `DISPLAY_MODE_OFF` — [FAQ → AMOLED watch faces](https://developer.garmin.com/connect-iq/connect-iq-faq/how-do-i-make-a-watch-face-for-amoled-products/)
- Garmin ships a test tool for exactly this: `"the Connect IQ simulator ships with a new feature to simulate a 24-hour run within minutes. Simply go to 'File->View Screen Heat Map' to open the 'Screen Burn-in Simulation' dialog"`; `"The menu option is only enabled when simulating a WatchFace on a device that supports screen protection"` — [FAQ → AMOLED watch faces](https://developer.garmin.com/connect-iq/connect-iq-faq/how-do-i-make-a-watch-face-for-amoled-products/)

### Cited Findings — onPartialUpdate (MIP only; NOT the AMOLED path)

- `onPartialUpdate` does not apply to AMOLED always-on: `"Always On watch faces behave differently from MIP to AMOLED. With MIP screens, you can use to update a portion of the screen every second. With AMOLED screen, this is no longer allowed."` (the Garmin page renders with the method names dropped from those two sentences) — [FAQ → AMOLED watch faces](https://developer.garmin.com/connect-iq/connect-iq-faq/how-do-i-make-a-watch-face-for-amoled-products/)
- **onPartialUpdate is a MIP-oriented mechanism** with its own budget: `"Always-active watch faces can perform a partial update of the screen every second. The update must operate under a 20 millisecond time frame, which does not allow updating the whole screen but can allow for an update on a small portion."` — [UX Guidelines → Watch Faces](https://developer.garmin.com/connect-iq/user-experience-guidelines/watch-faces/)
- API-side wording: `"This method is called each second as long as the device power budget is not exceeded. It is important to update as small of a portion of the display as possible in this method to avoid exceeding the allowed power budget. To do this, the application must set the clipping region for the Graphics.Dc object using the setClip() method."` and `"If the call to this method exceeds the power budget of the device, the partial update will not draw and a call to onPowerBudgetExceeded() is made to report the limits that were exceeded."` — [Toybox.WatchUi.WatchFace](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFace.html)
- `onPowerBudgetExceeded(powerInfo as WatchUi.WatchFacePowerInfo) as Void` — `"Handle a partial update exceeding the power budget. If the onPartialUpdate() callback of the associated WatchFace exceeds the power budget of the device, this method will be called with information about the limits that were exceeded."` — Since API Level 2.3.0 — [Toybox.WatchUi.WatchFaceDelegate](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFaceDelegate.html)
- The budget is reported numerically, in milliseconds, at runtime: `WatchFacePowerInfo` carries `executionTimeAverage as Lang.Float` — `"Average elapsed time per update in milliseconds (ms)"` — and `executionTimeLimit as Lang.Float` — `"The maximum allowable partial update execution time onPartialUpdate() is allowed to take."` / `"Maximum allowed time in milliseconds (ms)"`. Both since API Level 2.3.0; the class has exactly these two members and no power/pixel fields — [Toybox.WatchUi.WatchFacePowerInfo](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFacePowerInfo.html)
- Power-state cycle: `"During low power mode the system will call onUpdate() at the top of every minute. If partial update support is available, the onPartialUpdate() method will be called for the first 59 seconds of every minute."`; high-power mode is `"typically about ten seconds"` — [Toybox.WatchUi.WatchFace](https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFace.html)

### Verdicts
- **"AMOLED AOD updates once per minute" — CONFIRMED** (verbatim, two sources).
- **"Maximum 10% of pixels lit per update" — CONFIRMED but needs qualifying.** The 10% number is right and is stated three times. On the original Venu it is 10% of *pixels*; **since the Venu 2 it is "less than 10% of the screen's luminance"** — so a dim grey pixel is no longer equivalent to a bright white one. Any product claim that says "10% of pixels" for a current AMOLED device (FR965 included) is using the pre-Venu-2 rule.
- **Second constraint (missed by the prior researcher) — CONFIRMED:** `"Individual pixels can be on for no more than three update cycles when updating at once-per-minute intervals"` (API doc) / `"any pixel is on for longer than 3 minutes"` (FAQ). `"If either condition is violated all screen pixels will be turned off until the device goes into high-power mode."`
- **`requiresBurnInProtection` documented — CONFIRMED**, `System.DeviceSettings`, since API 3.0.12, with the three-update-cycle rule and the all-pixels-off penalty. Companion runtime API is `System.getDisplayMode()` for Venu 2 and later.
- **onPartialUpdate power budget — CONFIRMED**, at `20 milliseconds` per call (UX guidelines). The API doc keeps it abstract, but the runtime type is concrete: `WatchFacePowerInfo.executionTimeLimit` and `.executionTimeAverage` are both Floats in milliseconds. **The budget is device-reported, not a fixed constant** — 20 ms is the documented figure, the runtime value is authoritative.
- **`onPowerBudgetExceeded` behaviour — CONFIRMED:** the partial update is silently dropped (`"the partial update will not draw"`) and the delegate is called with a `WatchFacePowerInfo` carrying the average time taken and the allowed limit.
- **`onPartialUpdate` applies to AMOLED always-on — REFUTED.** `"With AMOLED screen, this is no longer allowed."`

### Inferences
- Three regimes get conflated easily, and a report that merges them will be wrong:
  1. **MIP always-active** — `onPartialUpdate` once per second, 20 ms execution budget, policed by `onPowerBudgetExceeded`.
  2. **Original Venu AMOLED always-on** — once per minute, ≤10% of pixels lit, no pixel lit >3 minutes, policed by firmware blanking the screen.
  3. **Venu 2 and later AMOLED always-on (this includes FR965)** — once per minute, <10% of screen *luminance*, `System.getDisplayMode()` to pick the render path.
- The luminance rule is strictly more permissive than the pixel rule for dim designs and stricter for bright ones — which is exactly why Garmin's design advice is "avoid much white or blue, consider light gray" and "use fonts with thin line weights."
- The three-minute rule forces pixel *movement*, which is why Garmin advises jittering static elements up to four pixels per minute. A perfectly static minimal AOD design is not achievable within the rules on burn-in-protected screens.
- The failure mode is silent and total — the screen goes fully dark until the next gesture. Garmin's own answer to this is the simulator's `File → View Screen Heat Map` 24-hour burn-in simulation, which is the cheapest real check available and does not need the watch. It is still a simulator result, so per this repo's house rule it is not device proof; an overnight FR965 run remains the confirming test.

### Gaps
- Garmin publishes no numeric value for the AMOLED luminance budget beyond "less than 10% of the screen's luminance", and no units or measurement method — the FAQ says `"See for tools to measure luminance"` with the cross-reference text missing from the rendered page.
- Garmin does not say which devices set `requiresBurnInProtection = true`; the doc only says "some devices", so it must be queried at runtime.
- The FAQ page renders with several inline method-name links stripped (e.g. `"you can use to update a portion of the screen every second"`), so a couple of sentences are quoted here with that gap intact.

---

## 5. App review

### Takeaway
There is a published App Review Guidelines page, but **no review SLA of any kind** —
Garmin commits only to "as thoroughly and promptly as possible". Review is not pure
content moderation: performance and battery are explicit, enforceable grounds for
rejection. Nothing on Garmin's site says review includes instrumented profiling, and the
guidelines push testing responsibility onto the developer.

### Cited Findings
- The page exists and is stale: `"Garmin Connect IQ App Review Guidelines — Last Updated: Oct 13th, 2021"` — [App Review Guidelines](https://developer.garmin.com/connect-iq/app-review-guidelines/)
- No SLA: `"We endeavor to review the app and the related documentation as thoroughly and promptly as possible. Please keep in mind that even if an app is approved, we may later discover issues after the review process."` — [App Review Guidelines](https://developer.garmin.com/connect-iq/app-review-guidelines/)
- Performance is a named rejection ground: `"Performance Requirements. We want our users to have the best experience. If your app doesn't function, diminishes battery life or other features of the Garmin device, or crashes frequently, it may be rejected or removed."` — [App Review Guidelines](https://developer.garmin.com/connect-iq/app-review-guidelines/)
- Battery specifically: `"Drain on Battery Life. Apps should not cause Garmin's products to no longer meet their expected battery life, cause other apps to run more slowly, attempt to access data in an unauthorized manner, or otherwise disrupt the advertised or desired user experience."` — [App Review Guidelines](https://developer.garmin.com/connect-iq/app-review-guidelines/)
- Testing is the developer's job, not the reviewer's: `"Test Before Submitting. By the time you submit, your app should be fully completed, tested, and ready for use."` and `"When you submit an app for approval, we expect the app to be ready to meet all of our Guidelines."` — [App Review Guidelines](https://developer.garmin.com/connect-iq/app-review-guidelines/)
- The guidelines are explicitly non-exhaustive and discretionary: `"These Guidelines are not an exhaustive set of rules. It may be necessary for us to suspend or remove a potentially harmful app from the Connect IQ store, even if there is no specific violation of the Guidelines."` — [App Review Guidelines](https://developer.garmin.com/connect-iq/app-review-guidelines/)
- No prior notice is guaranteed on takedown: `"Garmin, in its discretion, may choose to contact developers and request changes to apps, but Garmin is not required to provide notice prior to suspending or removing an app."` — [App Review Guidelines](https://developer.garmin.com/connect-iq/app-review-guidelines/)
- Submission flow, also without a timeframe: `"After you upload your app successfully, we will review it. You will be able to preview your app and download it yourself for testing. While approval is pending, your app will not appear in the Connect IQ Store. Once it's approved, we will notify you."` — [Submit an App](https://developer.garmin.com/connect-iq/submit-an-app/)
- Content-moderation scope is broad and itemised: prohibited sexual/obscene content, bullying, profanity, spam, gambling; no crypto mining (`"We prohibit apps from using Garmin devices to mine for cryptocurrency."`); no apps for children under 13; dangerous-activity apps barred even on Descent dive watches; medical apps need regulatory documentation; aviation apps need a specific verbatim disclaimer — [App Review Guidelines](https://developer.garmin.com/connect-iq/app-review-guidelines/)
- Monetization honesty rules bear on listing copy: `"Disclose from the outset if your app is only free for a limited time or for a limited number of uses"`, `"Inform users of your refund policy or lack thereof"`, `"Not \"bait-and-switch\" users by implying that a feature is available for free, when it is not"` — [App Review Guidelines](https://developer.garmin.com/connect-iq/app-review-guidelines/)
- Review-manipulation ban: `"Submit a rating for your own app"` is explicitly prohibited, as is paying for positive reviews — [App Review Guidelines](https://developer.garmin.com/connect-iq/app-review-guidelines/)
- Device-compatibility claims are a review surface: `"You must accurately disclose which Garmin devices support your app."` — [App Review Guidelines](https://developer.garmin.com/connect-iq/app-review-guidelines/)

### Verdicts
- **"Published review-guidelines page exists" — CONFIRMED** (last updated Oct 13 2021).
- **"Published review SLA" — REFUTED.** No turnaround time is stated on the App Review Guidelines page, the Submit an App page, or the Connect IQ FAQ. The FAQ index carries only technical how-to articles (bitmaps and fonts, watch faces, communication, advanced topics) and no submission or review entry at all — [Connect IQ FAQ](https://developer.garmin.com/connect-iq/connect-iq-faq/)
- **"Review is content moderation only" — REFUTED.** Performance, crash frequency and battery drain are explicit, separately enumerated rejection criteria (section 2 of the guidelines).
- **"Review includes performance/battery profiling" — UNVERIFIABLE.** Garmin states performance standards and reserves the right to reject on them, but publishes nothing about how or whether it measures them. Both readings are consistent with the text.

### Inferences
- The guidelines' 2021 date means they predate the AMOLED always-on rules and the current complication surface; the operative performance constraints for a modern AMOLED face live in the UX guidelines and API docs (section 4), not in the review guidelines.
- Because re-pricing a free app pulls it back into review (section 2), a free-then-paid launch strategy carries an unbounded, unpublished downtime window.

### Gaps
- No published review turnaround time, queue depth, rejection rate or appeals process anywhere on a Garmin-owned page.
- Whether reviewers run apps on hardware, in the simulator, or only inspect the listing is not documented.

---

## Source log (all rendered in Chrome, observed 2026-09-22)

| URL | Used for |
|---|---|
| https://developer.garmin.com/connect-iq/compatible-devices/ | §1 API levels for every device |
| https://developer.garmin.com/connect-iq/api-docs/Toybox/Complications.html | §1 COMPLICATION_TYPE_SLEEP_SCORE = API 6.0.2 |
| https://developer.garmin.com/connect-iq/monetization/merchant-onboarding/ | §2 $100 fee, seller countries |
| https://developer.garmin.com/connect-iq/monetization/app-sales/ | §1 monetized device tiers; §2 15%, payouts, buyer countries |
| https://developer.garmin.com/connect-iq/monetization/price-points/ | §2 16 currencies, $2.00–$100.00 |
| https://developer.garmin.com/connect-iq/core-topics/trial-apps/ | §3 trial mode, watch-face exclusion |
| https://developer.garmin.com/connect-iq/device-reference/fr965/ | §1 cross-check: no API level published per device |
| https://developer.garmin.com/connect-iq/user-experience-guidelines/watch-faces/ | §4 10% / once-per-minute / 20 ms |
| https://developer.garmin.com/connect-iq/connect-iq-faq/how-do-i-make-a-watch-face-for-amoled-products/ | §4 luminance rule, 3-minute rule, heat map |
| https://developer.garmin.com/connect-iq/api-docs/Toybox/System/DeviceSettings.html | §4 requiresBurnInProtection |
| https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFace.html | §4 onPartialUpdate power budget |
| https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFaceDelegate.html | §4 onPowerBudgetExceeded |
| https://developer.garmin.com/connect-iq/api-docs/Toybox/WatchUi/WatchFacePowerInfo.html | §4 executionTimeAverage / executionTimeLimit |
| https://developer.garmin.com/connect-iq/app-review-guidelines/ | §5 review scope, no SLA |
| https://developer.garmin.com/connect-iq/submit-an-app/ | §5 approval process, no SLA |
| https://developer.garmin.com/connect-iq/connect-iq-faq/ | §5 negative check: no review SLA in the FAQ |

Failed to render (404):
- `https://developer.garmin.com/connect-iq/core-topics/always-on-display/` — no such page; AOD content lives under User Experience Guidelines → Watch Faces and in the AMOLED FAQ article.
- `https://developer.garmin.com/connect-iq/device-reference/forerunner-965/` — the real slug is `/device-reference/fr965/`.

Not consulted for any verdict: the5krunner, Garmin forums, apps.garmin.com store listings,
or any non-Garmin source. One WebSearch restricted to Garmin domains was used only to
locate the App Trials URL, which was then rendered directly; nothing from that search's
snippets or result titles is used as evidence anywhere in this file.
