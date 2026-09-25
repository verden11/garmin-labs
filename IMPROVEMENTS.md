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

### ✅ `heroFace`: `DESIGN.md`'s accent-white token contradicted shipped code — fixed

Found by a background sub-agent cross-checking `DESIGN.md` against
`heroFace/docs/plan.md`, `HeroFacePalette.mc`, and
`resources/settings/settings.xml`. `DESIGN.md`'s front matter still
defined an `accent-white: "#FFFFFF"` token and its "Accent alternatives"
prose listed white as one of three settings-selectable accents, and a
separate line still said "four user-selectable accents." But
`heroFace/docs/plan.md`'s finish-review item 3 records a real, shipped
decision: "The white accent is gone: a white bar read as the clock's own
material. Three accents remain." Code agrees with `plan.md`, not the old
`DESIGN.md`: `HeroFacePalette.ACCENTS` (`HeroFacePalette.mc:23`) has
exactly 3 entries — blue/cyan/magenta, no white — matching
`settings.xml`'s 3 `listEntry` values exactly.
`heroFace/CLAUDE.md`'s own sync rule ("Behaviour change → update
`docs/plan.md` (and `DESIGN.md` if it is visual)") was followed on the
`plan.md` side and missed on the `DESIGN.md` side until now. **Fixed**:
removed the `accent-white` token from the front matter, "four" → "three"
accents, "Accent alternatives" now names only cyan and magenta. Doc-only,
zero compile risk, applied directly (unlike the Monkey C findings below,
which stay documented-only since this container can't compile/verify
them).

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

### 2. `heroFace`: dead parameter in `HeroFaceFooter.iconSize`

Found by a background sub-agent's independent read-through of all 20
heroFace source files. `heroFace/source/HeroFaceFooter.mc:38`:
```
private static function iconSize(layout as HeroFaceLayout) as Number {
    return Graphics.getFontAscent(Graphics.FONT_XTINY) * 2 / 3;
}
```
`layout` is accepted but never referenced in the body; all 3 call sites
(`HeroFaceFooter.mc:39,45,52`) pass it for nothing. Low stakes on its own,
but the kind of thing that quietly misleads a future editor into thinking
the parameter is load-bearing. **Fix**: drop the parameter, update the 3
call sites. **Effort**: trivial. **Verification**: confirmed by direct
source read (not compiled) — this is exactly the class of issue a
`monkeyc` compile would also just flag statically, no device needed.

### 3. `HeroSet`: `HeroSetMissionBars.drawBar` divides by `goal` with no zero-guard — currently unreachable, still worth the one-line fix

Found by a background sub-agent's full read-through of `HeroSet/source/`.
`HeroSet/source/ui/dashboard/HeroSetMissionBars.mc:106`:
```
var fill = done ? width : (count <= 0 ? 0 : width * count / goal);
```
Throws on integer divide-by-zero if `goal` is ever 0. **Confirmed
currently unreachable**: every caller reaches `goal` through
`HeroSetStore.getGoal()` (`HeroSet/source/data/HeroSetStore.mc:161-166`,
falls back to `DEFAULT_MISSION_GOAL` on null/≤0) and
`HeroSetRules.clampGoal` clamps into `[10, 500]`
(`HeroSet/source/domain/HeroSetRules.mc:87-94`) — the sub-agent checked
every constructor call of `HeroSetDashboardState` (production and both
test harnesses) and none passes 0. **Worth fixing anyway**: every
comparable division elsewhere in the codebase is explicitly guarded
(`HeroSetLayout.ringSweepFor` guards `whole <= 0`,
`HeroSetComplicationPublisher.valueFor` guards `cost > 0 ? … : 0`) — this
is the one place that pattern was skipped, and `HeroSetDashboardState` is
a plain public constructor with no invariant enforcement of its own, so a
future caller that stops routing through `getGoal()` could reintroduce a
live crash silently. **Fix**: `var fill = (done || goal <= 0) ? width :
(count <= 0 ? 0 : width * count / goal);` — one line. **Effort**: trivial.
**Verification**: `unverified: needs local monkeyc build + sim` — a
builder should confirm the guard doesn't change any of the four
`HeroSetScreenFitTest` states' rendering (it shouldn't, since none hits
the branch).

---

## Verified clean (no action needed)

### ✅ `HeroSet`/`heroFace`: two source passes, second one deeper — 3 small items found, everything else clean

First pass (grep-level): both source trees checked for `TODO`/`FIXME`/
`XXX`/`HACK` (zero hits), `dc.drawText` bypasses re-checked in HeroSet
(zero), and every repeated function name checked for copy-paste
duplication — the one that looked suspicious, `todayKey()` in three
places, turned out to be a deliberate test-seam delegation chain
(`HeroSetStoreTest`'s double → `HeroSetClock.todayKey()` →
`HeroSetCalendar.todayKey()`), not duplicated logic.

Second pass (two background sub-agents, one per project, full line-by-line
read of every non-test source file against each project's own house rules
and ADRs — see "Open" items 2–3 above and the DESIGN.md fix above for what
they found): confirmed the first pass's conclusion at far higher
confidence — no new layering violations, no function/file over the
documented size ceilings beyond what's already tracked, no un-guarded
null/empty edge case in either project's domain logic beyond the one
divide-by-zero above, no magic numbers outside the Config/Layout/Palette
convention, no `has`-guard gaps against either project's own documented
device-capability tables. Both sub-agents independently used the phrase
"unusually disciplined" / "genuinely clean" — three small, honestly-caveated
items surfaced (one dead parameter, one stale doc, one unreachable-but-
worth-guarding division), nothing structural.

### ✅ `verden-site`: real Chromium pass — no findings, site is clean

Actually run this time (previous entries above only grepped source/build
output): installed `playwright-core` in the scratchpad (not the project —
nothing committed), pointed it at the pre-installed
`/opt/pw-browsers/chromium-1194` binary, served the real `dist/` build via
`vite preview`, and loaded all 7 pages headless. Checked per page: console
errors/warnings, failed network requests, page errors, missing `alt`,
empty/unlabeled links, heading structure, landmark elements, and
navigation-timing byte counts.

**Result: nothing to fix.** Zero console errors or warnings on any page,
zero failed requests, zero missing `alt` attributes, zero empty/unlabeled
links, exactly one `<h1>` per page, 4–6 landmark elements per page,
`lang="en"` set. Heaviest page (`/heroset/`, `/heroface/`) transfers
~182KB total including web fonts; lightest (`/`) ~95KB. No CLS/blocking
concerns visible in `domContentLoadedEventEnd` (18–45ms across all 7
pages, served locally so not representative of real network latency, but
confirms no render-blocking resource pileup).

## Not investigated this pass

- Battery/allocation profiling inside `onUpdate`/`onPartialUpdate` beyond
  the static text-draw check above — needs a device or simulator profiler,
  not available in this container.
- Color-contrast ratios and focus-visibility/tab-order — the Chromium pass
  above checked structure and errors, not pixel-level contrast; would need
  `axe-core` or similar injected into the page, not done this pass.
- `HeroSetStoreTest.mc` (377 lines) exceeds the 250-line file budget and
  isn't listed alongside `HeroSetStore.mc` (330 lines) in
  `HeroSet/docs/architecture.md` §8's known-debt table — noted but not
  sized into an item this pass; low confidence it's worth splitting versus
  just documenting the debt.
