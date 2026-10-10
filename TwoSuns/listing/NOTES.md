# Two Suns listing — notes

What sits behind [`paste.md`](paste.md), the paste-ready copy. Nothing here is pasted into the form. Claims and gates: [`../docs/spec.md`](../docs/spec.md) ("Claims that may be made") and [`../docs/release-contract.md`](../docs/release-contract.md). Release history: [`../CHANGELOG.md`](../CHANGELOG.md) (an entry is due with every store publication: version, upload date, user-facing changes, ADRs; the previous What's New block then moves here, and the App Version field is bumped).

Written 2026-09-26 (plan phase 8); text finalised 2026-09-27 (name, category, price, "collects user data" all confirmed by the owner; see the table below). **No screenshot of the face exists** (the environment that wrote this cannot capture the simulator; the owner will supply images later). Two device checks have run on the owner's FR965 (sunrise/sunset match, Positioning); nothing else has run on a watch. The site pages are written and build in a scratch copy; they are not deployed.

**Description style (owner, 2026-09-27):** the description is about what the app IS, not how to use it — cut step-by-step settings instructions and adaptation-behaviour detail to one line each. Applied here; also applied to the other three apps' listing docs (`../../DaysToGo/listing/`, `../../HeroFace/listing/`, `../../HeroSet/listing/`) for consistency, without resubmitting anything already live.

**No Keywords field.** The Connect IQ upload form has no keywords/tags field. The README no longer carries one; neither do HeroSet's or HeroFace's (they never did). Removed from Days To Go's too.

**What's New, initial release:** left blank in the README, not "First release." — there is no field asking for that text, and it reads as noise on a first listing. (The sibling apps' 1.0.0 entries did say "First release."; that is their submitted history and is not being changed. This is the rule going forward.)

**What's New, 1.0.1 (prepared 2026-09-28, not yet submitted):** "Small refinement to the Body Battery level indicator." — covers the defensive glyph-fill fix, `../docs/decisions.md` ADR-017's 2026-09-28 amendment. 1.0.0 had no What's New block to move here (it was blank, the initial release). App Version bumped 1.0.0 → 1.0.1 in this README.

## Open owner decisions

| # | Decision | State | What to do |
|---|---|---|---|
| 1 | **Name** | **Decided 2026-09-27: "Two Suns"** (ADR-010). No trademark search done | "Body Battery" is Garmin's trademark and stays out of the name, icon and description headers. A future rename would touch: README Title and description, `../resources/strings/strings.xml` (`AppName`) and its 14 translations, `site/src/apps/two-suns/facts.ts` (`appName`, the one constant), `site/src/apps/two-suns/app.ts` (title, summary use it), the token name "Two Suns Coral" (twosuns-coral) and its line in `site/DESIGN.md`, the Two Suns row in `site/CLAUDE.md`, the "Two Suns specifics" section of `site/README.md`, and the docs in `../docs/` and `../CHANGELOG.md`. The slug `two-suns` and the URLs `/two-suns/...` **never change once published** (store listings link them) |
| 2 | **Category** | **Decided 2026-09-27: Utility** | Spec D13's alternative, Health & Fitness, was not taken: the copy describes and never claims, so either would have been honest, but Utility fits a sun-and-light face better |
| 3 | **Price wording** | Price decided 2026-10-04: the $2.50 tier (ADR-026, price: the $2.50 tier for every paid app; first confirmed at USD 1.99 on 2026-09-27, spec D3, price superseded). Wording open | The description carries no price sentence (Days To Go's does not). Add one only if you want it. Never write "free" while paid; disclose any limited-time free period (review guideline 4d). No refund or return wording appears in listing text (owner decision, 2026-10-04). No price number in any listing text. Re-pricing an approved app can remove it for re-review, so the tier is set with the 1.1.0 version upload (re-reviewed anyway; Garmin email cancelled, policy research in ROADMAP 2.1). No day-45 review (retired, ADR-020). Read the form's own Monetization wording at submission |
| 4 | **Launcher icon** | Placeholder SVG (generic, 65×65) | Make a real one. Never use "Body Battery" or a Garmin mark in it. The exporter and the compiler print icon-scaling notices until then |
| 5 | **Screenshots, cover, hero, device icons** | **Re-rendered 2026-10-04 (simulator, canned data): five screens, cover, hero, both icons** | See [`screenshots.md`](screenshots.md). Cover/hero mark still a draft, not owner-approved — same status as the launcher icon placeholder |
| 6 | **The Positioning permission** | **Decided 2026-09-27: kept, confirmed on-device.** No longer provisional (ADR-005, `../device-test/LocationProbe-RESULTS.md`) | The description's permissions paragraph already names it; no change needed unless a later run (M3/M4, not yet done) reverses ADR-005 — see "If Positioning is dropped" below |
| 7 | **Look** | The owner has not approved the colours, glyph or layout | The listing describes the ring and curve in words, not colours (accent colour is a setting). Nothing here is fixed until the look is approved |
| 8 | **Site colour** | Dusk coral `#ff6f8f`, ink `#240a10` (7.0:1), recorded in `site/DESIGN.md` | Amber was HeroSet's field and blue was HeroFace's when this was picked; the face's own default accent has since (2026-09-27) changed from amber to sky blue — which is now literally the same hue as HeroFace's site field, so the site page still cannot use it. Mint is Days To Go's. Change `color`/`onColor` in `app.ts` and the two tokens in `DESIGN.md` if you prefer another hue |
| 9 | **Privacy "Effective" date** | 26 September 2026 (the writing date) | Change it to the deploy date if that is later (`Privacy.tsx`) |
| 10 | **Collects user data** | **Decided 2026-09-27: No** | Nothing leaves the watch and there is no network code, so No is true of what is sent. The face reads a location on the watch (and Body Battery) and keeps a rounded place there; the Connect IQ review guidelines ask for consent before collecting location, but that consent is the manifest's own permission prompt, not this field. If the store form's own wording turns out to cover data read or kept on the device (not just sent off it), revisit and answer Yes with https://verden.watch/two-suns/privacy/ |
| 11 | **Body Battery in the copy** | Used only to describe Garmin's feature; not in the Title, not in the tags | The Days To Go rule ("no brand names in tags") is applied; the search terms people use will not all be reachable without the words, so add "body battery" to the tags only if you accept that trade |
| 12 | **Translations** | Not fit-tested. `../tools/fit_languages.sh` was not run; no native reader has seen any of the 14 on-watch translations | Run `fit_languages.sh` and get a native read before shipping any language. Do the same for any translated store description: the store description is English only until you decide, and unread copy is not shipped |
| 13 | **"Deleted on removal" statement** | Removed from `Privacy.tsx` (it said the stored place and settings are deleted when you remove the face) | Never verified on a watch, so the page no longer says it. The page says only that the rounded place is kept in the app's own storage on the watch. Restore a removal sentence only after checking what a watch does with the app's storage on uninstall |
| 14 | **The `.iq` package** | Export overreports device count vs. the manifest (`../docs/compatibility.md#the-export-and-89-devices`) | Check the Compatible Devices the form shows before submitting |
| 15 | **Tier B** | Not built. 23 products, API 3.4 to 4.1, planned for 1.1 (spec D4) | Gated on the on-watch location probes: it has no Complications, so sun times need a calculation and a location. Nothing on any page or in the listing mentions it |

## If Positioning is dropped (the one line to change)

Spec D7: if the on-watch probe without Positioning still gets a location from an activity or the weather, the permission is dropped and the listing says so. Places that state the current truth (Positioning declared) and must change together, in the same session:

1. `../listing/paste.md` description, paragraph "Permissions, and your place": remove "and Positioning (the last location the watch already knows)", change to two permissions; say the location comes from the watch's activity or weather data if that is what the probe showed.
2. `site/src/apps/two-suns/facts.ts`: delete the `Positioning` entry of `permissions` (the privacy page's count and list follow).
3. `site/src/apps/two-suns/Privacy.tsx`: the "Location" section says the face "reads the last location your watch already knows"; reword to the source the probe proved. The "In short" count follows `permissions.length`.
4. `site/src/apps/two-suns/Landing.tsx` (fact "Your place stays on the watch") and `Support.tsx` ("No place yet") describe the place, not the permission, and normally stay as they are.
5. The manifest, the manifest comment, `../docs/spec.md` D7, and `TwoSunsSources.positionLocation` (delete the function and its entry: `Position.getInfo` without the permission kills the app).
6. Never state "no location permission" on any page while the manifest declares it.

## To be confirmed on a watch (not claimed anywhere)

- **The two ways to fix "No place yet".** Spec phase 8 calls them a GPS activity started once and discarded, and Garmin's Sunrise/Sunset widget or glance opened once. Neither has been seen to work. The support page words them as things to try ("Two things to try") and promises no outcome. If the device check shows one does not work, remove it from `Support.tsx` and from this list.
- **"Sunrise and sunset match your watch's own Sunrise/Sunset glance"** is NOT on any page or in the description. It needs the device compare (probe question Q4, plan phase 9). The support page only asks the reader to quote their own glance when writing in.
- **"Works without GPS or your phone"** is NOT on any page. It needs a run with both off. The support page says nothing about working without a phone; the description says only what the face stores and that it has no network access.
- Always-on behaviour (lit-pixel share, ghosting) is described as behaviour, with no measurement. Simulator passing is not device proof.
- The "~" in "Sunrise ~06:41" (today's sunrise used as an estimate for tomorrow when there is no place) is a simulator-tested behaviour.

## Description rules

- One box per language, 4000 characters, plain text: the store shows `**` and `>` literally and keeps every line break. The English description is **1729 characters** (the "Five settings" paragraph now mentions the on-watch Customize menu, ADR-019); the Title is 8 (limit 50). There is no Keywords field and no What's New field, so neither has a count.
- The first sentence carries the weight (the store truncates in list views); the last line is the support URL (the form has no support field).
- Describe, never claim. Forbidden until measured or proven: accuracy of the sun times or of Body Battery, "improves", "optimises", recovery or any health outcome or advice, battery figures, always-on ghosting, MIP contrast, any watch count or "works on X", any download or rating figure, anything about a rival by name, "free" while paid.
- Allowed and used: what the face shows; that Body Battery is Garmin's estimate; where sun times come from (the watch's own values, plus a calculation when there is a place); that the place is rounded to about 11 km, stays on the watch and is never sent (no network code, no Communications permission); the three permissions and why; the five settings.
- Permissions are disclosed in the description because the face reads a location (Connect IQ review guidelines: seek permission before collecting location or data that may be sensitive; no medical claims).

## Why each answer

| Field | Reason |
|---|---|
| Category | Owner decision 2 |
| Collects user data | Owner decision 10 |
| Monetization | No: the app does not ask for payment to enable features or for tips. Paid through the store as HeroFace, HeroSet and Days To Go are |
| Additional Hardware Requirements | Paste the bare URL `https://verden.watch/two-suns/` only (API field `hardwareProductUrl`, a URL; the old "No additional hardware needed..." sentence is retired, ROADMAP 10.16). Live value today: empty |
| Device claims | Pro covers only the Instinct E (40 and 45 mm) and Instinct 3 Solar, all on Garmin's paid-app list; the 69 other products are ordinary. Verified 2026-10-04 (ROADMAP 10.15). Listing text never names watch models; the store's device tab is the claim (owner, 2026-10-04). |
| Price | Owner decision 3; the $2.50 tier since 2026-10-04 (ADR-026), in the form only |
| Email | The studio inbox, `hello@verden.watch` |

## Languages

English plus 14 (dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr) exist as **on-watch strings** and are **machine-drafted, not read by a native speaker**. They were **never fit-tested in any language on any screen** (the implementation notes record no fit test of any translation; `../tools/fit_languages.sh` exists: run it before shipping any). The sentences with no shorter form ("No place yet", "No sun data", "Sun is up") are kept to 14 characters or fewer by `../tools/check_strings.py`. The store description is English only until the owner decides whether to translate it; store copy that no native speaker has read is not shipped. The site says "machine-drafted and not yet read by native speakers". Russian, Greek and Chinese are not included.

## Open item: the .iq package

Export overreports device count vs. the manifest — full investigation in [`../docs/compatibility.md`](../docs/compatibility.md#the-export-and-89-devices). Check the Compatible Devices the form shows before submitting: that list is authoritative. The store's list is shorter than the manifest's (paid apps are sold only on Garmin's own list), so no watch count appears anywhere.

## Site pages

`site/src/apps/two-suns/` (landing, support, privacy) staged in the same session; deploy is the owner's (`npm run deploy` in `site/`). Store URL is unset: the pages say "Coming soon to the Connect IQ Store". After approval: set `storeUrl` in `app.ts`, update this folder and the root README. Landing and store copy must agree with this listing and the release contract.

- The landing page shows a **drawing** of the face (`FacePreview.tsx`, SVG primitives, example numbers 10:42, 64, "8:41 of daylight"), captioned "A drawing of the face by day, with example numbers. Not a screenshot." It is a schematic of the layout in the code, not an approved look. Delete it and use `Screens` with real captures when they exist.
- **Resolved 2026-10-10 (site SEO pass): faces now get `LifestyleApplication`.** The shared JSON-LD in `src/entry-server.tsx` gave every app `applicationCategory: HealthApplication`. That is site-wide, unchanged here, but it reads as a health label on this app's page. Make the category per-app (`App` type change) or neutral before deploy.
- **Resolved 2026-10-10 (site SEO pass): `intro` now names no app.** The studio home line in `src/site.ts` (`intro`) named the other three apps and not this one; left unchanged so the working name is spelled in one place. Add a sentence when the name is settled.
- The studio mark and `public/favicon.svg` grow one bar per app in the shell automatically; the favicon file is edited by hand if wanted.

## Images

**Rendered 2026-10-04** from the current Pro build in the simulator (five screens, one an Instinct E 45 mm, cover, hero, both device icons); canned data, the owner has not approved the looks. The weather and watch-battery rows are off in every shot (ADR-022/023: no claim before the wrist check; the simulator's weather is canned). The "PRO" pill and golden arcs that tell Pro from Free are a proposal. See [`screenshots.md`](screenshots.md).

## Previous What's New blocks

- **1.2.0** (uploaded 2026-10-08, live by 2026-10-09):

```text
- Rectangular watches get a design of their own: the sun ring becomes a track along the edges of the screen, and the time grows into the room inside it.
- The Weather and Watch battery rows are off until you switch them on in the settings.
- The Body Battery number keeps one colour at any level; it no longer dims when the level is low. A reading over an hour old still turns grey.
- With no Body Battery number, the two dashes are grey like the hollow bolt beside them, and a single reading no longer shows as a lone dot.
- With the energy curve on, nothing moves when the curve first appears or runs out: the bolt and the number keep their place at its left.
- The energy curve is a plain white line, and the Body Battery bolt is solid.
- Daylight reads in hours and minutes, such as "3h 42m of daylight", so it no longer looks like a clock time.
```

- **1.1.0** (uploaded 2026-10-04, in review): `The app is now called Two Suns Pro on the watch. New: optional Weather and Watch battery rows, switched on in the settings. A lighter Two Suns, with the sun ring and your Body Battery number, is also available.`
- **1.0.1 (prepared, not submitted; ROADMAP 4.1 is the owner's call):** `Small refinement to the Body Battery level indicator.` Use it with the 1.0.1 package if the owner uploads 1.0.1 before 1.1.0.
- **1.0.0:** blank (initial release).

## Pro 1.2.1: what `paste.md` now holds (prepared 2026-10-10, not uploaded)

- **Version** `1.2.1`, a fix release: the Out Of Memory crash on the three Instinct products (`../CHANGELOG.md` "Pro 1.2.1"). Description, images and price unchanged from 1.2.0. The What's New says "running out of memory", not "crash", and names only the watches the simulator showed it on; simulator only, not seen on a watch.

## Pro 1.2.0: what `paste.md` held (uploaded 2026-10-08)

- **Version** `1.2.0` (next minor; App Version is free text in the form, the manifest carries none). It can go up while 1.1.0 is still in review (`../../research_notes/Free and Pro ladder/garmin_rules.md`).
- **What's New** lists the user-facing changes of `../CHANGELOG.md` "Pro 1.2.0": the rectangles' own design (ADR-028 (rectangles: the sky ring follows the screen)), the Weather and Watch battery rows off until switched on (named as switches only, release contract), the Body Battery number in one colour at any level (ADR-008 (no verdicts on Body Battery), amended), the grey `--` and no lone dot (ADR-028 amendment), the curve's room (ADR-028 second amendment), the white curve line and solid bolt, the daylight wording. Left out: the compact weather row's change (it describes what the row shows, which waits for the wrist check, release contract) and the always-on grey (already in 1.1.0, ADR-027). No watch model, no language, no price, no "free".
- **Description fixed for the new build (upload gate of 2026-10-08):** "A thin ring around the bezel" is now "A thin ring along the edge of the screen"; "One face, every screen / Fits round and rectangular watches alike" is now "Every screen, its own fit", the ring named by screen type (around the bezel, a track along the glass, a small dial in a black-and-white screen's round window), as Days To Go 1.2.0 did. Spanish and Chinese mirrored in `paste-translations.md`. The matching site wording is a separate, held-back commit (deploy after Garmin approves).

## Pro 1.1.0: what `paste.md` held (uploaded 2026-10-04, accepted under ADR-020 (Free + Pro ladder); moved from a draft here, 2026-10-04)

`paste.md` is the 1.1.0 text. Names are confirmed (2026-10-04); the sibling URL is the owner's; the price is the $2.50 tier (ADR-026), set in the form.

- **Title**: `Two Suns Pro` (placeholder; the owner decides and may add device or feature tokens within the 50 characters).
- **Line 1:** `Also available: Two Suns, a lighter version: <URL>` (no "free" wording in the paid listing: release contract). The description otherwise describes only what Pro has (the curve, the place-based sun, golden hour, the date, ring orientation, six accents).
- **Edits against the release contract:** "Five settings" became "Settings" (the 1.1.0 build also has Weather and Battery switches, so a count would be false); "full detail down to the smallest" was dropped (a fit-test claim the contract does not list); no Instinct or other model sentence is in the text (owner, 2026-10-04; the former `meta.yaml` `held_back_text` sentence, "Fits round and rectangular watches alike, and on the Instinct E and Instinct 3 Solar it is black and white with the ring as a small 24-hour dial in the round window", is deleted).
- **Not described, on purpose:** the weather row (needs the wrist check, status F12, and the contract's wording rule: Garmin's cached weather, never "live" or "forecast accuracy") and the watch battery row (ADR-023, simulator only). Add a sentence after F12 passes; the owner decides.
- **Version** `1.1.0`; the What's New is the rename line.
- No device sentence in the Pro text (it would name the free app, which the paid listing may not).
- The price is **not** in this file (ADR-026: the $2.50 tier, set in the form with the 1.1.0 upload; the store showed $2.25 against the documented $1.99). Re-pricing an approved app can remove it for re-review (SDK `Monetization/App_Sales`); shipping it with the version upload covers that.
- The Pro privacy wording is unchanged (the place, `Positioning`, Body Battery history); the Free listing's differs (`../listing-free/NOTES.md`).
- "More from Verden" is left out: it lists only live free siblings, none live today.

## 2026-10-04: what moved out of `paste.md` (owner rule: paste.md holds only what is pasted or uploaded)

- **Form:** https://apps.garmin.com/developer/upload; two steps, attach the `.iq`, then the details. One block is one field. Status, version, package, limits and assets are in [`meta.yaml`](meta.yaml); the approvals the owner owes are in its `owner_approvals`.
- **Title:** "Two Suns Pro" is a placeholder the owner decides; device or feature tokens may be added within 50 characters.
- **Description:** line 1 holds the sibling's store URL (filled 2026-10-04; the link works once Garmin approves that listing). Languages are added one at a time (pick a language, press Add, fill Title + Description); only English is drafted, see "Languages" above. The description never uses the word "free" (it is paid; release contract, store review guideline 4d). The refund sentence ("Two Suns Pro is a paid app. Refunds follow the Connect IQ Store return window.") is removed.
- **Version:** the form reads it from the package; if a field asks, type it. paste.md is the 1.1.0 text (the Pro rename); the prepared 1.0.1 What's New is in "Previous What's New blocks" above.
- **Collects user data:** No (owner, confirmed 2026-09-27). Nothing leaves the watch: no network code, no Communications permission. The face reads a location on the watch and keeps a rounded place there, never sent: see owner decision 10 above. The privacy-policy URL field is conditional on Yes, so it may not appear; the policy is https://verden.watch/two-suns/privacy/ regardless.
- **Category:** Utility (alternative: Health & Fitness). **Subcategory:** whatever the Category choice offers. **Preview Video:** none (YouTube or Vimeo only).
- **Monetization:** No (same wording reading as Days To Go: Yes only if the app asks for payment to enable features, or for tips or donations; it does neither). Paid through the store; the price tier is the $2.50 tier (owner, 2026-10-04, ADR-026 (price: the $2.50 tier for every paid app); set in the form with the 1.1.0 upload, replacing the $2.25 the store showed).
- **Hardware field:** the bare URL only; the store API names it `hardwareProductUrl`, and a live listing's value is a bare URL (owner, 2026-10-02; Garmin research 2026-10-04).
- **Images:** the owner approves the looks first; all simulator only with canned data (sun times, curve and number are set for the picture, never a reading; the weather row and the watch battery row are switched off in them); the hero is 151 KB and the cover 13 KB, both on a violet ground since 2026-10-04; the "PRO" pill and the golden arcs are a proposal for telling this listing from its lighter sibling. Captions and devices are in `meta.yaml` `assets.screens` (no caption field in the form); details and commands in [`screenshots.md`](screenshots.md). Do not describe the black-and-white shot as a supported-device claim.

## 2026-10-04: cover and hero on a coloured ground (ROADMAP 10.25)

Garmin's brand page: "Do not choose black or transparent backgrounds"; the owner chose light or coloured covers. Chosen for Pro: **violet `#AA55FF` ground, navy name, white "Suns", larger orange PRO pill** (the pair is Free sky-blue, Pro violet; golden-hour orange stays Pro's). Looked at at 500 px and at 100 px. Rejected, rendered and looked at:

- **Amber `#FFAA00` ground** (Pro, sun colour): white "Suns" only 1.9:1 on it, the brown night arc went muddy, the orange golden arcs nearly vanished. 
- **Pale cream `#FFEFD9` ground** with the ring in full face colours: truest to the face, but weak presence at 100 px and the pill/arcs are the only thing that tells it from Free's pale-blue twin.
- **Deeper violet `#7A3CE0`** with white text: strong, but not a palette value (the Violet accent is `#AA55FF`) and noticeably darker.

Open for the owner: the look (colour, the pill size), and whether the device icons should also go off black (left alone: Garmin's sentence is about the cover, and the icon carries no text).

## Instinct image, black and white only (2026-10-08)

`screens-framed/4-instinct-e45.png` (instincte45mm): re-framed 2026-10-08 (99 KB, under the 150 KB cap): the Instinct E skin's display hole carries a ghost of Garmin's sample screen at alpha 1 to 25 of 255, which the framing composited over the black screen as faint grey marks (inside the dial and under the sun line); `docker/frame_shot.sh` now clears alpha under 10% inside the display rectangle (the opaque bezel and window rim stay). The capture `screens/4-instinct-e45.png` was checked: 176 x 176, pure black and white (2 colours), so nothing to snap. Only the faint marks went; the screen content is the same. The four round frames were not replaced (re-framing them changed only anti-aliased edge pixels).
