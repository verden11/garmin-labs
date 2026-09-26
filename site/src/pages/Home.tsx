import type { CSSProperties } from 'react'
import { Shell } from '../components/Shell.tsx'
import { apps } from '../apps/index.ts'
import { studio } from '../site.ts'
import { appUrl } from '../urls.ts'
import { StoreAction } from '../components/AppSections.tsx'

export function Home() {
  return (
    <Shell>
      <section className="home-intro field">
        <div className="wrap home-intro__inner">
        <h1>{studio.name}</h1>
        <p>{studio.tagline} {studio.intro}</p>
        </div>
      </section>
      <section aria-label="Our apps" className="program">
        {apps.map((app) => (
          <article key={app.slug} className="program__entry" style={{ '--field': app.color, '--on-field': app.onColor } as CSSProperties}>
            <div className="wrap program__inner">
              {app.Emblem ? <app.Emblem /> : <app.Mark size={96} />}
              <div>
                <h2><a href={appUrl(app.slug)}>{app.name}</a></h2>
                <p className="program__summary">{app.summary}</p>
                <p className="program__platform">{app.platform}</p>
              </div>
              <div className="program__actions">
                <StoreAction app={app} />
                <ul className="program__links">
                  <li><a href={appUrl(app.slug, 'support')}>Support<span className="sr-only"> for {app.name}</span></a></li>
                  <li><a href={appUrl(app.slug, 'privacy')}>Privacy<span className="sr-only"> for {app.name}</span></a></li>
                </ul>
              </div>
            </div>
          </article>
        ))}
      </section>
    </Shell>
  )
}
