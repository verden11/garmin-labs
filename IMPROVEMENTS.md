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

## Done

### ✅ `verden-site`: Open Graph / Twitter Card / canonical tags — shipped `4d275e7`

`entry-server.tsx`'s `head` now emits `og:*`, `twitter:*` and a canonical
link per page, absolute URLs via a new `studio.origin` constant in
`site.ts`. Verified: `npm run build` clean, `dist/heroset/index.html`
inspected directly — all tags present and absolute.

### ✅ `verden-site`: `robots.txt` + `sitemap.xml` — shipped `4d275e7`

`public/robots.txt` added; `prerender.ts` now also writes
`dist/sitemap.xml` from the same `routes` array the HTML pages come from,
so it can't drift out of sync with the route list. Verified: build output
inspected, all 7 routes present.

### ✅ `HeroSet`: `complication_label`/`complication_short` intentionally untranslated — already documented, no action needed

Diffed every translated string file against the base; all 14 non-English
locales are missing these two keys. Traced through
`heroFace/source/HeroFaceLink.mc:86` and
`HeroSet/resources-complications/complications.xml:9`: this is protective,
not a gap — HeroFace matches the literal `"HeroSet"` against
`complication.longLabel`, and Connect IQ's base-locale fallback is what
keeps that literal in place on every non-English build. Translating either
key would break the HeroSet→HeroFace link (ADR-044) on that locale.
Re-checked before proposing a doc fix: a comment already exists at
`HeroSet/resources/strings/strings.xml:76-77` ("not translated, it is how
the face finds it"), present since the repo's original import — nothing to
add.

### ✅ `verden-site`: `Content-Security-Policy` header — shipped, needs one post-deploy check

Added to `verden-site/netlify.toml`: `default-src 'self'; img-src 'self';
style-src 'self' 'unsafe-inline'; script-src 'self'; base-uri 'self';
frame-ancestors 'none'; object-src 'none'; form-action 'none'`.
`'unsafe-inline'` on styles is required and is a real, documented
weakening: React SSR emits inline `style="..."` on every page (checked via
`grep -oc 'style="' dist/*.html dist/*/*.html dist/*/*/*.html` before
adding the policy). `script-src 'self'` is safe as written — re-checked
after adding it, zero `<script>` tags anywhere in `dist/`. No `data:` URIs
in the built CSS either. A stronger version (nonces, or moving accent
colors to CSS classes instead of inline `style`) would drop
`'unsafe-inline'` entirely — future step, not done here. **One thing this
container can't check**: a `curl -I` against the live Netlify deploy to
confirm the header reaches the browser.

### ✅ `verden-site`: screenshot `width`/`height` now match file dimensions — shipped

Added optional `size` to the `Screenshot` type (defaults to 454), set
`size: 240` on heroFace's two 240×240 shots in `facts.ts`, both
`Landing.tsx` files now render `width={shot.size ?? 454} height={shot.size
?? 454}`. Verified: build clean, `dist/heroface/index.html` shows
`width="240" height="240"` on the two affected images, `454` elsewhere.
Correctness only — confirmed earlier this had no visible-blur effect since
`.screens img { width: 100% }` already renders below native size.

---

## Open

### 1. `heroFace`: Two draw calls bypass `HeroFaceDraw.text`, invisible to the screen-fit test — fix must also extend the harness

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
