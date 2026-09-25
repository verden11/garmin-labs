# Improvements backlog

Status: 2026-09-25. Incremental, implementable-cold findings from a read-only
+ measured audit of all three projects. This is not `HeroSet/docs/ideas.md`
(feature ideas) — this is small correctness/perf/quality gains, ranked by
gain/effort, meant to be picked up on a machine with the full Connect IQ
toolchain.

Each item states verification status. Anything under `HeroSet/`/`heroFace/`
was **not** compiled or run here (no `monkeyc`/simulator/device in this
container) — those are read-only findings, marked `unverified: needs local
monkeyc build + sim + device`. Simulator passing is not device proof either;
say so when reporting on those.

Ranked by gain/effort, strongest evidence first.

---

## verden-site (measured: `npm ci && npm run build`, tsc clean, 7 pages + 404 prerendered)

### 1. Two heroFace screenshots are served at the wrong intrinsic size (blurry upscale)

- `verden-site/src/apps/heroface/facts.ts:31-32` lists `everyday.png` and
  `goals-met.png`. Their files
  (`verden-site/public/heroface/screens/{everyday,goals-met}.png`) are
  **240×240** (measured: `file public/heroface/screens/*.png`), but
  `verden-site/src/apps/heroface/Landing.tsx:87` hardcodes
  `width="454" height="454"` for every shot in the list, including these two.
  `heroset.png` in the same list is actually 454×454, so it's fine — only
  these two are wrong.
- **Effect**: the browser lays out a 454px box and upscales a 240px source
  into it — visibly softer than the other screenshot on the same page.
- **Fix**: read `width`/`height` per-shot in `facts.ts` (or re-export the two
  screenshots at 454×454) instead of a single hardcoded pair in the map call.
- **Effort**: trivial (data change + one prop). **Verification**: measured
  here (`file`, then visually confirm in a local `npm run dev`).

### 2. No Open Graph / Twitter Card / canonical tags

- `verden-site/src/entry-server.tsx:38` builds `head` from only `<title>` and
  `<meta name="description">`. No `og:title`, `og:description`, `og:image`,
  `og:url`, `twitter:card`, or `<link rel="canonical">` on any of the 7 pages
  (measured: grepped `src/` for `og:`/`twitter:`/canonical — zero hits).
- **Effect**: links to `/heroset/` or `/heroface/` shared on Discord/Slack/X
  render as bare text, no preview card — real friction for a store-launch
  site whose job is conversions from shared links.
- **Fix**: extend the `Route` type in `entry-server.tsx` with an optional
  `image` (point at an existing screenshot, e.g.
  `/heroset/screens/dashboard.png`), and add the four `og:*` + one
  `twitter:card` meta tags + canonical link to the `head` template. Stays
  zero client JS — this is build-time SSR string, not a runtime script, so it
  doesn't trip the "Zero client JS" rule in `verden-site/CLAUDE.md`.
- **Effort**: small (one file). **Verification**: measured here (grep); the
  rendered `<head>` can be checked against `dist/*/index.html` after build,
  no browser needed.

### 3. No `robots.txt` or `sitemap.xml`

- `verden-site/public/` has only `favicon.svg` (measured: `ls public/`). A
  7-page fully-prerendered static site with no `robots.txt`/`sitemap.xml` is
  a free, zero-risk SEO win skipped for no stated reason — nothing in
  `verden-site/CLAUDE.md` forbids it (the "zero client JS" and "no
  analytics" rules don't cover crawl files).
- **Fix**: add `public/robots.txt` (`User-agent: *\nAllow: /\nSitemap:
  https://verden.watch/sitemap.xml`) and generate `sitemap.xml` from the
  existing `routes` array already computed in `prerender.ts` (loop already
  has every URL; just also write a sitemap file alongside the HTML).
- **Effort**: small. **Verification**: measured here (`ls public/`); output
  can be diffed against `routes` after build, no server needed.

### 4. No `Content-Security-Policy` header despite a "nothing leaves the watch / no third-party script" promise

- `verden-site/netlify.toml:14-19` sets `X-Content-Type-Options`,
  `X-Frame-Options`, `Referrer-Policy` — no CSP. The site's own privacy
  pages and `CLAUDE.md` state "Zero client JS... no analytics, no
  third-party script"; a CSP (`default-src 'self'; img-src 'self';
  style-src 'self'; base-uri 'self'; frame-ancestors 'none'`) makes that
  claim enforced by the browser instead of just asserted in prose, at zero
  functional cost since the site genuinely loads nothing external (measured:
  `index.html` only references `/src/styles/global.css` and the bundled
  fonts, both same-origin).
- **Effort**: small (one `netlify.toml` block). **Verification**: measured
  here (read `index.html`/`vite.config.ts`); add and then confirm `curl -I`
  on the Netlify deploy shows the header.

### 5. (minor) Screenshot PNGs are uncompressed screenshots, not optimized

- `verden-site/public/{heroset,heroface}/screens/*.png` total 112KB across 7
  files (measured: `du -h`), largest 28KB. Already small enough that
  converting to WebP/AVIF is marginal (a few KB) — noting it but ranking
  it last; not worth the added `<picture>` complexity for this payload size.

---

## HeroSet — localization (verified with python3, no build needed)

### 6. `complication_label` / `complication_short` missing from all 14 non-English string files

- Diffed every `id="..."` key in each `HeroSet/resources-<lang>/strings/*.xml`
  against the base `HeroSet/resources/strings/*.xml` (script: string-diff by
  regex, run in this session). Every one of the 14 translated languages
  (dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr) is
  missing `complication_label` (`"HeroSet"`) and `complication_short`
  (`"HERO"`) — present only in `resources/strings/strings.xml:78-79`.
- **Effect**: on a non-English device, the complication picker on a CIQ
  4.2+ watch falls back to whatever Connect IQ does for a missing string
  resource for those two ids (likely the base/English value, but that's a
  device-level fallback, not confirmed here).
- **Judgment call**: both strings are the brand name and a 4-letter
  abbreviation of it — arguably intentional to leave untranslated (compare:
  app name itself isn't translated either). Flagging as a **gap to make a
  deliberate decision on**, not an assumed bug: either (a) add the same
  `HeroSet`/`HERO` literal to all 14 files so the key exists everywhere and
  the source of truth is explicit, or (b) note in `docs/compatibility.md` or
  `decisions.md` that these two keys are deliberately English-only.
- **Effort**: trivial if (a). **Verification**: measured here (python
  key-diff); no Storage/complication contract touched, so no ADR-044 impact.
  heroFace's own strings had zero missing/extra keys — clean.

---

## heroFace — draw-path audit (read-only; not compiled or run here)

### 7. Two draw calls bypass `HeroFaceDraw.text`, invisible to the screen-fit test

- `heroFace/CLAUDE.md` states: "Text fit is measured, never guessed: draw
  through `HeroFaceDraw.text`." `HeroFaceDraw.text` itself
  (`heroFace/source/HeroFaceDraw.mc:15-31`) is a thin wrapper: it calls
  `dc.drawText` and, only when `misfits`/`boxes` are non-null (test builds),
  records the box so `everyStateFitsThisDisplay` can catch clipping/overlap
  per device.
- Two call sites skip the wrapper and call `dc.drawText` directly, so their
  text is **invisible to that test** on every product:
  - `heroFace/source/HeroFaceView.mc:108` — the seconds digits in
    `onPartialUpdate`, which is the highest-frequency draw path in the app
    (once a second whenever seconds are on).
  - `heroFace/source/HeroFaceSleep.mc:21` — the dimmed always-on clock.
- **Effect**: not a known bug, but a coverage hole — if a future font change
  or a narrow product ever clips the seconds digits or the sleep clock, the
  screen-fit test (`docs/compatibility.md`'s evidence source) won't catch
  it, because these two paths never populate `misfits`/`boxes`.
- **Fix**: swap both `dc.drawText(...)` calls for `HeroFaceDraw.text(dc,
  layout, ...)` with the same arguments — behavior-identical outside test
  builds (the wrapper's non-test path is exactly `dc.drawText`), it only
  adds instrumentation.
- **Effort**: trivial, 2 call sites. **Verification**:
  `unverified: needs local monkeyc build + sim` — must confirm the
  screen-fit test then actually reports boxes for these two elements, and
  that no product's simulator run regresses. Simulator passing is not
  device proof.

### 8. (minor, low-confidence) `HeroSetStoreTest.mc` is 377 lines, over the 250-line budget and untracked

- `HeroSet/source/test/HeroSetStoreTest.mc` is 377 lines (measured:
  `wc -l`), and `HeroSet/source/data/HeroSetStore.mc` is 330 — but only the
  latter is listed in `HeroSet/docs/architecture.md` §8 "Known technical
  debt". The house rule ("files ≲250 lines") doesn't explicitly exempt
  tests, so either split the test file (it's testing one class,
  `HeroSetStore`, so a per-behavior-group split is natural) or add it to
  the §8 table alongside its source counterpart so the debt is tracked, not
  silently over budget.
- **Effort**: documentation fix is trivial; the split itself is
  medium (test files are easy to get wrong when split blind).
  **Verification**: measured here (`wc -l`); ranked last, lowest
  confidence this is worth doing over just documenting it.

---

## Not investigated this pass

- HeroSet's own draw paths (`HeroSetView.mc` etc.) for the same
  `dc.drawText`-bypass pattern found in heroFace — worth the same grep next
  pass.
- Battery/allocation profiling inside `onUpdate`/`onPartialUpdate` beyond
  the static text-draw check above — needs a device or simulator profiler,
  not available in this container.
- `verden-site` Lighthouse/accessibility audit with the pre-installed
  Chromium — not run this pass; alt text and `width`/`height` attributes on
  images were already spot-checked and are in good shape (see item 1 for
  the one exception found).
