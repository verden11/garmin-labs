import { Doc, Note } from '../../components/Doc.tsx'
import { studio } from '../../site.ts'

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
      <h3>Are the calories exact?</h3>
      <p>No. The calorie figure is the change in Garmin’s own daily calorie total during your set, an estimate. HeroSet is not a medical device.</p>
      <h3>Can I change the daily goal?</h3>
      <p>
        Yes, on the watch: open the menu, choose <strong>Daily Goal</strong>, and set anything from 10 to 500 reps with
        UP/DOWN. It applies to all three exercises, no phone needed. Lowering it below what you have already done
        completes today straight away.
      </p>
      <h3>Does a higher goal earn rank faster?</h3>
      <p>
        No. Rank reflects the reps you do, not the goal you pick: XP stops at 100 reps per exercise per day whatever your
        goal is. A goal of 30 keeps your streak going every day, and rank climbs at the pace of the work behind it.
      </p>
      <h3>When do the daily counts reset?</h3>
      <p>At midnight, watch local time. XP, rank and streak carry over; missing a day resets the streak.</p>
      <h3>Which watches are supported?</h3>
      <p>
        Most Garmin watches with a round screen: Forerunner 70, 165, 170, 255, 265, 570, 945 LTE, 955, 965 and 970;
        epix (Gen 2) and epix Pro (Gen 2); fēnix 6, 6 Pro, 7, 7 Pro, 8, 8 Pro, 9, 9 Pro and fēnix E; Enduro and Enduro 3;
        MARQ (Gen 1 and Gen 2); D2 Mach and D2 Air X10; Descent MK2, MK2S, MK3 and G2; Venu 2, 2 Plus, 2S, 3, 3S and 4;
        vívoactive 5 and 6; Approach S50 and S70. On touchscreen watches without UP/DOWN buttons, swipe up or down to
        adjust a count and press START to save; a tap on the counting or adjust screen never ends or saves a set. HeroSet has been tested on a
        Forerunner 965; every other model passes each screen check in Garmin’s simulator. The Connect IQ Store shows the
        exact list for your model. If your watch isn’t supported, email <a href={`mailto:${studio.email}`}>{studio.email}</a> with
        your model and we’ll see whether it can be added.
      </p>
    </Doc>
  )
}
