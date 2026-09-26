import type { CSSProperties } from 'react'
import type { App } from '../apps/types.ts'
import { Shell } from './Shell.tsx'
import { appUrl, type Section } from '../urls.ts'

const tabs: [Section, string][] = [['landing', 'Overview'], ['support', 'Support'], ['privacy', 'Privacy']]

export function AppPage({ app, section }: { app: App; section: Section }) {
  const theme = { '--field': app.color, '--on-field': app.onColor } as CSSProperties
  const Body = { landing: app.Landing, support: app.Support, privacy: app.Privacy }[section]
  return (
    <div className="app-theme" style={theme}>
      <Shell>
        <nav className="app-bar" aria-label={app.name}>
          <div className="wrap app-bar__inner">
            <a className="app-bar__name" href={appUrl(app.slug)}><app.Mark size={28} />{app.name}</a>
            <ul>
              {tabs.map(([id, label]) => (
                <li key={id}>
                  <a href={appUrl(app.slug, id)} aria-current={id === section ? 'page' : undefined}>
                    {label}
                  </a>
                </li>
              ))}
            </ul>
          </div>
        </nav>
        <Body />
      </Shell>
    </div>
  )
}
