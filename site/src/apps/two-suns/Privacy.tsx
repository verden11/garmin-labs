import { Doc, Note, PrivacyTail } from '../../components/Doc.tsx'
import { appName, permissions } from './facts.ts'

export function Privacy() {
  return (
    <Doc title="Privacy policy" lede={`${appName} for Garmin watches. Effective 26 September 2026.`}>
      <Note>
        <strong>In short:</strong> {appName} keeps everything on your watch. It has no account, no internet access, no
        analytics and no ads. It asks for {permissions.length} permissions, listed below, and sends nothing to the developer
        or to anyone else. Your settings pass through Garmin Connect (see Settings below).
      </Note>

      <h2>What {appName} reads</h2>
      <p>
        To draw the face, as it draws, and saving none of it except the rounded place described below: the time and date; your Body Battery for the last 24
        hours and its current value; the watch’s own sunrise and sunset values; and a location (see below). Body Battery is
        Garmin’s own estimate. {appName} shows it as Garmin reports it and gives no advice about it.
      </p>

      <h2>Permissions</h2>
      <p>The face asks for these, and for nothing else:</p>
      <ul>
        {permissions.map(([name, why]) => (
          <li key={name}><strong>{name}</strong>: {why}</li>
        ))}
      </ul>

      <h2>Location</h2>
      <p>
        {appName} needs to know roughly where you are to place the sun. It reads the last location your watch already
        knows and keeps it rounded to about 0.1 degree, roughly 11 km, so it is a region and not an address. That rounded
        place is stored on the watch only, and only that.
      </p>

      <h2>What {appName} saves</h2>
      <p>
        Your settings and that rounded place, kept in the app’s own storage on the watch. Nothing else is stored: Body Battery readings are held in
        memory while the face draws and are not saved.
      </p>

      <h2>What {appName} shares</h2>
      <p>
        Nothing. It has no network access, so your location and your Body Battery are never sent by the face to the
        developer, to Garmin Connect or to anyone else. Your settings are the one thing that passes through Garmin Connect
        (see Settings below).
      </p>

      <h2>Settings</h2>
      <p>
        Your face settings are stored by Garmin Connect so they can reach the watch. They contain only your choices: the
        accent colour, the ring orientation, and whether the golden hour, the energy curve (the Body Battery curve) and the date are shown.
      </p>

      <PrivacyTail />
    </Doc>
  )
}
