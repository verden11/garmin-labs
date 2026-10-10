# Naming, store collisions and listing wording for a Connect IQ "Vitamin D sun window" widget/app

Researched 2026-10-04. Naming stays an owner decision. Labels: **Verified** = read from a primary page or the live store API today; **Unverified** = search snippet, DNS hint or my background knowledge; **Inference** = ours.

Method note for the store check: apps.garmin.com is a JS (Next.js) app, but its search page calls a public JSON endpoint, `https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/keywords?keywords=<term>&startPageIndex=0&pageSize=30&sortType=mostRelevant` (found in the site's `_app` chunk; param names `keywords, startPageIndex, pageSize, sortType, appType`; `sortType` is case-sensitive camelCase `mostRelevant` although the error message lists `MOST_RELEVANT`). It searches names and descriptions (checked: "Fitzpatrick" returns apps whose descriptions contain it) and ranks name matches first (checked: "Two Suns" returns our own "Two Suns Pro" first). Per candidate I read the top 120 hits (4 pages) and, for the shortlist, the top 30. `typeId`: 1 watch face, 2 widget, 3 watch app, 4 data field (inferred from the listings). Store listings are US-country; apps limited by country may not show.

## 1. Candidate names: store collisions, trademark and domain hints

### Takeaway
No Connect IQ listing uses any of the seven proposed names; the nearest hit for "Sun Window" is a 10-download watch face called just "Window". The real constraint is not the name but the crowd: four live Connect IQ apps already put "Vitamin D" in the title, and a "Vitamin D Window Widget" exists on the iPhone App Store, so "window" as a concept is not unique outside Connect IQ. Ranked shortlist (owner decides): **1 Sun Window, 2 Sun Gate, 3 High Sun, 4 Sunny Spell, 5 Good Sun, 6 Sun Hours, 7 Sun Spell**; drop "D Window" and "Sun Window D".

### Cited Findings

**Existing Connect IQ apps in the Vitamin D / UV space (the landscape the name must stand in), all APPROVED, read from the store API 2026-10-04:**
- "Vitamin D Estimate", data field, 1,000 downloads, 3.8 stars from 6 reviews. Description: "estimate your vitamin D absorption based on the current UV index. This is an estimate only." — [store API](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/f6aa38aa-ac02-4a99-8a9e-c0674f27f933?countryCode=US)
- "SunAlert: UV, Burn & Vitamin D", widget, 1,000 downloads, 4.9 from 22. Carries an "IMPORTANT DISCLAIMER: ... for informational purposes only ... not a substitute for professional medical advice", and says it "tracks your daily Vitamin D exposure too" — [store API](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/33a60aac-8f33-4ca5-9e94-7fd0a61cac0d?countryCode=US)
- "SunIQ: Vitamin D Tracker, UV & Sunburn Alerts", watch app, 100 downloads, 4.3 from 10. Description: "Stay Healthy & Motivated", "biological algorithm based on peer-reviewed clinical research", "Gamify your sun exposure" — [store API](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/f8ece1ea-dc33-4b01-8ca0-1d938262d891?countryCode=US)
- "Sun Tracker: UV Vitamin D and Burn Risk", widget, 100 downloads, 5.0 from 2. Description: "find the next good window to get outside", "recommended exposure range", "recommended minimum", "suggested maximum" — [store API](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/abb277e7-cef1-421e-8682-407fed5f7974?countryCode=US)
- Other sun/UV apps seen: "UV Guard: Sun & Burn Forecast" (widget), "UV Guard", "UV Index Pro", "UV Index Face", "UV Index Data Field", "Beach Day - Tides, UV Index, Weather" — [search result list](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/keywords?keywords=UV%20index%20sun%20exposure&startPageIndex=0&pageSize=30&sortType=mostRelevant)
- None of the four vitamin D listings has more than 1,000 downloads: the niche exists but is small. Same API.

**Per-candidate Connect IQ store check (names, top 120 relevance hits; Verified unless marked):**
- **Sun Window**: no app with this name. Nearest: "Window" (watch face, 10 downloads, id 464eb1c6), "DigitalWindow", "Rainy Window", "Clear window" and other watch faces; "Sun", "SUN", "Daymark Sun Dial" are unrelated faces. "Sun Window Pro": 0 results. — [search](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/keywords?keywords=sun%20window&startPageIndex=0&pageSize=30&sortType=mostRelevant)
- **D Window / Sun Window D**: no name match. "D" is a crowded suffix ("Goals D", "Clear D", "Large D", "OCD D", "Lap+ (D)", "AppBuilder 5 (D)") — [search](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/keywords?keywords=vitamin%20d&startPageIndex=0&pageSize=30&sortType=mostRelevant)
- **Good Sun**: no match; neighbours are "Good Morning", "Good Night", "Good Luck", "Good Hero" (all faces).
- **Sunny Spell**: no match; "Sunny" alone exists as six separate faces ("Sunny", "SUNNY"), "Lunar Spell" and "Autumn Spell" exist.
- **Sun Gate**: no match; "Gate" exists twice, plus "Nova Gate", "Lunar Gate", "Aether Gate" and others (faces).
- **High Sun**: no match. Neighbours "High Tides" (watch app), "High Trecker".
- Extra candidates I added and checked: **Sun Hours** (no match; "Golden Hours", "Sunlit Hour" exist), **Sun Spell** (no match), **Sun Slot** (no match, but results are slot-machine apps; gambling association), **UV Window** (no match; only "Window" hits), **Sun Break** (no match; "Summer Break"), **Strong Sun** (no match; "Strong" x3), **Sunstep** (no match). **Sun Time / Sun Times / Simply Sun Time exist** (face, widget x2, data field), so avoid "Sun Time". "Sunlit" prefix names exist ("Sunlit Hour", "Sunlit Racer").
- Closest descriptive wording already in the store: "Sun Tracker" ("find the next good window") and "Golden Hour: Photographer Sun Clock" — [search](https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/keywords?keywords=Sun%20Hour&startPageIndex=0&pageSize=30&sortType=mostRelevant)

**Outside Connect IQ (web search snippets, Unverified in detail):**
- iPhone App Store has "Vitamin D Window Widget" (developer Airhopping, SL; subtitle "Vitamin D Availability Window"; free). Its text says "the exact hours when sunlight is strong enough for natural vitamin D production", with "above 45° for optimal conditions, above 30° for partial" and the disclaimer "may vary depending on individual factors such as skin type, altitude, and atmospheric conditions". The fetch summary gave a release date of 25 Feb 2025 that does not fit the app id; treat dates as unreliable — [App Store page](https://apps.apple.com/app/id6759223422)
- Other iPhone apps in the same idea: "Seize Light" (morning-light window and "the vitamin-D window"), "Vitamin D: Sun & UV Tracker", "Sunlight & UV: Get Some Sun", "Sunbeam: UV Index", "Sun Tracker: UV & Vitamin D", "Beam Tanning", "Sola: UV Index & Sun Exposure", "Vitamin D™ (Sun AI)" — [search snippet](https://apps.apple.com/app/id6759223422), [search snippet 2](https://apps.apple.com/us/app/-/id6770848310)
- No App Store or Play hit named exactly "Sun Window", "Good Sun", "Sun Gate", "Sunny Spell", "High Sun" or "D Window" appeared in two searches (a negative from snippets, not a store search).
- Trademark: a snippet search for "Sun Gate", "Sunny Spell", "High Sun" returned only unrelated sun marks (SunPower, Sunworks, SUNZAPP, which is an app mark for sun-protection advice, reg. 4977878) — [Justia, SUNZAPP](https://trademark.justia.com/868/01/sunzapp-86801049.html). I did not query USPTO Trademark Search or EUIPO eSearch (both JS applications, not fetchable as text here).

**Domain hints (DNS records only; Unverified, no registrar lookup worked):**
- sunwindow.com: parked/for sale (Afternic nameservers). sunwindow.app: has records (Cloudflare NS; owner unknown). sunwindow.co: has records (GoDaddy NS).
- sungate.com and sungate.app: have records (sungate.app on Afternic nameservers). highsun.com: has records (hichina NS, a Chinese registrar). sunnyspell.com: has records (SiteGround). goodsun.com: registered since 2001-04-05 (whois). dwindow.com: registered since 2011 (whois).
- No DNS records at all for dwindow.app, goodsun.app, highsun.app, sunnyspell.app, sunslot.app: likely unregistered but not confirmed (whois returned nothing for .app).
- The studio does not need its own domain: apps live at `verden.watch/<slug>/` (`/Users/mbp/dev/garmin/reports/listing-template.md` section 2), so only the slug matters; `site/src/apps/` currently holds day-arc, day-arc-pro, days-to-go, heroface, heroset, two-suns, so `sun-window` is free in-repo.

**Studio naming convention and limits:**
- Free = clean name, Pro = "<Name> Pro" (owner-confirmed 2026-10-04) — `/Users/mbp/dev/garmin/CLAUDE.md` ("Names are confirmed (Free = clean name, Pro = "<Name> Pro")"). Example live: "Two Suns Pro" (title field in `/Users/mbp/dev/garmin/TwoSuns/listing/paste.md`).
- Title limit 50, description 4000, What's New 4000, App Version 20; no Keywords field on the upload form, so name plus description are the only search surface — `/Users/mbp/dev/garmin/DayArc/listing/meta.yaml` (`limits`), `/Users/mbp/dev/garmin/TwoSuns/listing/NOTES.md` line 9. I found no short-description field in either folder's `paste.md`; the form fields are Title, Description, App Version, What's New (field list in listing-template section 1). All candidate names plus " Pro" are far under 50 characters.
- Naming rules Garmin publishes: no IP infringement incl. developer account name (3a), no claim of Garmin affiliation (4a), no Garmin branding in the icon; nothing on a "Pro" suffix or title keywords — `/Users/mbp/dev/garmin/reports/Garmin policies and design guidelines.md` section 2 ("Naming").
- The Two Suns precedent: "No trademark search done" before the name was decided, and "Body Battery" (Garmin's trademark) is kept out of name, tags and description headers — `/Users/mbp/dev/garmin/TwoSuns/listing/NOTES.md` row 1 and row 11.

### Inferences
- **Ranked shortlist with reasons (owner decides):**
  1. **Sun Window** — says what it is (a window of the day when the sun is high enough); no store, App Store or trademark snippet collision found; "Window" is already the owner's intake concept; Free "Sun Window", Pro "Sun Window Pro"; slug `sun-window`. Cons: "window" is also the generic word on the iPhone side ("Vitamin D Window Widget", "Seize Light"), and sunwindow.app/.co are held by someone; neither blocks a store listing.
  2. **Sun Gate** — clean in all three checks; "gate" suggests open/closed, which fits a yes/no state. Cons: less self-explanatory; "Gate" is a popular face name ("Nova Gate" etc.); sungate.com and .app are taken.
  3. **High Sun** — plain description of solar elevation, zero health content. Cons: could read as a noon face; "High Tides" neighbour is harmless.
  4. **Sunny Spell** — warm, clean, no health reading. Cons: sounds like weather, not a threshold; "Sunny" is crowded with faces.
  5. **Good Sun** — short and clean in the store. Con: "good" is a value judgement about sunlight, which sits close to the "never a colour or label keyed to a reading" and no-verdict rules (a "Good Sun" tile implies a recommendation). Only usable if the UI never labels any state "good".
  6. **Sun Hours** — descriptive; clean; low distinctiveness ("Golden Hours", "Sunlit Hour").
  7. **Sun Spell** — clean, but near-duplicate of Sunny Spell.
  - Drop **D Window** and **Sun Window D**: the "D" is a visible vitamin D reference in the title (see section 2), it adds nothing a user searches for, and "D" suffixes are noise in the store.
- Avoid: **Sun Time(s)** (four exist), **Sun Slot** (gambling association), any name with "UV" in it (UV Guard, UV Index family exist, and UV implies a safety reading).
- Because the name carries no "Vitamin D", discoverability depends on the description; the store search does index descriptions (checked), so one neutral mention can still be found by "vitamin d" searches (see section 3 for the trade-off).

### Gaps
- No real trademark search (USPTO Trademark Search, EUIPO eSearch, WIPO) was run; nothing here is a clearance. Class 9 (software) and 42 would be the classes to search. The Two Suns precedent shows the owner has accepted shipping without one.
- No registrar check for domains; DNS silence is only a hint.
- The store API only shows listings visible for US; a country-limited listing could be missed. Names beyond the top 120 relevance hits per term were not read (name matches rank first, so a hit lower down is unlikely but not excluded).
- Play Store / App Store were only checked through search snippets, not their own searches.

## 2. Garmin rules on health wording, naming, keywords and trademarks

### Takeaway
Garmin's only health-specific rule is 1c: an app "intended for use in the diagnosis, cure, mitigation, treatment or prevention of disease or other conditions" needs regulator clearance, otherwise the description, features and functionality must not indicate any such use and the app must be "informational purposes only". "Vitamin D" in a title is not named as forbidden, and four live apps do it, but vitamin D deficiency is a "condition" and a title is the strongest statement of intended use, so keeping it out of the title is the cautious choice. No rule on keyword stuffing, "Pro" suffix, or title keywords is published.

### Cited Findings
- **1c Medical Apps** (verbatim): "If your app is intended for use in the diagnosis, cure, mitigation, treatment or prevention of disease or other conditions, you must be prepared to submit documentation from any relevant regulatory agencies proving the app is cleared for use in your target markets. Otherwise, you must update the app's description, features and functionality to ensure it does not indicate any use for the purposes of diagnosis, cure, prevention, mitigation or treatment of disease or other conditions and is intended for informational purposes only. Even if your app has been cleared by a regulatory agency, we reserve the right to accept or reject the app based on these Guidelines." — [App Review Guidelines](https://developer.garmin.com/connect-iq/articles/app-review-guidelines/Overview.html) (Last Updated Oct 13th 2021; read today)
- **1b Regulated Activities**: "You are solely responsible for ensuring that your app complies with laws and regulations and includes any legally-required disclaimer ... especially if your app relates to regulated activities, including the practice of medicine" — same page.
- **1b Physical Safety**: apps must not "create a false sense of security, such as 'safety awareness' apps" and Garmin may reject any app "that we believe is unsafe or could, directly or indirectly, cause anyone harm" — same page. Relevance: a window that says "sun is fine" could be read as a sun-safety/burn signal. A sun-exposure widget is close to "safety awareness" if it ever implies safe time in sun.
- **4a Describe Your App Accurately and Completely** (verbatim): "You must not make any inaccurate or misleading statements ... a complete description of all features and any minimum requirements, limitations, or dependencies. This also applies to any other advertising ... and any content or metadata associated with your app." Also "Avoid claiming any partnership or affiliation with Garmin" — same page.
- **Enforcement**: Guidelines "are not an exhaustive set of rules"; Garmin may suspend or remove an app without a specific violation, and gives no notice duty — same page (Overview and 5b).
- Prior reading: no rule about keywords in titles, "Pro" suffixes, or duplicate listings; limits title 50, description 4000 — `/Users/mbp/dev/garmin/reports/Garmin policies and design guidelines.md` sections 2 ("Naming", "Limits").
- Prior study of the same rule for Body Battery: "a medical-claim app needs regulatory documentation ... Body Battery is a wellness estimate: describe what the face shows, never what it means for health" — `/Users/mbp/dev/garmin/research_notes/Body Battery and sun face research/platform.md` line 101.
- Studio listing rule: "Never: ... accuracy claims, rivals by name, ... medical or advice wording" — `/Users/mbp/dev/garmin/reports/listing-template.md` section 3 "Both".
- Two Suns listing rule: "Describe, never claim. Forbidden until measured or proven: accuracy ..., 'improves', 'optimises', recovery or any health outcome or advice ..." — `/Users/mbp/dev/garmin/TwoSuns/listing/NOTES.md` line 58.
- **Precedent that Garmin approves titles with "Vitamin D"** (all APPROVED in the live store): "SunAlert: UV, Burn & Vitamin D", "SunIQ: Vitamin D Tracker, UV & Sunburn Alerts", "Sun Tracker: UV Vitamin D and Burn Risk", "Vitamin D Estimate" (listings above). Two of them add a "not a substitute for professional medical advice" or "estimate only" disclaimer; SunIQ's description does not hold to our standard ("Stay Healthy & Motivated", "peer-reviewed clinical research").
- Garmin's own wording precedent (health-science pages): every page carries a footnoted disclaimer ("does not constitute medical advice") and points to garmin.com/ataccuracy; Body Battery copy is neutral: "the occasional low-energy day is no cause for alarm"; Stress copy declines to say why a reading is high — `/Users/mbp/dev/watch-design-kit/knowledge/health-science.md` ("Legal/accuracy framing", "Body Battery", "Stress"), citing [Garmin health science](https://www.garmin.com/en-US/garmin-technology/health-science/).
- Trademark relevant to the wording: "Body Battery" is Garmin's mark; "Vitamin D" is a generic nutrient name, not a mark (my knowledge, Unverified). Rules: 3a IP infringement; Garmin branding not allowed in the icon (Garmin policies report).

### Inferences
- **Name rule:** keep "Vitamin D" out of the Title. Garmin's rule turns on intended use, and a title is read as intended use; precedent shows approval is possible, not that it is safe, since Garmin can remove any app without a specific violation and the existing apps may simply not have been challenged. This is the single place the owner's one-line "Vitamin D sun window" intake word choice meets the studio's no-health-claim line.
- **Description rule, two options for the owner:** (A) no "vitamin D" anywhere; (B) one factual, hedged mention in the description body (not title, not What's New, not screenshots, not the watch UI), e.g. "the window of the day when the sun is high enough, often called the vitamin D window". B keeps the app findable for "vitamin d" searches (the store indexes descriptions, verified) and mirrors the iPhone "Vitamin D Window Widget" text pattern, but B is a judgement call against guideline 1c and the owner's rule of never "what it means for health". Recommendation: start with A on the watch UI and screenshots, and treat B as the owner's one deliberate exception for the description only.
- Because the studio shows only what the sun and sky are doing, 1c is met by "informational purposes only" plus no outcome words, with no regulatory documentation needed.
- The 1b "false sense of security" line argues against any wording that implies "safe" or "no burn risk"; the widget must say it is not a sun-safety tool if UV is on screen.

### Gaps
- Garmin's own sun-exposure or vitamin D disclaimer wording is not in the research notes; the health-science page needs a real browser (JS-rendered) and was not re-read here.
- Not checked: Garmin's developer brand guidelines for any rule on app titles (the Garmin policies report read them for images only); no keyword-stuffing rule was found in the published guidelines, which does not prove none is enforced.
- Whether a reviewer treats "vitamin D" in a description differently from the title is unknown; no Garmin statement on it exists in what I read.
- The US/EU/other-market regulatory position on a "vitamin D" claim in software (FDA, EU health-claim rules for nutrients) was not researched here; if the owner picks option B, this is the next check.

## 3. Wording rules: what the listing and watch UI may say

### Takeaway
Describe measurable inputs and the on/off state the app computes (sun elevation, UV, cloud) and attribute it to the watch's own weather data; never name a health outcome, a person's need, a quantity of vitamin or a safe/unsafe verdict. Below is a draft do/don't list built from Garmin 1c/4a, the studio's rules and the neutral phrasing of Garmin's own pages and the iPhone precedent.

### Cited Findings
- Garmin's accepted style: "informational purposes only" (1c) and "does not constitute medical advice" (Garmin health-science pages) — sources in section 2.
- A competitor pattern we should not follow: "recommended exposure range", "recommended minimum", "suggested maximum", "burn risk", "tells you exactly how long you have before your skin starts burning", "Stay Healthy & Motivated" — store listings quoted in section 1.
- A competitor pattern that stays neutral: "shows you the exact hours when sunlight is strong enough for natural vitamin D production" plus "may vary depending on individual factors such as skin type, altitude, and atmospheric conditions" — [App Store page](https://apps.apple.com/app/id6759223422) (summary via fetch; Unverified verbatim).
- Studio rules already forbidding: accuracy claims, "improves", "optimises", health outcomes, advice, rivals by name, watch model names, price numbers, refund wording, language names/counts, "free" in the Pro description — `/Users/mbp/dev/garmin/reports/listing-template.md` sections 1 and 3, `/Users/mbp/dev/garmin/TwoSuns/listing/NOTES.md` line 58.

### Draft do / don't phrase list (proposal, for the owner and `watch-pm`)

| Say (describes what is shown) | Do not say (implies an outcome, need or verdict) |
|---|---|
| "Shows when the sun is high enough, UV is 3 or more and cloud is light." | "Shows when you can make vitamin D." / "Get your vitamin D." |
| "A window of the day, from your watch's own sun position and weather." | "Your vitamin D time." / "Your daily dose." |
| "The sun's height above the horizon, from your watch's location and clock." | "Optimal", "ideal", "best", "perfect" time, "safe", "good" or "bad" sun |
| "UV index and cloud cover as your watch's weather reports them." | "UVB-accurate", "accurate", "precise", "clinically", "science-based", "peer-reviewed" |
| "Window open / window closed." / "Opens at 11:10, closes at 14:40." | "You are low", "you need", "deficient", "top up", "enough", "missed your D" |
| "Based on your watch's weather data and the sun's position; estimates only." | "Tracks your vitamin D", "estimates your vitamin D", "synthesis", "absorption" |
| "Time spent in the window" (only if a count is ever built, a plain number, no goal) | "Daily goal", "streak", "recommended minutes", "minimum", "maximum", "target" |
| "Not a sun-safety tool. Use your own judgement and sun protection." (if UV is shown) | "Burn risk", "burn time", "SPF", "tan", "protect your skin", "stay safe" |
| "For information only." | "Improve", "support", "boost", "optimise", "healthy", "wellness", "prevent", "deficiency", "bones", "mood", "sleep" |
| "Nothing leaves your watch." (only while true) | Claims of medical, dermatological or Garmin endorsement; Garmin trademarks ("Body Battery") in the title or headers |

Rules behind the table (proposal, derived from the cited sources):
1. **Subject of the sentence is the sun or the sky, never the person.** "The sun is high enough" not "you can make".
2. **No threshold is described as good or bad.** The numbers (e.g. 3 or more UV, elevation, cloud) are the app's own display rule, stated plainly as a setting or a rule of the display, not as a health threshold. If the owner decides to quote the sun-angle rule, state it as a display rule ("the window opens when the sun is above N degrees"), not a biological fact.
3. **Attribute data to Garmin where it is Garmin's** ("your watch's weather", "from your watch's sun data"), as Two Suns does ("Garmin's own number", no "live" or "accurate").
4. **No UI label keyed to a reading** (Studio direction: "never a colour keyed to a reading"): window open/closed may be a state, but not green = good, red = bad. A red state for "closed" or a warning icon reads as a health or burn verdict.
5. **Same words everywhere:** title, description, What's New, screenshots, hero image, watch UI strings and all translations, because Garmin's 4a covers "any content or metadata associated with your app" and the site (`site/src/apps/<slug>/`) must carry the same claims.
6. **One disclaimer sentence in the description** ("For information only; not medical advice or a sun-safety tool"), matching Garmin 1c and SunAlert's precedent, in the studio's plain voice. This also covers the "false sense of security" wording in 1b.
7. **Never claim accuracy of UV or elevation**; the studio forbids accuracy claims until measured.

### Inferences
- The studio's existing rule "describe what's shown, never what it means for health/fitness" (watch-pm, quoted in the health-science knowledge file) covers this app fully; no new policy is needed, only the list above and an ADR for the name/wording choice once the owner decides.
- The intake phrase "Vitamin D sun window" is itself a health-meaning phrase; as an internal working title it is fine, in any user-facing string it should be replaced by "sun window" / "window".
- Whether a "time in window" count, a goal or a vibration alert is built changes the wording risk a lot: any goal or "reach the minimum" feature copies the competitor pattern that implies a recommended dose. That is a product decision to raise with the owner, not a wording one.

### Gaps
- I did not run this phrase list past the watch-design-kit `watch-pm` skill; and the 15-language translations are unchecked (translated strings can add a medical meaning the English lacks).
- Specific legal wording for the EU/UK (health claims on nutrients) was not researched.
- The iPhone app text was summarised by a fetch model, not read verbatim; the quoted lines should be re-read on the page before being cited in any report.
