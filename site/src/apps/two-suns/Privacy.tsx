import { Doc, Note, PrivacyTail } from '../../components/Doc.tsx'
import { appName, permissions } from './facts.ts'

// Two tiers, two privacy stories (TwoSuns docs/release-contract.md "Free and Pro listings"): the free face reads no
// location and stores no place or history; Pro keeps a rounded place. Never describe Pro's place or history as the free face's.
export function Privacy() {
  return (
    <Doc title="Privacy policy" lede={`${appName} and ${appName} Pro for Garmin watches. Effective 8 October 2026.`}>
      <Note>
        <strong>In short:</strong> both faces keep everything on your watch. Neither has an account, internet access,
        analytics or ads, and neither sends anything to the developer or to anyone else. {appName}, the free face, reads no
        location and stores no place and no history. {appName} Pro keeps a place rounded to about 11 km on the watch. Your
        settings pass through Garmin Connect (see Settings below).
      </Note>

      <h2>{appName} (free)</h2>
      <p>
        To draw the face, as it draws: the time and date, the watch’s own sunrise and sunset values, and Garmin’s own
        current Body Battery number. Body Battery is Garmin’s estimate; the face shows it as Garmin reports it and gives no
        advice about it. Its one permission is <strong>Complications</strong>, to read those values. It asks for no location
        permission and reads no location. It stores no place and no history; the only thing it saves is your accent colour
        setting.
      </p>

      <h2>{appName} Pro: what it reads</h2>
      <p>
        To draw the face, as it draws, and saving none of it except the rounded place described below: the time and date;
        your Body Battery for the last 24 hours and its current value; the watch’s own sunrise and sunset values; a location
        (see below); and, only if you switch those rows on, the weather your watch already holds and the watch’s battery
        level.
      </p>

      <h2>{appName} Pro: permissions</h2>
      <p>The face asks for these, and for nothing else:</p>
      <ul>
        {permissions.map(([name, why]) => (
          <li key={name}><strong>{name}</strong>: {why}</li>
        ))}
      </ul>

      <h2>{appName} Pro: location</h2>
      <p>
        {appName} Pro needs to know roughly where you are to place the sun. It reads the last location your watch already
        knows and keeps it rounded to about 0.1 degree, roughly 11 km, so it is a region and not an address. That rounded
        place is stored on the watch only, and only that.
      </p>

      <h2>{appName} Pro: what it saves</h2>
      <p>
        Your settings and that rounded place, kept in the app’s own storage on the watch. Nothing else is stored: Body
        Battery readings and the weather are held in memory while the face draws and are not saved.
      </p>

      <h2>What either face shares</h2>
      <p>
        Nothing. Neither has network access, so your location, your Body Battery and the weather are never sent by the face
        to the developer, to Garmin Connect or to anyone else. Your settings are the one thing that passes through Garmin
        Connect (see Settings below).
      </p>

      <h2>Settings</h2>
      <p>
        Your face settings are stored by Garmin Connect so they can reach the watch. They contain only your choices: in{' '}
        {appName}, the accent colour; in {appName} Pro, the accent colour, the ring orientation, and whether the golden
        hour, the energy curve (the Body Battery curve), the date, the weather row and the watch battery row are shown.
      </p>

      <PrivacyTail />
    </Doc>
  )
}
