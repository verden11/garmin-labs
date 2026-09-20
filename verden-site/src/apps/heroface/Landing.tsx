import { FacePreview } from './FacePreview.tsx'
import { heroface } from './app.ts'
import { screens, watchFamilies, languages, watchCount, linkedWatchCount } from './facts.ts'

function StoreAction() {
  return heroface.storeUrl
    ? <a className="button" href={heroface.storeUrl}>Get it on the {heroface.storeName}</a>
    : <p className="status">Coming soon to the {heroface.storeName}</p>
}

const rows = [
  { title: 'The time, first', text: 'The largest thing on the screen, in the largest size that fits your watch. Everything else stays out of its way.' },
  { title: 'Three goals, three bars', text: 'Steps, intensity minutes and floors by default, or whichever three you pick. Bar length carries the glance; the numbers are the detail.' },
  { title: 'The day at the edge', text: 'The ring around the bezel is all three goals at once. It turns green when the day is done.' },
  { title: 'A streak worth keeping', text: 'Days in a row you met your step goal, in gold. It shows up when you have one, and stays out of the way when you don’t.' },
]

export function Landing() {
  return (
    <>
      <section className="hero field">
        <div className="wrap hero__inner">
          <div className="hero__copy">
            <h1 className="hero__name">{heroface.name}</h1>
            <p className="hero__offer">The time first, and today’s goals right under it.</p>
            <div className="hero__actions">
              <StoreAction />
              <a className="hero__support" href="/heroface/support/">Support and answers</a>
            </div>
          </div>
          <div className="hero__reps">
            <FacePreview size={260} />
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="read-title">
        <h2 id="read-title" className="band__title">Built to be read, not studied.</h2>
        <p className="band__lede">Everything on the face earns its place: the time, the day’s three goals, and the few things worth knowing at a glance.</p>
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
          <h2 id="truth-title">It shows what your watch actually measures.</h2>
          <div className="truth__text">
            <p>No watch has every sensor. Without a barometer there is no floor count, and older watches have no weather at all.</p>
            <p>HeroFace fills each bar with the first thing your watch really measures, and leaves out what it cannot know. No empty bars, no invented numbers.</p>
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="yours-title">
        <h2 id="yours-title" className="band__title">Your three, your colour.</h2>
        <p className="band__lede">Set each bar to steps, calories, intensity minutes, distance, floors or the move bar. Pick the accent colour. Turn seconds and the temperature on or off. All from the Garmin Connect app on your phone.</p>
        <dl className="facts">
          <div><dt>Always on</dt><dd>A dim, drifting clock that respects your watch’s always-on rules.</dd></div>
          <div><dt>Every round watch</dt><dd>From a 208-pixel Forerunner 55 to a 466-pixel fēnix, one layout that measures itself.</dd></div>
          <div><dt>{languages.length} languages</dt><dd>Including the weekday and month, taken from your watch’s own language.</dd></div>
          <div><dt>Nothing leaves the watch</dt><dd>No account, no internet, no analytics, no ads.</dd></div>
        </dl>
        <p><a href="/heroface/privacy/">Read the privacy policy</a></p>
      </section>

      <section className="wrap band" aria-labelledby="heroset-title">
        <h2 id="heroset-title" className="band__title">Better with HeroSet.</h2>
        <p className="band__lede">If you also own <a href="/heroset/">HeroSet</a>, the bars can show today’s push-ups, sit-ups and squats, the ring becomes your progress to the next rank, and holding the face opens the app. On the {linkedWatchCount} watches that support it, and entirely on the watch. Without HeroSet, nothing is missing.</p>
        <div className="hero__reps">
          <FacePreview size={240} heroset />
        </div>
      </section>

      <section className="wrap band" aria-labelledby="screens-title">
        <h2 id="screens-title" className="band__title">On the wrist.</h2>
        <ul className="screens">
          {screens.map((shot) => (
            <li key={shot.label}>
              {shot.src
                ? <img src={shot.src} alt={`HeroFace ${shot.label.toLowerCase()} screen`} width="454" height="454" loading="lazy" />
                : <span className="screens__pending">Screenshot pending</span>}
              <span className="screens__label">{shot.label}</span>
            </li>
          ))}
        </ul>
      </section>

      <section className="wrap band" aria-labelledby="watches-title">
        <h2 id="watches-title" className="band__title">{watchCount} Garmin watches.</h2>
        <p className="band__lede">Round screens, AMOLED and memory-in-pixel, Connect IQ 3.0 and newer. Tested on a Forerunner 965; every other model passes each screen check in Garmin’s simulator. The {heroface.storeName} shows whether your exact model is listed.</p>
        <dl className="watches">
          {watchFamilies.map(([family, models]) => (
            <div key={family}><dt>{family}</dt><dd>{models}</dd></div>
          ))}
        </dl>
        <p className="band__aside">In {languages.length} languages: {languages.join(', ')}.</p>
      </section>

      <section className="field close">
        <div className="wrap close__inner">
          <h2>Put the day where you already look.</h2>
          <div className="hero__actions">
            <StoreAction />
            <a className="hero__support" href="/heroface/support/">Support and answers</a>
          </div>
        </div>
      </section>
    </>
  )
}
