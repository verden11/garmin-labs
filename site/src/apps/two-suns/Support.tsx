import { Doc, Note } from '../../components/Doc.tsx'
import { studio } from '../../site.ts'
import { appName } from './facts.ts'

export function Support() {
  return (
    <Doc title="Support" lede={`Help for ${appName}, the sun and Body Battery watch face for Garmin watches.`}>
      <h2>Contact</h2>
      <p>
        Questions or bugs: email <a href={`mailto:${studio.email}`}>{studio.email}</a>. Please include your watch model
        and its software version, what the face says, and what your watch’s own Sunrise/Sunset screen says at the same
        moment.
      </p>

      <h2>The settings</h2>
      <p>
        In the Garmin Connect app, open your watch, then Connect IQ Apps → Watch Faces → {appName} → Settings. There are
        seven in Two Suns Pro, all plain lists: <em>Accent colour</em> (sky, mint, autumn, violet, pink, winter), <em>Ring orientation</em>{' '}
        (noon at the top, or midnight at the top), <em>Golden hour</em> (off, or on), <em>Energy curve</em> (the Body
        Battery curve, on or off), <em>Date</em> (on or off), <em>Weather</em> and <em>Watch battery</em> (both off unless
        you switch them on). Two Suns, the free face, has the accent colour only. The face works with the defaults if you change nothing.
      </p>
      <Note>
        If the phone app will not save your settings, try Garmin Express on a computer, or reinstall the face and try
        again.
      </Note>

      <h2>What the bottom line says</h2>
      <p>
        By day it says how much daylight is left (“8h 41m of daylight”). Before sunrise and after sunset it says when the sun
        comes up (“Sunrise 06:41”). A “~” (“Sunrise ~06:41”) means the time is today’s, used as an estimate for tomorrow
        because the watch does not know where you are. In midnight sun and polar night it says “Sun stays up today” or “Sun
        stays down today”. On small screens the sentence gets shorter (“Rise 06:41”).
      </p>

      <h2>Common questions</h2>
      <h3>It says “No place yet”.</h3>
      <p>
        The watch has not told the face where you are, so the face cannot calculate where the sun is. Two things to try:
        start a GPS activity, wait until the watch has found satellites, then discard it; or open Garmin’s Sunrise/Sunset
        widget or glance on the watch once. Give the face a minute to redraw. Where the watch gives the face its own sunrise
        and sunset, the face uses them even without a place, and this message does not appear; it appears only when the
        watch gives neither.
      </p>
      <h3>It says “No sun data”.</h3>
      <p>The watch is not giving the face its sunrise and sunset values, and the face has no place to calculate from. This is rare. Try the two steps above.</p>
      <h3>The Body Battery number is “--”.</h3>
      <p>
        The watch has no valid reading in the last 24 hours, for example because it has not been worn. The face shows
        nothing rather than guessing; the “--” is grey, like the hollow bolt beside it. A curve or number in grey, with a hollow
        dot, means the newest reading is more than an hour old. The number keeps one colour at any level. In Two Suns Pro a new
        curve appears once two readings sit close together; until then its place under the time stays empty.
      </p>
      <h3>Is the Body Battery figure Garmin’s?</h3>
      <p>
        Yes. It is Garmin’s estimate, read from the history your watch keeps. The face draws it and gives no advice or
        judgement about it. Gaps in the history stay gaps in the curve.
      </p>
      <h3>What is the golden hour arc?</h3>
      <p>
        A warm arc on the ring for the time when the sun is low in the sky, calculated by the face. It appears only when
        Golden hour is on and the watch has a place.
      </p>
      <h3>Why did a row disappear on my watch?</h3>
      <p>
        On a small screen the face drops rows before it would crowd the time: the date first, then the curve, then the sun
        line. The time and the Body Battery number always stay.
      </p>
      <h3>Why does the ring jump on the day the clocks change?</h3>
      <p>The ring shows the wall clock, 0 to 24 hours, so on the day the clocks change it has a one-hour jump.</p>
      <h3>What does the always-on screen show?</h3>
      <p>
        On AMOLED watches: the time, the Body Battery number and the sun line in dim grey, moving position every minute. The
        full face shows when the watch is awake. Other watches keep the full face.
      </p>
      <h3>What does the face store?</h3>
      <p>Your settings and a place rounded to about 11 km, on the watch only. Nothing is sent anywhere. See the privacy policy.</p>
    </Doc>
  )
}
