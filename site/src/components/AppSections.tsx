import { Fragment, type CSSProperties } from 'react'
import type { App, Screenshot } from '../apps/types.ts'
import { appUrl } from '../urls.ts'

// Landing-page sections every app shares. Each app keeps its own hero, truth
// block, feature rows and FAQ; these are the parts that only differ by data.

export function StoreAction({ app }: { app: App }) {
  if (app.freeStoreUrl && app.storeUrl) {
    return (
      <>
        <a className="button" href={app.freeStoreUrl}>Get {app.name}, free</a>
        <a className="button" href={app.storeUrl}>Get {app.name} Pro</a>
      </>
    )
  }
  return app.storeUrl
    ? <a className="button" href={app.storeUrl}>Get it on the {app.storeName}</a>
    : <p className="status">Coming soon to the {app.storeName}</p>
}

// Free + Pro ladder: what the free face has, what Pro adds, one store link each. Two separate store listings.
export function FreeOrPro({ app, free, pro, note }: { app: App; free: string; pro: string; note?: string }) {
  return (
    <section className="wrap band" aria-labelledby="tiers-title">
      <h2 id="tiers-title" className="band__title">Free or Pro.</h2>
      <p className="band__lede">Two faces in the {app.storeName}, two separate listings. Nothing in {app.name} is locked or waiting to be bought on the watch.</p>
      <dl className="facts">
        <div><dt>{app.name}</dt><dd>Free. {free} {app.freeStoreUrl ? <a href={app.freeStoreUrl}>Get {app.name}</a> : 'Coming soon.'}</dd></div>
        <div><dt>{app.name} Pro</dt><dd>Paid, one purchase. {pro} <a href={app.storeUrl}>Get {app.name} Pro</a></dd></div>
      </dl>
      {note && <p className="band__aside">{note}</p>}
    </section>
  )
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
  // A slot with no image yet is not drawn (an empty dashed circle reads as broken); it appears when `src` is set.
  const shown = screens.filter((shot) => shot.src)
  return (
    <section className="wrap band" aria-labelledby="screens-title">
      <h2 id="screens-title" className="band__title">On the wrist.</h2>
      <ul className="screens" style={{ '--cols': shown.length } as CSSProperties}>
        {shown.map((shot) => (
          <li key={shot.label}>
            <img src={shot.src} alt={`${app.name} ${shot.label.toLowerCase()} screen${shot.watch ? ` on ${/^[aeiou]/i.test(shot.watch) ? 'an' : 'a'} ${shot.watch}` : ''}`} width={shot.size ?? 560} height={shot.size ?? 560} loading="lazy" />
            <span className="screens__label">{shot.label}</span>
          </li>
        ))}
      </ul>
    </section>
  )
}

// A simulator capture of the face framed in a real watch (its own simulator skin: chassis and part of the strap), the same
// images as the store listings (docker/frame_listing.sh), at 560 px under public/<slug>/watch/. Not lazy: it is used above the fold.
export function WatchShot({ src, alt, className }: { src: string; alt: string; className?: string }) {
  return <img className={`watch-shot${className ? ` ${className}` : ''}`} src={src} alt={alt} width={560} height={560} />
}

// Language names are written in their own language; `lang` lets a screen reader say them right (WCAG 3.1.2).
// A name missing here renders without `lang`: add it when a new language ships.
const LANG: Record<string, string> = {
  English: 'en', Dansk: 'da', Deutsch: 'de', Español: 'es', Français: 'fr', Italiano: 'it', Lietuvių: 'lt', Nederlands: 'nl',
  'Norsk bokmål': 'nb', Polski: 'pl', Português: 'pt', Suomi: 'fi', Svenska: 'sv', Türkçe: 'tr', Українська: 'uk',
}

export function Watches({ title, lede, families, languages }: { title: string; lede: string; families: [string, string][]; languages: string[] }) {
  return (
    <section className="wrap band" aria-labelledby="watches-title">
      <h2 id="watches-title" className="band__title">{title}</h2>
      <p className="band__lede">{lede}</p>
      <dl className="watches">
        {families.map(([family, models]) => (
          <div key={family}><dt>{family}</dt><dd>{models}</dd></div>
        ))}
      </dl>
      <p className="band__aside">In {languages.length} languages: {languages.map((name, i) => <Fragment key={name}>{i ? ', ' : ''}<span lang={LANG[name]}>{name}</span></Fragment>)}.</p>
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
