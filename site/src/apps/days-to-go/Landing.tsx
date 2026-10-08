import { daysToGo } from './app.ts'
import { languages, screens, watchCount, watchFamilies } from './facts.ts'
import { CallToAction, FreeOrPro, HeroActions, Screens, WatchShot, Watches } from '../../components/AppSections.tsx'
import { appUrl } from '../../urls.ts'

const rows = [
  { title: 'One number', text: 'The days left is the biggest thing on the screen, in the largest size your watch can draw. The time sits above it.' },
  { title: 'Plain lists, no date picker', text: 'Pick the month, day and year from simple lists in the app, or on many watches on the watch itself. Nothing to set at all if you just want New Year.' },
  { title: 'The ring drains', text: 'A thin ring empties as the day gets closer and fills on the day itself: around the bezel on a round screen, a track along the glass on a rectangular one, a gauge in the round window of a black-and-white Instinct.' },
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
            <WatchShot src="/days-to-go/watch/days.png" alt="Days To Go on a Venu 3: 161 days to a wedding, the date of the day under the count" />
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
        <p className="band__lede">Days, or weeks and days. Name the event, choose day-first or month-first dates and pick an accent colour. Days To Go Pro adds an event time, which counts the last 24 hours down to the minute, and an optional battery or steps line.</p>
        <dl className="facts">
          <div><dt>Always on</dt><dd>On AMOLED watches, a dim number and clock that shifts position every minute. Other watches keep the full face.</dd></div>
          <div><dt>Your screen</dt><dd>The layout measures itself to your screen. On a rectangular watch the face has its own square design: the ring runs along the glass and the rows fill the box inside it. The {daysToGo.storeName} shows whether your exact model is listed.</dd></div>
          <div><dt>English and {languages.length - 1} more</dt><dd>The words on the watch come in {languages.length - 1} more languages, machine-drafted and not yet read by native speakers. The weekday and month come from your watch’s own language.</dd></div>
          <div><dt>Nothing leaves the watch</dt><dd>No permissions, no account, no internet, no analytics, no ads.</dd></div>
        </dl>
        <p><a href={appUrl(daysToGo.slug, 'privacy')}>Read the privacy policy</a></p>
      </section>

      <FreeOrPro
        app={daysToGo}
        free="The day count, the ring, the time, the event’s name and date, days or weeks and days, the date style and the accent colour. On many watches you can set the date on the watch itself."
        pro="Everything in Days To Go, plus an event time: the last 24 hours count down to the minute the event starts, in the time zone it starts in. You pick that zone as a UTC offset; the face does not adjust for daylight saving. And an optional battery or steps line (not on black-and-white screens)."
      />

      <Screens app={daysToGo} screens={screens} />

      <Watches
        title={`${watchCount} Garmin watches.`}
        lede={`Round and rectangular screens, AMOLED and memory-in-pixel, and the black-and-white Instinct. Tested on a Forerunner 965; every screen size passes each screen check in Garmin’s simulator. The ${daysToGo.storeName} shows whether your exact model is listed. Days To Go runs on all of them; Days To Go Pro is sold only on Garmin’s paid-app list, which leaves out many older watches, among them the Instinct 2, 2S and 2X, the Descent G1 and the first-generation Venu Sq.`}
        families={watchFamilies}
        languages={languages}
      />

      <CallToAction app={daysToGo} title="Count down to the day." />
    </>
  )
}
