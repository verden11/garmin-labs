import { RepCounter } from './Pictograms.tsx'
import { RankScale } from './RankScale.tsx'
import { heroset } from './app.ts'
import { screens, watchFamilies, languages, watchCount } from './facts.ts'

function StoreAction() {
  return heroset.storeUrl
    ? <a className="button" href={heroset.storeUrl}>Get it on the {heroset.storeName}</a>
    : <p className="status">Coming soon to the {heroset.storeName}</p>
}

const Key = ({ name }: { name: string }) => <kbd className="key">{name}</kbd>

const steps = [
  { keys: ['START'], title: 'Pick an exercise', text: 'Push-ups, sit-ups or squats. Counting starts the moment you choose.' },
  { keys: [], title: 'Move', text: 'A short vibration confirms each rep. Live heart rate and a calorie estimate stay on screen.' },
  { keys: ['START'], title: 'Finish', text: 'The watch shows the count it detected, ready for review.' },
  { keys: ['UP', 'DOWN'], title: 'Fix it', text: 'Add or remove any rep the watch missed or invented, one press per rep.' },
  { keys: ['START'], title: 'Save', text: 'Your count is banked. XP, rank and streak update, with a double buzz when a goal falls.' },
]

export function Landing() {
  return (
    <>
      <section className="hero field">
        <div className="wrap hero__inner">
          <div className="hero__copy">
            <h1 className="hero__name">{heroset.name}</h1>
            <p className="hero__offer">100 push-ups, 100 sit-ups and 100 squats a day. Your Garmin counts the reps. You fix any miss before it’s saved.</p>
            <div className="hero__actions">
              <StoreAction />
              <a className="hero__support" href="/heroset/support/">Support and answers</a>
            </div>
          </div>
          <div className="hero__reps">
            <p className="sr-only">Illustration: three figures doing push-ups, sit-ups and squats, each counting toward today’s goal of 100.</p>
            <div className="hero__figures" aria-hidden="true">
              <RepCounter kind="pushup" label="Push-ups" start={82} tempo={1.5} />
              <RepCounter kind="situp" label="Sit-ups" start={71} tempo={1.9} />
              <RepCounter kind="squat" label="Squats" start={88} tempo={1.7} />
            </div>
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="set-title">
        <h2 id="set-title" className="band__title">One set, five buttons.</h2>
        <p className="band__lede">No phone, no touchscreen, no account. Every step works by feel, with the bezel buttons your watch already has.</p>
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
          <h2 id="truth-title">Your count is the truth.</h2>
          <div className="truth__text">
            <p>Automatic counting is in beta and can miscount, especially if your arm moves before or after the set. So nothing is saved until you’ve seen the number and agreed with it.</p>
            <p>HeroSet learns from the counts you save, corrected or not: they are what it tunes its counting to.</p>
          </div>
        </div>
      </section>

      <section className="wrap band" aria-labelledby="progress-title">
        <h2 id="progress-title" className="band__title">Show up, rank up.</h2>
        <p className="band__lede">2 XP for every rep you save, up to each day’s goal: 600 XP on a full day. Finish all three hundreds to keep your streak alive. Counts reset at local midnight; XP and rank never do.</p>
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
        <p><a href="/heroset/privacy/">Read the privacy policy</a></p>
      </section>

      <section className="wrap band" aria-labelledby="screens-title">
        <h2 id="screens-title" className="band__title">On the wrist.</h2>
        <ul className="screens">
          {screens.map((shot) => (
            <li key={shot.label}>
              {shot.src
                ? <img src={shot.src} alt={`HeroSet ${shot.label.toLowerCase()} screen`} width="454" height="454" loading="lazy" />
                : <span className="screens__pending">Screenshot pending</span>}
              <span className="screens__label">{shot.label}</span>
            </li>
          ))}
        </ul>
      </section>

      <section className="wrap band" aria-labelledby="watches-title">
        <h2 id="watches-title" className="band__title">{watchCount} Garmin watches.</h2>
        <p className="band__lede">Round-screen watches with five buttons, AMOLED and memory-in-pixel. Tested on a Forerunner 965; every other model passes each screen check in Garmin’s simulator. The {heroset.storeName} shows whether your exact model is listed.</p>
        <dl className="watches">
          {watchFamilies.map(([family, models]) => (
            <div key={family}><dt>{family}</dt><dd>{models}</dd></div>
          ))}
        </dl>
        <p className="band__aside">In {languages.length} languages: {languages.join(', ')}.</p>
      </section>

      <section className="field close">
        <div className="wrap close__inner">
          <h2>Today’s hundred starts with one press.</h2>
          <div className="hero__actions">
            <StoreAction />
            <a className="hero__support" href="/heroset/support/">Support and answers</a>
          </div>
        </div>
      </section>
    </>
  )
}
