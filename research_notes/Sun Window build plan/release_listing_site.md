# Sun Window: release, listing and site process (post-build tasks)

Researched 2026-10-04 in worktree `/Users/mbp/dev/garmin/.claude/worktrees/vitamin-d-window-intake` (paths below are relative to it unless absolute). Read-only research; nothing staged or committed. Simulator passing is not device proof, and nothing about Sun Window has run on a watch.

Owner decisions taken as fixed: v1 is a widget only, Free only (no Pro, no price), no notification (`SunWindow/docs/decisions.md` ADR-002, ADR-003).

## 1. Publish-checklist gates and the "Never decide alone" list: which apply to a Free widget

### Takeaway
The SunWindow template checklist has 17 gates. Fourteen apply as written or with small changes. Gate 14 (price) collapses to "Free, no price" (ADR-003). Gate 6 (always-on) does not apply. Gate 15 (baseline) is optional. Two gates the studio added after the template need adding: Positioning wording on site and listing, and the widget's own device checks D2/D6/D7/D9. The template is also out of shape with the studio layout: it has `listing/README.md` where the studio uses `paste.md` + `meta.yaml` + `NOTES.md`, and it has no `docs/status.md` or `docs/README.md`.

### Cited Findings
- The template "Never decide alone" list: "The store name; the price and its wording; the visual identity and the launcher icon; any permission with a privacy cost; any upload to the Connect IQ store; any phone or watch test; a site deploy; shipping unreviewed machine translations." — [SunWindow/docs/publish-checklist.md](SunWindow/docs/publish-checklist.md)
- The studio-wide version in ROADMAP: "Never decide alone: names, prices, icons, looks, uploads, translations, site deploys, deleting history. Always `[you]`." — [ROADMAP.md](ROADMAP.md) "How to use it"
- The Two Suns filled-in version adds "the `Positioning` permission … any claim the release contract forbids", and says a blanket "proceed" from the owner "does not cover this list". — [TwoSuns/docs/status.md](TwoSuns/docs/status.md) "Never decide alone"
- Template gates (17): 1 name cleared, 2 permission probes, 3 platform claims verified on-device, 4 look approved (round + rectangle), 5 UX checklist, 6 always-on/burn-in, 7 wear day, 8 full fit sweep, 9 export checked (device count vs manifest), 10 language decision, 11 real assets, 12 listing checked against release-contract, 13 site live, 14 price confirmed ("Tier and flip rule"), 15 baseline recorded, 16 tests green / zero warnings, 17 `watch-design-reviewer` `disposition: ship`. — [SunWindow/docs/publish-checklist.md](SunWindow/docs/publish-checklist.md)
- The day-45 flip rule is retired studio-wide, so the "flip rule" wording in gate 14 is stale. — [CLAUDE.md](CLAUDE.md) "Approved by the owner on 2026-10-04"
- In Two Suns, the owner waived some gates as "Not blocking" (always-on night, wear day). The status file records that waiver per gate instead of marking the gate passed. — [TwoSuns/docs/status.md](TwoSuns/docs/status.md) gates 5, 6
- Sun Window's own device checks: D2 `uvIndex`/`cloudCover` non-null on a real watch; D6 `Position.getInfo()` from the widget view and from a first-run glance; D7 glance render/memory (64 KB, 32 KB on three Instinct ids) and no stale state across midnight; D9 Monkey C `Double` solar maths within 0.02 degrees and 1 minute of the fixtures. "None of these can be settled in the simulator." — [SunWindow/docs/spec.md](SunWindow/docs/spec.md) "Device checks still required"
- Success test: "the three states match the sky and the fixtures on a real wrist for a full day on at least one AMOLED and one MIP watch". — [SunWindow/docs/spec.md](SunWindow/docs/spec.md) "Success and stop test"
- Stop conditions: no location in a glance and no clean fallback, `uvIndex`/`cloudCover` always null, or the owner decides SunIQ makes it pointless (ADR-007, open). — [SunWindow/docs/spec.md](SunWindow/docs/spec.md)
- "While `Positioning` is declared, no store or site copy may say 'no location'." — [SunWindow/docs/spec.md](SunWindow/docs/spec.md) "Data sources"
- The template's `docs/release-contract.md` "May claim" and "Data and privacy" sections are still `{{placeholders}}`. — [SunWindow/docs/release-contract.md](SunWindow/docs/release-contract.md)
- Studio layout requires `docs/README.md` and `docs/status.md` (the status file holds "where things stand, evidence, release gates, upload steps (no open checkboxes)"), and `listing/` holds `paste.md`, `meta.yaml`, `NOTES.md`, `screenshots.md`. — [README.md](README.md) "Layout"
- SunWindow has neither `docs/status.md` nor `docs/README.md`, and it has `listing/README.md` instead of `paste.md`/`meta.yaml` (file listing of `SunWindow/`). Its CLAUDE.md house rules still say "What's New block in `listing/README.md`". — [SunWindow/CLAUDE.md](SunWindow/CLAUDE.md)
- Template bug: the build and export commands use `bin/Sun Window.prg` and `dist/Sun Window.iq`. A space in the path breaks the unquoted shell command. — [SunWindow/docs/development.md](SunWindow/docs/development.md)

### Inferences
How each gate applies to Sun Window:

| Gate | Applies? | Sun Window form |
|---|---|---|
| 1 Name | Yes | ADR-001 is open. Do the store search by eye and a trademark search. The slug also freezes when the site publishes, so the name must be final before gate 13 |
| 2 Permission probes | Yes | `Positioning` is the one costly permission. D6 is the probe |
| 3 Platform claims | Yes | D9 (solar maths against fixtures), D2 (weather fields). Compare window edges against the watch's own sunrise/sunset or sun data if shown |
| 4 Look | Yes | Round, rectangle and (if kept) Instinct 1-bit. Covers glance and full view |
| 5 UX checklist | Yes | Glance-time budget, button navigation, the accent setting survives a phone sync, the empty state "open once" has a sentence |
| 6 Always-on | **No** | A widget has no always-on mode (faces only). Note "n/a" in status.md |
| 7 Wear day | Yes | One full day on the production build, this widget only. Success test asks for one AMOLED and one MIP watch, but the owner has only the FR965 (AMOLED), so the MIP half is a gap |
| 8 Fit sweep | Yes | API 5.1+ product list (66 products in SDK 9.2.0), glance and full view |
| 9 Export checked | Yes | Part numbers vs `<iq:product>` count. The upload form's Compatible Devices list is authoritative |
| 10 Languages | Yes | See section 6 |
| 11 Assets | Yes | Owner approves icon and looks |
| 12 Listing | Yes | `paste.md` checked against `release-contract.md`, plus the guideline 1c line (ADR-005) |
| 13 Site | Yes | New slug folder, privacy page with a Positioning paragraph |
| 14 Price | **Reduced** | "Free, no price" per ADR-003. Monetization answer is still open studio-wide (ROADMAP 2.8) |
| 15 Baseline | Optional | Only useful if a later Pro or store test needs a comparison |
| 16 Tests green | Yes | |
| 17 Design reviewed | Yes | `watch-design-reviewer` |
| (new) D2/D6/D7/D9 | Yes | Spec's device checks, gate-like |
| (new) Positioning wording | Yes | No "no location" anywhere while the permission is declared |

- Studio practice is to carry the gates in `docs/status.md`, as Two Suns does, rather than in a stand-alone `publish-checklist.md`. Sun Window should either rename or fold `publish-checklist.md` into a new `docs/status.md` and add `docs/README.md` (inference from the Layout rule and the TwoSuns/DaysToGo shape).

### Gaps
- Whether Garmin's widget/glance has any always-on or low-power state that needs a burn-in check was not checked in Garmin docs here. The face-only reading comes from the Watch Faces UX page cited in `reports/Garmin policies and design guidelines.md`.
- No MIP watch is known to be available to the owner for the success test's second device.

## 2. Store listing: form fields, Free listing content, App Version, What's New flow

### Takeaway
Write `SunWindow/listing/paste.md` + `meta.yaml` + `NOTES.md` + `screenshots.md` in the studio shape, not the template's `README.md`. Follow the 21-field form order, use Two Suns Free as the model, and leave out the Pro sibling line. Sun Window differs from every live Free listing in two ways: it declares `Positioning`, so the "nothing leaves your watch" paragraph must say location is read and stays on the watch, and it needs the guideline 1c "for information only" line. App Version is 1.0.0 and What's New is left blank on a new app.

### Cited Findings
- Form order (studio template): Title, Description (one box per language), App Version, What's New, Hero Image, Category, Subcategory, Does your app collect user data?, privacy-policy URL (only if Yes), ANT+ profiles, regional limits, Cover Image, Screen Images, Device icons, Preview Video (none), Email Address, Source Code URL (blank), Review Notification (Yes), App Migration, Monetization, Additional Hardware Requirements (Optional). — [reports/listing-template.md](reports/listing-template.md) §1 "Rules for paste.md"
- Limits: title 50, description 4000, What's New 4000, app version 20; hero 1440x720 under 2048 KB; cover 500x500 under 300 KB; screens under 150 KB each; icons 128x128 (64 Color and 24 bit). These live in `meta.yaml`. — [reports/listing-template.md](reports/listing-template.md); [TwoSuns/listing-free/meta.yaml](TwoSuns/listing-free/meta.yaml) `limits`
- Form: https://apps.garmin.com/developer/upload, "Two steps: attach the `.iq`, then the details. Compatible Devices is read from the package, not chosen." — [reports/listing-template.md](reports/listing-template.md)
- Three files per listing folder. `paste.md` holds only what is pasted or uploaded, in form order. `meta.yaml` holds the machine data (app id, store URLs, live/next version and status `drafted | prepared | uploaded | in-review | live`, package file and product count, `assets.screens`, `site`, `owner_approvals`, `open_items`). `NOTES.md` holds the why: the claim check table, owner decisions, previous What's New blocks, and after-approval steps. — [reports/listing-template.md](reports/listing-template.md) §1
- Listing text rules (owner 2026-10-04, ROADMAP 10.23): no refund or return wording; no language names or counts, only "Multi-language support: it follows your watch's language."; no Garmin watch model names in Description or What's New; no price number. — [ROADMAP.md](ROADMAP.md) 10.23; [reports/listing-template.md](reports/listing-template.md)
- Free description skeleton: line 1 sibling Pro URL; the promise; what this version has; "Pro adds"; review sentence; permissions in plain words ("Nothing leaves your watch." only while true); More from Verden (live free siblings only); last line `Support and answers: https://verden.watch/<slug>/support/`. — [reports/listing-template.md](reports/listing-template.md) §3
- Two Suns Free answers, as the model: Category **Utility**; Subcategory "Whatever the Category choice offers."; collect user data **No**; ANT+ **No**; regional limits **No**; Preview Video None; Email `hello@verden.watch`; Source Code URL blank; Review Notification **Yes**; App Migration **No** ("a new app id"); Monetization **No**; Additional Hardware Requirements `https://verden.watch/two-suns/`; App Version `1.0.0`; What's New "Leave blank." — [TwoSuns/listing-free/paste.md](TwoSuns/listing-free/paste.md); reasons in [TwoSuns/listing-free/NOTES.md](TwoSuns/listing-free/NOTES.md) "Why each answer"
- DayArc (free) answers Monetization with `Free`, while Two Suns, HeroFace and Days To Go answer "No". ROADMAP 2.8 asks the owner to read the form's Monetization question once and settle it. — [DayArc/listing/paste.md](DayArc/listing/paste.md); [ROADMAP.md](ROADMAP.md) 2.8
- Hardware field: "paste the URL only, no sentence". The API field is `hardwareProductUrl`. It is undocumented by Garmin, and the studio uses it for the site link. — [reports/listing-template.md](reports/listing-template.md) §2; [reports/Garmin policies and design guidelines.md](reports/Garmin%20policies%20and%20design%20guidelines.md) §2
- Guideline 1c: apps that diagnose, treat or prevent disease need regulatory documentation; "Otherwise, apps must be repositioned as 'intended for informational purposes only'". Guideline 1b: Garmin may reject apps that "may create a false sense of security, such as 'safety awareness' apps." — [Garmin App Review Guidelines](https://developer.garmin.com/connect-iq/articles/app-review-guidelines/Overview.html) (fetched 2026-10-04, summarised by the fetch tool, not a full verbatim copy)
- Sun Window wording rules (ADR-005, reversible default): "one line 'For information only; not medical advice or a sun-safety tool'". The same words go in the title, description, screenshots, watch strings, translations and site. "Vitamin D" option A (nowhere) or B (one hedged mention in the description body) is open for the owner. — [SunWindow/docs/decisions.md](SunWindow/docs/decisions.md) ADR-005
- Guideline 4a: no inaccurate or misleading statements. 4b: accurate device disclosure. 4d: "You must identify whether or not your app requires payment". — [Garmin App Review Guidelines](https://developer.garmin.com/connect-iq/articles/app-review-guidelines/Overview.html)
- Privacy policy: "needed if the app collects user data; Garmin does not define 'collects'". Exhibit A says an app must not collect location by default and users must opt in. For Two Suns Pro (Positioning, rounded place stored on the watch), the studio infers that on-watch storage is not collection and that the install prompt is the opt-in (unverified; the app passed review). — [reports/Garmin policies and design guidelines.md](reports/Garmin%20policies%20and%20design%20guidelines.md) §2
- The live Two Suns Pro (with Positioning) listing answers "collect user data" No, and its site privacy page has a "Location" paragraph (rounded to about 0.1 degree, stored on the watch only). — [TwoSuns/docs/status.md](TwoSuns/docs/status.md) "Store form answers"; [site/src/apps/two-suns/Privacy.tsx](site/src/apps/two-suns/Privacy.tsx)
- What's New flow: every store publication gets a CHANGELOG entry and a paste-ready What's New block in `paste.md`; "the previous block moves to `listing/NOTES.md`, and the App Version field is bumped". — [CLAUDE.md](CLAUDE.md) "House rules everywhere"
- First release: What's New left blank ("the form has no 'first release' field and the text reads as noise"). An optional draft line goes in `meta.yaml` `owner_approvals`. — [TwoSuns/listing-free/NOTES.md](TwoSuns/listing-free/NOTES.md)
- Version: "the form reads it from the package; if a field asks, type it." — [TwoSuns/listing-free/NOTES.md](TwoSuns/listing-free/NOTES.md) "2026-10-04: what moved out"
- Image sections list file names only, numbered in upload order, no captions. Captions and devices go in `meta.yaml` `assets.screens`. — [reports/listing-template.md](reports/listing-template.md)
- Placeholders are written `<WHAT>` and listed in `owner_approvals`; "an agent never fills in what the owner must decide". — [reports/listing-template.md](reports/listing-template.md)
- After approval (Two Suns Free): read the Free listing's real compatible-device list and record it in `docs/compatibility.md`; record app ids and approval dates. — [TwoSuns/listing-free/NOTES.md](TwoSuns/listing-free/NOTES.md) "After approval"

### Inferences
- For Sun Window, drop skeleton items 1 (Pro URL) and 4 ("Pro adds"), because there is no Pro (ADR-003). Item 7 (More from Verden) can list live free siblings if any are approved by submission. Two Suns Free, Days To Go Free and HeroFace Free were all in review on 2026-10-04 (ROADMAP 7.12).
- The Two Suns Free privacy paragraph ("No location … It stores no place") must **not** be copied. Sun Window's paragraph has to say a rounded location is read and stored on the watch, consistent with the spec's "no 'no location'" rule.
- The "collect user data" answer "No" has a studio precedent with Positioning (Two Suns Pro). It is still an inference, and it belongs in `owner_approvals` because "any permission with a privacy cost" is on the never-decide-alone list.
- Category: Two Suns Free chose Utility (alternative Health & Fitness). For Sun Window, Utility fits the 1c/1b risk better, because Health & Fitness reads as intended health use. This is an inference and an owner call.
- Description draft order: promise (the sun is the subject), the three states, window times (if ADR-006 is confirmed), accent setting, the informational-only line, the location paragraph, review sentence, support URL.

### Gaps
- Garmin publishes no form field list. The order above is the studio's recorded dashboard order.
- Whether a widget listing shows any extra form field (for example glance-related) was not checked; no studio app has been uploaded as type `widget`. HeroSet is a watch-app with a glance.
- The exact Monetization wording on the form is unresolved (ROADMAP 2.8).
- To verify, not assumed: whether API 5.1+ products still accept manifest `type="widget"` or treat it as a watch-app with a glance (Garmin's Glances core topic, cited in `reports/Garmin policies and design guidelines.md` §4, says "4.0+ apps need a glance view to appear"). This affects the app type the store form and type filter show. Check against https://developer.garmin.com/connect-iq/articles/core-topics/Glances.html.
- Guideline text above came back summarised by the fetch tool, not verbatim.

## 3. Website: files, registration, flags, prerender, sitemap, privacy wording

### Takeaway
A new app is one folder `site/src/apps/<slug>/` (app.ts, facts.ts, Landing.tsx, Support.tsx, Privacy.tsx, Mark.tsx, optional preview) plus one line in `site/src/apps/index.ts`. Routes, prerendered pages, the sitemap and the header nav all come from that registry. The by-hand edits are: the `site/CLAUDE.md` linked-apps table, the `studio.intro` sentence in `site/src/site.ts`, `public/favicon.svg`, and possibly the hard-coded JSON-LD `HealthApplication` category. Leave `storeUrl` unset until approval. A deploy is a push to main, and it is the owner's call.

### Cited Findings
- Adding an app: "Create `src/apps/<slug>/` with an `app.ts` exporting an `App` … and `Landing`, `Support`, `Privacy` components. Copy `src/apps/heroset/` as a starting point. Add it to the list in `src/apps/index.ts`. `npm run build`." — [site/README.md](site/README.md) "Adding an app"
- Also: "Add row to table above" in site/CLAUDE.md, and "In app docs, note public pages live here, with URLs." — [site/CLAUDE.md](site/CLAUDE.md) "Add app"
- Existing per-app folder: `FacePreview.tsx, Landing.tsx, Mark.tsx, Privacy.tsx, Support.tsx, app.ts, facts.ts`. — `site/src/apps/two-suns/` (file listing)
- The `App` type fields: `slug, name, summary, title, platform, color, onColor, storeUrl?` ("absent until the app is live"), `storeName, ogImage?, Mark, Emblem?, Landing, Support, Privacy`. — [site/src/apps/types.ts](site/src/apps/types.ts)
- Routes `/<slug>/`, `/<slug>/support/`, `/<slug>/privacy/` are generated from the registry. `appUrl()` is "the only place app URLs are spelled … must never change". — [site/src/urls.ts](site/src/urls.ts); [site/src/entry-server.tsx](site/src/entry-server.tsx)
- Prerender writes `dist/<route>/index.html`, `dist/404.html` and `dist/sitemap.xml` from `routes`, so there is no separate prerender or sitemap list to edit. — [site/prerender.ts](site/prerender.ts); [site/src/entry-server.tsx](site/src/entry-server.tsx) `sitemap()`
- JSON-LD on every landing page hard-codes `applicationCategory: 'HealthApplication'`. — [site/src/entry-server.tsx](site/src/entry-server.tsx) `softwareApplication`
- The header colour bars and nav list iterate `apps` automatically. — [site/src/components/Shell.tsx](site/src/components/Shell.tsx)
- The favicon does not update itself: "Update `public/favicon.svg` by hand if you want it to match." — [site/README.md](site/README.md)
- `studio.intro` is a hand-written sentence naming HeroSet, HeroFace and Days To Go. — [site/src/site.ts](site/src/site.ts)
- Store button: with `storeUrl` set, "Get it on the {storeName}"; without it, a "Coming soon" status. — [site/src/components/AppSections.tsx](site/src/components/AppSections.tsx); [site/README.md](site/README.md)
- Flags: `instinctLive` and `glanceLive` exist only in `site/src/apps/heroset/facts.ts`. The standing rule is that "site copy for an unreleased device list stays behind a flag until the store approves", and a watch list goes in `facts.ts` "only once the live store shows it". — [site/src/apps/heroset/facts.ts](site/src/apps/heroset/facts.ts); [/Users/mbp/dev/watch-design-kit/knowledge/owner-steering.md](/Users/mbp/dev/watch-design-kit/knowledge/owner-steering.md); [TwoSuns/docs/status.md](TwoSuns/docs/status.md) "On approval" 3
- The Two Suns `facts.ts` pattern: `appName` (working name, one constant), `languages`, `permissions` mirroring the manifest ("If it is ever dropped: delete its entry here and the 'Location' paragraph in Privacy.tsx"). — [site/src/apps/two-suns/facts.ts](site/src/apps/two-suns/facts.ts)
- Two Suns privacy page with Positioning: "In short" note (no account, no internet, no analytics, no ads; N permissions; settings pass through Garmin Connect); What it reads; Permissions list; **Location** ("reads the last location your watch already knows and keeps it rounded to about 0.1 degree, roughly 11 km … stored on the watch only"); What it saves; What it shares ("Nothing. It has no network access …"); Settings; `PrivacyTail`; plus an "Effective <date>" lede. — [site/src/apps/two-suns/Privacy.tsx](site/src/apps/two-suns/Privacy.tsx)
- Site rules: CSP enforced (no inline `<style>`, no `data:` URIs, no external origins); zero client JS; claims come from the app's docs; contact email lives only in `src/site.ts`; no analytics. — [site/CLAUDE.md](site/CLAUDE.md) "Rules"
- Hosting: deploys on push to `main` by the GitHub Action (about 30 s; `gh run list`); `npm run deploy` is the fallback. "Site must stay public: store reviewer and user must reach support and privacy page without login." — [site/CLAUDE.md](site/CLAUDE.md) "Hosting"
- Site deploys are `[you]` (never decide alone). — [ROADMAP.md](ROADMAP.md) "How to use it"
- A store listing links to `/<slug>/support/` in the description and `/<slug>/` in the hardware field, so the pages must be live before the reviewer reads the listing (Two Suns gate 12: "open without login"). — [TwoSuns/docs/status.md](TwoSuns/docs/status.md) gate 12
- Screenshots on site: PNGs go in `public/<slug>/screens/` and `src` is set in `facts.ts`. Placeholder slots show "Screenshot pending". — [site/README.md](site/README.md) "HeroSet specifics"
- Site colour: each app has a field colour on the shared grid. Two Suns notes "amber is HeroSet, blue HeroFace, mint Days To Go", and DESIGN.md wants a named token for each. — [site/src/apps/two-suns/app.ts](site/src/apps/two-suns/app.ts)

### Inferences
Files Sun Window touches on the site (slug `sun-window` if ADR-001 keeps it):
- New: `site/src/apps/sun-window/{app.ts, facts.ts, Landing.tsx, Support.tsx, Privacy.tsx, Mark.tsx}`. Optional: a `Preview.tsx` captioned as not a screenshot, and `public/sun-window/screens/*.png`.
- Edited: `site/src/apps/index.ts` (one import, one array entry); `site/CLAUDE.md` linked-apps table row; `site/src/site.ts` `intro` (optional); `site/public/favicon.svg` (optional); `site/src/styles/global.css` / `site/DESIGN.md` for the colour token; `site/README.md` "Sun Window specifics" section (pattern used per app).
- `platform` should read "Widget · Connect IQ", not "Watch face". The JSON-LD `HealthApplication` category sits uneasily with the informational-only positioning. Options are a per-app override field in `App` or accepting it; an agent cannot decide this alone because it touches shared code.
- The privacy page needs Positioning wording mirroring Two Suns', and must also cover reading the watch's cached weather forecast (UV index, cloud cover) on the watch with nothing sent. The Support page FAQ needs: "open once" first-run state, NONE TODAY explained (winter), why OPEN can be CLOSED on a cloudy day, the informational-only line, and how to change the accent.
- The slug freezes the moment the listing pastes these URLs, so the site pages must wait for ADR-001 (name).
- No `instinctLive`-style flag is needed unless the site names devices. Simplest is no device list until the store shows one (Two Suns/Days To Go rule).

### Gaps
- Whether `Doc`/`PrivacyTail` components say anything face-specific was not read.
- No existing site page describes a widget or glance in non-HeroSet terms. HeroSet's glance FAQ is the only precedent.

## 4. ROADMAP.md conventions and how a new project gets entries

### Takeaway
ROADMAP.md is the only to-do list. It has four sections (1 Decide, 2 Your hands, 3 Agent can do now, 4 Waiting), stable `N.x` ids tagged `[you]`, `[agent]` or `[both]`, plus "Ship sequences" (M1..M11) and a short "Done" list. Sun Window needs a fresh id family and an M-sequence. Per-project `docs/status.md` must hold no checkboxes.

### Cited Findings
- "Single source for every open item, all apps. Evidence stays in each project's `docs/status.md`; decisions in its `docs/decisions.md`. Do not keep open checkboxes anywhere else." — [ROADMAP.md](ROADMAP.md) header
- Tags `[you]` (decision, watch, store dashboard, a person), `[agent]`, `[both]`. Drive mode ("drive M3") and step mode ("next task"). — [ROADMAP.md](ROADMAP.md) "How to use it"
- "Ids are stable (other docs cite them): `1.x` to `8.x` are the old milestones, `9.x` Instinct family, `10.x` housekeeping, `11.x` image refresh. Add new work at the end of the right section." — [ROADMAP.md](ROADMAP.md)
- Used high ids: `12.1` (cancelled) and `14.1` (parked). No `13.x` appears in the worktree or main-checkout ROADMAP. — `rg` over [ROADMAP.md](ROADMAP.md) and `/Users/mbp/dev/garmin/ROADMAP.md`
- Sections: "1. Decide (needs your answer; blocks agent work)", "2. Your hands (a watch, the store dashboard, a person)" with sub-groups Uploads / Assets / Wrist and watch checks / People, "3. Agent can do now" (Simulator work / Fixes and polish / Packages, listings, site / Later features), "4. Waiting on a date or an outside event", "Ship sequences", "Done". — [ROADMAP.md](ROADMAP.md)
- Ship sequence format: "**M1 DayArc** (first real release …): 1.1, 1.2, …". — [ROADMAP.md](ROADMAP.md) "Ship sequences"
- Done items keep their id, have `[x]` and a bold "**Done <date> (simulator): …**" note. "Dates are earliest, never promises. Simulator evidence is never device proof." — [ROADMAP.md](ROADMAP.md)
- Two items with standing post-approval patterns: 6.4 "After each Free is approved: the 30-day (G1) and 60-day (G2) exposure reads", and 7.12 "Garmin review of … on approval: record dates and read the stores' device lists". — [ROADMAP.md](ROADMAP.md)
- The main checkout's ROADMAP.md differs from the worktree's: line numbers shift, so main has moved on since this worktree branched. — `/Users/mbp/dev/garmin/ROADMAP.md` vs [ROADMAP.md](ROADMAP.md)

### Inferences
- Sun Window ids: use a new family not yet used. `15.x` is the safe choice: `12` is taken by a cancelled item and `13` may have been skipped on purpose. Add an "M12 Sun Window" ship sequence. Also add a sentence to the "Ids are stable" line naming the new family.
- Candidate entries:
  - Decide: 15.1 name (ADR-001), 15.2 vitamin D A/B (ADR-005), 15.3 window times (ADR-006), 15.4 go/no-go vs SunIQ (ADR-007), 15.5 category, collect-data answer and Monetization wording.
  - Your hands: wear day and D2/D6/D7 on the FR965; icon and look approval; upload; site deploy; translations OK.
  - Agent: fit sweep, export check, listing drafts, site pages, reviewer pass.
  - Waiting: Garmin review, then 6.4-style G1/G2 reads if wanted.
- Edit the ROADMAP on top of main's latest version, or rebase first, to avoid conflicts. Other sessions edit it concurrently.

### Gaps
- Whether the owner wants a new id family or Sun Window folded into an existing number was not found anywhere.

## 5. Device testing protocol

### Takeaway
Builds for the wrist go into the git-ignored `/Users/mbp/dev/garmin/device-test/` (main checkout) as fr965 debug `.prg` files with a `checklists/<App>-CHECKLIST.md`. They are sideloaded over USB into `GARMIN/Apps`. Sideloads get **no phone settings**, so the accent round trip needs a store or Beta App install. The owner wears one variant for a whole day with no swaps. Results are recorded in `docs/status.md` gates and ROADMAP ticks, with the simulator-vs-device distinction always explicit.

### Cited Findings
- `device-test/` is "git-ignored scratch for on-watch builds". — [CLAUDE.md](CLAUDE.md)
- It does not exist in the worktree; it lives in the main checkout: `/Users/mbp/dev/garmin/device-test/` with `README.md`, `checklists/`, `debug/`, `_archive-2026-10-04/`. — [/Users/mbp/dev/garmin/device-test/README.md](/Users/mbp/dev/garmin/device-test/README.md)
- Every `.prg` is "a debug (not stripped) build for the Forerunner 965 (fr965) only", built in the container (`docker/run.sh`). The `debug/` folder keeps `.prg.debug.xml` for crash-log lookups. The README table lists file, size, app, tier, same app id as store?, ROADMAP check and checklist. — same file
- Sideload: plug in USB (MTP fallback: OpenMTP/Android File Transfer), copy ONE `.prg` to `GARMIN/Apps`, eject, the watch installs on disconnect. To remove, delete the `.prg`. Settings and data live in `GARMIN/Apps/SETTINGS` and `GARMIN/Apps/DATA`. — same file "Sideload on the FR965"
- "Garmin Connect phone settings do NOT reach a sideloaded `.prg`." The phone round trip "needs a store or Beta App install". A Beta App is uploaded at the dashboard ("new app, tick **Beta App**, no price, the listing copy is not needed") and installed from the Connect IQ phone app. — same file "Read before sideloading"
- Platform fact: a sideloaded app needs `getSettingsView()` for on-watch settings. — [/Users/mbp/dev/watch-design-kit/knowledge/platform-facts.md](/Users/mbp/dev/watch-design-kit/knowledge/platform-facts.md) "Settings"; [SunWindow/docs/spec.md](SunWindow/docs/spec.md) "Settings"
- Testing style: "a single all-day wear session … No build swap during a wear day — it breaks the battery window … one app owns a given day". Plans go in a git-ignored checklist file, "the only record of a session". — `/Users/mbp/.claude/projects/-Users-mbp-dev-garmin/memory/fr965-device-testing-style.md`; [/Users/mbp/dev/garmin/device-test/README.md](/Users/mbp/dev/garmin/device-test/README.md) ("all-day wear, dev builds only, **no swaps within a day**")
- Evidence recording: status gates cite the checklist or results file and date ("Passed, one comparison (2026-09-27): exact match, `device-test/TwoSuns-CHECKLIST.md`"). Results files like `TwoSuns-weather-RESULTS.md` sit in `checklists/`. — [TwoSuns/docs/status.md](TwoSuns/docs/status.md) gate 3, F12
- Simulator screenshots and automatic checks: `docker/SIMULATOR.md`, `docker/shot.sh`. "A layout change is not done until you have looked at a screenshot". Simulator runs go through the container by default; the host simulator is for final pre-release verification only with the owner's OK. — [CLAUDE.md](CLAUDE.md) "House rules everywhere"
- Owner steering: the owner accepted simulator-only evidence for the Instinct family "on the condition that every report says it is simulator-only". — [/Users/mbp/dev/watch-design-kit/knowledge/owner-steering.md](/Users/mbp/dev/watch-design-kit/knowledge/owner-steering.md)

### Inferences
- For Sun Window: build `SunWindow-fr965.prg` (debug) into `/Users/mbp/dev/garmin/device-test/` and add a row to its README table. SunWindow has no manifest or source yet; it gets a fresh app id when the manifest is written (the upload form reads it from the package, as for Two Suns Free), so a sideload clashes with nothing.
- Write `checklists/SunWindow-CHECKLIST.md` covering:
  - D6: first-run glance before the widget was opened, then the widget view, with GPS available and with no fix.
  - D2: `uvIndex`/`cloudCover` current and hourly, sunny vs overcast.
  - D7: glance on the FR965 and the state across local midnight.
  - D9: a few window-edge times against the fixtures for the owner's location.
  - The three states seen live.
  - The on-watch Customize accent.
  - Battery noted for information only.
- The accent phone round trip and "settings persist across a phone sync" (gate 5) need a Beta App upload, an extra `[you]` dashboard step, unless the owner accepts checking it after store approval.
- One wear day for Sun Window means no other sideload swap that day. Schedule it against the other pending FR965 days (ROADMAP 1.1, 3.1, 4.2, 5.5, 7.9).
- The 32 KB-glance Instinct ids and MIP displays cannot be checked on the owner's hardware. Report them as simulator-only or exclude them.

### Gaps
- Whether a widget glance from a sideloaded `.prg` shows in the glance loop exactly as a store install does was not found.

## 6. Translations

### Takeaway
The studio ships on-watch strings in English plus 14 machine-drafted languages (dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr), fit-tested with `tools/fit_languages.sh`. Store descriptions are English only until the owner approves translations. Each extra listing language is added after the first approval. Machine text is never shipped as store copy without a native read. Listing text names no languages.

### Cited Findings
- On-watch languages: "English plus 14 (dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr) exist as on-watch strings and are machine-drafted, not read by a native speaker … The store description is English only until the owner decides whether to translate it. Russian, Greek and Chinese are not included." — [DaysToGo/listing/NOTES.md](DaysToGo/listing/NOTES.md) "Languages"; [TwoSuns/listing/NOTES.md](TwoSuns/listing/NOTES.md) "Languages"
- Two Suns: "store copy that no native speaker has read is not shipped. The site says 'machine-drafted and not yet read by native speakers'." — [TwoSuns/listing/NOTES.md](TwoSuns/listing/NOTES.md)
- Language gate: `tools/fit_languages.sh <product>` per language on the smallest screen (`fr255s`) and a rectangle (`venusq2`). Owner decided for Two Suns to "ship all 15 … no native-speaker read required" (on-watch). — [TwoSuns/docs/status.md](TwoSuns/docs/status.md) gate 9
- Listing languages: "English first. Each further language is a separate pick, **Add**, Title + Description, and only after the first approval. Machine-drafted text needs the owner's OK and a native read before it is store copy." Listing text says only "Multi-language support: it follows your watch's language." — [reports/listing-template.md](reports/listing-template.md)
- ROADMAP 7.10 `[you]`: native-speaker reads of strings, and "any language you ship as store copy (all faces are machine-drafted in 14 languages)". — [ROADMAP.md](ROADMAP.md)
- Site `facts.ts` mirrors the language list. — [site/src/apps/two-suns/facts.ts](site/src/apps/two-suns/facts.ts)
- Garmin's localization page: "Supporting only English is not a localization strategy". — [reports/Garmin policies and design guidelines.md](reports/Garmin%20policies%20and%20design%20guidelines.md) §4
- "Translations" is on the never-decide-alone list. — [ROADMAP.md](ROADMAP.md)

### Inferences
- Sun Window's state words (OPEN, CLOSED, NONE TODAY, "open once"), the informational line and the accent names need 14 drafts each, checked against ADR-005's wording rules in every language. For example, no translation may turn "open" into "good" or "safe". That makes a native read more important here than for a face.
- Files touched: `SunWindow/resources-<lang>/strings/strings.xml` (14), a `check_strings`/`fit_languages` run, `site/src/apps/sun-window/facts.ts` `languages`, and `SunWindow/listing/NOTES.md` "Languages".

### Gaps
- Whether Garmin's store auto-shows the English description for non-English users was not checked.

## 7. Icons/store images pipeline, Garmin dashboard steps, review times

### Takeaway
An agent renders the images: simulator screenshots via `docker/shot.sh`, and cover and hero from HTML sources in `listing/src/`. The owner approves the looks and uploads. Every new Free so far went up as a new app at the developer upload page. Observed review time is about 1 to 3 days (the studio quotes "about 72 hours").

### Cited Findings
- Image set per listing: "5 screens each with an Instinct one …, hero 1440x720, cover 500x500, the two 128x128 icons; sizes within Garmin's caps; simulator only … **You approve the looks**". — [ROADMAP.md](ROADMAP.md) 9.7
- Covers on a light or coloured ground (owner 2026-10-04, after Garmin's brand page "Do not choose black or transparent backgrounds"). Device icons stay on black. — [ROADMAP.md](ROADMAP.md) 10.19, 10.25; [DaysToGo/listing/NOTES.md](DaysToGo/listing/NOTES.md) "Images"
- Brand page: 500x500 sRGB, 10 px padding, "Steer clear of descriptive text anywhere on the icon", 128x128 device icons (64 colours on MIP), hero 1440x720. — [reports/Garmin policies and design guidelines.md](reports/Garmin%20policies%20and%20design%20guidelines.md) §4, citing [developer.garmin.com/brand-guidelines/connect-iq](https://developer.garmin.com/brand-guidelines/connect-iq/)
- Pipeline: composed images from `listing/src/cover.html` and `hero.html` (sources), with output `cover-500.png`, `hero-1440x720.png`, `icon-24-128.png`, `icon-64-128.png`. Screens go in `listing/screens/`, older versions in `listing/old/`, and the recipe in `listing/screenshots.md`. — [DaysToGo/listing/screenshots.md](DaysToGo/listing/screenshots.md); `TwoSuns/listing-free/` (file listing)
- Screens are "simulator only with canned data … never a reading". The canned values must be noted in `owner_approvals`. — [TwoSuns/listing-free/meta.yaml](TwoSuns/listing-free/meta.yaml)
- Launcher icon (`resources/drawables/launcher_icon.svg`) is an owner decision. ROADMAP 1.5 lists icons, covers and hero images per app as `[you]`. — [ROADMAP.md](ROADMAP.md) 1.5; [DaysToGo/listing/screenshots.md](DaysToGo/listing/screenshots.md)
- New app upload steps (Two Suns Free): build or export (`monkeyc -e -r -f <jungle> -o dist/<Name>.iq -y ~/.garmin-connectiq/keys/developer_key`), run the package check, open https://apps.garmin.com/developer/upload, attach the `.iq` ("a **new** app: the form reads the new app id from the package"), paste fields in form order. Same day: update CHANGELOG and What's New. Never commit `dist/*.iq` or keys. — [TwoSuns/docs/status.md](TwoSuns/docs/status.md) "Free listing block"; [SunWindow/docs/publish-checklist.md](SunWindow/docs/publish-checklist.md) "Submit"
- After upload, record in `meta.yaml`: `app_id`, `store.listing_url` (`https://apps.garmin.com/apps/<id>`, valid once approved), `store.developer_url` (`https://apps-developer.garmin.com/apps/<id>`), `next.status: uploaded`, `uploaded:` date. — [TwoSuns/listing-free/meta.yaml](TwoSuns/listing-free/meta.yaml)
- `dist/` holds only what will be uploaded; older builds go in `dist-old/`. — [ROADMAP.md](ROADMAP.md) section 2 intro
- Observed review times:
  - HeroSet 1.1.0 uploaded 2026-09-21, live 2026-09-22.
  - HeroSet 1.1.1 uploaded and live 2026-09-24.
  - HeroFace 1.0.1 uploaded and live 2026-09-24.
  - Days To Go submitted 2026-09-26, approved 2026-09-28.
  - Two Suns submitted 2026-09-27, approved 2026-09-28.
  - HeroSet 1.2.0 uploaded 2026-09-27, approval reported 2026-10-01 (date not recorded).
  - Sources: [HeroSet/CHANGELOG.md](HeroSet/CHANGELOG.md); [HeroFace/CHANGELOG.md](HeroFace/CHANGELOG.md); [DaysToGo/CHANGELOG.md](DaysToGo/CHANGELOG.md); [TwoSuns/CHANGELOG.md](TwoSuns/CHANGELOG.md)
- "Review takes about 72 hours; a rejection comes back with specific reasons." "Advice, not evidence: submit early in the week." — [HeroFace/listing/NOTES.md](HeroFace/listing/NOTES.md); [TwoSuns/docs/status.md](TwoSuns/docs/status.md) "Timing"
- If rejected: "Fix the named item … bump the version if the package changes, re-submit." — [TwoSuns/docs/status.md](TwoSuns/docs/status.md)
- Export over-reports devices (part numbers vs products). "The store form's own Compatible Devices list is authoritative." — [TwoSuns/docs/status.md](TwoSuns/docs/status.md) gate 8
- Listing edits: whether the hardware field or images can be edited without a new version is unverified (ROADMAP 6.6, 10.5). — [ROADMAP.md](ROADMAP.md)

### Inferences
- Sun Window as a Free app has a different reach from the paid apps. Paid-list restrictions do not apply, so the store's device list should match the package more closely. Still quote no count.
- An Instinct screenshot is only needed if Instinct products ship (the spec says lean glance or exclude). The "5 screens with an Instinct one" studio set is a convention, not a rule.
- Screens should show OPEN, CLOSED, NONE TODAY, the glance, and one accent. ADR-005 bars "vitamin D" from screenshots, and no screenshot may imply a reading is good.
- A widget may need a glance-sized screenshot. The capture recipe would follow HeroSet's glance shots (`HeroSet/listing/screenshots.md`; not read here).

### Gaps
- The Garmin developer dashboard UI for a widget's app type was not observed. The type comes from the manifest.
- No published Garmin review SLA was found. All times above are the studio's own observations.

## 8. Merging the worktree into main: repo conventions for a new project folder

### Takeaway
A sixth (seventh, counting site) project folder must appear in the root README project table and Layout tree, the root CLAUDE.md project table, the README Build block, and site/CLAUDE.md. Its own folder needs the full standard doc set (`docs/README.md`, `docs/status.md`, `listing/paste.md` + `meta.yaml`). MEMORY already has a Sun Window note. The owner commits and merges; an agent never stages or commits unasked.

### Cited Findings
- Root CLAUDE.md project table lists six folders with a one-line status each. "Each folder has its own `CLAUDE.md` and `docs/`". — [CLAUDE.md](CLAUDE.md)
- Root README project table (folder / what / status), Layout tree header line `HeroSet/ · HeroFace/ · DaysToGo/ · TwoSuns/ · DayArc/`, and a Build block with one `monkeyc` line per project. — [README.md](README.md)
- "Every watch project shares one file layout — see root `README.md` 'Layout' … Keep new files in that shape." — [CLAUDE.md](CLAUDE.md)
- Layout: README.md, CLAUDE.md, CHANGELOG.md, PRODUCT.md, DESIGN.md; docs/{README.md, spec.md, decisions.md, compatibility.md, release-contract.md, development.md, status.md, archive/}; listing/{paste.md, meta.yaml, NOTES.md, screenshots.md, screens/, src/}; source/, resources*/, manifest*.xml, *.jungle, tools/. — [README.md](README.md) "Layout"
- User-facing claims rule: "A behaviour or data-handling change in a watch project → update its pages under `site/src/apps/<slug>/` the same session." — [CLAUDE.md](CLAUDE.md)
- Git: "Git index is often mixed staged/unstaged: don't stage, commit, stash or reset unless asked." — [CLAUDE.md](CLAUDE.md)
- MEMORY already lists "[Sun Window widget](sun-window-widget.md) — Free widget-only idea, spec in worktree vitamin-d-window-intake; open: name, vitamin D wording, go/no-go vs SunIQ". — `/Users/mbp/.claude/projects/-Users-mbp-dev-garmin/memory/MEMORY.md`
- Reports: `reports/` holds reports, with sourced notes in `research_notes/<report title>/`. `reports/README.md` indexes them. — [CLAUDE.md](CLAUDE.md); [README.md](README.md)
- Current worktree status is all untracked: `SunWindow/`, `reports/Vitamin D window.md`, `research_notes/Vitamin D window/`. — git status at session start
- The SunWindow docs are template copies from `/Users/mbp/dev/watch-design-kit/templates/watch-app/` (same file set: CHANGELOG, CLAUDE, DESIGN, README, docs/{compatibility, decisions, development, plan, publish-checklist, release-contract, spec}, listing/{NOTES, README, screenshots}). — file listings of both
- The DayArc precedent for an unreleased project: the status line in the CLAUDE.md table says what is simulator-only and what device evidence exists. — [CLAUDE.md](CLAUDE.md) DayArc row

### Inferences
Files to touch at merge time:
- Root `CLAUDE.md` table row: `SunWindow/` | Garmin widget, "Sun Window" (working name), Free only, not submitted.
- Root `README.md`: table row, Layout header line, Build line `cd SunWindow && monkeyc -d fr965 -f monkey.jungle -o bin/SunWindow.prg -y $KEY` (no space in the file name).
- `reports/README.md`: add the "Vitamin D window" report.
- `ROADMAP.md`: section entries and an M-sequence.
- `site/CLAUDE.md`: linked-apps row.
- The memory note: update it at each owner decision.
- Within `SunWindow/`:
  - Add `docs/README.md` and `docs/status.md` (gates plus upload steps, no checkboxes).
  - Add `PRODUCT.md` if the layout requires it.
  - Convert `listing/README.md` to `paste.md` + `meta.yaml`.
  - Move `docs/plan.md` to `docs/archive/` when built (TwoSuns keeps `archive/plan.md`).
  - Fix the CLAUDE.md "What's New in `listing/README.md`" wording, and the same pointer in the `SunWindow/CHANGELOG.md` header ("The store's 'What's New' text for each version is in `listing/README.md`").
- Rebase on main first, since main's ROADMAP has moved.
- The design-kit template itself is out of date relative to studio practice (listing/README vs paste.md/meta.yaml, no status.md, "flip rule" in gate 14, a space in the build path). That is a kit fix (`~/dev/watch-design-kit`, ROADMAP 10.4 territory), and the owner commits kit files.

### Gaps
- Whether `PRODUCT.md` is mandatory for every project (HeroSet lacks DESIGN.md; nothing said about PRODUCT.md exemptions).

## 9. Ordered release checklist (synthesis), files touched, owner vs agent

### Takeaway
After the build and simulator tests are green, the release side has about 25 ordered steps. Six owner decisions block listing text and site pages: name, vitamin D, window times, go/no-go, Category/collect-data/Monetization, and looks/icon. Wrist checks block submission. The order is: decide, then device-check, then assets and listing, then site live, then upload, then post-approval bookkeeping.

### Cited Findings
- All sources as cited in sections 1 to 8.

### Inferences
Ordered checklist:

| # | Step | Files touched | Who |
|---|---|---|---|
| 0 | Restructure docs to studio layout: `docs/status.md` (gates from publish-checklist, minus 6 and 14→"Free"), `docs/README.md`, `listing/paste.md` + `meta.yaml` from `listing/README.md`; fill `release-contract.md` May claim / Data and privacy; fix the build path space | `SunWindow/docs/*`, `SunWindow/listing/*`, `SunWindow/CLAUDE.md` | agent |
| 1 | Owner decides ADR-001 name (store search plus trademark), ADR-005 A/B, ADR-006, ADR-007 go/no-go | `SunWindow/docs/decisions.md`, `SunWindow/CLAUDE.md`, ROADMAP Decide | **owner** (agent records) |
| 2 | Fit sweep on all API 5.1+ products, glance and full view; Instinct 32 KB glance decision (lean or exclude); screenshots looked at | `SunWindow/docs/compatibility.md`, `docs/status.md` | agent |
| 3 | `watch-design-reviewer` until `ship` | `docs/status.md`, `DESIGN.md` | agent |
| 4 | Look approval (round, rectangle, Instinct if kept) and launcher icon | `resources/drawables/launcher_icon.svg`, `DESIGN.md` | **owner** |
| 5 | Build fr965 debug `.prg` into `device-test/`, write `checklists/SunWindow-CHECKLIST.md` (D2, D6, D7, D9, three states, accent on watch) | `/Users/mbp/dev/garmin/device-test/README.md`, `checklists/` (git-ignored) | agent |
| 6 | Wear day plus D-checks on the FR965 (no other swap that day) | checklist results | **owner** |
| 7 | Record evidence (dated, "FR965 only"); MIP is a stated gap | `docs/status.md`, `docs/compatibility.md`, `CHANGELOG.md` "Unreleased" | agent |
| 8 | (Optional) Beta App upload for the phone-settings round trip | dashboard | **owner** |
| 9 | Translations: 14 machine drafts, `check_strings`, `fit_languages.sh` on fr255s and venusq2; owner OK, native read optional per Two Suns precedent | `resources-<lang>/strings/strings.xml`, `listing/NOTES.md` | agent drafts, **owner** approves |
| 10 | Store images: screens (canned data noted), cover on a coloured ground, hero, two 128 icons | `listing/screens/`, `listing/src/`, `listing/screenshots.md`, `meta.yaml` `assets` | agent renders, **owner** approves |
| 11 | Listing text: Free skeleton without Pro lines, 1c line, Positioning paragraph, support URL last, hardware field bare URL; claim table in NOTES; 10.23 greps | `listing/paste.md`, `NOTES.md`, `meta.yaml` `owner_approvals` | agent |
| 12 | Owner answers Category, collect-data (with Positioning), Monetization wording (ROADMAP 2.8) | `paste.md` | **owner** |
| 13 | Site pages: `site/src/apps/sun-window/*`, registry line, CLAUDE.md row, platform "Widget", privacy with Location and Weather, FAQ; JSON-LD category question; `npm run build` | `site/src/apps/sun-window/`, `site/src/apps/index.ts`, `site/CLAUDE.md`, `site/README.md`, optional `site.ts`/`favicon.svg` | agent |
| 14 | Site deploy (push to main) so `/sun-window/`, `/support/`, `/privacy/` open without login before upload | git push | **owner** |
| 15 | Tests green and zero warnings on the submit commit; export `.iq` from the worn commit; package check (permission list = Positioning only, product count) | `dist/SunWindow-1.0.0.iq` (never committed), `meta.yaml` `package` | agent |
| 16 | Upload as a new app (developer/upload), paste fields, images; read the form's Compatible Devices | dashboard | **owner** |
| 17 | Same day: CHANGELOG entry (1.0.0, upload date, changes, ADRs), `meta.yaml` app id, URLs, `next.status: uploaded`, status.md "Uploaded" | `CHANGELOG.md`, `listing/meta.yaml`, `docs/status.md` | agent |
| 18 | Repo registration: root README (table, Layout, Build), root CLAUDE.md row, reports/README, ROADMAP M-sequence and ids, memory note | those files | agent (owner merges/commits) |
| 19 | Wait for review (observed 1 to 3 days, "about 72 hours") | ROADMAP section 4 | wait |
| 20 | On approval: dates in CHANGELOG/meta/status; open the live listing (title, description, images, device tab, links); record the real device list in compatibility.md | same | **owner** opens, agent records |
| 20b | Add the Sun Window store id to `tools/store_poll_ids.txt` so `tools/store_poll.py` appends daily rows to `research_notes/Free and Pro ladder/poll.csv` (feeds 6.4-style reads; root README "Layout") | `tools/store_poll_ids.txt` | agent |
| 21 | Site `storeUrl` in `site/src/apps/sun-window/app.ts`, push | site | agent edits, **owner** deploys |
| 22 | Optional: add listing translations (Add language), only with owner OK | dashboard | **owner** |
| 23 | Day-30/60 exposure reads (6.4 pattern) and spec success test; review mining for "wrong state" | ROADMAP, `docs/status.md` | **both** |

Not applicable to Sun Window v1: price tier and repricing (2.7), Pro sibling URLs and "Pro adds", flip rule, always-on/burn-in gate, `instinctLive`-style paid-reach trimming (no paid listing), merchant account.

### Gaps
- Whether the owner wants the site live before the name is final (it cannot be, since the slug freezes).
- Whether a Beta App round trip is required or can be replaced by a post-approval check: an owner call.
