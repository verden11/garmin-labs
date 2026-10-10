import { Doc, Note, PrivacyTail } from '../../components/Doc.tsx'
import { appName, permissions } from './facts.ts'

// Mirrors SunWindow/docs/release-contract.md "Data and privacy". It asks for Positioning, so no page or listing may say
// "no location". Update the effective date with any change to what is read or stored.
export function Privacy() {
  return (
    <Doc title="Privacy policy" lede={`${appName} for Garmin watches. Effective 10 October 2026.`}>
      <Note>
        <strong>In short:</strong> {appName} keeps everything on your watch. It has no account, no internet access, no
        analytics and no ads. It reads your watch’s last known place and its own weather, stores a place rounded to about 11
        km and your accent colour, and sends nothing to the developer or to anyone else.
      </Note>

      <h2>What {appName} reads</h2>
      <p>
        To work out where the sun is, as the screen draws: the time and date, a location (see below) and, from your watch’s own
        weather, the current UV index (and cloud cover as a fallback). The weather is Garmin’s own estimate, read from data the
        watch already holds; {appName} uses it only to show an open window as closed when the UV index is low, and gives no advice
        about it.
      </p>

      <h2>Permissions</h2>
      <p>The app asks for this, and for nothing else:</p>
      <ul>
        {permissions.map(([name, why]) => (
          <li key={name}><strong>{name}</strong>: {why}</li>
        ))}
      </ul>

      <h2>Location</h2>
      <p>
        {appName} needs to know roughly where you are to place the sun. It reads the last location your watch already knows and,
        only if there is none, asks the watch for one position once. It keeps that place rounded to about 0.1 degree, roughly
        11 km, so it is a region and not an address. The rounded place is stored on the watch only.
      </p>

      <h2>What {appName} saves</h2>
      <p>
        Two things, kept in the app’s own storage on your watch: that rounded place and your accent colour. The weather and
        everything else is held in memory while the screen draws and is not saved.
      </p>

      <h2>What {appName} shares</h2>
      <p>
        Nothing. It has no network access, so your place and the weather are never sent by the app to the developer, to Garmin
        Connect or to anyone else. Your accent colour is the one thing that passes through Garmin Connect, so a change made in the
        phone app can reach the watch.
      </p>

      <PrivacyTail />
    </Doc>
  )
}
