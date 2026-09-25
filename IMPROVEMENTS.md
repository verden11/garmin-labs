# Improvements backlog

Status: 2026-09-25. Incremental, implementable-cold findings from a read-only
+ measured audit of all three projects. This is not `HeroSet/docs/ideas.md`
(feature ideas) — this is small correctness/perf/quality gains.

Each item states verification status. Anything under `HeroSet/`/`heroFace/`
was **not** compiled or run here (no `monkeyc`/simulator/device in this
container) — those are read-only findings, marked `unverified: needs local
monkeyc build + sim + device`. Simulator passing is not device proof either;
say so when reporting on those.

Ranked by gain/effort, strongest evidence first.

---

### 1. `verden-site`: No Open Graph / Twitter Card / canonical tags

- `verden-site/src/entry-server.tsx:38` builds `head` from only `<title>` and
  `<meta name="description">`. No `og:title`, `og:description`, `og:image`,
  `og:url`, `twitter:card`, or `<link rel="canonical">` on any of the 7 pages
  (measured: grepped `src/` for `og:`/`twitter:`/canonical — zero hits).
- **Effect**: links to `/heroset/` or `/heroface/` shared on Discord/Slack/X
  render as bare text, no preview card — real friction for a store-launch
  site whose job is conversions from shared links.
- **Fix**: extend the `Route` type in `entry-server.tsx` with an optional
  `image`, and add `og:*` + `twitter:card` meta + canonical link to the
  `head` template. **`og:image`, `og:url` and the canonical href must be
  absolute** (`https://verden.watch/...`) — relative paths don't work for
  share-card scrapers. The origin isn't a constant anywhere yet; add it in
  `src/site.ts` next to `studio`/contact-email, which is where site-level
  constants already live. Stays zero client JS — this is build-time SSR
  string output, not a runtime script, so it doesn't trip the "Zero client
  JS" rule in `verden-site/CLAUDE.md`.
- **Effort**: small (one file + one constant). **Verification**: measured
  here (grep); the rendered `<head>` can be checked against
  `dist/*/index.html` after build, no browser needed.

### 2. `verden-site`: No `robots.txt` or `sitemap.xml`

- `verden-site/public/` has only `favicon.svg` (measured: `ls public/`). A
  7-page fully-prerendered static site with no `robots.txt`/`sitemap.xml` is
  a free, zero-risk SEO win skipped for no stated reason — nothing in
  `verden-site/CLAUDE.md` forbids it.
- **Fix**: add `public/robots.txt` (`User-agent: *\nAllow: /\nSitemap:
  https://verden.watch/sitemap.xml`) and generate `sitemap.xml` from the
  `routes` array already computed in `prerender.ts` (loop already has every
  URL; just also write a sitemap file alongside the HTML).
- **Effort**: small. **Verification**: measured here (`ls public/`); output
  can be diffed against `routes` after build, no server needed.

### 3. `heroFace`: Two draw calls bypass `HeroFaceDraw.text`, invisible to the screen-fit test — fix must also extend the harness

- `heroFace/CLAUDE.md` states: "Text fit is measured, never guessed: draw
  through `HeroFaceDraw.text`." `HeroFaceDraw.text` itself
  (`heroFace/source/HeroFaceDraw.mc:15-31`) is a thin wrapper: it calls
  `dc.drawText` and, only when `misfits`/`boxes` are non-null (test builds),
  records the box so `everyStateFitsThisDisplay` can catch clipping/overlap.
- Two call sites skip the wrapper, so their text is invisible to that
  instrumentation:
  - `heroFace/source/HeroFaceView.mc:108` — the seconds digits in
    `onPartialUpdate` (redraws once a second whenever seconds are on; same
    font/justify as the full-frame draw in `HeroFaceClock.mc:34`, so this is
    not a rendering-mismatch bug, just uninstrumented).
  - `heroFace/source/HeroFaceSleep.mc:21` — the dimmed always-on clock.
- **Checked and confirmed**: `heroFace/source/test/HeroFaceScreenFitTest.mc`
  only calls `view.drawState(...)` (the full-frame path) — it never calls
  `onPartialUpdate` or `HeroFaceSleep.draw`. **Swapping the two
  `dc.drawText` calls alone adds zero coverage**, because the harness never
  executes those two lines under test either way. HeroSet's own source has
  no equivalent violation (checked: `grep -rn "dc\.drawText" HeroSet/source
  --include=*.mc | grep -v HeroSetDraw.mc` → empty).
- **Fix, both parts required**: (a) swap the two `dc.drawText(...)` calls
  for `HeroFaceDraw.text(dc, layout, ...)` — behavior-identical outside test
  builds; (b) add a harness case that calls `onPartialUpdate` (with a
  `_secondsBox` primed by an initial `drawState`) and one that calls
  `HeroFaceSleep.draw`, wrapped in the same `misfits`/`boxes` capture the
  existing cases use.
- **Effort**: small (2 call sites + 2 new harness cases, following the
  existing pattern in `HeroFaceScreenFitTest.mc`). **Verification**:
  `unverified: needs local monkeyc build + sim` per product. Simulator
  passing is not device proof.

### 4. `HeroSet`: `complication_label`/`complication_short` missing from all 14 non-English string files — leave as is, but document why

- Diffed every `id="..."` key in each `HeroSet/resources-<lang>/strings/*.xml`
  against the base `HeroSet/resources/strings/*.xml`. All 14 translated
  languages are missing `complication_label` (`"HeroSet"`) and
  `complication_short` (`"HERO"`), present only in
  `resources/strings/strings.xml:78-79`.
- **This is not a bug — translating it would be.** Checked
  `heroFace/source/HeroFaceLink.mc:86`: HeroFace finds HeroSet's private
  complication by matching `HeroFaceConfig.HEROSET_COMPLICATION_LABEL`
  (hardcoded `"HeroSet"` in `HeroFaceConfig.mc:38`) against
  `complication.longLabel`. `HeroSet/resources-complications/complications.xml:9`
  sets `longLabel="@Strings.complication_label"`. Connect IQ falls back to
  the base-locale string when a locale's resource is missing a key — which
  is exactly why the link works on all 14 non-English builds today: the
  missing translations keep `longLabel` resolving to the literal `"HeroSet"`
  HeroFace matches against. **Translating `complication_label` on any
  locale would break the HeroSet→HeroFace link (ADR-044) on that locale.**
  This is the opposite of item 6 in the original draft of this file, which
  wrongly proposed adding the translations.
- **Fix**: no code/resource change. Add a one-line comment next to
  `complication_label`/`complication_short` in
  `HeroSet/resources/strings/strings.xml` noting they're intentionally
  base-locale-only because HeroFace's complication matcher depends on the
  literal value, and name that constraint explicitly in ADR-044 (or a new
  ADR) so a future translator doesn't "fix" the gap.
- **Effort**: trivial (comment + doc line). **Verification**: measured here
  (python key-diff, then grep-confirmed against both `HeroFaceLink.mc` and
  `complications.xml`). heroFace's own strings had zero missing/extra
  keys — clean, no equivalent risk there.

### 5. (minor, deferred) `verden-site`: `Content-Security-Policy` header — needs `'unsafe-inline'` for styles, not a drop-in

- `verden-site/netlify.toml:14-19` sets `X-Content-Type-Options`,
  `X-Frame-Options`, `Referrer-Policy` — no CSP, despite the site's own
  claim of zero third-party script/analytics.
- **Checked before proposing a policy**: every prerendered page has inline
  `style="..."` attributes from React (`grep -oc 'style="' dist/*.html
  dist/*/*.html dist/*/*/*.html` → 1+ per page; e.g. `FacePreview`'s accent
  colors). A naive `style-src 'self'` policy **breaks the page** — those
  inline styles would be blocked. No `data:` URIs turned up in the built
  CSS, so `img-src 'self'` is safe as-is.
- **Fix**: `default-src 'self'; img-src 'self'; style-src 'self'
  'unsafe-inline'; base-uri 'self'; frame-ancestors 'none'; object-src
  'none'; form-action 'none'`. `'unsafe-inline'` on styles is a real
  weakening (not the clean "zero functional cost" originally claimed) —
  worth doing since it's still strictly tighter than no CSP, but it doesn't
  fully back the "no third-party script" claim with enforcement the way a
  nonce-based policy would. A stronger version (nonces per inline style, or
  moving accent colors to CSS custom properties set via a class instead of
  inline `style`) is more effort and out of scope for this pass.
- **Effort**: small for the weakened version above; medium for the
  nonce/no-inline-style version. **Verification**: measured here (`grep -oc
  'style="'` on `dist/`, grep for `data:` in built CSS — done); the header
  itself needs a `curl -I` check against a real Netlify deploy, not
  available in this container.

### 6. (minor, corrected) `verden-site`: `everyface.png`/`goals-met.png` width/height attributes don't match file dimensions, but likely no visible effect

- `verden-site/src/apps/heroface/facts.ts:31-32` lists `everyday.png` and
  `goals-met.png` at 240×240 actual (measured: `file`), while
  `verden-site/src/apps/heroface/Landing.tsx:87` hardcodes
  `width="454" height="454"` for every shot including these two.
- **Checked before claiming a visible blur**: `verden-site/src/styles/global.css:260`
  sets `.screens img { width: 100%; aspect-ratio: 1; }` — the image is
  rendered at its grid-cell width (a quarter or half the content width,
  well under 454 CSS px on any real viewport), not at the HTML `width`
  attribute. Since displayed size is smaller than even the 240px source in
  practice, there's likely **no visible upscale**. Also checked
  `heroFace/listing/screens/`: only 240×240 source assets exist for these
  two shots there too (no higher-res originals to swap in).
- **What's actually wrong**: the `width`/`height` HTML attributes are just
  inaccurate metadata (both declared and actual are 1:1 aspect ratio, so no
  layout-shift risk either, since `aspect-ratio` CSS matches both). Low
  value — correctness/consistency only, not a user-visible fix. Downgraded
  from the original draft, which claimed a visible blur without checking
  the CSS.
- **Fix, if done at all**: read `width`/`height` per-shot in `facts.ts`
  matching actual file dimensions, for correctness.
- **Effort**: trivial. **Verification**: measured here (`file`, CSS read);
  no Playwright/rendered check run — genuinely low priority, listed last on
  purpose.

---

## Not investigated this pass

- Battery/allocation profiling inside `onUpdate`/`onPartialUpdate` beyond
  the static text-draw check above — needs a device or simulator profiler,
  not available in this container.
- `verden-site` Lighthouse/accessibility audit with the pre-installed
  Chromium — not run this pass; alt text on images was spot-checked and is
  in good shape (`width`/`height`/`loading="lazy"`/`alt` all present).
- `HeroSetStoreTest.mc` (377 lines) exceeds the 250-line file budget and
  isn't listed alongside `HeroSetStore.mc` (330 lines) in
  `HeroSet/docs/architecture.md` §8's known-debt table — noted but not
  sized into an item this pass; low confidence it's worth splitting versus
  just documenting the debt.
