import type { ReactElement } from 'react'
import { renderToStaticMarkup } from 'react-dom/server'
import { apps } from './apps/index.ts'
import { Home } from './pages/Home.tsx'
import { NotFound } from './pages/NotFound.tsx'
import { AppPage, type Section } from './components/AppPage.tsx'
import { studio } from './site.ts'

type JsonLd = Record<string, unknown>

type Route = { title: string; description: string; image?: string; jsonLd?: JsonLd; page: ReactElement }

const table = new Map<string, Route>([
  ['/', { title: `${studio.name} — apps`, description: studio.tagline, page: <Home /> }],
])
for (const app of apps) {
  const sections: [Section, string, string][] = [
    ['landing', `${app.name} — ${app.summary}`, app.summary],
    ['support', `${app.name} support`, `Help, answers and contact for ${app.name}.`],
    ['privacy', `${app.name} privacy policy`, `What ${app.name} reads, stores and never shares.`],
  ]
  for (const [section, title, description] of sections) {
    const url = section === 'landing' ? `/${app.slug}/` : `/${app.slug}/${section}/`
    const jsonLd: JsonLd | undefined = section === 'landing' ? {
      '@context': 'https://schema.org',
      '@type': 'SoftwareApplication',
      name: app.name,
      description: app.summary,
      applicationCategory: 'HealthApplication',
      operatingSystem: 'Garmin Connect IQ',
      url: `${studio.origin}${url}`,
      ...(app.storeUrl ? { sameAs: app.storeUrl } : {}),
    } : undefined
    table.set(url, { title, description, image: app.ogImage, jsonLd, page: <AppPage app={app} section={section} /> })
  }
}

export const routes = [...table.keys()]

const escape = (s: string) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;')

export function render(url: string): { status: number; head: string; body: string } {
  const withSlash = url.endsWith('/') ? url : `${url}/`
  const route = table.get(withSlash)
  const { title, description, image, jsonLd, page } = route ?? {
    title: `Not found — ${studio.name}`,
    description: studio.tagline,
    image: undefined,
    jsonLd: undefined,
    page: <NotFound />,
  }
  const canonical = `${studio.origin}${withSlash}`
  const tags = [
    `<title>${escape(title)}</title>`,
    `<link rel="canonical" href="${escape(canonical)}">`,
    `<meta name="description" content="${escape(description)}">`,
    `<meta property="og:type" content="website">`,
    `<meta property="og:site_name" content="${escape(studio.name)}">`,
    `<meta property="og:title" content="${escape(title)}">`,
    `<meta property="og:description" content="${escape(description)}">`,
    `<meta property="og:url" content="${escape(canonical)}">`,
    `<meta name="twitter:card" content="${image ? 'summary_large_image' : 'summary'}">`,
    `<meta name="twitter:title" content="${escape(title)}">`,
    `<meta name="twitter:description" content="${escape(description)}">`,
  ]
  if (image) {
    const absoluteImage = `${studio.origin}${image}`
    tags.push(`<meta property="og:image" content="${escape(absoluteImage)}">`)
    tags.push(`<meta name="twitter:image" content="${escape(absoluteImage)}">`)
  }
  if (jsonLd) {
    // </script> can't appear literally inside a script body even in a JSON
    // string value, so escape the one dangerous substring before embedding.
    const json = JSON.stringify(jsonLd).replace(/<\/script/gi, '<\\/script')
    tags.push(`<script type="application/ld+json">${json}</script>`)
  }
  return {
    status: route ? 200 : 404,
    head: tags.join('\n'),
    body: renderToStaticMarkup(page),
  }
}
