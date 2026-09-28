import { FacePreview } from './FacePreview.tsx'
import { dayArcPro } from './app.ts'
import { windows } from './facts.ts'
import { CallToAction, HeroActions } from '../../components/AppSections.tsx'
import { appUrl } from '../../urls.ts'

export function Landing() {
  return (
    <>
      <section className="hero field">
        <div className="wrap hero__inner">
          <div className="hero__copy">
            <h1 className="hero__name">{dayArcPro.name}</h1>
            <p className="hero__offer">The same four windows as DayArc, denser: a full field grid under every reading. Paid, $1.99, no free tier.</p>
            <HeroActions app={dayArcPro} />
          </div>
          <div className="hero__reps">
            <FacePreview size={260} />
            <p>A drawing of the face at midday, with example numbers. Not a screenshot.</p>
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="read-title">
        <h2 id="read-title" className="band__title">Four windows, full grid.</h2>
        <p className="band__lede">The same fixed schedule as DayArc, with more of what your watch already tracks shown alongside each window's main reading.</p>
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
          <h2 id="truth-title">Dense, but never crowded out.</h2>
          <div className="truth__text">
            <p>The main reading for each window stays the largest thing on screen, ahead of the grid — the grid sits below it, sized to what actually fits your watch's screen. A field your watch can't provide shows as "--", never blank, never a guess.</p>
            <p>Stress and Body Battery are still shown as a number and a plain gauge — Pro adds fields, it doesn't add mood words.</p>
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="yours-title">
        <h2 id="yours-title" className="band__title">A separate listing, on purpose.</h2>
        <p className="band__lede">DayArc Pro is a fixed $1.99 with no free tier and no in-app toggle. Want the simpler, one-reading-per-window face instead? That's DayArc, a separate free listing.</p>
        <dl className="facts">
          <div><dt>No settings</dt><dd>Every choice is decided at build time — this platform's most common complaint is settings that don't save, so DayArc Pro has none to fail to save.</dd></div>
          <div><dt>Nothing leaves the watch</dt><dd>No location, no network, no account.</dd></div>
        </dl>
        <p><a href={appUrl(dayArcPro.slug, 'privacy')}>Read the privacy policy</a></p>
      </section>

      <CallToAction app={dayArcPro} title="See more, in the same glance." />
    </>
  )
}
