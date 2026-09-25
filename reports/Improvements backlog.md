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

Status: 2026-09-25. Incremental, implementable-cold findings from a read-only
+ measured audit of all three projects. This is not `HeroSet/docs/ideas.md`
(feature ideas) — this is small correctness/perf/quality gains.

Each item states verification status. Anything under `HeroSet/`/`HeroFace/`
was **not** compiled or run here (no `monkeyc`/simulator/device in this
container) — those are read-only findings, marked `unverified: needs local
monkeyc build + sim + device`. Simulator passing is not device proof either;
say so when reporting on those.

Ranked by gain/effort, strongest evidence first.

---

## Done

### ✅✅ CRITICAL, confirmed live on `main` — the store CTA button was invisible on both app landing pages — fixed

Found by a background sub-agent running a real axe-core accessibility
scan (not just structural checks) against the built `dist/` output via
the pre-installed Chromium. `verden-site/src/styles/global.css:117`:
`.field a { color: inherit; }` has CSS specificity (0,1,1) — a type
selector (`a`) plus a class (`.field`) — which **beats** `.button`'s
`color: var(--field)` at specificity (0,1,0), regardless of which rule
comes later in the file. Since `.button`'s `background` is
`var(--on-field)` and the inherited `color` was also `var(--on-field)`,
the "Get it on the Connect IQ Store" button rendered with **identical
text and background color — completely invisible text** — on every page
with a live store link (`/heroset/`, `/heroface/`, both hero section and
closing-band CTA, 4 instances total).

**Confirmed live in production, not just on this session's branch**:
`git show main:verden-site/src/styles/global.css` has the exact same
bug — this shipped to verden.watch, the site's actual store-conversion
button was unreadable for real visitors until this fix.

**How it was caught**: axe-core didn't report it as a hard "violation" —
it flagged the 4 elements under `color-contrast` **incomplete** ("1:1
contrast ratio with the background"), which is why a plain
violation-count check (the earlier Chromium pass in this file, which only
checked structure/console-errors/alt-text) wouldn't have caught it. The
sub-agent's manual follow-up on every `incomplete` axe result — plus a
direct `getComputedStyle` check and a screenshot — is what surfaced it.

**Fixed**: `.field a { color: inherit; }` → `.field :where(a) { color:
inherit; }`. `:where()` has zero specificity contribution, so the rule
still applies to plain text links inside `.field` (unchanged behavior
there) but no longer outranks `.button`'s own `color` rule by specificity
— cascade order decides instead, and `.button` (declared later) wins as
originally intended. **Verified three ways**: (1) real build, (2) a real
browser `getComputedStyle` check on the live `.button` element —
`color: rgb(255, 170, 0)` (the intended amber `--field`) against
`background: rgb(21, 19, 15)` (`--on-field`), correct contrast restored;
(3) confirmed the same CSS with the actual shipped CSP header served (not
just built) produces zero console/CSP errors — the fix doesn't interact
with the CSP in this file's other entries.

### ✅ `verden-site`: JSON-LD structured data on both app landing pages — shipped

Found as a gap by the same sub-agent: zero `application/ld+json` anywhere
on the site (confirmed via grep on `src/` and `dist/`, and a full read of
`entry-server.tsx`). Added a `SoftwareApplication` schema, emitted only
on `landing` routes (not support/privacy/home), built from data already
in each app's registry entry — no fabricated fields: `name`, `description`
(from `app.summary`), `applicationCategory: "HealthApplication"`,
`operatingSystem: "Garmin Connect IQ"`, canonical `url`, and `sameAs`
pointing at the Connect IQ Store listing when `storeUrl` exists. Checked
`HeroSet/docs/release-contract.md` for banned claim types first — no
price/rating fields are emitted, since none exist in the site's data
model, avoiding any risk of fabricating an `offers`/`aggregateRating`
schema.org still expects.

**Verified**: real build produces the expected `<script
type="application/ld+json">` tag with correct data on `/heroset/`
and `/heroface/` only, absent on `/`. Also verified against the actual
shipped CSP header (`script-src 'self'`, no `'unsafe-inline'`) served
through a local HTTP server with the header attached — a real concern
since inline `<script>` tags are normally CSP-blocked — confirmed zero
console/CSP errors: `type="application/ld+json"` isn't treated as
executable script by the browser, so it isn't subject to `script-src`
at all. `</script>` is escaped inside the embedded JSON as a defensive
measure (can't currently occur in this data, but cheap to guard).

### ✅ `verden-site`: Netlify header hardening (HSTS + Permissions-Policy) — shipped

Also from the same sub-agent's Netlify config read. Added to
`netlify.toml`: `Strict-Transport-Security: max-age=63072000;
includeSubDomains` (site is HTTPS-only via Netlify-managed cert per
`verden-site/CLAUDE.md`; `includeSubDomains` is safe since HSTS only
affects HTTP(S), not the mail subdomain's SMTP/MX records) and
`Permissions-Policy: camera=(), microphone=(), geolocation=()` (zero
client JS site, no reason any of these should ever be requested).
**One thing this container can't check, same limitation as the CSP
entry above**: whether Netlify already injects HSTS by default for
custom domains — if so this header is a harmless duplicate; if not, it's
now explicit. Needs a `curl -I` against the live deploy to confirm either
way, not possible from here.

### ✅ `verden-site`: `vite` patch bump 8.3.0 → 8.3.1 — shipped

`npm outdated` (run by the sub-agent) found one outdated dependency, a
patch release already inside the existing `^8.3.0` range in
`package.json` — just not reflected in the lockfile yet. `npm update
vite` picked it up; `npm run build` still clean afterward. No other
outdated or unused dependencies found (checked: `react`, `react-dom`,
`@fontsource-variable/archivo`, and all devDeps confirmed actually used).

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
`HeroFace/source/HeroFaceLink.mc:86` and
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
`size: 240` on HeroFace's two 240×240 shots in `facts.ts`, both
`Landing.tsx` files now render `width={shot.size ?? 454} height={shot.size
?? 454}`. Verified: build clean, `dist/heroface/index.html` shows
`width="240" height="240"` on the two affected images, `454` elsewhere.
Correctness only — confirmed earlier this had no visible-blur effect since
`.screens img { width: 100% }` already renders below native size.

### ✅ `HeroFace`: `DESIGN.md`'s accent-white token contradicted shipped code — fixed

Found by a background sub-agent cross-checking `DESIGN.md` against
`HeroFace/docs/plan.md`, `HeroFacePalette.mc`, and
`resources/settings/settings.xml`. `DESIGN.md`'s front matter still
defined an `accent-white: "#FFFFFF"` token and its "Accent alternatives"
prose listed white as one of three settings-selectable accents, and a
separate line still said "four user-selectable accents." But
`HeroFace/docs/plan.md`'s finish-review item 3 records a real, shipped
decision: "The white accent is gone: a white bar read as the clock's own
material. Three accents remain." Code agrees with `plan.md`, not the old
`DESIGN.md`: `HeroFacePalette.ACCENTS` (`HeroFacePalette.mc:23`) has
exactly 3 entries — blue/cyan/magenta, no white — matching
`settings.xml`'s 3 `listEntry` values exactly.
`HeroFace/CLAUDE.md`'s own sync rule ("Behaviour change → update
`docs/plan.md` (and `DESIGN.md` if it is visual)") was followed on the
`plan.md` side and missed on the `DESIGN.md` side until now. **Fixed**:
removed the `accent-white` token from the front matter, "four" → "three"
accents, "Accent alternatives" now names only cyan and magenta. Doc-only,
zero compile risk, applied directly (unlike the Monkey C findings below,
which stay documented-only since this container can't compile/verify
them).

---

## Open

### 1. `HeroFace`: Two draw calls bypass `HeroFaceDraw.text`, invisible to the screen-fit test — fix must also extend the harness

- `HeroFace/CLAUDE.md` states: "Text fit is measured, never guessed: draw
  through `HeroFaceDraw.text`." `HeroFaceDraw.text` itself
  (`HeroFace/source/HeroFaceDraw.mc:15-31`) is a thin wrapper: it calls
  `dc.drawText` and, only when `misfits`/`boxes` are non-null (test builds),
  records the box so `everyStateFitsThisDisplay` can catch clipping/overlap.
- Two call sites skip the wrapper, so their text is invisible to that
  instrumentation:
  - `HeroFace/source/HeroFaceView.mc:108` — the seconds digits in
    `onPartialUpdate` (redraws once a second whenever seconds are on; same
    font/justify as the full-frame draw in `HeroFaceClock.mc:34`, so this is
    not a rendering-mismatch bug, just uninstrumented).
  - `HeroFace/source/HeroFaceSleep.mc:21` — the dimmed always-on clock.
- **Checked and confirmed**: `HeroFace/source/test/HeroFaceScreenFitTest.mc`
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

### 2. `HeroFace`: dead parameter in `HeroFaceFooter.iconSize`

Found by a background sub-agent's independent read-through of all 20
HeroFace source files. `HeroFace/source/HeroFaceFooter.mc:38`:
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

### 4. `verden-site`: the one non-Latin-script word on the site silently falls back to a system font

Found by a background sub-agent running a real axe-core + font-coverage
check. Both app landing pages list all 15 supported languages, ending in
native-script `Українська` (`src/apps/heroset/facts.ts:18`,
`src/apps/heroface/facts.ts:24`). The three loaded Archivo Variable
woff2 subsets (confirmed via `@fontsource-variable/archivo`'s own
`unicode.json`: only `latin`, `latin-ext`, `vietnamese` are shipped by
this package at all — **no Cyrillic subset exists to add**, correcting
the sub-agent's own suggested fix option, which assumed one might be
available) don't cover Cyrillic (U+0400–04FF), so that one word renders
in a visibly different fallback font — a real, screenshot-confirmed break
of `DESIGN.md`'s "one grotesque doing every job" rule, not just a
theoretical gap.
- **Real options, correctly narrowed**: (a) pull in a different font
  package/subset that does cover Cyrillic for just this one word (adds a
  font-loading cost for one label in a list — probably not worth it); (b)
  accept the fallback as a conscious, documented choice rather than a
  silent gap, since it's one label among fifteen, not body copy.
- **Recommendation**: (b), with a one-line note added to `DESIGN.md`'s
  typography section saying so explicitly — this is a product/design call
  the owner should make deliberately, not something to silently code
  around. **Not fixed here** — genuinely a decision, not a bug.
- **Effort**: trivial either way (one doc line, or one font-loading
  change). **Verification**: confirmed via direct read of the font
  package's own `unicode.json` plus a screenshot of the rendered
  fallback — real, not speculative.

---

## Verified clean (no action needed)

### ✅ `HeroSet`/`HeroFace`: two source passes, second one deeper — 3 small items found, everything else clean

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

### ✅ `verden-site`: real axe-core contrast/ARIA scan — found the one critical bug above, everything else clean

A background sub-agent went deeper than the Chromium pass above: ran a
real `axe.run()` (WCAG 2.0/2.1 A+AA + best-practice rules) against all 7
built pages. **Zero hard violations.** The only `incomplete`
(needs-manual-review) results were the 4 store-button instances that
turned out to be the critical bug fixed above, plus contrast-check
noise inside the two decorative preview SVGs (`FacePreview.tsx`) — those
sit inside a `role="img"` element, which already hides their internal
text nodes from assistive tech, so axe's flag there isn't a real a11y
gap. Tab order/focus-order-adjacent checks are covered by axe's
best-practice ruleset and returned nothing, though a scripted manual
Tab-key walkthrough wasn't additionally run — call that a lighter-confidence
"clean" than the directly-measured contrast data.

Also checked and confirmed genuinely clean, not just assumed:
- **Font subsetting is not actually over-broad.** Real network requests
  traced per page: only the `latin` subset (and `latin-ext` where needed
  for `fēnix`/`Português`/etc.) is ever fetched — the `vietnamese`
  subset exists in `dist/assets/` but modern browsers skip it via
  `unicode-range` since nothing on any page needs it. The one real gap in
  this area is the Cyrillic fallback documented above, not over-fetching.
- **`tsconfig.json`'s strictness** already has `strict: true` plus
  `noUnusedLocals`/`noUnusedParameters`. Checked whether adding
  `noUncheckedIndexedAccess` would catch anything real: grepped all
  dynamic indexing in the codebase, found one hit
  (`Pictograms.tsx:25`'s `pose.head[0]`/`[1]`), which is a fixed-length
  tuple type already exempt from that flag's narrowing. **Would not
  currently catch any real bug** — reasonable defensive default for
  future code, not sized as worth flipping today.
- **No redirect/legacy-URL gaps.** Checked git history of
  `src/apps/`: slugs were only ever added, never renamed or removed,
  consistent with the "never change a published URL" rule already being
  followed.
- **`font-display: swap`** already present on all 3 `@font-face` rules
  (checked the built CSS directly) — no invisible-text-on-load risk.
  The one real gap: no `<link rel="preload">` for the primary `latin`
  subset (the one actually fetched on every route), which would shave a
  font-discovery round trip on a real network — a real LCP element is the
  hero `<h1>` on every page (confirmed via a real `PerformanceObserver`
  measurement), so the font matters for it. Small, well-targeted,
  low-urgency addition, not done this pass — this container can't
  produce a real-network-latency number to size the actual gain.

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
