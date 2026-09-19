import { Doc, Note } from '../../components/Doc.tsx'
import { studio } from '../../site.ts'
import { watchCount } from './facts.ts'

export function Support() {
  return (
    <Doc title="Support" lede="Help for HeroSet, the daily push-up, sit-up and squat app for Garmin watches.">
      <h2>Contact</h2>
      <p>
        Questions, bugs or refund trouble: email <a href={`mailto:${studio.email}`}>{studio.email}</a>. Please include
        your watch model, its software version, and which exercise you were doing.
      </p>

      <h2>Getting accurate counts</h2>
      <ul>
        <li><strong>Save the count you really did.</strong> After each set, correct the count with UP/DOWN before saving. HeroSet learns from the counts you save.</li>
        <li><strong>Start the set in position</strong>, and wear the watch snug in the same spot each time. Arm movement before you start or after you finish can count as reps.</li>
        <li><strong>Hold still for a second</strong> after pressing START, then begin your first rep.</li>
        <li><strong>Move through full reps.</strong> Tiny partial movements may not count.</li>
      </ul>
      <Note>
        Automatic counting is in beta and can miscount. When you finish a set, press START to review the count, adjust it
        with UP/DOWN, then press START again to save.
      </Note>

      <h2>Common questions</h2>
      <h3>Does HeroSet add activities to Garmin Connect?</h3>
      <p>No. HeroSet records no activity and sends nothing to your phone or the internet. Your progress lives on the watch.</p>
      <h3>Are the calories exact?</h3>
      <p>No. The calorie figure is the change in Garmin’s own daily calorie total during your set, an estimate. HeroSet is not a medical device.</p>
      <h3>When do the daily counts reset?</h3>
      <p>At midnight, watch local time. XP, rank and streak carry over; missing a day resets the streak.</p>
      <h3>Which watches are supported?</h3>
      <p>
        {watchCount} Garmin watches with five buttons and a round screen: Forerunner 70, 165, 170, 255, 265, 570, 945 LTE,
        955, 965 and 970; epix (Gen 2) and epix Pro (Gen 2); fēnix 6, 6 Pro, 7, 7 Pro, 8, 8 Pro, 9, 9 Pro and fēnix E;
        Enduro and Enduro 3; MARQ (Gen 1 and Gen 2); D2 Mach; Descent MK2, MK2S, MK3 and G2. HeroSet has been tested on a
        Forerunner 965; every other model passes each screen check in Garmin’s simulator. The Connect IQ Store shows the
        exact list for your model.
      </p>
    </Doc>
  )
}
