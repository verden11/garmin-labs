# Verden site — CLAUDE.md

This site public website for **Verden** — studio name for user apps. One site serve all app: studio home, plus landing, support, privacy page per app. HeroSet first app; **more apps come later**, so keep everything app-agnostic outside `src/apps/<slug>/`.

`README.md` = commands, routes, how add app. `DESIGN.md` = visual system (read before any UI change).

## Hosting

- Repo: private GitHub `verden11/garmin-labs`, branch `main` — monorepo; this site is the `verden-site/` folder.
- Live at **https://verden.watch/** (primary; `www` and http redirect there). Host: Firebase Hosting, project `verden-watch-87da4` (also live at https://verden-watch-87da4.web.app/). Deploy by hand: `npm run deploy` (build, then `firebase deploy --only hosting`; needs `firebase login`). Cache + security headers in `firebase.json`. HTTPS: Firebase-managed cert, auto-renew.
- Domain `verden.watch` register at Hostinger; DNS stay at Hostinger: `A @ 199.36.158.100`, `TXT @ hosting-site=verden-watch-87da4`, `CNAME www verden-watch-87da4.web.app`, plus Hostinger mail records (MX `mx1`/`mx2.hostinger.com`, SPF, DKIM `hostingermail-a/b/c`, DMARC). No touch mail records when edit web ones.
- Contact inbox: `hello@verden.watch` (Hostinger Mail); set in `src/site.ts`.
- Site must stay public: store reviewer and user must reach support and privacy page without login.
- Keep Firebase Analytics / Google Analytics off for the Hosting site: privacy page promise no analytics, no third-party script.

## Linked apps

Each app live in own top-level folder of the monorepo; this site only hold public pages. App docs point back here.

| App | Site folder | Pages | App folder | Copy must match |
|---|---|---|---|---|
| HeroSet (Garmin Connect IQ) | `src/apps/heroset/` | `/heroset/`, `/heroset/support/`, `/heroset/privacy/` | `../HeroSet` | `../HeroSet/docs/release-contract.md` (claims), `docs/compatibility.md` (watch list → `facts.ts`) |
| HeroFace (Garmin Connect IQ watch face) | `src/apps/heroface/` | `/heroface/`, `/heroface/support/`, `/heroface/privacy/` | `../HeroFace` | `../HeroFace/docs/compatibility.md` (watch list + count → `facts.ts`), `docs/go-to-market.md` (claims) |

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
- No affiliation/trademark footer, no third-party service name (e.g. Strava) unless truly needed; privacy page stay minimal.