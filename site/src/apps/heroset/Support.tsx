import { Doc, Note } from '../../components/Doc.tsx'
import { studio } from '../../site.ts'
import { glanceLive, instinctLive } from './facts.ts'

export function Support() {
  return (
    <Doc title="Support" lede="Help for HeroSet, the daily push-up, sit-up and squat app for Garmin watches.">
      <h2>Contact</h2>
      <p>
        Questions or bugs: email <a href={`mailto:${studio.email}`}>{studio.email}</a>. Please include
        your watch model, its software version, and which exercise you were doing.
      </p>

      <h2>Getting accurate counts</h2>
      <ul>
        <li><strong>Save the count you really did.</strong> After each set, adjust the count with UP/DOWN if needed before saving. HeroSet learns from the counts you save.</li>
        <li><strong>Start the set in position</strong>, and wear the watch snug in the same spot each time. Arm movement before you start or after you finish can count as reps.</li>
        <li><strong>Hold still for a second</strong> after pressing START, then begin your first rep.</li>
        <li><strong>Move through full reps.</strong> Tiny partial movements may not count.</li>
      </ul>
      <Note>
        Counting depends on how you wear the watch and how you move. When you finish a set, press START to review the count, adjust it
        with UP/DOWN, then press START again to save.
      </Note>

      <h2>Common questions</h2>
      <h3>Does HeroSet add activities to Garmin Connect?</h3>
      <p>No. HeroSet records no activity and sends nothing to your phone or the internet. Your progress lives on the watch.</p>
      <h3>Do my sets add intensity minutes?</h3>
      <p>
        Not through HeroSet. A set is not saved as an activity, so it adds no workout, intensity minutes or training load of its own.
        Your watch still counts intensity minutes from your heart rate on its own, as it does all day.
      </p>
      <h3>Are the calories exact?</h3>
      <p>No. The calorie figure is the change in Garmin’s own daily calorie total during your set, an estimate. HeroSet is not a medical device.</p>
      <h3>Can I change the daily goal?</h3>
      <p>
        Yes, on the watch: open the menu, choose <strong>Daily Goal</strong>, and set anything from 10 to 500 reps with
        UP/DOWN. It applies to all three exercises, no phone needed. Lowering it below what you have already done
        completes today straight away.
      </p>
      <h3>What if I correct today’s count back under my goal?</h3>
      <p>
        Then today is no longer done: your streak goes back to what it was before today counted, in the app, the glance and,
        on watches with Connect IQ 4.2 or later, HeroFace. Save today’s count over the goal again and the day completes again.
        XP you earned stays. Raising the daily goal never takes a finished day back.
      </p>
      <h3>Does a higher goal earn rank faster?</h3>
      <p>
        No. Rank reflects the reps you do, not the goal you pick: XP stops at 100 reps per exercise per day whatever your
        goal is. A goal of 30 keeps your streak going every day, and rank climbs at the pace of the work behind it.
      </p>
      <h3>When do the daily counts reset?</h3>
      <p>At midnight, watch local time. XP, rank and streak carry over; missing a day resets the streak.</p>
      {glanceLive && (
        <>
          <h3>Is there a glance?</h3>
          <p>
            Yes, on watches with Connect IQ 4.0 or later, which is most supported models: scroll through your glance
            list (add HeroSet to it if it is not there) to see today’s push-ups, sit-ups and squats and your streak
            without opening the app, and select it to open HeroSet. It is not available on fēnix 6, MARQ Gen 1,
            Descent MK2 and MK2S, Forerunner 945 LTE, or the original Enduro{instinctLive ? ' (Instinct E and Instinct 3 Solar do have it)' : ''}.
          </p>
        </>
      )}
      <h3>Which watches are supported?</h3>
      <p>
        Most Garmin watches with a round screen{instinctLive ? ' (and the black-and-white Instinct E and Instinct 3 Solar)' : ''}, and the rectangular Venu Sq 2, Sq 2 Music and Venu X1: Forerunner 70, 165, 170, 255, 265, 570, 945 LTE, 955, 965 and 970;
        epix (Gen 2) and epix Pro (Gen 2); fēnix 6, 6 Pro, 7, 7 Pro, 8, 8 Pro, 9, 9 Pro and fēnix E; Enduro and Enduro 3;
        MARQ (Gen 1 and Gen 2); D2 Mach and D2 Air X10; Descent MK2, MK2S, MK3 and G2; Venu 2, 2 Plus, 2S, 3, 3S, 4, Sq 2, Sq 2 Music and X1;
        vívoactive 5 and 6; Approach S50 and S70; Instinct 3 AMOLED{instinctLive ? '; Instinct E and Instinct 3 Solar (black-and-white screens, with a small round window top right that HeroSet uses as the XP gauge)' : ''}. On touchscreen watches without UP/DOWN buttons, swipe up or down to
        adjust a count and press START to save; a tap on the counting or adjust screen never ends or saves a set. HeroSet has been tested on a
        Forerunner 965; every other model passes each screen check in Garmin’s simulator. The Connect IQ Store shows the
        exact list for your model. If your watch isn’t supported, email <a href={`mailto:${studio.email}`}>{studio.email}</a> with
        your model and we’ll see whether it can be added.
      </p>
    </Doc>
  )
}
