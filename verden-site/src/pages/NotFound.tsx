import { Shell } from '../components/Shell.tsx'
import { apps } from '../apps/index.ts'

export function NotFound() {
  return (
    <Shell>
      <section className="wrap lost">
        <p className="lost__code" aria-hidden="true">404</p>
        <h1>This page isn’t on the program.</h1>
        <p>The address may be mistyped, or the page has moved. Try one of these:</p>
        <ul>
          <li><a href="/">All apps</a></li>
          {apps.map((app) => (
            <li key={app.slug}><a href={`/${app.slug}/support/`}>{app.name} support</a></li>
          ))}
        </ul>
      </section>
    </Shell>
  )
}
