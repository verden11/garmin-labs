import { dayArcPro } from './app.ts'
import { windows, watchCount, watchFamilies, languages } from './facts.ts'
import { CallToAction, HeroActions, Screens, WatchShot, Watches } from '../../components/AppSections.tsx'
import { appUrl } from '../../urls.ts'

// The watch each window's capture was taken on (listing_shots.sh; night from docker/edge_states.sh), for the alt text.
const WINDOW_WATCH: Record<string, string> = { morning: 'fēnix 8', midday: 'Forerunner 970', evening: 'fēnix 8 Pro', night: 'Forerunner 965' }

const shots = [
  { label: 'Accent colour', src: '/day-arc-pro/watch/accent.png', watch: 'Forerunner 965' },
  { label: 'Instinct', src: '/day-arc-pro/watch/instinct.png', watch: 'Instinct E' },
]

export function Landing() {
  return (
    <>
      <section className="hero field">
        <div className="wrap hero__inner">
          <div className="hero__copy">
            <h1 className="hero__name">{dayArcPro.name}</h1>
            <p className="hero__offer">The same four windows as DayArc, denser: a full field grid under every reading. Paid once, no free tier.</p>
            <HeroActions app={dayArcPro} />
          </div>
          <div className="hero__reps">
            <WatchShot src="/day-arc-pro/watch/midday.png" alt="DayArc Pro at midday on a Forerunner 970: the time, the date and the stress reading with its gauge" />
            <p>A simulator capture at midday, with example numbers.</p>
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="read-title">
        <h2 id="read-title" className="band__title">Four windows, full grid.</h2>
        <p className="band__lede">The same fixed schedule as DayArc, with more of what your watch already tracks shown alongside each window's main reading.</p>
        <ol className="course">
          {windows.map(([title, time, text]) => (
            <li key={title} className="course__stop">
              <span className="course__keys"><WatchShot src={`/day-arc-pro/watch/${title.toLowerCase()}.png`} alt={`DayArc Pro in the ${title.toLowerCase()} window on a ${WINDOW_WATCH[title.toLowerCase()]}`} /></span>
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
        <p className="band__lede">DayArc Pro is a one-time paid listing with no free tier and no in-app toggle; the Connect IQ Store shows its price in your own currency. Want the simpler, one-reading-per-window face instead? That's DayArc, a separate free listing.</p>
        <dl className="facts">
          <div><dt>One setting</dt><dd>An accent colour, chosen in the Garmin Connect app — Auto by default, where each time of day has its own colour. Which fields show is decided at build time, not a setting; if the colour setting is ever missing the face just shows its normal colours.</dd></div>
          <div><dt>Nothing leaves the watch</dt><dd>No location, no network, no account.</dd></div>
        </dl>
        <p><a href={appUrl(dayArcPro.slug, 'privacy')}>Read the privacy policy</a></p>
      </section>

      <Screens app={dayArcPro} screens={shots} />

      <Watches
        title={`${watchCount} Garmin watches.`}
        lede={`Round and rectangular screens, AMOLED and memory-in-pixel, and the black-and-white Instinct. Tested on a Forerunner 965; every screen size passes each screen check in Garmin’s simulator. The ${dayArcPro.storeName} shows whether your exact model is listed, and sells it only on Garmin's paid-app list.`}
        families={watchFamilies}
        languages={languages}
      />

      <CallToAction app={dayArcPro} title="See more, in the same glance." />
    </>
  )
}
