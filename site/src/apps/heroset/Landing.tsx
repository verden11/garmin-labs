import { RepCounter } from './Pictograms.tsx'
import { RankScale } from './RankScale.tsx'
import { heroset } from './app.ts'
import { screens, watchFamilies, languages } from './facts.ts'
import { CallToAction, HeroActions, Screens, Watches } from '../../components/AppSections.tsx'
import { studio } from '../../site.ts'
import { appUrl } from '../../urls.ts'


const Key = ({ name }: { name: string }) => <kbd className="key">{name}</kbd>

const steps = [
  { keys: ['START'], title: 'Pick an exercise', text: 'Push-ups, sit-ups or squats. Counting starts the moment you choose.' },
  { keys: [], title: 'Move', text: 'A short vibration confirms each rep. Live heart rate and a calorie estimate stay on screen.' },
  { keys: ['START'], title: 'Finish', text: 'The watch shows the count it detected, ready for review.' },
  { keys: ['UP', 'DOWN'], title: 'Adjust', text: 'If the count is off, nudge it up or down. On a touchscreen watch, swipe instead.' },
  { keys: ['START'], title: 'Save', text: 'Your count is banked. XP, rank and streak update, with a double buzz when a goal falls.' },
]

export function Landing() {
  return (
    <>
      <section className="hero field">
        <div className="wrap hero__inner">
          <div className="hero__copy">
            <h1 className="hero__name">{heroset.name}</h1>
            <p className="hero__offer">100 push-ups, 100 sit-ups and 100 squats a day, or your own goal from 10 to 500. Your Garmin counts the reps.</p>
            <HeroActions app={heroset} />
          </div>
          <div className="hero__reps">
            <p className="sr-only">Illustration: three figures doing push-ups, sit-ups and squats, each counting toward today’s goal of 100.</p>
            <div className="hero__figures" aria-hidden="true">
              {/* Every run ends within 5 s of load (WCAG 2.2.2): 0.8 s delay +
                  (100 − start) × tempo. Staggered, so the three finish apart. */}
              <RepCounter kind="pushup" label="Push-ups" start={97} tempo={1.3} />
              <RepCounter kind="situp" label="Sit-ups" start={96} tempo={1} />
              <RepCounter kind="squat" label="Squats" start={98} tempo={1.6} />
            </div>
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="set-title">
        <h2 id="set-title" className="band__title">One set, by feel.</h2>
        <p className="band__lede">No phone, no account, no tapping the screen. Every step works by feel, with the buttons your watch already has; on a touchscreen watch, a swipe replaces UP/DOWN.</p>
        <ol className="course">
          {steps.map((step) => (
            <li key={step.title} className="course__stop">
              <span className="course__keys">{step.keys.length ? step.keys.map((k) => <Key key={k} name={k} />) : null}</span>
              <h3>{step.title}</h3>
              <p>{step.text}</p>
            </li>
          ))}
        </ol>
      </section>

      <section className="truth" aria-labelledby="truth-title">
        <div className="wrap truth__inner">
          <h2 id="truth-title">You have the final say.</h2>
          <div className="truth__text">
            <p>Counting depends on how you wear the watch and how you move, so the number can be off, especially if your arm moves before or after the set. Nothing is saved until you’ve seen it.</p>
            <p>HeroSet learns from the counts you save, so counting adapts to how you move.</p>
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="progress-title">
        <h2 id="progress-title" className="band__title">Show up, rank up.</h2>
        <p className="band__lede">2 XP for every rep you save, up to 100 reps per exercise a day: 600 XP on a full day. Meet your daily goal on all three to keep your streak alive. Counts reset at local midnight; XP and rank never do.</p>
        <RankScale />
      </section>

      <section className="wrap band" aria-labelledby="private-title">
        <h2 id="private-title" className="band__title">Nothing leaves your watch.</h2>
        <dl className="facts">
          <div><dt>No account</dt><dd>Nothing to sign up for, nothing to log in to.</dd></div>
          <div><dt>No internet</dt><dd>No analytics, no ads, no tracking. The app has no network access at all.</dd></div>
          <div><dt>No syncing</dt><dd>HeroSet doesn’t record activities or send anything to Garmin Connect.</dd></div>
          <div><dt>One permission</dt><dd>Your watch’s sensors: motion to count reps, heart rate to show it.</dd></div>
        </dl>
        <p><a href={appUrl(heroset.slug, 'privacy')}>Read the privacy policy</a></p>
      </section>

      <Screens app={heroset} screens={screens} />

      <Watches
        title="Works on most Garmin watches."
        lede={`Round-screen watches, AMOLED and memory-in-pixel, with five buttons or a touchscreen. Tested on a Forerunner 965; every other model passes each screen check in Garmin’s simulator. The ${heroset.storeName} shows whether your exact model is listed. Don’t see yours? Email ${studio.email} with your model.`}
        families={watchFamilies}
        languages={languages}
      />

      <CallToAction app={heroset} title="Today’s hundred starts with one press." />
    </>
  )
}
