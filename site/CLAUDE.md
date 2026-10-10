# Verden site — CLAUDE.md

This site public website for **Verden** — studio name for user apps. One site serve all app: studio home, plus landing, support, privacy page per app. HeroSet first app; **more apps come later**, so keep everything app-agnostic outside `src/apps/<slug>/`.

`README.md` = commands, routes, how add app. [`DESIGN.md`](DESIGN.md) = visual system (read before any UI change).

## Hosting

- Repo: private GitHub `verden11/garmin-labs`, branch `main` — monorepo; this site is the `site/` folder.
- Live at **https://verden.watch/** (primary; `www` and http redirect there). Host: Firebase Hosting, project `verden-watch-87da4` (also live at https://verden-watch-87da4.web.app/). Deploys on push to `main` by the GitHub Action "Deploy to Firebase Hosting on merge" (about 30 s; check `gh run list`). By hand only as a fallback: `npm run deploy` (build, then `firebase deploy --only hosting`; needs `firebase login`). Cache + security headers in `firebase.json`. HTTPS: Firebase-managed cert, auto-renew.
- Domain `verden.watch` register at Hostinger; DNS stay at Hostinger: `A @ 199.36.158.100`, `TXT @ hosting-site=verden-watch-87da4`, `TXT @ google-site-verification=CCP2Z_N-J1YWH-TQXRpQfL5iTnCcqExUXeHDP3zeSwY` (Search Console Domain property, 2026-10-10; keep it or verification lapses), `CNAME www verden-watch-87da4.web.app`, plus Hostinger mail records (MX `mx1`/`mx2.hostinger.com`, SPF, DKIM `hostingermail-a/b/c`, DMARC). No touch mail records when edit web ones.
- `_dmarc` TXT is `v=DMARC1; p=quarantine; rua=mailto:hello@verden.watch` since 2026-10-10 (was `p=none` from 2026-09-26; no rua reports arrived, a test mail to Gmail passed SPF, DKIM `hostingermail1` and DMARC).
- Contact inbox: `hello@verden.watch` (Hostinger Mail); set in `src/site.ts`.
- `public/.well-known/security.txt` (RFC 9116): contact + `Expires` 2027-10-10, renew yearly (ROADMAP 6.7). Firebase `ignore` skips only `.DS_Store`, not every dotfile, so `.well-known/` deploys; keep it that way. Email change → update this file too.
- Site must stay public: store reviewer and user must reach support and privacy page without login.
- Keep Firebase Analytics / Google Analytics off for the Hosting site: privacy page promise no analytics, no third-party script.

## Linked apps

Each app live in own top-level folder of the monorepo; this site only hold public pages. App docs point back here.

| App | Site folder | Pages | App folder | Copy must match |
|---|---|---|---|---|
| HeroSet (Garmin Connect IQ) | `src/apps/heroset/` | `/heroset/`, `/heroset/support/`, `/heroset/privacy/` | `../HeroSet` | [`../HeroSet/docs/release-contract.md`](../HeroSet/docs/release-contract.md) (claims), `docs/compatibility.md` (watch list → `facts.ts`) |
| HeroFace (Garmin Connect IQ watch face) | `src/apps/heroface/` | `/heroface/`, `/heroface/support/`, `/heroface/privacy/` | `../HeroFace` | [`../HeroFace/docs/compatibility.md`](../HeroFace/docs/compatibility.md) (watch list + count → `facts.ts`), `docs/status.md` (claims) |
| Days To Go (Garmin Connect IQ watch face; store URL set in `app.ts`) | `src/apps/days-to-go/` | `/days-to-go/`, `/days-to-go/support/`, `/days-to-go/privacy/` | `../DaysToGo` | [`../DaysToGo/docs/release-contract.md`](../DaysToGo/docs/release-contract.md) (claims); no watch list in `facts.ts` until a store build is live |
| Two Suns (Garmin Connect IQ watch face; store URL set in `app.ts`) | `src/apps/two-suns/` | `/two-suns/`, `/two-suns/support/`, `/two-suns/privacy/` | `../TwoSuns` | `../TwoSuns/docs/spec.md` ("Claims that may be made"); no watch list in `facts.ts` until a store build is live; the name is one constant (`appName` in `facts.ts`), the slug never changes once published |
| DayArc (Garmin Connect IQ watch face, free; live since 2026-10-05, store URL in `app.ts`) | `src/apps/day-arc/` | `/day-arc/`, `/day-arc/support/`, `/day-arc/privacy/` | `../DayArc` | `../DayArc/docs/release-contract.md` (claims); no device list in `facts.ts` — the watch face has no location-derived claims to caveat |
| DayArc Pro (Garmin Connect IQ watch face, paid; live since 2026-10-05, store URL in `app.ts`) | `src/apps/day-arc-pro/` | `/day-arc-pro/`, `/day-arc-pro/support/`, `/day-arc-pro/privacy/` | `../DayArc` (same project, second manifest/jungle — `docs/decisions.md` ADR-003) | `../DayArc/docs/release-contract.md` (same contract as DayArc) |

Support and privacy URLs get entered in each app store listing, so **never change or remove published app URL**.

Add app:
1. Add `src/apps/<slug>/` + one line in `src/apps/index.ts` (see README).
2. Add row to table above.
3. In app docs, note public pages live here, with URLs.

## Rules

- CSP is **enforced** (`firebase.json`, live 2026-09-26): `default-src 'none'`, own-origin style/font/img only. Inline `style=""` attr OK; inline `<style>`, `data:` URI, any external origin (font CDN, embed, analytics) get blocked. Need one → change CSP in same commit, re-check with `ReportingObserver` (`csp-violation`, `buffered: true`) on every route.
- Zero client JS: React run only at build time. No add hydration, analytics, third-party script; privacy page say none exist.
- App user-facing claim come from that app's docs, not from memory. Behavior change there → update page here (and privacy page effective date if data handling change).
- Contact email live only in `src/site.ts`.
- Accessibility: WCAG 2.2 AA, audited 2026-10-10 (axe-core on every route, light/dark, 1280/375 px, plus keyboard, text-spacing and 320 px checks; no screen-reader pass yet). The build fails if an app's `onColor` on `color` is under 4.5:1 (`entry-server.tsx`). A new watch language needs its code in `LANG` (`AppSections.tsx`).
- SEO head (title, description, canonical, OG, JSON-LD) is built in `render()` in `src/entry-server.tsx`; `studio.intro` names no app (only kinds: "a rep counter and a set of watch faces"), so it stays true as faces are added; reword it when a new kind ships (widget, phone app). JSON-LD carries no `offers`/price (no price numbers anywhere, prices vary by region) and no rating.
- No affiliation/trademark footer, no third-party service name (e.g. Strava) unless truly needed; privacy page stay minimal.