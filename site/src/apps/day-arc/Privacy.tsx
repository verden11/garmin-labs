import { Doc, Note, PrivacyTail } from '../../components/Doc.tsx'
import { appName, permissions } from './facts.ts'

export function Privacy() {
  return (
    <Doc title="Privacy policy" lede={`${appName} for Garmin watches. Effective 28 September 2026.`}>
      <Note>
        <strong>In short:</strong> {appName} keeps everything on your watch. It has no account, no internet access, no
        analytics, no ads, and stores just one setting (your accent colour choice). It asks for one permission, listed below, and sends nothing to the
        developer or to anyone else.
      </Note>

      <h2>What {appName} reads</h2>
      <p>
        To draw the face, as it draws, and saving none of it: the time and date, and, depending on the time of day, your
        watch's own weather, stress, and Body Battery readings. Every reading is Garmin's own estimate, read from data the
        watch already has. {appName} shows it as Garmin reports it and gives no advice or judgement about it.
      </p>

      <h2>Permissions</h2>
      <p>The face asks for this, and for nothing else:</p>
      <ul>
        {permissions.map(([name, why]) => (
          <li key={name}><strong>{name}</strong>: {why}</li>
        ))}
      </ul>
      <p>{appName} does not read your location. It has no Positioning permission.</p>

      <h2>What {appName} saves</h2>
      <p>One thing: the accent colour you choose, a single small number kept in the app's own settings storage on your watch. No readings are stored — every value is read fresh each time the face redraws. If you change the colour in the Garmin Connect app, Garmin's own app and settings sync carry that choice to your watch; that is Garmin's mechanism, not something {appName} sends anywhere.</p>

      <h2>What {appName} shares</h2>
      <p>Nothing. It has no network access, so nothing the face reads is ever sent to the developer, to Garmin Connect, or to anyone else.</p>

      <PrivacyTail />
    </Doc>
  )
}
