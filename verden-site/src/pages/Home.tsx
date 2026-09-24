import type { CSSProperties } from 'react'
import { Shell } from '../components/Shell.tsx'
import { apps } from '../apps/index.ts'
import { studio } from '../site.ts'
import { appUrl } from '../urls.ts'

export function Home() {
  return (
    <Shell>
      <section className="home-intro field">
        <div className="wrap home-intro__inner">
        <h1>{studio.name}</h1>
        <p>{studio.tagline} Each app does one job, says plainly what it can and can’t do, and keeps your data where it belongs.</p>
        </div>
      </section>
      <section aria-label="Apps" className="program">
        {apps.map((app) => (
          <article key={app.slug} className="program__entry" style={{ '--field': app.color, '--on-field': app.onColor } as CSSProperties}>
            <div className="wrap program__inner">
              {app.Emblem ? <app.Emblem /> : <app.Mark size={96} />}
              <div>
                <h2><a href={appUrl(app.slug)}>{app.name}</a></h2>
                <p className="program__summary">{app.summary}</p>
                <p className="program__platform">{app.platform}</p>
              </div>
              <ul className="program__links">
                <li><a href={appUrl(app.slug)}>Overview</a></li>
                <li><a href={appUrl(app.slug, 'support')}>Support</a></li>
                <li><a href={appUrl(app.slug, 'privacy')}>Privacy</a></li>
              </ul>
            </div>
          </article>
        ))}
      </section>
    </Shell>
  )
}
