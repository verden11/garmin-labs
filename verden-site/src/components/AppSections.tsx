import type { App, Screenshot } from '../apps/types.ts'
import { appUrl } from '../urls.ts'

// Landing-page sections every app shares. Each app keeps its own hero, truth
// block, feature rows and FAQ; these are the parts that only differ by data.

export function StoreAction({ app }: { app: App }) {
  return app.storeUrl
    ? <a className="button" href={app.storeUrl}>Get it on the {app.storeName}</a>
    : <p className="status">Coming soon to the {app.storeName}</p>
}

export function HeroActions({ app }: { app: App }) {
  return (
    <div className="hero__actions">
      <StoreAction app={app} />
      <a className="hero__support" href={appUrl(app.slug, 'support')}>Support and answers</a>
    </div>
  )
}

export function Screens({ app, screens }: { app: App; screens: Screenshot[] }) {
  return (
    <section className="wrap band" aria-labelledby="screens-title">
      <h2 id="screens-title" className="band__title">On the wrist.</h2>
      <ul className="screens">
        {screens.map((shot) => (
          <li key={shot.label}>
            {shot.src
              ? <img src={shot.src} alt={`${app.name} ${shot.label.toLowerCase()} screen`} width={shot.size ?? 454} height={shot.size ?? 454} loading="lazy" />
              : <span className="screens__pending">Screenshot pending</span>}
            <span className="screens__label">{shot.label}</span>
          </li>
        ))}
      </ul>
    </section>
  )
}

export function Watches({ count, lede, families, languages }: { count: number; lede: string; families: [string, string][]; languages: string[] }) {
  return (
    <section className="wrap band" aria-labelledby="watches-title">
      <h2 id="watches-title" className="band__title">{count} Garmin watches.</h2>
      <p className="band__lede">{lede}</p>
      <dl className="watches">
        {families.map(([family, models]) => (
          <div key={family}><dt>{family}</dt><dd>{models}</dd></div>
        ))}
      </dl>
      <p className="band__aside">In {languages.length} languages: {languages.join(', ')}.</p>
    </section>
  )
}

export function CallToAction({ app, title }: { app: App; title: string }) {
  return (
    <section className="field close">
      <div className="wrap close__inner">
        <h2>{title}</h2>
        <HeroActions app={app} />
      </div>
    </section>
  )
}
