import { Doc, Note } from '../../components/Doc.tsx'
import { studio } from '../../site.ts'
import { appName } from './facts.ts'

export function Support() {
  return (
    <Doc title="Support" lede={`Help for ${appName}, a watch face that changes through the day.`}>
      <h2>Contact</h2>
      <p>
        Questions or bugs: email <a href={`mailto:${studio.email}`}>{studio.email}</a>. Please include your watch model
        and its software version, and what the face showed at the time.
      </p>

      <h2>The settings</h2>
      <p>
        There are none. {appName} has no phone-app settings and no on-watch Customize menu — every choice (the four time
        windows, which fields show) is fixed at build time.
      </p>
      <Note>This is deliberate: settings not saving is this platform's most common complaint, so {appName} has nothing to fail to save.</Note>

      <h2>Common questions</h2>
      <h3>The stress or Body Battery number is "--".</h3>
      <p>
        Your watch has no valid reading right now — for example, stress isn't tracked during a logged activity. The face
        shows nothing rather than guessing, and says so in words below the number.
      </p>
      <h3>Why doesn't midday show my next event?</h3>
      <p>
        {appName} keeps one reading per window on purpose. DayArc Pro, a separate listing, adds a calendar field and a
        denser grid of other fields to every window.
      </p>
      <h3>Why does the face look different at night?</h3>
      <p>Between 23:00 and 5:00 the face shows time and date only — no health reading. This is a fixed schedule, the same every day.</p>
      <h3>What does the always-on screen show?</h3>
      <p>
        On AMOLED watches: the time only, dim, moving position every minute to avoid burn-in. The full face shows when the
        watch is awake. Other watches keep the full face.
      </p>
      <h3>What does the face store?</h3>
      <p>Nothing. {appName} has no settings and no storage — see the privacy policy.</p>
    </Doc>
  )
}
