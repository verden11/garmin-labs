import { Doc, Note } from '../../components/Doc.tsx'
import { studio } from '../../site.ts'
import { watchCount, linkedWatchCount } from './facts.ts'
import { appUrl } from '../../urls.ts'

export function Support() {
  return (
    <Doc title="Support" lede="Help for HeroFace, the daily goals watch face for Garmin watches.">
      <h2>Contact</h2>
      <p>
        Questions or bugs: email <a href={`mailto:${studio.email}`}>{studio.email}</a>. Please include your watch model
        and its software version, and say which bar or reading looks wrong.
      </p>

      <h2>Changing what the bars show</h2>
      <p>
        In the Garmin Connect app, open your watch, then Connect IQ Apps → Watch Faces → HeroFace → Settings. Each of the
        three bars can be set to steps, calories, intensity minutes, distance, floors or the move bar, or left on
        Automatic. You can also pick the accent colour and turn seconds and the temperature on or off.
      </p>
      <Note>
        Automatic picks the first thing your watch actually measures. A watch with no barometer has no floor count, so
        that bar falls back to the move bar rather than sitting empty.
      </Note>

      <h2>Common questions</h2>
      <h3>A bar shows something I didn’t choose.</h3>
      <p>
        On Automatic, the face uses the first metric your watch supports: steps, then intensity minutes, then floors,
        with calories, distance and the move bar as fallbacks. Set that bar explicitly in settings to override it.
      </p>
      <h3>One bar has no bar, only a number.</h3>
      <p>
        Calories and distance have no daily goal on your watch, so there is nothing to fill. The number still updates.
      </p>
      <h3>What is the ring around the edge?</h3>
      <p>
        How far today has come across all three goals at once. It turns green when every one of them is met. With HeroSet
        showing, it becomes your progress towards the next rank instead.
      </p>
      <h3>What does the gold line mean?</h3>
      <p>
        Days in a row you have met your step goal. It appears once you have a streak, and disappears if you miss a day.
        With HeroSet showing, it becomes your rank and HeroSet streak.
      </p>
      <h3>The seconds stopped.</h3>
      <p>
        Watches allow a watch face only a small amount of power to redraw between minutes. If your watch withdraws it,
        HeroFace turns seconds off rather than leaving a frozen number on screen. Turn them back on in settings.
      </p>
      <h3>Why is there no temperature?</h3>
      <p>
        The face shows the weather your watch already has, which arrives with a phone sync. Older watches have no weather
        at all, and then the temperature is simply left out.
      </p>
      <h3>How do I show my HeroSet reps?</h3>
      <p>
        Install <a href={appUrl('heroset')}>HeroSet</a> and open it once. On the {linkedWatchCount} watches that support it, the
        bars then show push-ups, sit-ups and squats, and the ring shows rank progress. Holding the face opens HeroSet.
        Without HeroSet, the face shows your everyday goals and nothing is missing.
      </p>
      <h3>Which watches are supported?</h3>
      <p>
        {watchCount} Garmin watches with round screens, from Connect IQ 3.0 upwards. The Connect IQ Store shows whether
        your exact model is listed. HeroFace has been tested on a Forerunner 965; every screen size passes each screen
        check in Garmin’s simulator.
      </p>
    </Doc>
  )
}
