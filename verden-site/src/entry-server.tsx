import type { ReactElement } from 'react'
import { renderToStaticMarkup } from 'react-dom/server'
import { apps } from './apps/index.ts'
import { Home } from './pages/Home.tsx'
import { NotFound } from './pages/NotFound.tsx'
import type { App } from './apps/types.ts'
import { AppPage } from './components/AppPage.tsx'
import { studio } from './site.ts'
import { appUrl, type Section } from './urls.ts'

type Route = { title: string; description: string; image?: string; jsonLd?: object; page: ReactElement }

const softwareApplication = (app: App, url: string) => ({
  '@context': 'https://schema.org',
  '@type': 'SoftwareApplication',
  name: app.name,
  description: app.summary,
  applicationCategory: 'HealthApplication',
  operatingSystem: 'Garmin Connect IQ',
  url: studio.origin + url,
  ...(app.storeUrl ? { sameAs: app.storeUrl } : {}),
})

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
    const url = appUrl(app.slug, section)
    const landing = section === 'landing'
    table.set(url, {
      title,
      description,
      image: landing ? app.ogImage : undefined,
      jsonLd: landing ? softwareApplication(app, url) : undefined,
      page: <AppPage app={app} section={section} />,
    })
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
  const { title, description, image, jsonLd, page } = route ?? {
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
      `<meta name="twitter:card" content="${image ? 'summary_large_image' : 'summary'}">`,
      `<meta name="twitter:title" content="${escape(title)}">`,
      `<meta name="twitter:description" content="${escape(description)}">`,
    )
    if (image) {
      const src = escape(studio.origin + image)
      head.push(`<meta property="og:image" content="${src}">`, `<meta name="twitter:image" content="${src}">`)
    }
    // "</script" can't appear inside a script body, even in a JSON string.
    if (jsonLd) head.push(`<script type="application/ld+json">${JSON.stringify(jsonLd).replace(/<\/script/gi, '<\\/script')}</script>`)
  }
  return { status: route ? 200 : 404, head: head.join('\n'), body: renderToStaticMarkup(page) }
}
