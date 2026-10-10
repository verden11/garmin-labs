import { sunWindow } from './app.ts'
import { states, watchCount, watchFamilies, languages } from './facts.ts'
import { CallToAction, HeroActions, Watches } from '../../components/AppSections.tsx'
import { appUrl } from '../../urls.ts'

// No watch-framed captures yet: they come with the approved store screens (SunWindow/listing/screenshots.md, ROADMAP 18.1), and a
// `<Screens>` and `<WatchShot>` section is added then. Until then the page is words only, which is all it needs to be true.
export function Landing() {
  return (
    <>
      <section className="hero field">
        <div className="wrap hero__inner">
          <div className="hero__copy">
            <h1 className="hero__name">{sunWindow.name}</h1>
            <p className="hero__offer">Is the sun high right now? One word on your watch: OPEN, CLOSED or NONE TODAY.</p>
            <HeroActions app={sunWindow} />
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="read-title">
        <h2 id="read-title" className="band__title">One word, one picture.</h2>
        <p className="band__lede">The window is open while the sun is at or above 45 degrees, the height where your shadow is no longer than you are. Open the app for today’s sun path over that line, with the times it opens and closes.</p>
        <dl className="facts">
          {states.map(([word, text]) => (
            <div key={word}><dt>{word}</dt><dd>{text}</dd></div>
          ))}
        </dl>
      </section>

      <section className="truth" aria-labelledby="truth-title">
        <div className="wrap truth__inner">
          <h2 id="truth-title">A sun reading, not advice.</h2>
          <div className="truth__text">
            <p>Sun Window says where the sun is, nothing about you. No minutes, no dose, no goal, no streak, and no state is called good or safe. For information only; not medical advice or a sun-safety tool.</p>
            <p>When it cannot tell, it says so in words: "Open once" before it has found your place, "No weather" when the watch gave no UV reading, never a blank.</p>
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="yours-title">
        <h2 id="yours-title" className="band__title">Small on purpose.</h2>
        <p className="band__lede">A glance in your watch’s glance list, and the app behind it. One setting: an accent colour.</p>
        <dl className="facts">
          <div><dt>Your place</dt><dd>Sun Window reads the last place your watch knows to work out the sun’s height. It keeps that place rounded to about 11 km, on the watch only.</dd></div>
          <div><dt>The sky</dt><dd>On a day when your watch’s own weather reports a low UV index, an open window shows as closed. If the watch has no reading, the sun’s height decides alone.</dd></div>
          <div><dt>Nothing leaves the watch</dt><dd>No account, no internet, no analytics, no ads.</dd></div>
        </dl>
        <p><a href={appUrl(sunWindow.slug, 'privacy')}>Read the privacy policy</a></p>
      </section>

      <Watches
        title={`${watchCount} Garmin watches.`}
        lede={`Round and rectangular screens, AMOLED and memory-in-pixel, and the black-and-white Instinct. The ${sunWindow.storeName} shows whether your exact model is listed.`}
        families={watchFamilies}
        languages={languages}
      />

      <CallToAction app={sunWindow} title="Check the sun without opening anything." />
    </>
  )
}
