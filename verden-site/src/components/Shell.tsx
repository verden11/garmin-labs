import type { ReactNode } from 'react'
import { apps } from '../apps/index.ts'
import { studio } from '../site.ts'
import { appUrl } from '../urls.ts'

// The studio mark is the program's color key: one bar per app, in registry order.
export function StudioMark() {
  return (
    <span className="studio-mark" aria-hidden="true">
      {apps.map((app) => <span key={app.slug} style={{ background: app.color }} />)}
      <span />
    </span>
  )
}

export function Shell({ children }: { children: ReactNode }) {
  return (
    <>
      <a className="skip" href="#main">Skip to content</a>
      <header className="studio-bar">
        <div className="wrap studio-bar__inner">
          <a className="wordmark" href="/"><StudioMark />{studio.name}</a>
          <nav aria-label="Apps">
            {apps.map((app) => <a key={app.slug} href={appUrl(app.slug)}>{app.name}</a>)}
          </nav>
        </div>
      </header>
      <main id="main">{children}</main>
      <footer className="site-footer">
        <div className="wrap site-footer__inner">
          <p className="site-footer__studio"><StudioMark />{studio.name}</p>
          <p>Questions or problems: <a href={`mailto:${studio.email}`}>{studio.email}</a></p>
        </div>
      </footer>
    </>
  )
}
