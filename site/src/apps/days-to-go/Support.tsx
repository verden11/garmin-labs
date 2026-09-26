import { Doc, Note } from '../../components/Doc.tsx'
import { studio } from '../../site.ts'

export function Support() {
  return (
    <Doc title="Support" lede="Help for Days To Go, the countdown watch face for Garmin watches.">
      <h2>Contact</h2>
      <p>
        Questions or bugs: email <a href={`mailto:${studio.email}`}>{studio.email}</a>. Please include your watch model
        and its software version, and the date you set.
      </p>

      <h2>Setting the date</h2>
      <p>
        In the Garmin Connect app, open your watch, then Connect IQ Apps → Watch Faces → Days To Go → Settings. Set{' '}
        <em>Event</em> to <em>My own date</em>, then choose the Month, Day and Year from the lists. Every date setting is a
        plain list, so there is no date picker to fill in.
      </p>
      <Note>
        If the phone app will not save your settings, try Garmin Express on a computer, or reinstall the face and try
        again. Until you set a date, the face counts to the next New Year’s Day.
      </Note>

      <h2>Setting the date on the watch</h2>
      <p>
        On many watches you can also set it without the phone: open the watch-face list, choose Days To Go, then choose
        Customize (next to Apply) and Set date. Pick the month, day and year. The face updates at once. Some watches do not
        offer this and need the phone or Garmin Express.
      </p>

      <h2>Common questions</h2>
      <h3>What does “Every year” mean?</h3>
      <p>
        Choose Every year as the Year and the face counts to the next time that day comes round: birthdays, anniversaries,
        holidays. It rolls over by itself the day after. For 29 February it counts to 28 February in years that have no
        29 February.
      </p>
      <h3>It says SET A DATE.</h3>
      <p>
        The date you saved does not exist, for example 30 February or, with Every year, 31 April. Pick a real date. The
        Day list offers 1 to 31 for every month, so this is easy to do by accident.
      </p>
      <h3>When does the count change?</h3>
      <p>
        At midnight on your watch’s clock. The day itself says TODAY; the day after it counts the days since, or, with
        Every year, starts counting to next year.
      </p>
      <h3>How do I count to a time, not just a day?</h3>
      <p>
        Set Time of day to the hour of the event. In the last 24 hours the face shows hours and minutes, and once the time
        arrives it says TODAY until midnight. The list of hours is always in 24-hour form (18:00), whatever your watch
        uses for the clock.
      </p>
      <h3>How do I see weeks?</h3>
      <p>Set Count in to Weeks and days. From one full week on, the face shows whole weeks and the days over (6 WEEKS + 3 DAYS).</p>
      <h3>The date reads the wrong way round.</h3>
      <p>
        The face writes dates in words (Fri 25 Dec), so they cannot be misread, but the system does not tell it whether
        you prefer day first or month first. Set Date style to Day first or Month first. Automatic guesses month first
        only for English watches that use miles, and on some older watches it always writes day first.
      </p>
      <h3>Can I name the event?</h3>
      <p>Yes: up to 16 characters in Name. Leave it empty to hide the name row.</p>
      <h3>Does it work without my phone?</h3>
      <p>Once set up, yes. Nothing on the face needs a connection.</p>
    </Doc>
  )
}
