# Verden site — CLAUDE.md

This site public website for **Verden** — studio name for user apps. One site serve all app: studio home, plus landing, support, privacy page per app. HeroSet first app; **more apps from other repos come later**, so keep everything app-agnostic outside `src/apps/<slug>/`.

`README.md` = commands, routes, how add app. `DESIGN.md` = visual system (read before any UI change).

## Hosting

- Repo: private GitHub `verden11/watches-site`, branch `main`.
- Live at **https://verden.watch/** (primary; `www` and http redirect there). Host: Netlify site `verden-watch` (also live at https://verden-watch.netlify.app/). Every push to `main` build and deploy via `netlify.toml` (Node 26, `npm run build`, publish `dist/`, cache + security headers). HTTPS: Netlify-managed Let's Encrypt, auto-renew.
- Domain `verden.watch` register at Hostinger; DNS stay at Hostinger (not Netlify DNS): `A @ 75.2.60.5`, `CNAME www verden-watch.netlify.app`, plus Hostinger mail records (MX `mx1`/`mx2.hostinger.com`, SPF, DKIM `hostingermail-a/b/c`, DMARC). No touch mail records when edit web ones.
- Contact inbox: `hello@verden.watch` (Hostinger Mail); set in `src/site.ts`.
- Netlify visitor access / site protection must stay **off**: store reviewer and user must reach support and privacy page without login.
- Keep Netlify Analytics, Forms, Identity, snippet injection off: privacy page promise no analytics, no third-party script.

## Linked app repos

Each app live in own repo; this site only hold public pages. App repo docs point back here.

| App | Site folder | Pages | App repo (local) | Copy must match |
|---|---|---|---|---|
| HeroSet (Garmin Connect IQ) | `src/apps/heroset/` | `/heroset/`, `/heroset/support/`, `/heroset/privacy/` | `../HeroSet` | `../HeroSet/docs/release-contract.md` (claims), `docs/compatibility.md` (watch list → `facts.ts`) |
| HeroFace (Garmin Connect IQ watch face) | `src/apps/heroface/` | `/heroface/`, `/heroface/support/`, `/heroface/privacy/` | `../heroFace` | `../heroFace/docs/compatibility.md` (watch list + count → `facts.ts`), `docs/go-to-market.md` (claims) |

Support and privacy URLs get entered in each app store listing, so **never change or remove published app URL**.

Add app from another repo:
1. Add `src/apps/<slug>/` + one line in `src/apps/index.ts` (see README).
2. Add row to table above.
3. In app repo docs, note public pages live here, with URLs.

## Rules

- Zero client JS: React run only at build time. No add hydration, analytics, third-party script; privacy page say none exist.
- App user-facing claim come from that app repo docs, not from memory. Behavior change there → update page here (and privacy page effective date if data handling change).
- Contact email live only in `src/site.ts`.
- No affiliation/trademark footer, no third-party service name (e.g. Strava) unless truly needed; privacy page stay minimal.