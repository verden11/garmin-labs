import { twoSuns } from './app.ts'
import { languages, screens, watchCount, watchFamilies } from './facts.ts'
import { CallToAction, HeroActions, Screens, WatchShot, Watches } from '../../components/AppSections.tsx'
import { appUrl } from '../../urls.ts'

const rows = [
  { title: 'The time comes first', text: 'The time is the biggest thing on the screen, in a large size that scales to your screen. A thin ring runs around the bezel on a round watch, and along the edges of the glass on a rectangular one.' },
  { title: 'A ring for the sun', text: 'The ring is the 24 hours of your day, noon at the top or midnight at the top. Night is dim, daylight is lit, and a marker sits where the sun is now: solid while it is up, an outline while it is not.' },
  { title: 'Your Body Battery, as a curve', text: 'Under the time, the last 24 hours of your Garmin Body Battery, with the current point marked and its number beside it. It is Garmin’s estimate, shown as Garmin reports it.' },
  { title: 'One line for the sun', text: 'How much daylight is left, or when the sun comes back: “8h 41m of daylight”, “Sunrise 06:41”. Tomorrow’s sunrise after dark.' },
]

export function Landing() {
  return (
    <>
      <section className="hero field">
        <div className="wrap hero__inner">
          <div className="hero__copy">
            <h1 className="hero__name">{twoSuns.name}</h1>
            <p className="hero__offer">The sun’s day and your Body Battery, on one watch face. A ring for the light, a curve for the last 24 hours.</p>
            <HeroActions app={twoSuns} />
          </div>
          <div className="hero__reps">
            <WatchShot src="/two-suns/watch/day.png" alt="Two Suns on a fēnix 8 Pro: the 24-hour sun ring, the time, Body Battery 59 with its curve, 7h 22m of daylight" />
            <p>A simulator capture with example numbers.</p>
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="read-title">
        <h2 id="read-title" className="band__title">Two things, one glance.</h2>
        <p className="band__lede">The sky’s day and your Body Battery. It shows no steps, no heart rate and no advice; Two Suns Pro can add a weather row and a watch battery row, off unless you switch them on.</p>
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
          <h2 id="truth-title">A sentence, never a blank.</h2>
          <div className="truth__text">
            <p>No place yet, so the watch cannot say where the sun is? The line says “No place yet”. No sun data at all? It says “No sun data”. No Body Battery reading? The number is a grey “--” beside a hollow bolt. If the newest reading is over an hour old, the curve and number turn grey and the dot becomes an outline. The number keeps one colour at any level: a low reading is not drawn as a warning. A new curve waits for two readings close together, and its place stays free until then, so nothing on the face moves when it appears.</p>
            <p>Sun times come from your watch’s own sunrise and sunset values and, when the watch has a place, from a calculation that fills what the watch does not give: tomorrow’s sunrise after dark, the twilight, the golden hour.</p>
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="yours-title">
        <h2 id="yours-title" className="band__title">Yours to set.</h2>
        <p className="band__lede">Five settings, all plain lists: accent colour (six), ring orientation, golden hour on or off, the energy curve (shown as Energy curve in the settings) on or off, and the date on or off. The face works with the defaults if you never open them.</p>
        <dl className="facts">
          <div><dt>Always on</dt><dd>On AMOLED watches, a dim time, number and sun line that shift position every minute; no ring, no curve. Other watches keep the full face.</dd></div>
          <div><dt>Your screen</dt><dd>On a round screen the ring runs around the bezel; on a rectangular one it becomes a track along the glass and the rows fill the box inside it, with a larger time; on the black-and-white Instinct it is a small dial in the round window. The layout measures itself to your screen and drops the date, then the curve, then the sun line before it would crowd the time. The {twoSuns.storeName} shows whether your exact model is listed.</dd></div>
          <div><dt>English and {languages.length - 1} more</dt><dd>The words on the watch come in {languages.length - 1} more languages, machine-drafted and not yet read by native speakers.</dd></div>
          <div><dt>Your place stays on the watch</dt><dd>The face keeps a place, rounded to about 11 km, on the watch only. It has no internet access and sends nothing anywhere.</dd></div>
        </dl>
        <p><a href={appUrl(twoSuns.slug, 'privacy')}>Read the privacy policy</a></p>
      </section>

      <Screens app={twoSuns} screens={screens} />

      <Watches
        title={`${watchCount} Garmin watches.`}
        lede={`Round and rectangular screens, AMOLED and memory-in-pixel, and the black-and-white Instinct. Tested on a Forerunner 965; every screen size passes each screen check in Garmin’s simulator. The ${twoSuns.storeName} shows whether your exact model is listed, and sells the Pro version only on Garmin's paid-app list.`}
        families={watchFamilies}
        languages={languages}
      />

      <CallToAction app={twoSuns} title="See how much day is left." />
    </>
  )
}
