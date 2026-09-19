# Verden site — CLAUDE.md

Public website for **Verden**, the studio name for the user's apps. One site serves every app: a studio home, plus a landing, support and privacy page per app. HeroSet is the first app; **more apps from other repos will be added over time**, so keep everything app-agnostic outside `src/apps/<slug>/`.

`README.md` = commands, routes, how to add an app. `DESIGN.md` = visual system (read before any UI change).

## Hosting

- Repo: private GitHub `verden11/watches-site`, branch `main`.
- Live at **https://verden.watch/** (primary; `www` and http redirect there). Host: Netlify site `verden-watch` (also served at https://verden-watch.netlify.app/). Every push to `main` builds and deploys via `netlify.toml` (Node 26, `npm run build`, publish `dist/`, cache + security headers). HTTPS: Netlify-managed Let's Encrypt, auto-renews.
- Domain `verden.watch` registered at Hostinger; DNS stays at Hostinger (not Netlify DNS): `A @ 75.2.60.5`, `CNAME www verden-watch.netlify.app`, plus Hostinger mail records (MX `mx1`/`mx2.hostinger.com`, SPF, DKIM `hostingermail-a/b/c`, DMARC). Don't touch the mail records when editing web ones.
- Contact inbox: `hello@verden.watch` (Hostinger Mail); set in `src/site.ts`.
- Netlify visitor access / site protection must stay **off**: store reviewers and users must reach support and privacy pages without login.
- Keep Netlify Analytics, Forms, Identity and snippet injection off: the privacy pages promise no analytics or third-party scripts.

## Linked app repos

Each app lives in its own repo; this site only holds its public pages. The app repo's docs point back here.

| App | Site folder | Pages | App repo (local) | Copy must match |
|---|---|---|---|---|
| HeroSet (Garmin Connect IQ) | `src/apps/heroset/` | `/heroset/`, `/heroset/support/`, `/heroset/privacy/` | `../HeroSet` | `../HeroSet/docs/release-contract.md` (claims), `docs/compatibility.md` (watch list → `facts.ts`) |

The support and privacy URLs are entered in each app's store listing, so **never change or remove a published app URL**.

Adding an app from another repo:
1. Add `src/apps/<slug>/` + one line in `src/apps/index.ts` (see README).
2. Add a row to the table above.
3. In the app repo's docs, note that its public pages live here, with their URLs.

## Rules

- Zero client JS: React runs only at build time. Don't add hydration, analytics or third-party scripts; the privacy pages say there are none.
- An app's user-facing claims come from that app's repo docs, not from memory. Behavior change there → update its pages here (and its privacy page's effective date if data handling changes).
- Contact email lives only in `src/site.ts`.
- No affiliation/trademark footers and no third-party service names (e.g. Strava) unless genuinely needed; privacy pages stay minimal.
