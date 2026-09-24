import type { ReactElement } from 'react'
import { renderToStaticMarkup } from 'react-dom/server'
import { apps } from './apps/index.ts'
import { Home } from './pages/Home.tsx'
import { NotFound } from './pages/NotFound.tsx'
import { AppPage } from './components/AppPage.tsx'
import { studio } from './site.ts'
import { appUrl, type Section } from './urls.ts'

type Route = { title: string; description: string; page: ReactElement }

const table = new Map<string, Route>([
  ['/', { title: `${studio.name} — apps`, description: studio.tagline, page: <Home /> }],
])
for (const app of apps) {
  const sections: [Section, string, string][] = [
    ['landing', app.title, app.summary],
    ['support', `${app.name} support · ${studio.name}`, `Help, answers and contact for ${app.name}.`],
    ['privacy', `${app.name} privacy policy · ${studio.name}`, `What ${app.name} reads, stores and never shares.`],
  ]
  for (const [section, title, description] of sections) {
    table.set(appUrl(app.slug, section), { title, description, page: <AppPage app={app} section={section} /> })
  }
}

export const routes = [...table.keys()]

export function sitemap(): string {
  const urls = routes.map((url) => `  <url><loc>${studio.origin}${url}</loc></url>`).join('\n')
  return `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${urls}\n</urlset>\n`
}

const escape = (s: string) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;')

export function render(url: string): { status: number; head: string; body: string } {
  const withSlash = url.endsWith('/') ? url : `${url}/`
  const route = table.get(withSlash)
  const { title, description, page } = route ?? {
    title: `Not found — ${studio.name}`,
    description: studio.tagline,
    page: <NotFound />,
  }
  const head = [`<title>${escape(title)}</title>`, `<meta name="description" content="${escape(description)}">`]
  if (route) {
    // One canonical host, since the Netlify subdomain serves the same pages.
    const canonical = escape(studio.origin + withSlash)
    head.push(
      `<link rel="canonical" href="${canonical}">`,
      `<meta property="og:type" content="website">`,
      `<meta property="og:site_name" content="${escape(studio.name)}">`,
      `<meta property="og:title" content="${escape(title)}">`,
      `<meta property="og:description" content="${escape(description)}">`,
      `<meta property="og:url" content="${canonical}">`,
    )
  }
  return { status: route ? 200 : 404, head: head.join('\n'), body: renderToStaticMarkup(page) }
}
