import { Doc, Note, PrivacyTail } from '../../components/Doc.tsx'

export function Privacy() {
  return (
    <Doc title="Privacy policy" lede="Days To Go for Garmin watches. Effective 26 September 2026.">
      <Note>
        <strong>In short:</strong> Days To Go keeps everything on your watch. It asks for no permissions, has no account,
        no internet access, no analytics and no ads.
      </Note>

      <h2>What Days To Go reads</h2>
      <p>
        To draw the face: the time and date, and, only if you turn them on, the battery level or your step count. It
        reads these from your watch as it draws and saves none of them.
      </p>

      <h2>What Days To Go saves</h2>
      <p>Only your settings, on the watch (see below). Nothing else is stored, and it is deleted when you remove the face.</p>

      <h2>What Days To Go shares</h2>
      <p>Nothing. It sends no data to the developer, to Garmin Connect or to anyone else.</p>

      <h2>Settings</h2>
      <p>
        Your face settings are stored by Garmin Connect so they can reach the watch. They contain only your choices: the
        event and its date, an optional name you type, the time of day, how to count, the date style, the bottom line and
        the accent colour. If you type a name, it is stored with the other settings and shown only on your watch.
      </p>

      <PrivacyTail />
    </Doc>
  )
}
