import type { ReactNode } from 'react'

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
