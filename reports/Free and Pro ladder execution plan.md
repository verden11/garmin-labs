# Free and Pro ladder: execution plan

For agents executing the strategy in `reports/Free and Pro ladder.md`. That report holds the decisions (D1–D12) and the evidence.
This file holds **what to do, in what order, in which files, and how to know it is done.** Notes: `research_notes/Free and Pro ladder/`.

Written 2026-09-28. Time estimates are the planner's, for an agent working alone; they are not measured.

## 0. Read this before touching anything

1. Read, in order: this file section 1, the work package you were given, the target project's `CLAUDE.md`, then its `docs/decisions.md`.
2. **Never decide alone** (root and per-project lists): store names, prices, visual identity and icons, any permission with a privacy cost, any store
   upload, any phone or watch test, any site deploy, shipping unreviewed machine translations. Prepare it, list it as an owner decision, stop.
3. **Do not stage, commit, stash or reset** unless asked (the index is mixed).
4. **DayArc source is being edited by another session** (uncommitted). Do not edit `DayArc/source`, `DayArc/resources*` or its docs from this
   plan except where WP3 says so and only after that session's work is committed or the owner says go.
5. **Simulator passing is not device proof.** Every report says which claims rest on the simulator.
6. **Do not invent evidence:** no reviews, downloads, screenshots, or revenue numbers in any doc or listing.
7. ADR numbers are always glossed with a short parenthetical ("ADR-044, the complication contract"), never cited bare.
8. A behaviour change updates the doc that describes it in the same session; a durable decision gets an ADR in that project's `docs/decisions.md`.
9. Every store publication gets a `CHANGELOG.md` entry and a paste-ready What's New block in that listing's `README.md`; the previous block moves to `NOTES.md`.

## 1. Conventions for every twin (so all five projects look the same)

The live paid app id **is the Pro**. It keeps its files. The Free build is added beside it. Do not rename existing files.

| Thing | Pro (existing, untouched unless stated) | Free (new) |
|---|---|---|
| Manifest | `manifest.xml` (DayArc: `manifest.pro.xml`) | `manifest.free.xml` (DayArc's Free is `manifest.simple.xml`, keep) |
| App id | unchanged, forever | new UUID (`uuidgen`), forever |
| Jungle | `monkey.jungle` | `monkey.free.jungle`: `project.manifest = manifest.free.xml`; `base.sourcePath = source`; `base.resourcePath = resources;resources-free`; `base.excludeAnnotations = pro` |
| Annotation | code only Pro has: `(:pro)` | nothing to write; the jungle excludes `(:pro)` |
| Where bodies differ | pair `(:free)` / `(:pro)` as `DayArcFields` does, and set `base.excludeAnnotations = free` in the Pro jungle | same pair |
| Resources | shared `resources/` (strings, drawables, **no settings**) + `resources-pro/` (AppName "<Name> Pro", full settings and properties). Pro jungle: `resources;resources-pro` | shared `resources/` + `resources-free/` (AppName "<Name>", Free settings and properties, launcher icon if different). Free jungle: `resources;resources-free` |
| Settings XML | full list, only in `resources-pro/settings/` | only in `resources-free/settings/`: omits every Pro setting and every Pro-only list value. Never a locked or greyed item (D2 rule 2). **No `settings.xml` in the shared folder**, so two files never overlap |
| Listing folder | `listing/` (Pro) | `listing-free/` with `README.md`, `NOTES.md`, `screenshots.md` |
| Version | Pro bumps minor (for example 1.1.0) | Free starts 1.0.0 |
| Permissions | unchanged | subset of Pro's, never more |
| Tests | existing runner | run **both** jungles: copy DayArc's `tools/run_tests.sh <device> [jungle] [testName]`; add the compile sweep across the manifest's products for both jungles (`DayArc/tools/compile_sweep.sh`) |

Rules for the code:

- Config classes must return defaults for a property the Free properties file does not define; Pro-only reads are `(:pro)`.
- A Free build must contain no upgrade string, no "Pro" word anywhere on the watch, and no unreachable Pro state.
- Any new function: typed params and `as` return type, no magic numbers (tunables in the project's Config class, colours in its Palette, words in `strings.xml`).
- Text fit is measured; render only in `onUpdate`; a value the watch does not have is hidden or said in words, never blank.
- Accent lists: **append-only.** The Pro build owns the id table (WP1). Free shows a subset of the same ids.

Definition of done for any Free build:

- [ ] `monkeyc -w --typecheck 3` clean for both jungles on `fr965` and one small round, one rectangular product where the project has one.
- [ ] Full compile sweep on every manifest product, both jungles.
- [ ] Project tests pass on both jungles; add tests for the accent table. Add a check on the **compiled** Free package (not the source file) that it contains none of the Pro setting keys: see the WP4 step 0 spike for how to read what the compiler emitted.
- [ ] Package both: `monkeyc -e -r -f <jungle> -o dist/<Name>[Pro].iq -y $KEY` (see the project's `docs/status.md` for its known store-package quirk).
- [ ] Docs updated (spec, DESIGN if visual, ADR, compatibility, CHANGELOG, both listings, site).
- [ ] Owner-only items listed, not done.

## 2. Waves and gates

Dates are earliest; approval dates are unknown, so use the gate, not the date.

| Wave | Work packages | Starts when |
|---|---|---|
| 0 | WP0 decisions, Garmin email, dashboard baseline | now |
| 1 | WP1 (accent) inside WP2 (design), **WP3 DayArc pair**, **WP4 DaysToGo Free**, WP8 site, WP9 measurement | OD1 and OD2 answered |
| 2 | WP5 TwoSuns Free, WP6 HeroFace Free | G1 passed on WP4, and for WP6 the HeroSet/HeroFace readout (about 2026-10-25) is done |
| 3 | WP7 HeroSet Free | Accuracy proof passed (research stage 1b) and the ADR-044 (complication contract) review is done |

| Gate | Read at | Continue if | Else |
|---|---|---|---|
| G1 reach | Free approval + 30 days | ≥100 installs bucket and ≥3 reviews | Fix the listing (title tokens, first line, screenshots) before concluding anything |
| G2 attach | Free approval + 60 days | Pro sales ≥ 5, or ≥ 1% of free installs | <0.3% with ≥1,000 free installs: fix Pro content or price, not the ladder |
| G3 quality | any time | Free rating ≥ 4.0 and no "crippled"/"bait" theme | Move the complained feature to Free |
| G4 renewal | month 12 | Family Pro net covers the $100 fee | Deliberate renewal decision. Never cancel the merchant account to demonetize |

## 3. Work packages

Each: goal, depends on, steps, files, done-when, owner gates. Estimates are agent hours.

### WP0. Decisions, Garmin, dashboard (owner, ≈1.5 h owner time; agent prepares in ≈1 h)

Goal: unblock Wave 1 and stop the flip-to-free clocks.

1. Agent: turn the strategy report's "Owner decisions" table (OD1–OD8) into a one-screen checklist for the owner. Do not answer for them.
2. Owner: send the email in `research_notes/Free and Pro ladder/garmin_questions.md`; work the dashboard checklist there (approval dates, TwoSuns price tier, baselines).
3. Agent, once OD2 is yes: in `DaysToGo/docs/decisions.md` and `TwoSuns/docs/decisions.md` write **a new ADR "Free + Pro ladder, no flip-to-free"** that supersedes the day-45 flip rule
   (DaysToGo ADR-002 and the TwoSuns reference); change `spec.md` "Price review" and each `CLAUDE.md`; remove the "PRICE REVIEW due approval + 45 days" memory entries. Write the recorded approval dates in.
4. Agent: update the root `README.md` status rows and root `CLAUDE.md` table for DaysToGo and TwoSuns from "not submitted/pending" to the owner-confirmed state.

Done when: OD1–OD8 have recorded answers in the report's table; the two ADRs exist; no doc mentions a day-45 flip as active.
Owner gates: everything (prices, names, email, ADRs are decisions).

### WP1. Accent foundation (built inside each release, not shipped alone; ≈2 h per project)

Goal: every face has a customisable accent in **Free**, one family roster, append-only ids, tested, and no accent that collides with a colour the face
already spends on a role. The roster is a candidate list: **each face admits a subset** (`research_notes/Free and Pro ladder/accent_roster.md`, "Per-face eligibility").

Provisional id tables (Pro owns them; Free shows the subset; `watch-design-lead` confirms in WP2):

| Id | DaysToGo Pro | TwoSuns Pro | HeroFace Pro | In the Free list? |
|---|---|---|---|---|
| 0 | Mint #55FFAA (default) | Sky #55AAFF (default) | Sky #55AAFF (default) | yes, all three faces |
| 1 | Amber #FFAA00 | Mint #55FFAA | Cyan #00FFFF | yes, all three faces |
| 2 | Sky #55AAFF | Amber #FFAA00 ("autumn") | Magenta #FF55FF | yes, all three faces |
| 3 | Pink #FF55AA | Violet #AA55FF | (none unless the design pass admits one) | DaysToGo, TwoSuns |
| 4 | Violet #AA55FF | Pink #FF55AA | | DaysToGo, TwoSuns |
| 5 | White #FFFFFF | White #FFFFFF ("winter") | | DaysToGo, TwoSuns |
| 6 | Cyan #00FFFF | Cyan #00FFFF | | Pro only |
| 7 | Lime #55FF55 | Lime #55FF55 | | Pro only |
| 8 | Yellow #FFFF55 | Yellow #FFFF55 | | Pro only |
| 9 | Orange #FF5500 | Magenta #FF55FF | | Pro only |
| 10 | Coral #FF5555 | not admitted | | Pro only |
| 11 | Magenta #FF55FF | not admitted | | Pro only |

Existing ids (DaysToGo 0–5; TwoSuns 0–5; HeroFace 0–2) keep their shipped colour exactly. Default stays id 0. **Reserved colours, per face, never admitted:**
HeroFace: gold, green, alert red, white (so no Amber, Yellow, Lime, Mint, Orange, Coral, White); TwoSuns: golden-hour #FF5500 and near it (no Orange, no Coral).
HeroFace's list therefore stays at its shipped three unless the daring pass re-cuts its role palette or track (its own rule is ≥3:1 against TRACK, and shipped Magenta measures 2.84).

Steps per project:

1. Extend `<Name>Palette.ACCENTS` (append). The palette is shared code: **do not annotate array entries**; only the settings lists differ by tier. Unknown or out-of-range id falls back to the default, as `accent(index)` does today.
2. Settings live in **tier-only folders**: move `settings/settings.xml` and `settings/properties.xml` out of the shared `resources/` into `resources-pro/settings/` and `resources-free/settings/`, and make the Pro jungle `resources;resources-pro` (see section 1 and the WP4 step 0 spike). `DaysToGo/tools/gen_settings.py` and `TwoSuns/tools/gen_settings.py` generate the XML from a table: add a tier argument. HeroFace has no generator: write both by hand.
3. On-watch Customize menu (DaysToGo and TwoSuns have `getSettingsView` Menu2 code): its accent list must be the same subset per tier. Same rule as before: whichever route was used last wins, no merge.
4. Strings: new colour names in all 15 languages. **Machine drafts need the owner's OK** (never decide alone: unreviewed translations). Run `tools/check_strings.py` where it exists.
5. Tests (add to each project's suite): every `ACCENTS` entry has each channel in {00, 55, AA, FF}; contrast on black ≥ 3:1; dimmed form ≥ 3:1; dimmed form ≠ the face's muted grey; not equal to any reserved role colour of that face; the face's own track-contrast rule if it has one (HeroFace); out-of-range id returns the default. HeroFace has no accent test today: add one, and expect Magenta to fail until the rule or the list changes.
6. Never-default rule: amber, orange, coral and red are not the default on Body Battery, stress or sleep faces (TwoSuns ADR-017, the amber-read-as-"low" lesson).
7. Mockup every accent on the face's ring/bar in the design pass (Pink, Violet, Orange, Coral, Magenta sit at 1.9–2.8:1 on the #555555 track; TwoSuns's night track is #5555AA).
8. Device check (owner, FR965 store build): change the accent on the phone, sync, restart, confirm; then change on the watch, restart.

Done when: tests pass in both jungles; the id table and reserved-colour list are in the project's `DESIGN.md`; the phone round trip is recorded as done or as an open owner check.
HeroSet: accent is design-led (WP7). DayArc: WP3.

### WP2. Daring pass (design; per face; ≈4–6 h each, mostly mockup iteration)

Goal: each face gets one decisive signature move, designed **Free first**, with Pro's additions on top, before any Monkey C. Uses the binding brief in section 5.

Order of faces: DaysToGo (Wave 1), TwoSuns, HeroFace, HeroSet UI (their waves). DayArc is already done (its ADR-013, icon system and window colour) and needs only the craft review below.

Per face, steps:

1. `watch-design-lead` reads the brief (section 5), the project's `DESIGN.md`, `PRODUCT.md`, and the face's competitor set from `reports/Garmin watch face market gap.md`.
2. Produce **two** HTML/SVG round mockups in a real browser (round div, real font sizes, real row widths): one Free, one Pro. Screenshot-verify at 454 px and at the smallest supported size. Add the rectangular case where the project has one. Reading the markup is not verification; the Pro grid overflow on DayArc was invisible until rendered.
3. Owner picks the direction (visual identity is an owner decision). Record it as a design ADR in that project's `docs/decisions.md`.
4. Update `DESIGN.md` (tokens, layout, type, icons, accent application rule: does colour mark state, category, or nothing? pick one).
5. Implementation happens in the face's work package (WP4–WP7).
6. After the build: a fresh-context `watch-design-reviewer` pass on the built Free and the built Pro. Fix material findings. State plainly "no detector ran; judged from source and simulator screenshots".

Per-face starting hooks (ideas for the mockups, not orders):

| Face | Constraint that shapes it | Hooks to explore |
|---|---|---|
| DaysToGo | 96 KB, no bitmaps, primitives and fonts only; countdown buyers want the minimum | The number as the whole face at maximum size in the accent; ring as a bezel sweep; event glyphs as a tintable icon font subset if a memory test allows; one alternate layout for Pro |
| TwoSuns | 4.2+, bitmaps allowed; Body Battery: no verdict | Thicker full-bleed sun ring; curve as a banded fill; bigger time; accent-keyed, never value-keyed |
| HeroFace | 96 KB, primitives; game-coach voice, gold/blue/green roles | Bolder rings and bars; oversized time; a confident streak mark; Free and Pro differ by density only |
| HeroSet | App, five buttons, sweaty glance | Bolder rank/XP presentation; accent for the effort role only; big count during a set |
| DayArc | Already built | Only the reviewer pass, and aligning its accent roster to the family (WP3) |

Done when (per face): approved mockups (Free and Pro), design ADR, updated `DESIGN.md`, reviewer report addressed.

### WP3. DayArc pair, the launch pilot (≈3 h agent, mostly gates)

Goal: ship DayArc and DayArc Pro as the first ladder. The build exists; this package makes it releasable and aligned.

Depends on: the other session's uncommitted work being committed or handed over.

1. **Resolve the two flagged conflicts (OD7):** write DayArc's missing ADR-014 (accent setting) and mark ADR-011 (no settings surface, either density) superseded by it; fix `CLAUDE.md`'s "No settings surface" wording.
2. **Align the accent roster (optional, recommended):** DayArc lists Auto, cyan, amber, rose, green, blue, purple; the family roster is Sky, Mint, Amber, Pink, Violet, White (Free) plus six (Pro). Proposal: Auto stays; Free = Auto + the six; Pro = Auto + the eligible set; separate `settings.xml` per tier (move it out of the shared `resources/`, same tier-only-folder rule as section 1; today one file serves both jungles). Owner decides; not blocking.
3. Run `tools/compile_sweep.sh` (69 products, both jungles) and `tools/run_tests.sh fr965` on both jungles after the merge.
4. Run `watch-design-reviewer` on the built version (ADR-013 says it has never run).
5. Owner: look approval of the actual render (gate 4 in `docs/status.md`), icons and covers, the trademark search, names, price (ADR-007 says $1.99; D6 recommends $3.00 for Pro), the night-window default (ADR-010).
6. Listing: `listing/` (DayArc) and `listing-pro/` (DayArc Pro) already exist. Apply the D8 pattern: sibling store URL on the first line of each, review request in the free text, honest device note, "More from Verden" block with the live free siblings.
7. Site: `day-arc` and `day-arc-pro` pages exist as two slugs. Keep both; add cross-links. Do not merge slugs (published URLs).
8. Submission is the owner's. Upload order: Free first, Pro the same day.

Done when: the DayArc `docs/status.md` gates are green or explicitly open with an owner name, and G-measurement (WP9) has both app ids.

### WP4. DaysToGo Free, the retrofit pilot (≈10 h agent + Garmin review cycles)

Goal: a free Days To Go on 120 products (33 of which the paid listing can never reach), and the existing paid listing becomes "Days To Go Pro".

Depends on: WP0 (OD1–OD4), WP2 (approved DaysToGo mockups), WP1.

0. **Spike first (≈1 h, do this before any retrofit).** Nothing in the repo proves that a second `settings.xml` in a later resource folder *replaces* the first (as strings do) rather than being merged or rejected; DayArc shares one settings file across both jungles, so it never tested this. Avoid the question by using tier-only folders (section 1), then prove the Free build ships no Pro keys **from what the compiler produced**: build the Free `.iq` (`monkeyc -e -r -f monkey.free.jungle ...`), unzip it, and inspect the settings it contains (or load the Free `.prg` in the simulator and open its application-settings editor). Record which method works in `DaysToGo/docs/development.md`. If neither can be automated, the check becomes an owner step on the store build.
1. **Spec first (`watch-pm`).** Update `DaysToGo/docs/spec.md` with the Free/Pro table (strategy report D2). Commission `anthropic-skills:deep-research` on the one open question: which Pro headline do countdown buyers pay for (multiple countdowns is a v1 non-goal; count-up from a start date; a progress ring)? Cite sources; if none is validated, ship Pro v1 as the shipped extras only and say Pro is thin.
2. **Files.**
   - New: `DaysToGo/manifest.free.xml` (copy of `manifest.xml`, new app id, same 120 products, `minApiLevel` 3.0.0, no permissions), `DaysToGo/monkey.free.jungle`, `DaysToGo/resources-free/` (AppName "Days To Go"; settings XML without Pro keys), `DaysToGo/listing-free/`.
   - Edit: `resources/strings/strings.xml` AppName → "Days To Go Pro" (Pro); annotate Pro-only code `(:pro)` (timed-event hour handling, footer line, alternate layout); extend accents (WP1; the palette array is shared, only the settings lists differ by tier); move settings into `resources-pro/`; `docs/decisions.md` (ladder ADR, from WP0), `spec.md`, `plan.md`, `compatibility.md`, `CHANGELOG.md` (two entries: Free 1.0.0, Pro 1.1.0), `tools/run_tests.sh` gains a jungle argument.
3. **Free settings:** Event, Name, Month, Day, Year, Unit (days or weeks), Date style, Accent (ids 0–5). Pro adds: Hour (timed events, which turn the count into H:MM under 24 h), Footer (battery or steps), Accent 6–11, and the new layout choice.
4. Free properties file defines only Free keys; Config returns defaults for Pro keys.
5. **Tests** as section 1, plus: the Free jungle with `Unit` unset counts calendar days correctly (the existing 43 tests run against both jungles).
6. **Listing.** `listing-free/paste.md` in the store form's field order. Title budget (50 chars): Free "Days To Go: Countdown to a Date" (check store-collision in the browser first); Pro "Days To Go Pro: Countdown, Hours, Footer". First line: the sibling's store URL. Sibling block: live free faces only. Device sentence: "Pro is sold only on devices Garmin lists for paid apps; this free version also runs on older watches such as FR245 and vívoactive 4." (verify against the free listing's real device list after approval.)
7. **Site:** WP8.
8. Owner: names, price tier for Pro, look approval, machine translations, upload Free 1.0.0 (new app) and Pro 1.1.0 (existing id) together.

Done when: definition of done in section 1 is green, both `.iq` packages exist, docs updated, and the owner has the upload checklist.

### WP5. TwoSuns Free (≈10 h) — gated on G1 from WP4

Goal: Free Two Suns with no location and no history permission; existing listing becomes Two Suns Pro at the intended price tier.

1. **Fix the price tier first:** the store shows $2.25. The owner picks the tier in the next upload (D6).
2. **Free promise:** time, 24-hour sun ring from Garmin's own sunrise/sunset (Complications), today's Body Battery from a complication, accent ids 0–5. Manifest: `ComplicationSubscriber` only.
3. **Pro adds:** 24-hour energy curve (`SensorHistory`), golden hour and tomorrow's sun (`Positioning` and the remembered place), ring orientation, date row, accent ids 6–11.
4. **Known design question (for `watch-design-lead` and `watch-pm`):** Free's Body Battery has no history, so the "stale reading" state (newest sample more than an hour old) may not exist. Decide what Free shows when the complication is null; use words, never blank. ADR.
5. Split the code: `TwoSunsSources` is the only class that touches the watch; annotate `(:pro)` its history and location paths and everything downstream.
6. Same file conventions, tests (124 today must pass in both jungles or be annotated), packaging, listing (`listing-free/`), site.
7. **Do not hold the prepared 1.0.1 hostage to this wave.** The owner was holding it until 1.0.0's review concluded, and 1.0.0 is now approved. Submitting 1.0.1 (existing app id) is an owner call that can happen any time; this package then delivers Pro 1.1.0 (accents, tier fix, rename) and Free 1.0.0 together.

Done when: as WP4. Owner gates: names, price, permissions (Free has fewer, Pro unchanged: adding none to Pro), upload.

### WP6. HeroFace Free (≈10 h) — gated on the HeroSet/HeroFace 30-day readout and G1

Goal: Free HeroFace on 117 products (33 free-only) that keeps HeroSet mode, the funnel to HeroSet.

1. Free: Everyday mode and HeroSet mode, slots fixed to Auto, accent ids {0,3,4,5,6,7}. Pro: choose the metric per slot, seconds, weather, accent ids 0–11, the alternate layout.
2. Smallest memory budget 96 KB: verify with the simulator after each addition; primitives and fonts only.
3. HeroSet mode requires HeroSet installed: the Free description says so in one line and links HeroSet (and HeroSet Free when it exists). The complication link is unchanged (HeroSet ADR-044, the complication contract). No change to field order.
4. HeroFace has no tools folder: create `tools/run_tests.sh` (copy DayArc's) and `tools/compile_sweep.sh` for both jungles.
5. Rename the paid listing "HeroFace Pro" **inside the listing repair submission** the exposure-test plan already requires, so it costs no extra review. Keep device tokens in the Pro title as that plan says.
6. Everything else as WP4.

Done when: as WP4, plus the exposure-test day-0/day-30 dates recorded so the ratio is still readable.

### WP7. HeroSet Free (≈16 h) — gated on the accuracy proof

Goal: a free push-up counter that proves the counting, and HeroSet Pro for the rest.

1. **Gate:** research stage 1b passed: HeroSet beats the native counter on the same sets (3×10 reps per exercise at slow, medium, fast, plus one 30+ rep set, hand-counted, FR965). If not, stop and fix the detector. No Free listing before this.
2. **ADR-044 review (complication contract):** a Free build publishes either nothing or the fixed field order with zeros for the locked exercises. Decide and record in HeroSet `docs/decisions.md` and HeroFace in the same commit.
3. Free: push-ups only, correct the count, save the set, daily goal fixed at the default. Pro: sit-ups, squats, goals 10–500, XP/rank/streak, glance, HeroFace link. Confirm against `PRODUCT.md` principles.
4. The store build today declares `Sensor` + `ComplicationPublisher`. Free can drop the publisher permission if it does not publish.
5. HeroSet accent: `watch-design-lead` decides whether the effort role becomes selectable; gold and green stay fixed roles.
6. Keep the title tokens that earn today's search rank (rep counter, push-up, sit-up, squat, bodyweight): Free "HeroSet: Push-Up Rep Counter", Pro "HeroSet Pro: Push-Up, Sit-Up, Squat Counter". Category 277 (Strength Training) for both, per the listing-repair plan.
7. Files and conventions as section 1; HeroSet has 15 `resources-*` language folders: add a Free override only for AppName and the settings/menu strings that differ.

Done when: as WP4, plus the validation log has the accuracy evidence and the release contract is amended only if HeroSet won.

### WP8. Site (≈2 h per product, no deploy without the owner)

The site models one page per app (`site/src/apps/<slug>`); URLs are published and never change.

1. Add an optional `freeStoreUrl?: string` to `site/src/apps/types.ts` beside `storeUrl`. `storeUrl` stays the Pro (existing) link.
2. On each existing app page, add a "Free or Pro" section: one small table (what Free has, what Pro adds) and two store buttons. Reuse the same support and privacy pages for the Free listing; the Free store listing points to the existing support and privacy URLs.
3. Do not create Free slugs for retrofits. DayArc keeps its two slugs.
4. Update each page's claims against the project's `docs/release-contract.md`. **Privacy and support pages must be written per tier**: the Free listing shares the URL, so each statement says which listing it describes. Example: TwoSuns Pro stores a place rounded to 0.1 degree; TwoSuns Free stores nothing and asks for no location. A privacy page that describes storage the Free build does not do (or hides storage Pro does) is a false claim (guideline 4a). Device counts: say "N in the store today, see Compatible Devices" or link, not a raw number (Garmin's list is "subject to change").
5. The studio home summary lines: Pro is the paid one, Free is free. Keep "no analytics, zero client JS".
6. Owner deploys (`npm run deploy` in `site/`).

### WP9. Measurement (≈2 h setup, ≈10 min per week)

1. One reader script at the repo root: `tools/store_poll.py` (new). Input: a list of app ids. For each, GET `https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/<id>?countryCode=US`;
   append one CSV row per day to `research_notes/Free and Pro ladder/poll.csv`: date, id, `downloadCount`, `reviewCount`, `averageRating`, count of `compatibleDeviceTypeIds`, `latestExternalVersion`, price.
   The description text sits under `appLocalizations[].description`. Ids: the ten listings (HeroSet, HeroFace, DaysToGo, TwoSuns, DayArc, and each Free as it appears).
2. The dashboard (owner) gives installs and sales; record monthly.
3. After each Free approval, record `compatibleDeviceTypeIds` for Free vs Pro: that is the true free-only reach, replacing the 33 estimate.
4. Read gates G1–G4 (section 2) and write the result in the strategy report's "Corrections and conflicts" style: measured, inferred, unverified. Never turn download buckets into revenue.
5. A monthly firmware check (existing rule): a native accuracy improvement would remove HeroSet's reason to exist.

### WP10. Listing kit (≈1 h once, reused)

A template `research_notes/Free and Pro ladder/listing_template.md` with placeholders; every twin's listing follows it. Field order follows the store form (each project's `listing/paste.md` shows it).

The template also fills **Additional Hardware Requirements (Optional)** with the site link as the bare URL `https://verden.watch/<slug>/` (owner, 2026-10-02: other apps use the field this way; the API field is a URL, so no sentence, research 2026-10-04; not a documented Garmin rule; see `research_notes/Free and Pro ladder/garmin_rules.md`).

Free description skeleton:

1. Line 1: `Get <Name> Pro: <store URL>` (only if the Pro is offered on the reader's device: say so on line 2).
2. Line 2: the one-sentence promise, plainly. Nothing implied.
3. Short "What Free has" list (concrete: fields, accent choices, always-on).
4. "Pro adds" list, same words as the Pro listing. One line about devices Pro cannot be bought on.
5. A one-sentence review request.
6. "More from Verden": 3–4 sibling free store URLs.
7. Permissions in plain words; "Nothing leaves your watch." only if it is still true.

Pro description skeleton: Line 1 `Try free first: <store URL>`; then Pro's promise, what it adds, device list note, support line, sibling block.
Both: cumulative What's New; support route `hello@verden.watch`; localise into the 15 languages in a separate submission after first approval; screenshots honest per tier; claims checked against `release-contract.md`.

## 4. Order of work at a glance

```
Wave 0   WP0 ---------------------------------------------┐
Wave 1   WP1+WP2(DaysToGo) → WP4   WP3 (DayArc)   WP8  WP9 ├─ G1 (30 d) → G2 (60 d)
Wave 2                        WP5 (TwoSuns)   WP6 (HeroFace, after exposure readout)
Wave 3                        WP7 (HeroSet, after accuracy proof + ADR-044 review)
```

## 5. Briefs for the two skills (binding; paste into the invocation)

The three directives are the owner's instructions of 2026-09-28; the ladder mechanics in the briefs are the plan's proposal until the owner signs off (OD1/OD2). The kit lives in a separate repo (`~/dev/watch-design-kit`); this repo carries the directives in
its root `CLAUDE.md` ("Studio direction") so both skills see them on every run, and the generic parts are also written into the kit (5c).

### 5a. Brief to `watch-design-lead`

> **Studio direction (owner, 2026-09-28).**
> 1. **Every face has a customisable accent colour, and it is in the free tier.** Start from the family candidate roster in `research_notes/Free and Pro ladder/accent_roster.md` (Sky, Mint, Amber, Pink, Violet, White, then Cyan, Lime, Yellow, Orange, Coral, Magenta), but **each face admits only the colours that do not collide with its own roles** (HeroFace: gold, green, alert red, white, and its ≥3:1-on-track rule; TwoSuns: golden hour #FF5500). Lists only. Append-only ids. Check every colour for 64-colour safety, 3:1 on black, dimmed-form 3:1, no collision with the muted grey or a reserved role colour. Amber, orange, coral and red are never a default on Body Battery, stress or sleep faces.
> 2. **Design more daringly.** The owner called earlier looks "boring and far too plain". Daring means decisiveness, not more. One signature move per face, at full commitment: an oversized hero read, saturated category-keyed colour on true black, real icons in a fixed hue per icon type, bold type-size contrast. A colour is allowed to be bold only if it would be the same whatever the number is. No extra fields because they are available. Restraint remains the rule for what is *on* the face; boldness is the rule for *how* it is drawn.
> 3. **Design the Free build first.** Free is the store screenshot and the first impression; Pro adds density and modes on top and must never be the only version that looks good. Free never shows locked items, in the face or in the settings list.
> 4. **Constraints you must respect:** 96 KB faces (HeroFace, DaysToGo) have no bitmap budget: primitives and fonts, or a measured icon-font subset. 4.2+ faces may use pre-coloured bitmaps as DayArc does. AMOLED always-on: under 10% luminance, no pixel lit three minutes, dim and drift. Round safe zones by `getObscurityFlags()`. Settings screens and the on-watch Customize menu are held to the same craft bar as the face.
> 5. **Process:** HTML/SVG mockup, screenshot-verified in a real browser, for Free and for Pro, on round and (where supported) rectangular, before any Monkey C. Owner approves the look. Record a design ADR. Fresh-context `watch-design-reviewer` after the build. Say plainly when no detector ran and that the simulator is not device proof.
> 6. **Deliver per face:** updated `DESIGN.md` (Free and Pro deltas), accent id table, design ADR, the list of open owner decisions (identity, icons).

### 5b. Brief to `watch-pm`

> **Studio direction (owner, 2026-09-28).**
> 1. **Every face ships as Free + Pro.** The live paid app id is the Pro. The Free is a new app id with the clean name. Nothing is ever flipped to free, and the day-45 flip rule in DaysToGo and TwoSuns is retired (new ADR each). Apps too where possible; HeroSet is gated on the accuracy proof.
> 2. **Spec the split** per product with the six rules in `reports/Free and Pro ladder.md` D2: Free delivers the whole promise honestly; no locked items visible; Pro additive; Free must be beautiful; permissions only shrink in Free; upgrade talk only in the store text and site.
> 3. **Pricing is the owner's call.** Provide the input: the recommendation in D6 with its evidence (top-30 paid price mix, break-even 59 → 39 sales, base-case +15%, elasticity assumed), and record the decision as an ADR including that there is no flip rule. Ask Garmin whether repricing an approved app removes it before any live repricing.
> 4. **Commission the open research** with `anthropic-skills:deep-research`: which Pro headline countdown buyers pay for (DaysToGo); whether the Free tier of each face can stand alone on reviews (check rival free faces' complaints). File under `research_notes/`.
> 5. **Gate discipline:** add to each project's `docs/status.md` a Free-listing block and keep the "Never decide alone" list (names, price, identity, privacy-cost permissions, uploads, device tests, site deploys, machine translations).
> 6. **Listings:** write both tiers' store text from the template (WP10), sibling store URL first, honest device note, review request, "More from Verden", cumulative What's New; check every claim against `release-contract.md`.
> 7. **Measure:** own gates G1–G4 (section 2) and the monthly readout (WP9). Distinguish measured, inferred, assumed.

### 5c. Passed into the kit itself

Because the owner asked for the direction to reach both skills, the **generic** parts are now written into the kit (`~/dev/watch-design-kit`, a separate
repo with its own uncommitted changes; nothing committed or staged by this work):

- `skills/watch-design-lead/SKILL.md` craft bar: "Bold is not more", "Design the free tier first", and "An accent is checked against the face's own roles, not just against black".
- `skills/watch-pm/SKILL.md` Pricing: a "Free/Pro ladder" subsection with the six split rules, the break-even arithmetic and the gates.

The studio specifics (the roster, Verden's directives, the pilots) stay in this repo: the root `CLAUDE.md` "Studio direction" block and sections 5a and 5b above.

## 6. Status tracker (update as work lands)

| WP | Item | State |
|---|---|---|
| WP0 | Owner decisions OD1–OD8 | open |
| WP0 | Garmin email sent | open |
| WP0 | Flip reminders retired (ADR in DaysToGo and TwoSuns) | open (a reminder, nothing flips by itself; earliest possible review date is about 2026-11-10, so do it in October) |
| WP1 | Accent tables: HeroFace, DaysToGo, TwoSuns | open |
| WP2 | Daring mockups: DaysToGo | open |
| WP3 | DayArc pair releasable | blocked on the other session + owner look-approval |
| WP4 | DaysToGo Free + Pro 1.1.0 | built 2026-10-01, unreleased (see START HERE tracker) |
| WP5 | TwoSuns Free | built 2026-10-01, unreleased (see START HERE tracker) |
| WP6 | HeroFace Free | built 2026-10-01, unreleased (see START HERE tracker) |
| WP7 | HeroSet Free | gated (accuracy proof + ADR-044 review) |
| WP8 | Site | open |
| WP9 | `tools/store_poll.py` + CSV | script written 2026-10-04 (tested offline against a fixture); no weekly polling has started |
| WP10 | Listing template | written 2026-10-04: [`listing-template.md`](listing-template.md) (this folder), not in `research_notes/` |
