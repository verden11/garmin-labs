import { FacePreview } from './FacePreview.tsx'
import { daysToGo } from './app.ts'
import { languages } from './facts.ts'
import { CallToAction, HeroActions } from '../../components/AppSections.tsx'
import { appUrl } from '../../urls.ts'

const rows = [
  { title: 'One number', text: 'The days left is the biggest thing on the screen, in the largest size your watch can draw. The time sits above it.' },
  { title: 'Plain lists, no date picker', text: 'Pick the month, day and year from simple lists in the app, or on many watches on the watch itself. Nothing to set at all if you just want New Year.' },
  { title: 'The ring drains', text: 'A thin ring around the bezel empties as the day gets closer and fills on the day itself.' },
  { title: 'Whole calendar days', text: 'Tomorrow is 1 day. The day itself says TODAY. Afterwards it counts the days since.' },
]

export function Landing() {
  return (
    <>
      <section className="hero field">
        <div className="wrap hero__inner">
          <div className="hero__copy">
            <h1 className="hero__name">{daysToGo.name}</h1>
            <p className="hero__offer">How many days until the day. One number, counted in whole calendar days.</p>
            <HeroActions app={daysToGo} />
          </div>
          <div className="hero__reps">
            <FacePreview size={260} />
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="read-title">
        <h2 id="read-title" className="band__title">Built for one job.</h2>
        <p className="band__lede">Beside the count, the time and the date. Nothing else is on by default: no steps, no heart rate, no weather.</p>
        <ol className="course">
          {rows.map((row) => (
            <li key={row.title} className="course__stop">
              <span className="course__keys" />
              <h3>{row.title}</h3>
              <p>{row.text}</p>
            </li>
          ))}
        </ol>
      </section>

      <section className="truth" aria-labelledby="truth-title">
        <div className="wrap truth__inner">
          <h2 id="truth-title">Never empty, never broken.</h2>
          <div className="truth__text">
            <p>Nothing set up yet? It counts to the next New Year’s Day. Choose Every year for birthdays and anniversaries and it rolls over by itself.</p>
            <p>A date that does not exist, like 30 February, asks you to set a date instead of showing a wrong number.</p>
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="yours-title">
        <h2 id="yours-title" className="band__title">Yours to set.</h2>
        <p className="band__lede">Days, or weeks and days. An optional event time turns the last 24 hours into hours and minutes. Name the event, choose day-first or month-first dates, pick an accent colour, and optionally show battery or steps.</p>
        <dl className="facts">
          <div><dt>Always on</dt><dd>On AMOLED watches, a dim number and clock that shifts position every minute. Other watches keep the full face.</dd></div>
          <div><dt>Your screen</dt><dd>One layout that measures itself to your screen. The {daysToGo.storeName} shows whether your exact model is listed.</dd></div>
          <div><dt>English and {languages.length - 1} more</dt><dd>The words on the watch come in {languages.length - 1} more languages, machine-drafted and not yet read by native speakers. The weekday and month come from your watch’s own language.</dd></div>
          <div><dt>Nothing leaves the watch</dt><dd>No permissions, no account, no internet, no analytics, no ads.</dd></div>
        </dl>
        <p><a href={appUrl(daysToGo.slug, 'privacy')}>Read the privacy policy</a></p>
      </section>

      <CallToAction app={daysToGo} title="Count down to the day." />
    </>
  )
}
