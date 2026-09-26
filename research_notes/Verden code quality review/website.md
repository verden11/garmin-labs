# Verden website (site/) — code quality and architecture review

Reviewed 2026-09-24, working tree as it stands (read-only). Paths are relative to `/Users/mbp/dev/garmin/`. "Source" links point at local files; `file:line` is the evidence. Evidence I ran myself: `npm run build` (dist/ and .ssr/ are git-ignored, `site/.gitignore:2-3`), `npx tsc --noEmit`, `npm outdated`, `npm ls`, `npm audit`, a headless Chrome screenshot of the built `/heroface/` page served locally, a contrast-ratio script (WCAG relative-luminance formula), and read-only `curl -I` requests to the live site.

**A correction to the brief:** only three site files are staged (`src/apps/heroset/Landing.tsx`, `Support.tsx`, `facts.ts`, per `git status --short -- site`). DESIGN.md, global.css and index.html have **no** staged or unstaged changes. Their latest changes are already committed in `8a40cb6 style: website UI`.

---

## Does `npm run build` succeed and emit every route? Does `tsc --noEmit` pass?

### Takeaway
Yes. The build passes and prerenders all 7 routes plus `404.html` as static HTML with no `<script>` tags. `tsc --noEmit` reports no errors (0.56 s, TypeScript 7.0.2). There are no hydration-mismatch risks, because nothing hydrates. I found no broken internal links, and no published URL changes in the working tree.

### Cited Findings
- `npm run build` exited 0 and printed `prerendered 7 pages + 404`. It emitted `dist/index.html`, `dist/heroset/{,support/,privacy/}index.html`, `dist/heroface/{,support/,privacy/}index.html` and `dist/404.html`. Client assets: CSS 14.55 kB (4.05 kB gzip) plus 3 Archivo woff2 subsets (latin 90 kB, latin-ext 86 kB, vietnamese 34 kB) — [package.json:7](site/package.json), [prerender.ts:13-16](site/prerender.ts)
- Routes come from the registry. For each app the table adds `/slug/`, `/slug/support/` and `/slug/privacy/`. The route table and the 404 fallback use `status: route ? 200 : 404` — [src/entry-server.tsx:11-24,30-42](site/src/entry-server.tsx)
- `grep -c '<script'` on every emitted HTML file returns 0, so the "zero client JS" rule holds — [site/CLAUDE.md:34](site/CLAUDE.md)
- The Vite build rewrites the font preload in index.html from the node_modules path to the hashed asset (`/assets/archivo-latin-wdth-normal-DY7AcnAa.woff2` in dist HTML) — [index.html:7](site/index.html)
- Every internal `href` in dist resolves to an emitted route or asset: `/`, `/heroset/`, `/heroset/support/`, `/heroset/privacy/`, and the same three for heroface. Nothing points elsewhere.
- Live: `https://verden.watch/heroset/support` (no slash) returns `301 → /heroset/support/`, and the slash URL returns 200. The trailing-slash URLs therefore hold (curl, 2026-09-24).
- Live `/robots.txt` and `/sitemap.xml` return 404 (curl).
- **Latent bug:** `fill()` uses `String.prototype.replace` with a string replacement, so a `$&`, `` $` `` or `$'` sequence in rendered page HTML would be expanded rather than inserted literally. No page contains one today (grep over src finds none) — [vite.config.ts:29-31](site/vite.config.ts). Fix: `template.replace('<!--head-->', () => page.head).replace('<!--body-->', () => page.body)`.
- `prerender.ts` imports `fill` from `vite.config.ts`, which loads the Vite config module (and `vite`) at prerender time. It works, but the coupling is odd — [prerender.ts:3](site/prerender.ts). Low priority. A 1-line `fill` could live in `entry-server.tsx` instead.
- Dev and prod differ: in dev, `/heroset/support` (no slash) renders 200 directly ([src/entry-server.tsx:31](site/src/entry-server.tsx)), while prod 301s. This is harmless.

### Inferences
- Published URLs are stable: the only route builders are the registry loop and the hard-coded hrefs, and none of the staged edits touch slugs or sections.
- The route string is built in 4+ places: [entry-server.tsx:21](site/src/entry-server.tsx), [AppPage.tsx:17,21](site/src/components/AppPage.tsx), [Home.tsx:21,26-28](site/src/pages/Home.tsx), [NotFound.tsx:14](site/src/pages/NotFound.tsx), plus hard-coded `/heroset/support/` in [heroset/Landing.tsx:32,84,117](site/src/apps/heroset/Landing.tsx) and `/heroface/…` in [heroface/Landing.tsx:28,70,111](site/src/apps/heroface/Landing.tsx). One `appUrl(app, section)` helper in `AppPage.tsx` would define the "never change a published URL" surface in exactly one place. The risk today is low, but this is cheap insurance.

### Gaps
- I did not test the dev server (`npm run dev`).
- I did not verify that the host serves `dist/404.html` with a real 404 status. `/robots.txt` on the live site returned the 404 page body with a 404 code, which suggests it does.

---

## Are there duplicated page structures between apps that a shared component should own?

### Takeaway
Yes. Four landing sections, the store button and three privacy-policy sections are copy-pasted between `apps/heroset/` and `apps/heroface/`, differing only in app object and data. With a third app coming (CLAUDE.md:3 "more apps come later"), they should move into one small shared file. The hero, the "truth" field and the Support FAQ are app-specific copy and should stay per-app.

### Cited Findings
- **`StoreAction`**: the two copies are identical apart from the app object — [heroset/Landing.tsx:6-10](site/src/apps/heroset/Landing.tsx), [heroface/Landing.tsx:5-9](site/src/apps/heroface/Landing.tsx)
- **"On the wrist." screens section**: identical apart from the app name in `alt` — [heroset/Landing.tsx:87-99](site/src/apps/heroset/Landing.tsx), [heroface/Landing.tsx:81-93](site/src/apps/heroface/Landing.tsx)
- **"N Garmin watches." section** (count, lede, family `<dl>`, languages aside): the same structure, only the lede differs — [heroset/Landing.tsx:101-110](site/src/apps/heroset/Landing.tsx), [heroface/Landing.tsx:95-104](site/src/apps/heroface/Landing.tsx)
- **Closing CTA field** (`section.field.close` with h2, StoreAction and support link): only the heading differs — [heroset/Landing.tsx:112-120](site/src/apps/heroset/Landing.tsx), [heroface/Landing.tsx:106-114](site/src/apps/heroface/Landing.tsx)
- **Privacy boilerplate**: the "In short" Note, Purchases, This website, and Changes and contact sections are word-for-word identical apart from the app name — [heroset/Privacy.tsx:7-10,27-40](site/src/apps/heroset/Privacy.tsx), [heroface/Privacy.tsx:7-10,42-55](site/src/apps/heroface/Privacy.tsx)
- The `languages` arrays are identical — [heroset/facts.ts:18-21](site/src/apps/heroset/facts.ts), [heroface/facts.ts:22-25](site/src/apps/heroface/facts.ts). Each one mirrors its own app's docs, so keeping two copies is defensible. Do not merge them.
- The field-theme style object is built twice — [AppPage.tsx:10](site/src/components/AppPage.tsx), [Home.tsx:17](site/src/pages/Home.tsx)
- App colors are hard-coded again inside the app folders instead of read from the registry: `#ffaa00` in [heroset/Mark.tsx:5,7](site/src/apps/heroset/Mark.tsx) and [heroface/FacePreview.tsx:7,24](site/src/apps/heroface/FacePreview.tsx), and `#55aaff` in [heroface/Mark.tsx:6,8](site/src/apps/heroface/Mark.tsx). These sit in app folders, so the DESIGN.md rule for shared components ([DESIGN.md:161,256](site/DESIGN.md)) is not broken. They are simply a second source of truth. The marks mirror the watch launcher icons (Mark.tsx:1 comment), so this is acceptable.
- Dead code: `const under = heroset ? 'STREAK 12' : 'STREAK 12'` has identical branches — [heroface/FacePreview.tsx:12](site/src/apps/heroface/FacePreview.tsx)
- HeroFace reuses the `.course` stepped-list component for four non-sequential feature rows and leaves an empty `<span className="course__keys" />` in each — [heroface/Landing.tsx:40-48](site/src/apps/heroface/Landing.tsx). DESIGN.md defines Course as "Numbered steps strung along one 3px ink rule … with its keys above the step title" ([DESIGN.md:230-231](site/DESIGN.md)). See also the layout findings below.

### Inferences
- The minimal fix is one file, e.g. `src/components/AppSections.tsx`, exporting `StoreAction({app})`, `Screens({app, screens})`, `Watches({app, count, families, languages, lede})` and `CallToAction({app, title})`. A `PrivacyTail({app})` in `Doc.tsx` would cover the shared privacy sections. That removes about 60 duplicated lines, and a third app would be mostly data. The hero, truth, feature rows and FAQ should not be abstracted: they are the per-app copy that DESIGN.md wants to vary.
- For type strictness: `strict`, `noUnusedLocals` and `noUnusedParameters` are on ([tsconfig.json:7-9](site/tsconfig.json)), and there is no `any`. `noUncheckedIndexedAccess` is off, so `called[rank]` in [RankScale.tsx:12,21,24](site/src/apps/heroset/RankScale.tsx) is typed `string` when it can be `undefined`. It is guarded at runtime, so turning the option on is optional hardening. The three `as CSSProperties` casts for custom properties ([AppPage.tsx:10](site/src/components/AppPage.tsx), [Home.tsx:17](site/src/pages/Home.tsx), [Pictograms.tsx:42](site/src/apps/heroset/Pictograms.tsx)) are the normal React idiom. `// @ts-ignore` at [prerender.ts:4](site/prerender.ts) is justified, because `.ssr/` does not exist when `tsc` runs.

### Gaps
- None material.

---

## Do any page claims contradict the watch projects' docs (HeroSet release-contract.md, compatibility.md; HeroFace compatibility.md / go-to-market.md)?

### Takeaway
Yes, several. The most urgent is timing. The **staged** HeroSet edits advertise 80 watches, including the 13 touch-first models. HeroSet's release contract says those 13 are **not in a store build yet**. The live site correctly shows 67 today, and CLAUDE.md says every push to `main` deploys, so committing these files now would publish a false support claim on a store-linked page. There are also two wording contradictions in HeroSet copy and one simulator overclaim on the HeroFace pages.

### Cited Findings
**HIGH: publishing the staged HeroSet watch list before the store build ships**
- The staged diff changes `watchCount` from 67 to 80 and adds Venu, vívoactive, Approach and D2 Air X10 — [heroset/facts.ts:4,11-15](site/src/apps/heroset/facts.ts), [heroset/Support.tsx:46-50](site/src/apps/heroset/Support.tsx), [heroset/Landing.tsx:18,103](site/src/apps/heroset/Landing.tsx)
- The release contract says: "80 round watches … 13 touch-first … **Not in a store build yet**: the touch-first 13 ship with the next upload" — [HeroSet/docs/release-contract.md:7](HeroSet/docs/release-contract.md). HeroFace's compatibility doc says the same ("not yet in a HeroSet store build") — [HeroFace/docs/compatibility.md:5-7](HeroFace/docs/compatibility.md)
- The live page currently reads "67 Garmin watches" (curl of https://verden.watch/heroset/, 2026-09-24). "Every push to `main` build and deploy" — [site/CLAUDE.md:10](site/CLAUDE.md)
- Fix: do not commit or push the three staged site files until the HeroSet upload with wave 5 is live in the store, then ship them together. The fact counts themselves are correct: HeroSet families sum to 16+18+16+17+13 = 80, matching [HeroSet/docs/compatibility.md:7-75](HeroSet/docs/compatibility.md).

**HIGH/MEDIUM: HeroFace simulator overclaim**
- The site says "Tested on a Forerunner 965; every other model passes each screen check in Garmin's simulator" — [heroface/Landing.tsx:97](site/src/apps/heroface/Landing.tsx), [heroface/Support.tsx:64-65](site/src/apps/heroface/Support.tsx)
- HeroFace's evidence is "15/15 tests re-run 2026-09-22 on **11 products** — fr965 plus one per screen size … `.iq` builds for all 117" — [HeroFace/docs/go-to-market.md:17](HeroFace/docs/go-to-market.md), and likewise "one per screen size" in [HeroFace/docs/compatibility.md:37-42](HeroFace/docs/compatibility.md). Fix: "…every screen size passes Garmin's simulator checks" (or "builds for every model; each screen size passes…"). The same sentence is accurate for HeroSet, whose checks run per product ([HeroSet/docs/compatibility.md:79](HeroSet/docs/compatibility.md)), which is probably how it was copied across.

**MEDIUM: HeroSet "no tapping / bezel buttons" contradicts the touch-first input it now advertises**
- "No phone, no account, no tapping the screen. Every step works by feel, with the bezel buttons your watch already has." — [heroset/Landing.tsx:48](site/src/apps/heroset/Landing.tsx). On wave 5, "No UP/DOWN keys: swipe up/down adjusts" — [HeroSet/docs/compatibility.md:66](HeroSet/docs/compatibility.md). The contract's allowed claim is "Button-first … five-button and touch-first" — [release-contract.md:23](HeroSet/docs/release-contract.md). Fix: e.g. "No phone, no account. Every step works by feel with the buttons, and a swipe replaces UP/DOWN on touchscreen watches."
- The Adjust step names "Venu, vívoactive or Approach" but leaves out **D2 Air X10**, which is also touch-first — [heroset/Landing.tsx:18](site/src/apps/heroset/Landing.tsx) vs [HeroSet/docs/compatibility.md:74](HeroSet/docs/compatibility.md). The step also still shows UP/DOWN key pills for every watch. Fix: "On a touchscreen watch, swipe instead."

**MEDIUM: HeroSet streak rule stated against the default goal, not the user's goal**
- "Finish all three hundreds to keep your streak alive." — [heroset/Landing.tsx:72](site/src/apps/heroset/Landing.tsx). But "the goal drives bars, done state, mission completion, streak … never XP" — [HeroSet/docs/decisions.md:275](HeroSet/docs/decisions.md), and "Goal 30 mean mission complete daily and streak climbing" — [HeroSet/docs/input-and-ux.md:19](HeroSet/docs/input-and-ux.md). The site's own Support page says "A goal of 30 keeps your streak going every day" ([heroset/Support.tsx:40](site/src/apps/heroset/Support.tsx)). Fix: "Meet your daily goal on all three to keep your streak alive."

**Claims verified consistent (do not change)**
- XP and rank: "2 XP for every rep … up to 100 reps per exercise a day: 600 XP" ([Landing.tsx:72](site/src/apps/heroset/Landing.tsx)) matches [release-contract.md:12](HeroSet/docs/release-contract.md) and [decisions.md:63](HeroSet/docs/decisions.md). The RankScale math at [RankScale.tsx:3-12](site/src/apps/heroset/RankScale.tsx) gives rank 10 = 22.5 days (~3 weeks), rank 14 = 45.5 days (~6½ weeks) and rank 20 = 87.5 days (~12½ weeks). This matches the rule at [input-and-ux.md:19](HeroSet/docs/input-and-ux.md).
- "Rank reflects reps done, not the goal" ([Support.tsx:37-41](site/src/apps/heroset/Support.tsx), [RankScale.tsx:28](site/src/apps/heroset/RankScale.tsx)) is the contract's required wording ([release-contract.md:12,36](HeroSet/docs/release-contract.md)).
- Goal range 10–500 ([Landing.tsx:29](site/src/apps/heroset/Landing.tsx), [Support.tsx:33](site/src/apps/heroset/Support.tsx)) matches [release-contract.md:11](HeroSet/docs/release-contract.md). The calories wording is "an estimate … not a medical device" ([Support.tsx:30](site/src/apps/heroset/Support.tsx)), which respects the forbidden-claims list ([release-contract.md:29](HeroSet/docs/release-contract.md)). The "can be off" caveat is kept ([Landing.tsx:64](site/src/apps/heroset/Landing.tsx)). There is no "beta", "fix" or "correct" wording (grep over src). The tap guard ([Support.tsx:50](site/src/apps/heroset/Support.tsx)) matches [release-contract.md:9](HeroSet/docs/release-contract.md).
- Privacy "your last 30 sets" ([heroset/Privacy.tsx:20](site/src/apps/heroset/Privacy.tsx)): the store build does keep a 30-entry log. `logValidationTrial` is called unannotated from [HeroSetManualPickerView.mc:81](HeroSet/source/ui/manual/HeroSetManualPickerView.mc) and capped at `VALIDATION_LOG_MAX_ENTRIES = 30` ([HeroSetConfig.mc:87](HeroSet/source/domain/HeroSetConfig.mc)). The store jungle excludes only `sync;debug` annotations ([HeroSet/store.jungle:7](HeroSet/store.jungle)). The claim is accurate.
- Languages: 15 in the HeroSet list ([heroset/facts.ts:18-21](site/src/apps/heroset/facts.ts)), matching [release-contract.md:18](HeroSet/docs/release-contract.md). HeroFace has 14 `resources-*` folders plus base English, so 15 there too.
- HeroFace: the count of 117 matches ([heroface/facts.ts:4](site/src/apps/heroface/facts.ts); the screen-table rows in [HeroFace/docs/compatibility.md:18-27](HeroFace/docs/compatibility.md) sum to 117), and so does `linkedWatchCount = 66` ([compatibility.md:30](HeroFace/docs/compatibility.md)).

**LOW: HeroFace facts gaps and uncertain claims**
- The family list omits fēnix Chronos (`fenixchronos`) and the four Legacy Hero/Saga products, which are counted in 117 — [heroface/facts.ts:5-17](site/src/apps/heroface/facts.ts) vs [HeroFace/docs/compatibility.md:24,26](HeroFace/docs/compatibility.md). The landing hedges with "The Connect IQ Store shows whether your exact model is listed", so this is low.
- The "Always on" claim ([heroface/Landing.tsx:65](site/src/apps/heroface/Landing.tsx)) is backed according to [go-to-market.md:23-25](HeroFace/docs/go-to-market.md), but the same doc's claims list still says "Forbidden until measured on a watch: … any always-on claim" ([go-to-market.md:220](HeroFace/docs/go-to-market.md)). This is drift inside the HeroFace docs. The site follows the newer statement. Flag to the HeroFace owner.
- The settings instructions ([heroface/Support.tsx:14-19](site/src/apps/heroface/Support.tsx), [Landing.tsx:63](site/src/apps/heroface/Landing.tsx)) are an allowed claim ([go-to-market.md:217](HeroFace/docs/go-to-market.md)). However, "settings delivery" is still listed as open device evidence ([go-to-market.md:18,103-104](HeroFace/docs/go-to-market.md): "It shipped unverified; verify it now"). This is uncertain, not wrong.
- The watch-project docs contradict each other: [HeroFace/docs/compatibility.md:50](HeroFace/docs/compatibility.md) says "**No watch has run it yet**", while [go-to-market.md:18](HeroFace/docs/go-to-market.md) records FR965 wear on 2026-09-20/22. The site's "Tested on a Forerunner 965" follows go-to-market. compatibility.md is stale.

### Inferences
- Because the site deploys on every push to `main` and store listings link these pages, the site copy should ship in the same push as the store upload it describes, not the same session as the code change. That is stricter than the current CLAUDE.md rule ("update page here", same session), and it may be worth an explicit line in site/CLAUDE.md.

### Gaps
- I did not check the live store listings' device lists (Connect IQ Store pages), so I could not confirm that the store currently lists exactly 67 HeroSet devices.

---

## Ranked findings by category (a–h), with fixes

### Takeaway
The site is small, strict and mostly clean. Beyond the claims above, the real defects are a verified desktop layout bug on `/heroface/`, missing canonical and OG metadata (with a live duplicate host), a long-running auto-animation with no pause control, and a HeroFace field color that is nearly the same as the studio color. Everything else is low severity.

### Cited Findings
**MEDIUM**
1. **(a/d) Layout bug on /heroface/ "Better with HeroSet."** The band reuses `.hero__reps` inside `.band`: [heroface/Landing.tsx:76](site/src/apps/heroface/Landing.tsx). `.hero__reps { grid-column: 7 / -1 }` ([global.css:142](site/src/styles/global.css)) then applies inside `.band`, which is `display: grid` with no column template ([global.css:194](site/src/styles/global.css)), so the browser creates implicit columns. A headless Chrome render at 1400 px confirms it: the h2 and lede sit side by side, and the face preview drops below-left, instead of stacking like every other band. (Scratch screenshot: `scratchpad/heroface.png`.) Fix: replace the wrapper with a plain `<div>` or a new class such as `.band__figure`. Do not reuse hero classes outside the hero.
2. **(a/d) HeroFace's 4-row course in a 5-column grid.** `.course` is `repeat(5, …)` ([global.css:203](site/src/styles/global.css)), but HeroFace passes 4 rows ([heroface/Landing.tsx:11-16](site/src/apps/heroface/Landing.tsx)). The 3px rule runs past the last stop into an empty fifth column (visible in the screenshot). On top of that, the empty `.course__keys` spans reserve 2.1 rem at desktop, because `:empty { display: none }` applies only below 60 rem ([global.css:211,340](site/src/styles/global.css)). Fix: `grid-template-columns: none; grid-auto-flow: column; grid-auto-columns: minmax(0, 1fr)`, so the column count follows the item count. Also move `.course__keys:empty { display: none }` out of the media query. Alternatively, render HeroFace's rows with `.facts` and keep Course for bezel sequences, as DESIGN.md intends.
3. **(b) The auto-playing RepCounter has no pause control.** The three figures animate for about 27 s (push-ups: (100−82)×1.5 s), about 55 s (sit-ups: 29×1.9 s) and about 20 s (squats: 12×1.7 s), each after a 0.8 s delay — [heroset/Landing.tsx:38-40](site/src/apps/heroset/Landing.tsx), [global.css:185-190](site/src/styles/global.css). WCAG 2.2 SC 2.2.2 (Level A) requires a pause, stop or hide mechanism for moving content that starts automatically, lasts more than 5 s and runs beside other content — [W3C Understanding 2.2.2](https://www.w3.org/WAI/WCAG22/Understanding/pause-stop-hide.html). Gating on `prefers-reduced-motion` ([global.css:185](site/src/styles/global.css)) is good, but it does not satisfy 2.2.2 on its own. This is my reading of the SC. The figures are decorative and `aria-hidden`, and the SC still applies to visual users. Zero-JS fixes, either of which works: start the counts near 100 so each run is ≤5 s, or add a CSS-only toggle (`<input type=checkbox id=pause>` with `.hero__reps:has(#pause:checked) * { animation-play-state: paused }`).
4. **(c) No canonical, OG or sitemap, and a duplicate host is live.** The head holds only `<title>` and a description — [entry-server.tsx:40](site/src/entry-server.tsx). the host's default subdomain serves `/heroset/` with 200 (curl), and CLAUDE.md confirms it stays live ([site/CLAUDE.md:10](site/CLAUDE.md)). robots.txt and sitemap.xml return 404. Fix: in `render()`, add `<link rel="canonical" href="https://verden.watch${withSlash}">` plus `og:title`, `og:description`, `og:url` and `og:type`. Put the origin in `src/site.ts`. Have `prerender.ts` write `dist/sitemap.xml` from `routes` (about 3 lines). An `og:image` per app is optional.
5. **(h/design) HeroFace's field color is almost the studio color.** HeroFace uses `#55aaff` ([heroface/app.ts:12](site/src/apps/heroface/app.ts)) and the studio uses `#62b0ea` ([global.css:9](site/src/styles/global.css)). Their contrast ratio is 1.04:1, so they are visually the same hue. DESIGN.md: "A visitor should be able to tell which event they are in from the color alone" ([DESIGN.md:126](site/DESIGN.md)). The studio home stacks the studio-blue intro directly on the HeroFace-blue entry ([Home.tsx:9-17](site/src/pages/Home.tsx)), and the last two bars of the StudioMark are indistinguishable ([Shell.tsx:9-10](site/src/components/Shell.tsx)). DESIGN.md's token list has no HeroFace tokens either ([DESIGN.md:4-20](site/DESIGN.md)). This needs a design decision (user call): either re-key the studio color or HeroFace's field, then add `heroface-*` tokens to DESIGN.md. The HeroFace ink pair itself passes (`#0a1420` on `#55aaff` = 7.57:1).

**LOW**
6. **(f) There is no Content-Security-Policy or Permissions-Policy.** [firebase.json](site/firebase.json) sets nosniff, X-Frame-Options DENY and Referrer-Policy. HSTS is present live (`strict-transport-security: max-age=31536000`), so the host adds it by default. The site is zero-JS, so a strict CSP turns the privacy-page promise of no third-party scripts ([heroset/Privacy.tsx:34](site/src/apps/heroset/Privacy.tsx)) into a mechanical guarantee: `default-src 'none'; style-src 'self'; style-src-attr 'unsafe-inline'; font-src 'self'; img-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'`. The `style-src-attr` is needed because React emits `style="…"` attributes for the field variables and mark bars. Add `Permissions-Policy: camera=(), microphone=(), geolocation=()` as well. Verify on a deploy preview before `main`. [MDN CSP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy)
7. **(c) Titles.** The HeroSet landing title is 95 characters with three em dashes ("HeroSet — 100 push-ups … — or your own goal — counted on your Garmin."), because it is built as `name — summary` ([entry-server.tsx:16](site/src/entry-server.tsx), [heroset/app.ts:11](site/src/apps/heroset/app.ts)). The support and privacy titles carry no studio brand ([entry-server.tsx:17-18](site/src/entry-server.tsx)), and the home title is just "Verden — apps" ([entry-server.tsx:12](site/src/entry-server.tsx)). Fix: use an optional short `title` field on `App`, and suffix ` · Verden` on app pages.
8. **(b) Focus ring on field-colored blocks outside `.field`.** The on-field outline override covers only `.app-bar`, `.field` ([global.css:113](site/src/styles/global.css)) and `.program__entry` ([global.css:290](site/src/styles/global.css)). `.note` ([global.css:312](site/src/styles/global.css)) and the dark-mode `.truth` field ([global.css:228-231](site/src/styles/global.css)) fall back to `--ink`. In dark mode that is `#eceef1` on amber, 1.64:1, and on `#55aaff`, 2.11:1. That fails the 3:1 non-text contrast minimum, and DESIGN.md's Field Ink Rule ([DESIGN.md:163](site/DESIGN.md)). This is latent: no Note or truth block contains a link today. Fix: add `.note :focus-visible` and the dark-scheme `.truth :focus-visible` to the override at line 113.
9. **(b/h) Hover motion is not gated on reduced motion.** `.button { transition: transform 180ms }` / `:hover { translateY(-2px) }` sit outside the `no-preference` query ([global.css:128-130](site/src/styles/global.css)), against "Don't animate outside `prefers-reduced-motion: no-preference`" ([DESIGN.md:257](site/DESIGN.md)). Fix: move both into the existing media block at [global.css:185](site/src/styles/global.css).
10. **(e) HeroFace screenshots are upscaled.** `everyday.png` and `goals-met.png` are 240×240 (`file` output) but are declared `width="454" height="454"` and shown up to about a quarter of a 76 rem wrap — [heroface/Landing.tsx:87](site/src/apps/heroface/Landing.tsx), [heroface/facts.ts:31-32](site/src/apps/heroface/facts.ts). They will look soft on HiDPI. The aspect ratio is equal, so there is no CLS. Fix: re-capture at 454 px, as the HeroSet screens are. The "Always on" slot still renders "Screenshot pending" on a live page ([heroface/facts.ts:34](site/src/apps/heroface/facts.ts)), and [go-to-market.md:19](HeroFace/docs/go-to-market.md) says it is "now capturable".
11. **(e) Font weight.** The app pages also download the 86 kB latin-ext subset, because "fēnix" (U+0113) and "Lietuvių" (U+0173) fall inside its unicode-range. The home page does not. "Українська" has no Archivo glyphs in this package (only latin, latin-ext and vietnamese subsets are emitted), so it renders in the system fallback. The package uses `font-display: swap` (`node_modules/@fontsource-variable/archivo/wdth.css`), and the latin subset is preloaded ([index.html:7](site/index.html)). Acceptable as is. PNG screenshots are 4–27 kB each, so converting them to WebP/AVIF is not worth doing.
12. **(g) Dependencies.** Every declared package is imported: react (types plus the JSX runtime), react-dom/server, `@fontsource-variable/archivo` ([global.css:1](site/src/styles/global.css)), vite, @types/*. `npm audit` finds 0 vulnerabilities. `npm outdated`: vite 8.3.0 → 8.3.1 (patch). `"@types/node": "latest"` is unpinned ([package.json:16](site/package.json)), so pin `^26` to match Node 26 (the build's Node 26). react and react-dom run only at build time and could be devDependencies. That is cosmetic, so leave it.
13. **(h) Doc drift in site docs.**
    - [README.md:58](site/README.md) still says to set `storeUrl` "When the Connect IQ listing is live". Both apps have it set ([heroset/app.ts:16](site/src/apps/heroset/app.ts), [heroface/app.ts:15](site/src/apps/heroface/app.ts)).
    - README has "HeroSet specifics" but no HeroFace section. HeroFace needs one, because `FacePreview.tsx` mirrors `HeroFace source/HeroFaceLayout.mc` ([FacePreview.tsx:1-3](site/src/apps/heroface/FacePreview.tsx)) and must be updated when the face layout changes.
    - [public/favicon.svg](site/public/favicon.svg) has 2 bars (amber, studio), while the StudioMark has 3. README:37 says to update it by hand.
    - The DESIGN.md frontmatter has no HeroFace color tokens (see item 5).

### Inferences
- None of the low items is urgent. Items 1, 2 and 4 are small, contained edits (the CSS and head fixes) with clear user-visible or search-visible payoff.

### Gaps
- I rendered the headless screenshot only in the machine's dark scheme and only at 1400 px wide. I did not visually check light mode or phone widths.
- I did not run Lighthouse or axe, so there are no automated a11y or performance scores. The contrast figures come from my own WCAG luminance script.

---

## What is good and should NOT be changed

### Takeaway
The architecture is right for the job: a registry-driven, build-time-only React site with no runtime JS, strict types, three runtime packages and root-absolute trailing-slash URLs. Keep all of it.

### Cited Findings
- **Zero client JS, prerender-only**: no `<script>` in any output. This is what backs the privacy-page claim — [vite.config.ts:4-5](site/vite.config.ts), [site/CLAUDE.md:34](site/CLAUDE.md)
- **The app registry drives routes, nav, the studio mark, home and 404**, so adding an app adds its three URLs — [src/apps/index.ts:5-6](site/src/apps/index.ts), [entry-server.tsx:14-24](site/src/entry-server.tsx), [types.ts:9-27](site/src/apps/types.ts)
- **A real 404 page with a status** (render returns 404; `dist/404.html` is emitted) — [entry-server.tsx:33-39](site/src/entry-server.tsx), [prerender.ts:14](site/prerender.ts)
- **Accessibility basics are present**:
  - Skip link, then header, nav, main and footer landmarks — [Shell.tsx:18-33](site/src/components/Shell.tsx)
  - Labelled navs and `aria-current="page"` on tabs — [AppPage.tsx:15,21](site/src/components/AppPage.tsx)
  - Exactly one `<h1>` per emitted page (grep of dist), with a clean h1 → h2 → h3 order
  - Decorative SVGs are `aria-hidden`, with an sr-only description for the animated figures — [heroset/Landing.tsx:36-37](site/src/apps/heroset/Landing.tsx). The RankScale is exposed as a single `role="img"` with a full text label — [RankScale.tsx:17](site/src/apps/heroset/RankScale.tsx)
  - A visible 3px `:focus-visible` ring — [global.css:64](site/src/styles/global.css)
  - Animations and the view transition sit only under `prefers-reduced-motion: no-preference` — [global.css:46,185-190](site/src/styles/global.css)
- **Contrast tokens all pass AA for text** (my computation): link 6.03:1, ink-2 8.00:1, dark link 9.08:1, dark ink-2 8.42:1, HeroSet ink on amber 9.72:1, studio ink on studio blue 7.62:1, studio-ink on paper 6.29:1, amber on the inverse field 9.49:1. These match the figures DESIGN.md quotes ([DESIGN.md:150,163,165](site/DESIGN.md)).
- **No CLS from images**: every `<img>` has width, height and `loading="lazy"`. The screen slots use `aspect-ratio: 1` — [global.css:263](site/src/styles/global.css). Counts use `cqi` sizing so "100/100" never overflows — [global.css:157-172](site/src/styles/global.css).
- **Caching**: `/assets/*` immutable for a year, HTML revalidates (live `cache-control: public,max-age=0,must-revalidate`) — [firebase.json](site/firebase.json)
- **Strict TypeScript**: `tsc --noEmit` is clean, runs as the first build step and fails the deploy on type errors — [package.json:7](site/package.json), [tsconfig.json:7-9](site/tsconfig.json)
- **Single sources**: the contact email lives only in `site.ts` — [site.ts:4](site/src/site.ts), [site/CLAUDE.md:36](site/CLAUDE.md). The `.env` guard is in `.gitignore` — [site/.gitignore:6-10](site/.gitignore). The RankScale is computed from the real rule rather than hand-placed — [RankScale.tsx:1-7](site/src/apps/heroset/RankScale.tsx).
- **HTML escaping of title and description** — [entry-server.tsx:28](site/src/entry-server.tsx). It escapes `& < "`, which is sufficient inside a double-quoted attribute and a `<title>` element.

### Inferences
- Do not add a router, a hydration layer, a CSS framework or an SEO/head library. Every fix above fits in the existing `render()`, `prerender.ts` and `global.css`.

### Gaps
- None.
