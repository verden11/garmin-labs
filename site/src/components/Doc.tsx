import type { ReactNode } from 'react'
import { studio } from '../site.ts'

// Reading layout for support, privacy and other long-form app pages.
export function Doc({ title, lede, children }: { title: string; lede: ReactNode; children: ReactNode }) {
  return (
    <article className="doc wrap">
      <header className="doc__head">
        <h1>{title}</h1>
        <p className="doc__lede">{lede}</p>
      </header>
      <div className="doc__body">{children}</div>
    </article>
  )
}

export function Note({ children }: { children: ReactNode }) {
  return <div className="note">{children}</div>
}

// The closing sections every app's privacy policy shares, word for word.
export function PrivacyTail() {
  return (
    <>
      <h2>Purchases</h2>
      <p>
        Garmin handles purchases through the Connect IQ Store under{' '}
        <a href="https://www.garmin.com/privacy/">Garmin’s privacy policy</a>. The developer never sees your payment details.
      </p>

      <h2>This website</h2>
      <p>No cookies, analytics or third-party scripts. The web host may keep standard access logs.</p>

      <h2>Changes and contact</h2>
      <p>
        This policy may change; the effective date above shows the current version. Questions:{' '}
        <a href={`mailto:${studio.email}`}>{studio.email}</a>.
      </p>
    </>
  )
}
