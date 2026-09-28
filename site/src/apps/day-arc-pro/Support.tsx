import { Doc, Note } from '../../components/Doc.tsx'
import { studio } from '../../site.ts'
import { appName } from './facts.ts'

export function Support() {
  return (
    <Doc title="Support" lede={`Help for ${appName}, the data-rich version of DayArc.`}>
      <h2>Contact</h2>
      <p>
        Questions or bugs: email <a href={`mailto:${studio.email}`}>{studio.email}</a>. Please include your watch model
        and its software version, and what the face showed at the time.
      </p>

      <h2>The settings</h2>
      <p>There are none. {appName} has no phone-app settings and no on-watch Customize menu — every field and every window is fixed at build time.</p>
      <Note>This is deliberate: settings not saving is this platform's most common complaint, so {appName} has nothing to fail to save.</Note>

      <h2>Common questions</h2>
      <h3>Some fields are missing on my watch.</h3>
      <p>
        The grid shows only as many fields as measurably fit your watch's screen — the smallest screens in the supported
        set show fewer than the largest. A field your watch doesn't support at all shows as "--", not blank.
      </p>
      <h3>The calendar field says "No upcoming event".</h3>
      <p>This can mean either your watch has no calendar sync enabled, or you simply have nothing upcoming — the watch doesn't tell {appName} which.</p>
      <h3>How is this different from DayArc?</h3>
      <p>Same four time windows, same fixed schedule, same no-verdict wording on stress and Body Battery. {appName} adds a denser field grid under each window's main reading, and costs $1.99 with no free tier.</p>
      <h3>What does the always-on screen show?</h3>
      <p>On AMOLED watches: the time only, dim, moving position every minute to avoid burn-in. The full face shows when the watch is awake. Other watches keep the full face.</p>
      <h3>What does the face store?</h3>
      <p>Nothing. {appName} has no settings and no storage — see the privacy policy.</p>
    </Doc>
  )
}
