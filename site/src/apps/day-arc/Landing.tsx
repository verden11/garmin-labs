import { FacePreview } from './FacePreview.tsx'
import { dayArc } from './app.ts'
import { windows } from './facts.ts'
import { CallToAction, HeroActions } from '../../components/AppSections.tsx'
import { appUrl } from '../../urls.ts'

export function Landing() {
  return (
    <>
      <section className="hero field">
        <div className="wrap hero__inner">
          <div className="hero__copy">
            <h1 className="hero__name">{dayArc.name}</h1>
            <p className="hero__offer">One reading at a time, changing on a fixed schedule through the day. No settings, nothing to configure.</p>
            <HeroActions app={dayArc} />
          </div>
          <div className="hero__reps">
            <FacePreview size={260} />
            <p>A drawing of the face at midday, with example numbers. Not a screenshot.</p>
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="read-title">
        <h2 id="read-title" className="band__title">Four windows, one glance each.</h2>
        <p className="band__lede">The same clock every day decides what's on screen. Nothing to open, nothing to set.</p>
        <ol className="course">
          {windows.map(([title, time, text]) => (
            <li key={title} className="course__stop">
              <span className="course__keys" />
              <h3>{title} · {time}</h3>
              <p>{text}</p>
            </li>
          ))}
        </ol>
      </section>

      <section className="truth" aria-labelledby="truth-title">
        <div className="wrap truth__inner">
          <h2 id="truth-title">A number, never a verdict.</h2>
          <div className="truth__text">
            <p>Stress and Body Battery are shown as a number and a plain gauge, one colour, never a mood word, an emoji, or a red/amber/green scale. DayArc doesn't say whether a reading is good or bad — Garmin's own guidance doesn't either.</p>
            <p>No reading yet? The line says so in words — "Stress unavailable right now", "Body Battery unavailable" — never a blank field, never a guess.</p>
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="yours-title">
        <h2 id="yours-title" className="band__title">Looking for more fields?</h2>
        <p className="band__lede">DayArc keeps one reading per window on purpose. DayArc Pro is a separate, paid listing with the same four windows and a denser grid of fields under each one — steps, heart rate, calendar, and more.</p>
        <dl className="facts">
          <div><dt>No settings</dt><dd>Every choice here is decided at build time, not a phone setting — this platform's most common complaint is settings that don't save, so DayArc has none to fail to save.</dd></div>
          <div><dt>Nothing leaves the watch</dt><dd>No location, no network, no account. DayArc reads data your watch already has and keeps it there.</dd></div>
        </dl>
        <p><a href={appUrl(dayArc.slug, 'privacy')}>Read the privacy policy</a></p>
      </section>

      <CallToAction app={dayArc} title="See what's next, without checking." />
    </>
  )
}
