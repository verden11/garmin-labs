import type { ReactElement } from 'react'
import { renderToStaticMarkup } from 'react-dom/server'
import { apps } from './apps/index.ts'
import { Home } from './pages/Home.tsx'
import { NotFound } from './pages/NotFound.tsx'
import { AppPage, type Section } from './components/AppPage.tsx'
import { studio } from './site.ts'

type Route = { title: string; description: string; page: ReactElement }

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
    table.set(url, { title, description, page: <AppPage app={app} section={section} /> })
  }
}

export const routes = [...table.keys()]

const escape = (s: string) => s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;')

export function render(url: string): { status: number; head: string; body: string } {
  const withSlash = url.endsWith('/') ? url : `${url}/`
  const route = table.get(withSlash)
  const { title, description, page } = route ?? {
    title: `Not found — ${studio.name}`,
    description: studio.tagline,
    page: <NotFound />,
  }
  return {
    status: route ? 200 : 404,
    head: `<title>${escape(title)}</title>\n<meta name="description" content="${escape(description)}">`,
    body: renderToStaticMarkup(page),
  }
}
