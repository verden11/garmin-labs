import { Doc, Note } from '../../components/Doc.tsx'
import { studio } from '../../site.ts'
import { appName } from './facts.ts'

export function Support() {
  return (
    <Doc title="Support" lede={`Help for ${appName}, a Garmin widget that shows whether the sun is at or above 45 degrees.`}>
      <h2>Contact</h2>
      <p>
        Questions or bugs: email <a href={`mailto:${studio.email}`}>{studio.email}</a>. Please include your watch model and its
        software version, where you were (the country is enough), and what {appName} showed at the time.
      </p>

      <h2>How to read it</h2>
      <p>
        The glance in your watch’s glance list shows one word: <strong>OPEN</strong>, <strong>CLOSED</strong> or{' '}
        <strong>NONE TODAY</strong>. Open the app for the picture: today’s sun path over a dashed line at 45 degrees, the
        part above the line drawn thick, and a dot for the sun now (filled while the window is open). Under it are the word,
        one line that says why it is closed, and today’s times.
      </p>
      <Note>For information only; not medical advice or a sun-safety tool. The 45 degrees is a display rule (your shadow is no longer than you are), not a medical threshold.</Note>

      <h2>The settings</h2>
      <p>
        There is one: <strong>Accent colour</strong>, a short list (Sky, Mint, Amber, Pink, Violet or White). Change it in the
        Garmin Connect app (open {appName}’s settings there) or from the app’s own menu on the watch. It only colours the
        thick part of the sun’s path and the dot; it never changes what a state means. The black-and-white Instinct has no
        colour setting.
      </p>

      <h2>Common questions</h2>
      <h3>The glance says “Open once”.</h3>
      <p>
        {appName} has not found where you are yet. Open the app once and wait for the picture; your watch’s last known place is
        usually enough and arrives at once. After that the glance shows the state by itself.
      </p>
      <h3>It says “Finding your place”, then “No place yet”.</h3>
      <p>
        Your watch has no usable position right now. Press START to ask again, ideally outdoors or at a window. {appName} never
        guesses a place.
      </p>
      <h3>It says NONE TODAY.</h3>
      <p>
        Today’s highest sun stays under 45 degrees. In the north that is the normal state for much of the winter: at the latitude
        of Vilnius the sun reaches that height only from about mid April to late August.
      </p>
      <h3>The sun is high but it says CLOSED, “Cloud cover”.</h3>
      <p>
        Your watch’s own weather reports a low UV index, so an open window shows as closed. If you think the watch’s reading is
        wrong, that is the watch’s weather, not {appName}’s.
      </p>
      <h3>It says “No weather”.</h3>
      <p>The watch gave no UV reading, so the sun’s height alone decides. Nothing is hidden or guessed.</p>
      <h3>I travelled and it looks wrong.</h3>
      <p>{appName} updates your place whenever you open the app. After a trip, open it once; the glance is right again after that.</p>
      <h3>How long does the app stay open?</h3>
      <p>When you open it from the glance the watch closes it by itself after about two minutes without a button press.</p>
      <h3>What does it store?</h3>
      <p>Your place, rounded to about 11 km, and your accent colour. See the privacy policy.</p>
    </Doc>
  )
}
