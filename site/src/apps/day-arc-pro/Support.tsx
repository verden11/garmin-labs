import { Doc, Note } from '../../components/Doc.tsx'
import { studio } from '../../site.ts'
import { appName } from './facts.ts'

export function Support() {
  return (
    <Doc title="Support" lede={`Help for ${appName}, the data-rich version of DayArc.`}>
      <h2>Contact</h2>
      <p>
        Questions or bugs: email <a href={`mailto:${studio.email}`}>{studio.email}</a>. Please include your watch model
        and its software version, and what the face showed at the time.
      </p>

      <h2>The settings</h2>
      <p>
        There is one: <strong>Accent colour</strong>, in the Garmin Connect app (open {appName}'s settings there). It is a
        short list — Auto, which is the default and gives each time of day its own colour, or Cyan, Amber, Rose, Green,
        Blue or Purple — and it colours the progress arc, the main number and its icon in every window except night. The
        small icons in the field grid keep their own fixed colours. It only ever changes the colour, never what a number
        means. Every field and every window is fixed at build time.
      </p>
      <Note>If the setting is ever missing or can't be read, the face simply shows its normal Auto colours.</Note>

      <h2>Common questions</h2>
      <h3>The morning says "Weather unavailable".</h3>
      <p>
        Your watch has no weather reading right now. The morning then shows the
        time, the date and those words, with your fields under them, rather than a lone "--".
      </p>
      <h3>Some fields are missing on my watch.</h3>
      <p>
        The grid shows only as many fields as measurably fit your watch's screen — the smallest screens in the supported
        set show fewer than the largest. A field your watch doesn't support at all shows as "--", not blank.
      </p>
      <h3>The calendar field says "None".</h3>
      <p>This can mean either your watch has no calendar sync enabled, or you simply have nothing upcoming — the watch doesn't tell {appName} which.</p>
      <h3>How is this different from DayArc?</h3>
      <p>Same four time windows, same fixed schedule, same no-verdict wording on stress and Body Battery. {appName} adds a denser field grid under each window's main reading, and is a one-time paid listing with no free tier.</p>
      <h3>What does the always-on screen show?</h3>
      <p>On AMOLED watches: the time only, dim, moving position every minute to avoid burn-in. The full face shows when the watch is awake. Other watches keep the full face.</p>
      <h3>What does it look like on a rectangular watch?</h3>
      <p>
        It has its own square design there: the arc that shows how far the window has come runs along the top of a track
        around the screen, the Stress and Body Battery gauge is a straight bar, and the time, date and readings use the room
        inside the track. Round watches and the Instinct keep their own layout.
      </p>
      <h3>What does the face store?</h3>
      <p>One thing: your accent colour choice, a small number kept in the app's own settings storage on the watch. No readings are stored — see the privacy policy.</p>
    </Doc>
  )
}
