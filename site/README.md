# Verden site

Static website for Verden apps: studio home + per-app landing page, support page, privacy policy. HeroSet first app; more apps, each own folder, to be added. `CLAUDE.md` lists linked apps, hosting setup.

Vite + React + TypeScript, React runs only at build time: every page prerendered to plain HTML + CSS. Browser gets no JavaScript -> pages work with JS off; deep links such as `/heroset/privacy/` work on any static host without rewrite rules.

## Commands

```sh
npm install
npm run dev       # http://localhost:5173, pages rendered on request
npm run build     # type-check, build CSS/fonts, prerender every route into dist/
npm run preview   # serve dist/
npm run deploy    # build + firebase deploy --only hosting
```

**No horizontal scroll on phones** (check after any layout change; must print "no horizontal overflow"):

```sh
npm run build && (cd dist && python3 -m http.server 8765 &) && sleep 1
node scripts/check-overflow.mjs http://127.0.0.1:8765 $(cd dist && find . -name index.html | sed 's|^\.||; s|index.html$||') /404.html   # SHOTS=<dir> also saves phone screenshots
```

Loads each page with phone emulation at 320, 360, 375, 414 px, names any element past right edge. (Plain headless `--window-size=375` screenshot not phone view: lays out at about 500 px, crops.)

Hosted on Firebase Hosting (project `verden-watch-87da4`, config `firebase.json`): `npm run deploy`. Serve from domain root (links root-absolute). Any other static host works: upload `dist/`. `dist/404.html` = not-found page other hosts pick up automatically.

## Routes

| URL | Page |
|---|---|
| `/` | Studio home, lists every app |
| `/<slug>/` | App landing page |
| `/<slug>/support/` | App support + FAQ (put in store listing) |
| `/<slug>/privacy/` | App privacy policy (put in store listing) |

Routes from app registry -> adding app adds its three pages.

## Adding an app

1. Create `src/apps/<slug>/` with `app.ts` exporting `App` (`src/apps/types.ts`): name, summary, field color + readable ink on it (at least 4.5:1, or build fails), mark, `Landing`, `Support`, `Privacy` components; `storeUrl` once live, plus `freeStoreUrl` when free twin exists (then `storeUrl` = Pro listing, store action splits in two, landing uses `FreeOrPro`). Copy `src/apps/heroset/` as start.
2. Add to list in `src/apps/index.ts`.
3. `npm run build`.

Studio mark (color bars in header + favicon) grows one bar per app. Update `public/favicon.svg` by hand to match.

## Layout

```
src/
  site.ts               studio name, tagline, contact email, canonical origin
  urls.ts               appUrl(): the one place app URLs are spelled (published, never change)
  entry-server.tsx      route table + render(url) used by dev server and prerender
  components/           Shell (studio bar, footer), AppPage (app bar + tabs), Doc (reading layout),
                        AppSections (store button, screens, watch list, closing call shared by landings)
  pages/                Home, NotFound
  apps/<slug>/          one folder per app: registry entry, pages, app-specific graphics and facts
  styles/global.css     tokens and all styles
prerender.ts            writes dist/<route>/index.html, dist/404.html and dist/sitemap.xml
vite.config.ts          dev middleware that renders pages on request
```

## HeroSet specifics

- Copy bound by HeroSet `docs/release-contract.md`: no accuracy numbers, prices, invented screenshots. Check before changing any claim.
- `src/apps/heroset/facts.ts` mirrors HeroSet `docs/compatibility.md` (watch list) + language list. Update both together.
- Screenshot slots in `facts.ts` render "Screenshot pending" until simulator captures of store build added: drop PNGs in `public/heroset/screens/`, set each `src` (e.g. `/heroset/screens/dashboard.png`).
- `storeUrl` in `src/apps/heroset/app.ts` set (live since 2026-09-21); without it store button falls back to "Coming soon" status.
- Watch list may only name watches in **live** store build: HeroSet changes adding products ship to site after upload approved, never before.
- Rank scale on landing page computed from HeroSet rank rule (300 × min(r, 14) XP per rank, 600 XP per full day). Rule changes -> update `RankScale.tsx`.

## HeroFace specifics

- `src/apps/heroface/facts.ts` mirrors HeroFace `docs/compatibility.md` (129 watches from manifests via `scripts/watch-families.py`, 72 on Connect IQ 4.2+ that can link to HeroSet) + language list. Free, Pro share page: `freeStoreUrl` = HeroFace (free), `storeUrl` = HeroFace Pro.
- `src/apps/days-to-go/`: `storeUrl` = Days To Go Pro, `freeStoreUrl` = Days To Go (free); one shared page with "Free or Pro." band. `facts.ts` has watch list from manifests. Slug has hyphen: `dist/days-to-go/index.html` verified.
- `FacePreview.tsx` redraws face in SVG from HeroFace `HeroFaceLayout.mc` proportions; watch layout changes -> update.
- Claims follow HeroFace `docs/status.md` ("Claims allowed and forbidden"). Screen checks cover every screen size, not every model: say so.

## Two Suns specifics

- `src/apps/two-suns/`: `storeUrl` = Two Suns Pro, `freeStoreUrl` = Two Suns (free). Its `facts.ts` holds name (`appName`), language list, Pro permission list (mirrors `TwoSuns/manifest.xml`), watch list. Privacy page has separate free-face section (no location, no place or history kept).
- `FacePreview.tsx` = drawing from SVG primitives with example numbers, captioned not a screenshot on landing page. Replace with real captures (`Screens`) once owner has them.
- Claims follow `TwoSuns/docs/spec.md` "Claims that may be made": no sunrise-matches-the-glance claim, no works-without-GPS-or-phone claim until device checks pass.