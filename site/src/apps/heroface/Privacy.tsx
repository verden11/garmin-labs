import { Doc, Note, PrivacyTail } from '../../components/Doc.tsx'
import { appUrl } from '../../urls.ts'

export function Privacy() {
  return (
    <Doc title="Privacy policy" lede="HeroFace and HeroFace Pro for Garmin watches. Effective 8 October 2026.">
      <Note>
        <strong>In short:</strong> HeroFace and HeroFace Pro keep everything on your watch. Neither has an account, internet access,
        analytics or ads.
      </Note>

      <h2>What HeroFace reads</h2>
      <p>
        To draw the face: the time and date, your step, intensity-minute and floor counts and their goals, the move bar,
        calories, distance, heart rate, battery level and unread notification count. HeroFace Pro also reads the weather
        your watch has already received, for the temperature. It reads these from your watch as it draws, and saves none of them.
      </p>

      <h2>What HeroFace saves</h2>
      <p>
        Two things, in HeroFace’s own storage on the watch: how many days in a row you have met your step goal, and the
        most recent progress published by HeroSet, so the face can still show it after a restart. Both are deleted when
        you remove the face.
      </p>

      <h2>HeroSet</h2>
      <p>
        If you also own <a href={appUrl('heroset')}>HeroSet</a> and your watch supports it, HeroFace can show your reps, rank and
        streak. HeroSet publishes that progress on the watch itself, readable only by apps from this developer. It never
        leaves the watch, and neither app needs an internet connection for it to work.
      </p>

      <h2>What HeroFace shares</h2>
      <p>Nothing. It sends no data to the developer, to Garmin Connect or to anyone else.</p>

      <h2>Settings</h2>
      <p>
        Your face settings are stored by Garmin Connect so they can reach the watch. They contain only your display
        choices: whether HeroSet progress may show and the accent colour; in HeroFace Pro also which metrics the bars show
        and whether seconds and temperature appear.
      </p>

      <PrivacyTail />
    </Doc>
  )
}
