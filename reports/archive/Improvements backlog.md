# Improvements backlog

> **Reconciled with `main` 2026-09-25.** This backlog was written on a branch cut
> before `main`'s site work, and its "Done" entries describe that branch's
> implementations. Where `main` differs, `main` wins:
> - **CTA button fix, OG/canonical tags, sitemap, robots.txt:** `main` has its own
>   versions (`.field a:not(.button)`, `sitemap()` in `entry-server.tsx`). The
>   branch's copies were dropped.
> - **CSP:** `main` ships it **report-only** with a stricter policy (HeroSet
>   go-to-market item C2 enforces it after a deploy-preview check). The branch's
>   enforced `'unsafe-inline'` policy was not taken.
> - **HSTS:** taken, but `max-age=31536000` without `includeSubDomains`, as an
>   unconfirmed two-year, all-subdomain commitment is hard to undo.
> - **Taken as written:** Twitter tags, `og:image`, JSON-LD, screenshot `size`,
>   HeroFace `DESIGN.md` accent fix.
> - The opportunity list moved with it: see `Opportunities backlog.md`.

Status: 2026-09-25. Incremental, implementable-cold findings from read-only
+ measured audit of all three projects. Not `HeroSet/docs/ideas.md`
(feature ideas) — this = small correctness/perf/quality gains.

Each item states verification status. Anything under `HeroSet/`/`HeroFace/`
**not** compiled or run here (no `monkeyc`/simulator/device in container) — read-only findings, marked `unverified: needs local
monkeyc build + sim + device`. Simulator passing not device proof either;
say so when reporting on those.

Ranked by gain/effort, strongest evidence first.

---

## Done

### ✅✅ CRITICAL, confirmed live on `main` — the store CTA button was invisible on both app landing pages — fixed

Found by background sub-agent running real axe-core accessibility
scan (not just structural checks) against built `dist/` output via
pre-installed Chromium. `site/src/styles/global.css:117`:
`.field a { color: inherit; }` has CSS specificity (0,1,1) — type
selector (`a`) plus class (`.field`) — **beats** `.button`'s
`color: var(--field)` at specificity (0,1,0), regardless of which rule
comes later in file. `.button`'s `background` is
`var(--on-field)`, inherited `color` also `var(--on-field)`,
so "Get it on the Connect IQ Store" button rendered **identical
text and background color — completely invisible text** — on every page
with live store link (`/heroset/`, `/heroface/`, hero section and
closing-band CTA, 4 instances total).

**Confirmed live in production, not just this session's branch**:
`git show main:site/src/styles/global.css` has exact same
bug — shipped to verden.watch, site's actual store-conversion
button unreadable for real visitors until this fix.

**How caught**: axe-core did not report as hard "violation" —
flagged 4 elements under `color-contrast` **incomplete** ("1:1
contrast ratio with the background"), so plain
violation-count check (earlier Chromium pass in this file, only
checked structure/console-errors/alt-text) would not have caught it. Sub-agent's manual follow-up on every `incomplete` axe result — plus direct `getComputedStyle` check and screenshot — surfaced it.

**Fixed**: `.field a { color: inherit; }` → `.field :where(a) { color:
inherit; }`. `:where()` zero specificity contribution, so rule
still applies to plain text links inside `.field` (behavior unchanged)
but no longer outranks `.button`'s own `color` rule by specificity
— cascade order decides, `.button` (declared later) wins as
originally intended. **Verified three ways**: (1) real build, (2) real
browser `getComputedStyle` check on live `.button` element —
`color: rgb(255, 170, 0)` (intended amber `--field`) against
`background: rgb(21, 19, 15)` (`--on-field`), correct contrast restored;
(3) confirmed same CSS with actual shipped CSP header served (not
just built) produces zero console/CSP errors — fix doesn't interact
with CSP in this file's other entries.

### ✅ `site`: JSON-LD structured data on both app landing pages — shipped

Gap found by same sub-agent: zero `application/ld+json` anywhere
on site (confirmed via grep on `src/` and `dist/`, full read of
`entry-server.tsx`). Added `SoftwareApplication` schema, emitted only
on `landing` routes (not support/privacy/home), built from data already
in each app's registry entry — no fabricated fields: `name`, `description`
(from `app.summary`), `applicationCategory: "HealthApplication"`,
`operatingSystem: "Garmin Connect IQ"`, canonical `url`, `sameAs`
pointing at Connect IQ Store listing when `storeUrl` exists. Checked
`HeroSet/docs/release-contract.md` for banned claim types first — no
price/rating fields emitted, none exist in site's data
model, avoiding risk of fabricating `offers`/`aggregateRating`
schema.org still expects.

**Verified**: real build produces expected `<script
type="application/ld+json">` tag with correct data on `/heroset/`
and `/heroface/` only, absent on `/`. Also verified against actual
shipped CSP header (`script-src 'self'`, no `'unsafe-inline'`) served
through local HTTP server with header attached — real concern
since inline `<script>` tags normally CSP-blocked — confirmed zero
console/CSP errors: `type="application/ld+json"` not treated as
executable script by browser, so not subject to `script-src`
at all. `</script>` escaped inside embedded JSON as defensive
measure (can't currently occur in this data, cheap to guard).

### ✅ `site`: Netlify header hardening (HSTS + Permissions-Policy) — shipped

Also from same sub-agent's Netlify config read. Added to
`netlify.toml`: `Strict-Transport-Security: max-age=63072000;
includeSubDomains` (site HTTPS-only via Netlify-managed cert per
`site/CLAUDE.md`; `includeSubDomains` safe since HSTS only
affects HTTP(S), not mail subdomain's SMTP/MX records) and
`Permissions-Policy: camera=(), microphone=(), geolocation=()` (zero
client JS site, no reason any of these ever requested).
**One thing container can't check, same limitation as CSP
entry above**: whether Netlify already injects HSTS by default for
custom domains — if so header = harmless duplicate; if not, now
explicit. Needs `curl -I` against live deploy to confirm either
way, not possible from here.

### ✅ `site`: `vite` patch bump 8.3.0 → 8.3.1 — shipped

`npm outdated` (run by sub-agent) found one outdated dependency, patch release already inside existing `^8.3.0` range in
`package.json` — not yet in lockfile. `npm update
vite` picked it up; `npm run build` still clean after. No other
outdated or unused dependencies found (checked: `react`, `react-dom`,
`@fontsource-variable/archivo`, all devDeps confirmed used).

### ✅ `site`: Open Graph / Twitter Card / canonical tags — shipped `4d275e7`

`entry-server.tsx`'s `head` now emits `og:*`, `twitter:*` and canonical
link per page, absolute URLs via new `studio.origin` constant in
`site.ts`. Verified: `npm run build` clean, `dist/heroset/index.html`
inspected directly — all tags present and absolute.

### ✅ `site`: `robots.txt` + `sitemap.xml` — shipped `4d275e7`

`public/robots.txt` added; `prerender.ts` now also writes
`dist/sitemap.xml` from same `routes` array HTML pages come from,
so cannot drift from route list. Verified: build output
inspected, all 7 routes present.

### ✅ `HeroSet`: `complication_label`/`complication_short` intentionally untranslated — already documented, no action needed

Diffed every translated string file against base; all 14 non-English
locales missing these two keys. Traced through
`HeroFace/source/HeroFaceLink.mc:86` and
`HeroSet/resources-complications/complications.xml:9`: protective,
not a gap — HeroFace matches literal `"HeroSet"` against
`complication.longLabel`, Connect IQ's base-locale fallback keeps that literal in place on every non-English build. Translating either
key would break HeroSet→HeroFace link (ADR-044) on that locale.
Re-checked before proposing doc fix: comment already exists at
`HeroSet/resources/strings/strings.xml:76-77` ("not translated, it is how
the face finds it"), present since repo's original import — nothing to
add.

(ADR-044 lacked gloss in source; kept bare as only given "HeroSet→HeroFace link (ADR-044)".)

### ✅ `site`: `Content-Security-Policy` header — shipped, needs one post-deploy check

Added to `site/netlify.toml`: `default-src 'self'; img-src 'self';
style-src 'self' 'unsafe-inline'; script-src 'self'; base-uri 'self';
frame-ancestors 'none'; object-src 'none'; form-action 'none'`.
`'unsafe-inline'` on styles required, real, documented
weakening: React SSR emits inline `style="..."` on every page (checked via
`grep -oc 'style="' dist/*.html dist/*/*.html dist/*/*/*.html` before
adding policy). `script-src 'self'` safe as written — re-checked
after adding, zero `<script>` tags anywhere in `dist/`. No `data:` URIs
in built CSS either. Stronger version (nonces, or moving accent
colors to CSS classes instead of inline `style`) would drop
`'unsafe-inline'` entirely — future step, not done here. **One thing container can't check**: `curl -I` against live Netlify deploy to
confirm header reaches browser.

### ✅ `site`: screenshot `width`/`height` now match file dimensions — shipped

Added optional `size` to `Screenshot` type (defaults 454), set
`size: 240` on HeroFace's two 240×240 shots in `facts.ts`, both
`Landing.tsx` files now render `width={shot.size ?? 454} height={shot.size
?? 454}`. Verified: build clean, `dist/heroface/index.html` shows
`width="240" height="240"` on two affected images, `454` elsewhere.
Correctness only — confirmed earlier no visible-blur effect since
`.screens img { width: 100% }` already renders below native size.

### ✅ `HeroFace`: `DESIGN.md`'s accent-white token contradicted shipped code — fixed

Found by background sub-agent cross-checking `DESIGN.md` against
`HeroFace/docs/archive/plan.md`, `HeroFacePalette.mc`, and
`resources/settings/settings.xml`. `DESIGN.md` front matter still
defined `accent-white: "#FFFFFF"` token, "Accent alternatives"
prose listed white as one of three settings-selectable accents, separate line still said "four user-selectable accents." But
`HeroFace/docs/archive/plan.md`'s finish-review item 3 records real, shipped
decision: "The white accent is gone: a white bar read as the clock's own
material. Three accents remain." Code agrees with `plan.md`, not old
`DESIGN.md`: `HeroFacePalette.ACCENTS` (`HeroFacePalette.mc:23`) has
exactly 3 entries — blue/cyan/magenta, no white — matching
`settings.xml`'s 3 `listEntry` values exactly.
`HeroFace/CLAUDE.md`'s own sync rule ("Behaviour change → update
`docs/archive/plan.md` (and `DESIGN.md` if it is visual)") followed on
`plan.md` side, missed on `DESIGN.md` side until now. **Fixed**:
removed `accent-white` token from front matter, "four" → "three"
accents, "Accent alternatives" now names only cyan and magenta. Doc-only,
zero compile risk, applied directly (unlike Monkey C findings below,
documented-only since container can't compile/verify
them).

---

## Open

### 1. `HeroFace`: Two draw calls bypass `HeroFaceDraw.text`, invisible to the screen-fit test — fix must also extend the harness

- `HeroFace/CLAUDE.md` states: "Text fit is measured, never guessed: draw
  through `HeroFaceDraw.text`." `HeroFaceDraw.text` itself
  (`HeroFace/source/HeroFaceDraw.mc:15-31`) = thin wrapper: calls
  `dc.drawText`, only when `misfits`/`boxes` non-null (test builds),
  records box so `everyStateFitsThisDisplay` can catch clipping/overlap.
- Two call sites skip wrapper, so text invisible to that
  instrumentation:
  - `HeroFace/source/HeroFaceView.mc:108` — seconds digits in
    `onPartialUpdate` (redraws once a second whenever seconds are on; same
    font/justify as the full-frame draw in `HeroFaceClock.mc:34`, so this is
    not a rendering-mismatch bug, just uninstrumented).
  - `HeroFace/source/HeroFaceSleep.mc:21` — dimmed always-on clock.
- **Checked and confirmed**: `HeroFace/source/test/HeroFaceScreenFitTest.mc`
  only calls `view.drawState(...)` (full-frame path) — never calls
  `onPartialUpdate` or `HeroFaceSleep.draw`. **Swapping the two
  `dc.drawText` calls alone adds zero coverage**, because harness never
  executes those two lines under test either way. HeroSet's own source has
  no equivalent violation (checked: `grep -rn "dc\.drawText" HeroSet/source
  --include=*.mc | grep -v HeroSetDraw.mc` → empty).
- **Fix, both parts required**: (a) swap two `dc.drawText(...)` calls
  for `HeroFaceDraw.text(dc, layout, ...)` — behavior-identical outside test
  builds; (b) add harness case calling `onPartialUpdate` (with `_secondsBox` primed by initial `drawState`) and one calling
  `HeroFaceSleep.draw`, wrapped in same `misfits`/`boxes` capture
  existing cases use.
- **Effort**: small (2 call sites + 2 new harness cases, following
  existing pattern in `HeroFaceScreenFitTest.mc`). **Verification**:
  `unverified: needs local monkeyc build + sim` per product. Simulator
  passing not device proof.

### 2. `HeroFace`: dead parameter in `HeroFaceFooter.iconSize`

Found by background sub-agent's independent read-through of all 20
HeroFace source files. `HeroFace/source/HeroFaceFooter.mc:38`:
```
private static function iconSize(layout as HeroFaceLayout) as Number {
    return Graphics.getFontAscent(Graphics.FONT_XTINY) * 2 / 3;
}
```
`layout` accepted, never referenced in body; all 3 call sites
(`HeroFaceFooter.mc:39,45,52`) pass it for nothing. Low stakes alone,
but quietly misleads future editor into thinking
parameter load-bearing. **Fix**: drop parameter, update 3
call sites. **Effort**: trivial. **Verification**: confirmed by direct
source read (not compiled) — exactly class of issue `monkeyc` compile would also flag statically, no device needed.

### 3. `HeroSet`: `HeroSetMissionBars.drawBar` divides by `goal` with no zero-guard — currently unreachable, still worth the one-line fix

Found by background sub-agent's full read-through of `HeroSet/source/`.
`HeroSet/source/ui/dashboard/HeroSetMissionBars.mc:106`:
```
var fill = done ? width : (count <= 0 ? 0 : width * count / goal);
```
Throws on integer divide-by-zero if `goal` ever 0. **Confirmed
currently unreachable**: every caller reaches `goal` through
`HeroSetStore.getGoal()` (`HeroSet/source/data/HeroSetStore.mc:161-166`,
falls back to `DEFAULT_MISSION_GOAL` on null/≤0) and
`HeroSetRules.clampGoal` clamps into `[10, 500]`
(`HeroSet/source/domain/HeroSetRules.mc:87-94`) — sub-agent checked
every constructor call of `HeroSetDashboardState` (production and both
test harnesses), none passes 0. **Worth fixing anyway**: every
comparable division elsewhere in codebase explicitly guarded
(`HeroSetLayout.ringSweepFor` guards `whole <= 0`,
`HeroSetComplicationPublisher.valueFor` guards `cost > 0 ? … : 0`) — this
only place pattern skipped, `HeroSetDashboardState` = plain public constructor with no invariant enforcement of its own, so future caller that stops routing through `getGoal()` could reintroduce live crash
silently. **Fix**: `var fill = (done || goal <= 0) ? width :
(count <= 0 ? 0 : width * count / goal);` — one line. **Effort**: trivial.
**Verification**: `unverified: needs local monkeyc build + sim` — builder should confirm guard doesn't change any of four
`HeroSetScreenFitTest` states' rendering (shouldn't, none hits
branch).

### 4. `site`: the one non-Latin-script word on the site silently falls back to a system font

Found by background sub-agent running real axe-core + font-coverage
check. Both app landing pages list all 15 supported languages, ending in
native-script `Українська` (`src/apps/heroset/facts.ts:18`,
`src/apps/heroface/facts.ts:24`). Three loaded Archivo Variable
woff2 subsets (confirmed via `@fontsource-variable/archivo`'s own
`unicode.json`: only `latin`, `latin-ext`, `vietnamese` shipped by
package at all — **no Cyrillic subset exists to add**, correcting
sub-agent's own suggested fix option, which assumed one might be
available) don't cover Cyrillic (U+0400–04FF), so that one word renders
in visibly different fallback font — real, screenshot-confirmed break
of `DESIGN.md`'s "one grotesque doing every job" rule, not theoretical gap.
- **Real options, correctly narrowed**: (a) pull in different font
  package/subset covering Cyrillic for just this one word (adds font-loading cost for one label in list — probably not worth it); (b)
  accept fallback as conscious, documented choice rather than silent gap, since one label among fifteen, not body copy.
- **Recommendation**: (b), with one-line note added to `DESIGN.md`'s
  typography section saying so explicitly — product/design call
  owner should make deliberately, not silently code
  around. **Not fixed here** — genuinely decision, not bug.
- **Effort**: trivial either way (one doc line, or one font-loading
  change). **Verification**: confirmed via direct read of font
  package's own `unicode.json` plus screenshot of rendered
  fallback — real, not speculative.

---

## Verified clean (no action needed)

### ✅ `HeroSet`/`HeroFace`: two source passes, second one deeper — 3 small items found, everything else clean

First pass (grep-level): both source trees checked for `TODO`/`FIXME`/
`XXX`/`HACK` (zero hits), `dc.drawText` bypasses re-checked in HeroSet
(zero), every repeated function name checked for copy-paste
duplication — one that looked suspicious, `todayKey()` in three
places, = deliberate test-seam delegation chain
(`HeroSetStoreTest`'s double → `HeroSetClock.todayKey()` →
`HeroSetCalendar.todayKey()`), not duplicated logic.

Second pass (two background sub-agents, one per project, full line-by-line
read of every non-test source file against each project's own house rules
and ADRs — see "Open" items 2–3 above and DESIGN.md fix above for what
found): confirmed first pass's conclusion at far higher
confidence — no new layering violations, no function/file over
documented size ceilings beyond what's already tracked, no un-guarded
null/empty edge case in either project's domain logic beyond the one
divide-by-zero above, no magic numbers outside Config/Layout/Palette
convention, no `has`-guard gaps against either project's own documented
device-capability tables. Both sub-agents independently used phrase
"unusually disciplined" / "genuinely clean" — three small, honestly-caveated
items surfaced (one dead parameter, one stale doc, one unreachable-but-
worth-guarding division), nothing structural.

### ✅ `site`: real Chromium pass — no findings, site is clean

Actually run this time (previous entries above only grepped source/build
output): installed `playwright-core` in scratchpad (not project —
nothing committed), pointed at pre-installed
`/opt/pw-browsers/chromium-1194` binary, served real `dist/` build via
`vite preview`, loaded all 7 pages headless. Checked per page: console
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

### ✅ `site`: real axe-core contrast/ARIA scan — found the one critical bug above, everything else clean

Background sub-agent went deeper than Chromium pass above: ran real
`axe.run()` (WCAG 2.0/2.1 A+AA + best-practice rules) against all 7
built pages. **Zero hard violations.** Only `incomplete`
(needs-manual-review) results: 4 store-button instances that
turned out to be critical bug fixed above, plus contrast-check
noise inside two decorative preview SVGs (`FacePreview.tsx`) — those
sit inside `role="img"` element, which already hides internal
text nodes from assistive tech, so axe's flag there not real a11y
gap. Tab order/focus-order-adjacent checks covered by axe's
best-practice ruleset, returned nothing, though scripted manual
Tab-key walkthrough not additionally run — lighter-confidence
"clean" than directly-measured contrast data.

Also checked and confirmed genuinely clean, not assumed:
- **Font subsetting not actually over-broad.** Real network requests
  traced per page: only `latin` subset (and `latin-ext` where needed
  for `fēnix`/`Português`/etc.) ever fetched — `vietnamese`
  subset exists in `dist/assets/` but modern browsers skip it via
  `unicode-range` since nothing on any page needs it. Only real gap in
  this area = Cyrillic fallback documented above, not over-fetching.
- **`tsconfig.json`'s strictness** already has `strict: true` plus
  `noUnusedLocals`/`noUnusedParameters`. Checked whether adding
  `noUncheckedIndexedAccess` would catch anything real: grepped all
  dynamic indexing in codebase, one hit
  (`Pictograms.tsx:25`'s `pose.head[0]`/`[1]`), fixed-length
  tuple type already exempt from that flag's narrowing. **Would not
  currently catch any real bug** — reasonable defensive default for
  future code, not sized as worth flipping today.
- **No redirect/legacy-URL gaps.** Checked git history of
  `src/apps/`: slugs only ever added, never renamed or removed,
  consistent with "never change a published URL" rule already followed.
- **`font-display: swap`** already present on all 3 `@font-face` rules
  (checked built CSS directly) — no invisible-text-on-load risk.
  One real gap: no `<link rel="preload">` for primary `latin`
  subset (one actually fetched on every route), would shave font-discovery round trip on real network — real LCP element = hero `<h1>` on every page (confirmed via real `PerformanceObserver`
  measurement), so font matters for it. Small, well-targeted,
  low-urgency addition, not done this pass — container can't
  produce real-network-latency number to size actual gain.

## Not investigated this pass

- Battery/allocation profiling inside `onUpdate`/`onPartialUpdate` beyond
  static text-draw check above — needs device or simulator profiler,
  not available in container.
- Color-contrast ratios and focus-visibility/tab-order — Chromium pass
  above checked structure and errors, not pixel-level contrast; would need
  `axe-core` or similar injected into page, not done this pass.
- `HeroSetStoreTest.mc` (377 lines) exceeds 250-line file budget and
  not listed alongside `HeroSetStore.mc` (330 lines) in
  `HeroSet/docs/architecture.md` §8's known-debt table — noted, not
  sized into item this pass; low confidence worth splitting versus
  just documenting debt.