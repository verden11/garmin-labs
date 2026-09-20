# Verden site

[![Netlify Status](https://api.netlify.com/api/v1/badges/d26d0261-d940-4cf3-bf49-d3a10d635897/deploy-status)](https://app.netlify.com/projects/verden-watch/deploys)

Static website for Verden apps: a studio home plus, for each app, a landing page, a support page and a privacy policy. HeroSet is the first app; more apps, each from its own repo, will be added. `CLAUDE.md` lists the linked app repos and the hosting setup.

Vite + React + TypeScript, but React only runs at build time: every page is prerendered to plain HTML + CSS. The browser gets no JavaScript, so pages work with JS off, and deep links such as `/heroset/privacy/` work on any static host without rewrite rules.

## Commands

```sh
npm install
npm run dev       # http://localhost:5173, pages rendered on request
npm run build     # type-check, build CSS/fonts, prerender every route into dist/
npm run preview   # serve dist/
```

Hosted on Netlify: pushing to `main` builds and deploys using `netlify.toml`. Serve it from the domain root (links are root-absolute). Any other static host works too: upload `dist/`. `dist/404.html` is the not-found page those hosts pick up automatically.

## Routes

| URL | Page |
|---|---|
| `/` | Studio home, lists every app |
| `/<slug>/` | App landing page |
| `/<slug>/support/` | App support + FAQ (put in store listing) |
| `/<slug>/privacy/` | App privacy policy (put in store listing) |

Routes come from the app registry, so adding an app adds its three pages.

## Adding an app

1. Create `src/apps/<slug>/` with an `app.ts` exporting an `App` (`src/apps/types.ts`): name, summary, field color + readable ink on it, mark, and `Landing`, `Support`, `Privacy` components. Copy `src/apps/heroset/` as a starting point.
2. Add it to the list in `src/apps/index.ts`.
3. `npm run build`.

The studio mark (color bars in the header and favicon) grows by one bar per app. Update `public/favicon.svg` by hand if you want it to match.

## Layout

```
src/
  site.ts               studio name, tagline, contact email
  entry-server.tsx      route table + render(url) used by dev server and prerender
  components/           Shell (studio bar, footer), AppPage (app bar + tabs), Doc (reading layout)
  pages/                Home, NotFound
  apps/<slug>/          one folder per app: registry entry, pages, app-specific graphics and facts
  styles/global.css     tokens and all styles
prerender.ts            writes dist/<route>/index.html and dist/404.html
vite.config.ts          dev middleware that renders pages on request
```

## HeroSet specifics

- Copy is bound by HeroSet's `docs/release-contract.md`: no accuracy numbers, prices or invented screenshots. Check it before changing any claim.
- `src/apps/heroset/facts.ts` mirrors HeroSet `docs/compatibility.md` (watch list) and the language list. Update both together.
- Screenshot slots in `facts.ts` render as "Screenshot pending" until you add simulator captures of the store build: drop PNGs in `public/heroset/screens/` and set each `src` (e.g. `/heroset/screens/dashboard.png`).
- When the Connect IQ listing is live, set `storeUrl` in `src/apps/heroset/app.ts`; the "Coming soon" status becomes a store button.
- The rank scale on the landing page is computed from HeroSet's rank rule (300 × min(r, 14) XP per rank, 600 XP per full day). If the rule changes, update `RankScale.tsx`.
