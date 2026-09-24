import { Doc, Note, PrivacyTail } from '../../components/Doc.tsx'

export function Privacy() {
  return (
    <Doc title="Privacy policy" lede="HeroSet for Garmin watches. Effective 19 September 2026.">
      <Note>
        <strong>In short:</strong> HeroSet keeps everything on your watch. It has no account, no internet access, no
        analytics and no ads.
      </Note>

      <h2>What HeroSet uses</h2>
      <p>
        While a set is running, HeroSet reads the watch’s motion sensor to count reps, and its heart rate and daily calorie
        total to show them on screen. These readings are not saved. Sensor access is the only permission it asks for.
      </p>

      <h2>What HeroSet saves</h2>
      <p>
        Your daily counts, XP and streak, your last 30 sets, and what it has learned about how you move. This stays in
        HeroSet’s storage on your watch and is deleted when you remove the app.
      </p>

      <h2>What HeroSet shares</h2>
      <p>Nothing. It sends no data to the developer, to Garmin Connect or to anyone else.</p>

      <PrivacyTail />
    </Doc>
  )
}
