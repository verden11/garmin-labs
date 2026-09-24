# HeroFace code quality and architecture review (working tree, 2026-09-24)

Scope: `/Users/mbp/dev/garmin/HeroFace` (21 source files, 3 test files, about 2,560 lines including docs), plus the cross-folder contract (HeroSet ADR-044/045, `HeroSetComplicationPublisher.mc`). This was a read-only review. I did not run the simulator or monkeydo, so nothing here is device evidence.

How I got the evidence:
- I read every `.mc` file, the manifest, jungle, settings, properties, `CLAUDE.md`, `docs/plan.md`, `docs/compatibility.md`, and parts of `docs/go-to-market.md` and `docs/development.md`.
- I looked up API levels in the SDK 9.2.0 docs.
- I read `memoryLimit` for the watch-face app type from each of the 117 products' `compiler.json`.
- I compiled with monkeyc for `fr55`, `fenix5s` and `fr965` at `-l 2` (all built), and at `-l 3` (5 strict-typing errors, see (c)).
- Side effect: monkeyc writes intermediates into `HeroFace/bin/` (git-ignored). One fenix5s build failed with undefined `Rez.Strings` symbols, and a lone rebuild then passed. That looks like a collision with another build sharing `bin/gen`, so I do not report it as a finding.

Severity tags: **[HIGH]** can break the product on real watches or break a store rule. **[MED]** is a real defect or contract risk with limited reach. **[LOW]** is hygiene.

Links point to local files (`file:line` is given in the text).

---

## Ranked summary: what matters most?

### Takeaway
HeroFace is small, disciplined and mostly correct. It has no watchdog-scale work in `onUpdate` or `onPartialUpdate`. Every unguarded API it calls is at or below CIQ 3.0, and the contract parser rejects anything it cannot trust. The one potentially HIGH issue is the AMOLED always-on screen on original-Venu-class products, and it is an unverified inference. Everything else is MEDIUM or LOW: contract docs that no longer match, one nullable API value passed unchecked, a settings option that does nothing, and a large amount of doc drift.

### Cited Findings (ranked)
1. **[HIGH, unverified] The always-on screen may trip the original Venu's 3-minute pixel rule.**
   - The sleep screen offsets the time by `dx = (min % 3 - 1) * 4` and `dy = (min / 3 % 3 - 1) * 4` ([HeroFaceSleep.mc:16-17](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceSleep.mc)). So x changes every minute, y only every 3 minutes, and the whole walk stays inside an 8 × 8 px box.
   - It draws `FONT_NUMBER_MEDIUM` ([HeroFaceSleep.mc:18](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceSleep.mc)).
   - The SDK FAQ says: "On the original Venu® no more than 10% of the screen can be on, and no pixel can be on longer than 3 mins … the system will shut off the screen". It says the Venu 2 onward uses a 10%-luminance rule instead ([SDK FAQ: How do I make a watch face for AMOLED products](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Connect_IQ_FAQ/How_Do_I_Make_a_Watch_Face_for_AMOLED_Products.html)).
   - The manifest ships `venu`, `venud` and `d2air` ([manifest.xml](/Users/mbp/dev/garmin/HeroFace/manifest.xml)). These are AMOLED products on CIQ 3.2–3.3 firmware per `compiler.json`, so they are Venu-1 generation.
   - The only device evidence is one FR965 night with no image retention ([go-to-market.md:40-53](/Users/mbp/dev/garmin/HeroFace/docs/go-to-market.md)). The FR965 falls under the luminance rule, so that night says nothing about the 3-minute rule.
   - Fix:
     - Run the simulator's File → View Screen Heat Map on `venu` once the sweep is done.
     - If it trips, make the walk cover more ground per minute (e.g. step both axes every minute, over a larger grid than 8 px, or with a per-minute 1-px checkerboard mask), or use a thinner font on burn-in products.
2. **[MED] Contract documentation no longer matches the code, which breaks the monorepo rule.**
   - ADR-044 still gives the value as 9 fields, `v|dayKey|push|sit|squat|rank|rankPct|streak|lastDoneDay`, and says "Complication id `0` is stored by subscribers" ([HeroSet decisions.md:259-263](/Users/mbp/dev/garmin/HeroSet/docs/decisions.md)).
   - In fact the publisher sends 10 fields ([HeroSetComplicationPublisher.mc:28-49](/Users/mbp/dev/garmin/HeroSet/source/app/HeroSetComplicationPublisher.mc)).
   - HeroFace never stores the id. It finds the complication by matching the long label against `"HeroSet"` ([HeroFaceLink.mc:82-91](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLink.mc), [HeroFaceConfig.mc:37-38](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceConfig.mc)).
   - That label is protected only by a comment at [HeroSet resources/strings/strings.xml:78-80](/Users/mbp/dev/garmin/HeroSet/resources/strings/strings.xml).
   - Fix: update ADR-044 in the same commit as any future contract change. It should state the 10-field order, name the long label as a contract field, and drop the "subscribers store id 0" line.
3. **[MED] A nullable complication id is passed straight to the subscribe call.**
   - `found.complicationId` is typed nullable. It goes directly into `subscribeToUpdates` and is kept in `_id`, which later goes to `exitTo` ([HeroFaceLink.mc:32-34](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLink.mc), [HeroFaceLink.mc:59](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLink.mc)).
   - `monkeyc -l 3` flags both lines: "Passing 'Null or Complications.Id' as … non-poly type".
   - `start()` runs in `onStart` and has no `try`, so a null id or a throwing system call would crash the face at launch on CIQ 4.2+ watches.
   - Fix: `var id = found.complicationId; if (id == null) { return; }`, and wrap the register/subscribe calls in `try` so they fall back to Everyday mode.
4. **[MED] The "HeroSet" mode setting behaves exactly like "Auto".**
   - `MODE_HEROSET` is never referenced ([HeroFaceConfig.mc:8](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceConfig.mc)). The only mode check is `mode == MODE_EVERYDAY` ([HeroFaceReadings.mc:22](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceReadings.mc)).
   - So the user sees three choices ([settings.xml](/Users/mbp/dev/garmin/HeroFace/resources/settings/settings.xml)), and two of them do the same thing.
   - Fix: either remove the list entry (keep accepting the value 2, since property ids never change), or give it a meaning and document it in plan.md.
5. **[MED] The link is only discovered at app start.**
   - `find()` runs once, in `onStart` ([HeroFaceApp.mc:17-19](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceApp.mc), [HeroFaceLink.mc:24-36](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLink.mc)).
   - If HeroSet is installed while the face is already running, the face stays in Everyday mode until it restarts. I could not confirm whether the system restarts the face on an app install.
   - Fix: retry `find()` at the minute rebuild while unlinked, which is cheap. Alternatively, document the restart requirement on the support page.
6. **[MED] Doc drift is heavy and contradicts the current state.** The full list is in (f). The headline items:
   - [compatibility.md:50](/Users/mbp/dev/garmin/HeroFace/docs/compatibility.md) says "**No watch has run it yet.**", while [CLAUDE.md](/Users/mbp/dev/garmin/HeroFace/CLAUDE.md) says the FR965 has run it.
   - plan.md says the always-on screen shows "time plus a thin ring" ([plan.md:133](/Users/mbp/dev/garmin/HeroFace/docs/plan.md)), but the code draws no ring.
   - [go-to-market.md:172](/Users/mbp/dev/garmin/HeroFace/docs/go-to-market.md) says "English only", but 15 languages ship.
7. **[LOW] Duplicated goal constant.** `HeroFaceContract.DEFAULT_GOAL = 100` ([HeroFaceContract.mc:21](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceContract.mc)) duplicates `HeroFaceConfig.HEROSET_GOAL = 100` ([HeroFaceConfig.mc:32](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceConfig.mc)). This breaks the "tunables in HeroFaceConfig" rule. Fix: use `HeroFaceConfig.HEROSET_GOAL` in the contract.
8. **[LOW] Test gaps in the robustness paths.** There are no tests for the settings type fallback, the link's uninstall and caching path, the translated rank wording, or the slot fallback chain. Details are in (e).

### Inferences
- Nothing I found would crash a CIQ 3.x watch. The launch-crash risk (finding 3) is only on 4.2+ watches, and only if the system hands back a null id, which is unlikely for a complication that was just enumerated.
- The AMOLED risk is limited to 3 of 117 products, but those are the ones where the system actively blanks the screen.

### Gaps
- There is no runtime memory figure, peak or steady-state, for any product. See (a).
- There is no heat-map run on `venu`.

---

## (a) Could onUpdate or onPartialUpdate allocate heavily, blow the watchdog or power budget, or break always-on rules? Is every API above CIQ 3.0 guarded? Is sensor, ActivityMonitor and weather data null-handled?

### Takeaway
The render paths are light. All data gathering is cached once per minute, and the partial update draws one clipped `FONT_XTINY` string. Every API newer than 3.0 sits behind `has`. Null handling is thorough. The real risks are the always-on walk on original Venu (summary item 1) and a few small numeric issues.

### Cited Findings
- **Good: data is gathered once per minute.**
  - `frameFor` rebuilds the `HeroFaceState` only when the minute or the link version changes. In between, it only reformats the seconds ([HeroFaceView.mc:72-83](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceView.mc)).
  - The step-history walk runs once per day ([HeroFaceStreak.mc:21-25](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceStreak.mc)).
  - No loop is unbounded:
    - contract parse: at most 10 iterations ([HeroFaceContract.mc:56](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceContract.mc));
    - history: about 7 entries;
    - complication enumeration: once, at start.
- **Good: the partial update is minimal.** It is clip → clear → one `drawText` → unclip, and it returns early when there is no seconds box ([HeroFaceView.mc:99-110](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceView.mc)). Garmin allows a 20 ms budget per partial update ([SDK UX guidelines: Watch Faces](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/User_Experience_Guidelines/Watch_Faces.html)).
- **Good: there is a budget fallback.** `onPowerBudgetExceeded` leads to `disableSeconds()` ([HeroFaceDelegate.mc:22-27](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceDelegate.mc), [HeroFaceView.mc:46-50](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceView.mc)), and a test covers it by mutation ([go-to-market.md:57-64](/Users/mbp/dev/garmin/HeroFace/docs/go-to-market.md)). The real per-update cost was never measured ([go-to-market.md:65-69](/Users/mbp/dev/garmin/HeroFace/docs/go-to-market.md)).
- **[LOW] Small allocations on every awake frame.** While awake, each 1 Hz `onUpdate` still allocates:
  - label and value arrays and formatted strings per column ([HeroFaceText.mc:26-63](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceText.mc), [HeroFaceMissions.mc:23,49](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceMissions.mc));
  - footer arrays ([HeroFaceFooter.mc:14-31](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceFooter.mc)).

  These are small, short-lived and bounded, so they are no risk. Optional fix: compute the chosen label and value strings in `HeroFaceReadings` once per minute.
- **[HIGH, unverified] Always-on walk on original Venu.** See summary item 1.
- **Palette and luminance.** The always-on time uses `SLEEP_TEXT = 0x555555` ([HeroFacePalette.mc:18](/Users/mbp/dev/garmin/HeroFace/source/HeroFacePalette.mc)) and draws nothing else. That comfortably fits the "less than 10% of the screen's luminance" rule that applies from the Venu 2 on ([SDK FAQ](file:///Users/mbp/Library/Application%20Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2/doc/docs/Connect_IQ_FAQ/How_Do_I_Make_a_Watch_Face_for_AMOLED_Products.html)).
- **[LOW, uncertain] The always-on screen is chosen from one flag.**
  - Sleep rendering depends only on `requiresBurnInProtection` ([HeroFaceView.mc:35,61](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceView.mc)).
  - The SDK FAQ's own example uses `System.getDisplayMode()` for Venu 2 and later, and uses the flag only for the original Venu.
  - The FR965 run shows the flag was true there ([go-to-market.md:42-45](/Users/mbp/dev/garmin/HeroFace/docs/go-to-market.md)). Whether every AMOLED product in the manifest returns true is not verifiable offline: the device JSONs carry no such key.
  - If any AMOLED product returns false, the full face (white time, ring, bars) is drawn in always-on mode.
  - Fix: treat `displayType == amoled`-class devices as burn-in either way, e.g. `_burnIn = flag || (System has :getDisplayMode)`. Or verify the flag per AMOLED screen size in the simulator.
- **Every unguarded API is at CIQ 3.0 or below.** I checked each against the SDK 9.2.0 docs:

  | API | Level |
  |---|---|
  | `Dc.setClip`, `Dc.clearClip` | 2.3.0 |
  | `WatchFaceDelegate.onPowerBudgetExceeded` | 2.3.0 |
  | `Application.Properties.getValue` | 2.4.0 |
  | `ActivityMonitor.Info.activeMinutesWeekGoal`, `floorsClimbedGoal` | 2.1.0 |
  | `Array.slice`, `Array.addAll` | 1.3.0 |
  | `Graphics.getFontAscent`, `Dc.drawArc` | 1.2.0 |
  | `String.find`, `String.toNumber`, `String.toUpper`, `Number.abs`, `fillRoundedRectangle`, `fillPolygon` | 1.0.0 |

  These APIs are guarded:
  - `Toybox has :Complications` ([HeroFaceLink.mc:25](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLink.mc));
  - `Complications has :exitTo` ([HeroFaceLink.mc:55](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLink.mc));
  - `Toybox has :Weather` (3.2) ([HeroFaceReadings.mc:60](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceReadings.mc));
  - `ActivityMonitor has :getHeartRateHistory` ([HeroFaceReadings.mc:149](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceReadings.mc));
  - `info has :activeMinutesDay` and `info has :floorsClimbed` ([HeroFaceMetrics.mc:35,39](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceMetrics.mc));
  - `device has :requiresBurnInProtection` ([HeroFaceView.mc:35](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceView.mc)).

  `onPress` is CIQ 4.2, but the system only calls it where supported. [SDK docs, Toybox/*.html]
- **[LOW] Dead branch.** `WatchUi has :WatchFaceDelegate` ([HeroFaceApp.mc:27](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceApp.mc)) is always true at the 3.0 floor, because `WatchFaceDelegate` has existed since 2.3.0. The `[view]`-only branch and the comment at lines 21-23 are dead but harmless.
- **Null handling is good throughout.**
  - Weather conditions and their temperature ([HeroFaceReadings.mc:63-66](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceReadings.mc)).
  - Heart rate: the live value, then the newest history sample checked against `INVALID_HR_SAMPLE` ([HeroFaceReadings.mc:144-157](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceReadings.mc)).
  - `notificationCount` ([HeroFaceReadings.mc:30-31](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceReadings.mc)).
  - Each ActivityMonitor field goes through `orZero` for values, and `supported()` probes for the slot choice ([HeroFaceMetrics.mc:29-87](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceMetrics.mc)).
  - History days with a null start, steps or goal ([HeroFaceStreak.mc:47](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceStreak.mc)).
  - A zero or null step goal hides the streak row ([HeroFaceStreak.mc:18-20](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceStreak.mc)).
- **[LOW] Fahrenheit truncates instead of rounding.** `value.toNumber()` truncates ([HeroFaceReadings.mc:68-69](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceReadings.mc)). For example, 21 °C becomes 69.8 °F and is shown as 69, where Garmin's own display rounds to 70. Fix: round before converting.
- **[LOW] Slots are resolved only at start and on settings change.**
  - `HeroFaceMetrics.resolve` runs only then ([HeroFaceView.mc:33,40](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceView.mc)).
  - If a field is transiently null at boot (e.g. `floorsClimbed`), the slot could fall back until the next restart. I could not confirm that this happens.
  - Fix: re-resolve at the daily streak refresh.
- **[LOW] Heart rate may be stale.** The newest history sample has no age check ([HeroFaceReadings.mc:152-156](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceReadings.mc)), so an off-wrist watch can show a stale heart rate. Garmin faces behave the same way, so this is acceptable.
- **[LOW, uncertain] Seconds clip box.** The box is sized to `"00"` ([HeroFaceClock.mc:19](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceClock.mc)). If `FONT_XTINY` digits are not tabular on some product, digits wider than "0" would clip in the partial update. Fix: measure `"88"` as well and take the larger width.
- **Memory.**
  - The smallest watch-face `memoryLimit` across all 117 manifest products is 98,304 bytes (96 KB). Examples include `fenix5`, `fenix5s`, `vivoactive3`, `fr935` and `d2charlie` (from `Devices/<id>/compiler.json`, appType `watchFace`). The "64 KB" in [plan.md:32](/Users/mbp/dev/garmin/HeroFace/docs/plan.md) refers to the 130-product set that included Instinct and rectangle products, and is corrected at [plan.md:144,191](/Users/mbp/dev/garmin/HeroFace/docs/plan.md).
  - The code holds no bitmaps, and the string cache is bounded by the number of string ids ([HeroFaceText.mc:9-19](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceText.mc)).
  - `.prg` sizes are 140 KB (fenix5s), 144 KB (fr55) and 152 KB (fr965). Those are flash sizes, not RAM.
- **[LOW] `d2charlie` lists a part on CIQ 2.4.1 firmware** (compiler.json), below `minApiLevel` 3.0.0. The store should filter those units out, so this is informational.

### Inferences
- Watchdog risk is negligible. The heaviest per-minute work is one `Weather.getCurrentConditions`, one `ActivityMonitor.getInfo`, one heart-rate history iterator and one `Gregorian.info`.
- The biggest always-on uncertainty is not code quality but which rule each AMOLED firmware applies.

### Gaps
- Runtime peak memory on a 96 KB product was not measured. [plan.md:140](/Users/mbp/dev/garmin/HeroFace/docs/plan.md) says the spike checked it, but records no figure. Fix: record the simulator's peak memory for `fenix5s` in compatibility.md.
- The partial-update cost is still unmeasured (same as go-to-market §1).

---

## (b) Does the complication consumer match the publisher's field order and handle absence, old formats and malformed data?

### Takeaway
Yes. The field indices match the publisher exactly, the parser rejects rather than guesses, and HeroSet being absent or uninstalled falls back to Everyday mode. The weak spots are that discovery happens once and relies on the label, and the nullable id in summary item 3.

### Cited Findings
- **The field order matches.**

  | Index | Field |
  |---|---|
  | 0 | version |
  | 1 | dayKey |
  | 2 | push |
  | 3 | sit |
  | 4 | squat |
  | 5 | rank |
  | 6 | rankPct |
  | 7 | streak |
  | 8 | lastDoneDay |
  | 9 | goal |

  The consumer's indices are at [HeroFaceContract.mc:35-47](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceContract.mc) and the publisher's `fields` array is at [HeroSetComplicationPublisher.mc:38-49](/Users/mbp/dev/garmin/HeroSet/source/app/HeroSetComplicationPublisher.mc).

  Both sides compute the day key as YYYYMMDD from `Gregorian.info(…, FORMAT_SHORT)` ([HeroFaceReadings.mc:82-85](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceReadings.mc), [HeroSetCalendar.mc:12-19](/Users/mbp/dev/garmin/HeroSet/source/domain/HeroSetCalendar.mc)).
- **The parser rejects anything it cannot trust.** It returns null for:
  - a null or empty value;
  - an unknown version;
  - fewer than 9 fields;
  - a non-numeric or empty field, including a truncated trailing `|`;
  - a negative field.

  It ignores fields beyond the tenth. The goal falls back to 100 when it is missing or 0, and the rank percent is clamped at 100 ([HeroFaceContract.mc:27-74](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceContract.mc)). Tests cover all of these except the negative case ([HeroFaceLogicTest.mc:33-89](/Users/mbp/dev/garmin/HeroFace/source/test/HeroFaceLogicTest.mc)).
- **Stale data is expired.**
  - Counts are zeroed when `dayKey != today`.
  - The streak is zeroed when `lastDoneDay < yesterday` ([HeroFaceContract.mc:35-38](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceContract.mc)).
  - "Yesterday" is computed as `Time.today() - 12h`, so a DST change cannot make it skip a day ([HeroFaceReadings.mc:76-78](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceReadings.mc)).
  - The publisher sends `lastDoneDay` as 0 when it has none, which reads as a broken streak ([HeroSetComplicationPublisher.mc:47](/Users/mbp/dev/garmin/HeroSet/source/app/HeroSetComplicationPublisher.mc)).
- **Absence is handled.**
  - With no `Complications` API, or no matching label, the face is never linked, `progress()` returns null, and Everyday mode is used ([HeroFaceLink.mc:24-31,48-50](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLink.mc), [HeroFaceReadings.mc:22-27](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceReadings.mc)).
  - On uninstall, `getComplication` throws, which clears the id, the cache and the stored value ([HeroFaceLink.mc:68-80](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLink.mc)).
  - The cached value is used only while linked, so a cache left behind by an uninstalled HeroSet is never shown after a restart.
- **The cache survives reboots.** The raw string is stored under `face_heroset` ([HeroFaceLink.mc:19-22,94-99](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLink.mc)) and was verified on the FR965 ([decisions.md ADR-044 bullets](/Users/mbp/dev/garmin/HeroSet/docs/decisions.md)).
- **[MED]** Summary item 3: `complicationId` is nullable and `start()` has no `try` ([HeroFaceLink.mc:32-34](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLink.mc)).
- **[MED]** Summary item 5: discovery runs only in `onStart`.
- **[MED]** Summary item 2: the label is an undocumented contract field ([HeroFaceLink.mc:86](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLink.mc)).
- **[LOW, uncertain] Lenient number parsing.** `String.toNumber()` may accept a numeric prefix such as `"12abc"`, and very long digit strings may overflow. I did not verify either behaviour in the runtime. The publisher never emits such values, so the risk is theoretical. Fix, if wanted: check `piece.length()` against the number of digits written back.
- **[LOW] Uninstall behaviour on device is unverified.** No test covers `HeroFaceLink` (see (e)). If the system never calls the callback when HeroSet is uninstalled, the face keeps showing the cached rank until it restarts. I could not verify on a device which of these happens.

### Inferences
- The "reject, don't guess" design combined with append-only fields is sound. The ADR-045 decision to append `goal` without bumping the version ([decisions.md ADR-045, last bullet](/Users/mbp/dev/garmin/HeroSet/docs/decisions.md)) was correct given how this parser works.

### Gaps
- There is no device evidence for the uninstall path, or for installing HeroSet while the face is running.

---

## (c) Does it break any house rule in its CLAUDE.md or the monorepo CLAUDE.md?

### Takeaway
There are only minor violations: literal keys, a few magic numbers outside Config and Layout, a duplicated constant, and the cross-folder rule that ADR-044 must track contract changes.

### Cited Findings
- **[MED] The cross-folder contract rule is not being followed.** The rule is "Contract change → both projects and HeroSet's ADR-044, same session" ([HeroFace/CLAUDE.md](/Users/mbp/dev/garmin/HeroFace/CLAUDE.md), [monorepo CLAUDE.md](/Users/mbp/dev/garmin/CLAUDE.md)). ADR-044 still shows 9 fields and "subscribers store id 0" ([decisions.md:263](/Users/mbp/dev/garmin/HeroSet/docs/decisions.md)). The header comment in [HeroFaceContract.mc:3-4](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceContract.mc) also lists 9 fields.
- **[LOW] Settings keys are literals.** `"Mode"`, `"Slot1"`–`"Slot3"`, `"Accent"`, `"Seconds"` and `"Weather"` appear as string literals ([HeroFaceSettings.mc:13-21](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceSettings.mc)) and are repeated in a test ([HeroFaceScreenFitTest.mc, `"Seconds"`](/Users/mbp/dev/garmin/HeroFace/source/test/HeroFaceScreenFitTest.mc)). The rule says "tunables and keys in `HeroFaceConfig`". The accent fallback `0` is also a bare literal ([HeroFaceSettings.mc:19](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceSettings.mc)).
- **[LOW] Duplicated constant.** `DEFAULT_GOAL` duplicates `HEROSET_GOAL` (summary item 7).
- **[LOW] Geometry ratios live outside `HeroFaceLayout`.**
  - Footer: `stackGap() * 3`, `body - 4`, `+ 2`, `size / 8`, `size * 3 / 5` ([HeroFaceFooter.mc:47,65,70-78](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceFooter.mc)).
  - Missions: `* 3 / 4`, `* 2 / 3`, `size / 5` ([HeroFaceMissions.mc:54,61,66](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceMissions.mc)).
  - Clock: `stackGap() * 2` ([HeroFaceClock.mc:18](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceClock.mc)).
  - These are icon proportions, so it is a judgement call. They are listed only for completeness.
- **[LOW] Stricter typing surfaces 5 errors.** At `-l 3` there are errors at:
  - [HeroFaceLink.mc:34,59](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLink.mc) — nullable id, a real issue;
  - [HeroFaceSettings.mc:38](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceSettings.mc) — return poly-type mismatch;
  - [HeroFaceStreak.mc:36](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceStreak.mc) — Storage value type;
  - [HeroFaceStreak.mc:47](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceStreak.mc) — member null-narrowing, a false positive.

  The project builds clean at `-l 2`. Neither CLAUDE.md nor development.md names a level, so this is an observation, not a violation.
- **Complied with:**
  - One class per file, `HeroFace` prefix. The largest file is 189 lines ([HeroFaceLayout.mc](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLayout.mc)).
  - Functions are typed with `as` return types.
  - No `as Any`.
  - All visible text comes from strings.xml ([HeroFaceText.mc](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceText.mc)).
  - Text fit goes through `HeroFaceDraw.firstFitting`/`firstWithin`.
  - Storage keys have fixed spellings ([HeroFaceConfig.mc:55-57](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceConfig.mc)).
  - `.gitignore` excludes `*.der`, `*.pem` and `developer_key*` ([.gitignore](/Users/mbp/dev/garmin/HeroFace/.gitignore)).
  - A missing value is hidden, not faked: heart rate, temperature and streak are nullable and omitted.

  One exception: the footer's battery defaults to 0 and notifications to 0 ([HeroFaceState.mc:21,23](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceState.mc)). Both always have a real value (`getSystemStats`, and the count is null-guarded to 0), so this is acceptable.

### Inferences
- The house rules are clearly followed in spirit. The violations are cheap to fix and do not affect behaviour, except the ADR-044 drift, which is a process risk for the next contract change.

### Gaps
- None.

---

## (d) What architecture, duplication, dead code or over-engineering is there? Is the code shared conceptually with HeroSet duplicated in a managed way?

### Takeaway
The architecture fits the problem: Readings produce a State, and pure draw functions render it, which is what enables the screen-fit tests. The dead code is small. Duplication with HeroSet is deliberate and documented, and the values are currently identical.

### Cited Findings
- **The Readings → State → draw split** ([HeroFaceState.mc:3-4](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceState.mc), [HeroFaceView.mc:86-95](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceView.mc)) lets the tests render the widest states without real sensor data. This is the key design choice and it is justified.
- **Dead code:**
  - `HeroFaceConfig.MINUTES_PER_HOUR` has 0 uses ([HeroFaceConfig.mc:47](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceConfig.mc)).
  - `MODE_HEROSET` has 0 uses ([HeroFaceConfig.mc:8](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceConfig.mc)).
  - `HeroFaceLayout.displayRadius()` has 0 uses ([HeroFaceLayout.mc:96-98](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLayout.mc)).
  - The `[view]`-only branch in [HeroFaceApp.mc:27-30](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceApp.mc) never runs.
  - Fix: delete them all.
- **[LOW] Indirection.** The delegate reaches the view through the global `getApp().view()` ([HeroFaceDelegate.mc:23](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceDelegate.mc), [HeroFaceApp.mc:33-35](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceApp.mc)). Passing the view into the delegate's constructor would remove `view()` and `_view`. Optional.
- **Test hooks in production code.** `HeroFaceDraw.misfits` and `boxes` are statics checked on every text draw ([HeroFaceDraw.mc:12-31](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceDraw.mc)). The cost is two null checks per draw, which is acceptable. The same pattern is used in HeroSet.
- **Duplication with HeroSet is managed:**
  - The palette values are identical to `HeroSetPalette`: BACKGROUND, TEXT, MUTED, TRACK, GOLD, DONE and ALERT, with `ACCENTS[0] == EFFORT == 0x55AAFF` ([HeroFacePalette.mc:8-23](/Users/mbp/dev/garmin/HeroFace/source/HeroFacePalette.mc), [HeroSetPalette.mc:8-19](/Users/mbp/dev/garmin/HeroSet/source/ui/HeroSetPalette.mc)). The file names the source, HeroSet ADR-031.
  - The ring angles 220/260 are identical ([HeroFaceLayout.mc:14-15](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLayout.mc), [HeroSetLayout.mc:15-16](/Users/mbp/dev/garmin/HeroSet/source/layout/HeroSetLayout.mc)).
  - The pill-bar radius rule is identical ([HeroFaceMissions.mc:37-43](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceMissions.mc), [HeroSetMissionBars.mc:119-123](/Users/mbp/dev/garmin/HeroSet/source/ui/dashboard/HeroSetMissionBars.mc)). The comment names `HeroSetMissionBars`.
  - The streak rule mirrors `HeroSetRules.activeStreak`, and says so in a comment ([HeroFaceContract.mc:36-38](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceContract.mc)).
  - `HEROSET_MAX_GOAL = 500` mirrors HeroSet's `MAX_MISSION_GOAL` ([HeroFaceConfig.mc:33-35](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceConfig.mc)).
  - Nothing enforces any of this, but every copy names its origin.
- **No over-engineering found.** Slot fallback chains ([HeroFaceConfig.mc:24-28](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceConfig.mc)) exist because watches genuinely lack barometers and similar sensors.

### Inferences
- The drift risk worth watching is `HEROSET_MAX_GOAL` and the palette. If HeroSet raises its maximum goal, the screen-fit test on the face will not know. Optional fix: list the mirrored constants in ADR-044 or in a HeroFace doc.

### Gaps
- None.

---

## (e) What test gaps are there?

### Takeaway
There are 15 tests: 11 logic tests plus 4 render or screen-fit tests. They cover the contract parser, streak maths and layout well. They do not cover settings robustness, the link lifecycle, the always-on screen, slot resolution, or translated HeroSet-mode wording.

### Cited Findings
- **Covered:**
  - Streak runs and extension ([HeroFaceLogicTest.mc:7-31](/Users/mbp/dev/garmin/HeroFace/source/test/HeroFaceLogicTest.mc)).
  - Contract read, goal, expiry and reject cases (lines 33-89).
  - Day score, move bar, clamps, 12/24 h and ring sweep (lines 91-149).
  - Widest-state fit, the layout report, labels per language, and the seconds fallback ([HeroFaceScreenFitTest.mc](/Users/mbp/dev/garmin/HeroFace/source/test/HeroFaceScreenFitTest.mc)).
- **[LOW] The translated HeroSet-mode strings are never rendered.**
  - `everyLabelFitsThisLanguage` renders the translated `streak_long` and `streak_short` but never `rank_streak` or `rank_only`, even though its comment says "Real streak and rank wordings" ([HeroFaceScreenFitTest.mc, streakLines block](/Users/mbp/dev/garmin/HeroFace/source/test/HeroFaceScreenFitTest.mc)).
  - The HeroSet state uses a hard-coded English `"RANK 999  STREAK 9999"` ([HeroFaceTestStates.mc:52](/Users/mbp/dev/garmin/HeroFace/source/test/HeroFaceTestStates.mc)).
  - `firstFitting` returns the last candidate even when it does not fit ([HeroFaceDraw.mc:49-56](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceDraw.mc)), so a long translation of `rank_only` could overflow undetected.
  - Fix: add a second pass with `HeroFaceText.format(Rez.Strings.rank_streak, [999, 9999])`.
- **[LOW] A test state production can no longer show.** `HeroFaceTestStates.fresh()` still uses `"0-DAY STREAK"` ([HeroFaceTestStates.mc:38](/Users/mbp/dev/garmin/HeroFace/source/test/HeroFaceTestStates.mc)). The finish review removed that from production ([plan.md:179-180](/Users/mbp/dev/garmin/HeroFace/docs/plan.md)). Fix: make `streakLines` empty, which also exercises the temperature-only row.
- **Missing tests:**
  - `HeroFaceSettings` falling back on a wrong-typed or missing property ([HeroFaceSettings.mc:26-42](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceSettings.mc)).
  - `HeroFaceLink.remember` and the uninstall path.
  - `HeroFaceMetrics.resolve` chains with a synthetic info object. Today this is checked only by a manual run on fr245 ([compatibility.md:44-48](/Users/mbp/dev/garmin/HeroFace/docs/compatibility.md)).
  - `HeroFaceReadings.dayKey`.
  - A negative or overflowing contract field.
  - The always-on offsets staying inside ±`BURN_IN_STEP_PX` ([HeroFaceSleep.mc:16-17](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceSleep.mc)).
  - `HeroFaceText.values` thousand formatting.
- **[LOW] The always-on screen skips fit checks.** `HeroFaceSleep` draws with `dc.drawText`, not `HeroFaceDraw.text` ([HeroFaceSleep.mc:21](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceSleep.mc)), so screen-fit never checks it.

### Inferences
- The highest-value additions are the rank-wording language pass and a settings-fallback test. Both are pure and cheap.

### Gaps
- I did not run any tests; the simulator was reserved. The claim of 15 passing tests per screen size on 2026-09-22 comes from [compatibility.md:37-42](/Users/mbp/dev/garmin/HeroFace/docs/compatibility.md).

---

## (f) Where have the docs drifted from the code and each other?

### Takeaway
`plan.md` is the most out of date: it is still dated 2026-09-20, before launch. `compatibility.md` and `go-to-market.md` contradict CLAUDE.md on device evidence and languages.

### Cited Findings
- **plan.md:**
  - Status is 2026-09-20 and lists "Left: … submission itself" ([plan.md:3-10](/Users/mbp/dev/garmin/HeroFace/docs/plan.md)), but the face went live on 2026-09-22.
  - "What's next #1: Device run on the FR965 (blocks everything else)" ([plan.md:165](/Users/mbp/dev/garmin/HeroFace/docs/plan.md)) has already been done.
  - The always-on screen is described as "time plus a thin ring only" ([plan.md:133](/Users/mbp/dev/garmin/HeroFace/docs/plan.md)). Line 212 and the code say there is no ring ([HeroFaceSleep.mc:5-7](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceSleep.mc)).
  - The ASCII screen ([plan.md:123-129](/Users/mbp/dev/garmin/HeroFace/docs/plan.md)) shows the streak on top, the date under the time and a steps ring. The code has the date on top, the streak and temperature under the time, and a day-score ring ([HeroFaceView.mc:112-148](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceView.mc)).
  - "The streak took the narrow row … the date moved under the time" ([plan.md:211](/Users/mbp/dev/garmin/HeroFace/docs/plan.md)) was reversed by plan.md:194-198.
  - "Accent colour: 4–6 choices" ([plan.md:83](/Users/mbp/dev/garmin/HeroFace/docs/plan.md)), but the code has 3 ([HeroFacePalette.mc:23](/Users/mbp/dev/garmin/HeroFace/source/HeroFacePalette.mc)).
  - "Seconds … only where `onPartialUpdate` is supported" and "Weather … only shown where `Toybox has :Weather`" ([plan.md:84-85](/Users/mbp/dev/garmin/HeroFace/docs/plan.md)). In fact both settings are always listed ([settings.xml](/Users/mbp/dev/garmin/HeroFace/resources/settings/settings.xml)), so the Weather toggle appears on fēnix 5, which has no weather.
  - "`Dc has :setAntiAlias`" is named as a guard ([plan.md:90](/Users/mbp/dev/garmin/HeroFace/docs/plan.md)), but it is not used anywhere.
  - "v1 ships English only" and "weekday and month abbreviations in strings.xml" ([plan.md:98-102](/Users/mbp/dev/garmin/HeroFace/docs/plan.md)) have both been superseded.
- **compatibility.md:** "**No watch has run it yet.**" ([compatibility.md:50](/Users/mbp/dev/garmin/HeroFace/docs/compatibility.md)) contradicts [CLAUDE.md](/Users/mbp/dev/garmin/HeroFace/CLAUDE.md) ("The FR965 has run it (2026-09-20 onward)") and [go-to-market.md:40-53](/Users/mbp/dev/garmin/HeroFace/docs/go-to-market.md). This file is modified in the working tree, so check it against that edit.
- **go-to-market.md:**
  - §1 opens "Everything below is unknown until the face runs on the FR965" ([go-to-market.md:37](/Users/mbp/dev/garmin/HeroFace/docs/go-to-market.md)).
  - §5 says "English only (by decision). Translations after launch." and "13 round watches below CIQ 3.0" ([go-to-market.md:172-173](/Users/mbp/dev/garmin/HeroFace/docs/go-to-market.md)). The manifest has 15 languages, and compatibility.md says 15 old watches ([compatibility.md:60](/Users/mbp/dev/garmin/HeroFace/docs/compatibility.md)).
- **Contract docs:** ADR-044 lists 9 fields and says "stored by subscribers" ([decisions.md:263](/Users/mbp/dev/garmin/HeroSet/docs/decisions.md)). The HeroFaceContract header lists 9 fields ([HeroFaceContract.mc:4](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceContract.mc)). plan.md:110-119 and CLAUDE.md are correct with 10 fields.
- **Accurate:** the test count of 15 matches the code: 11 in [HeroFaceLogicTest.mc](/Users/mbp/dev/garmin/HeroFace/source/test/HeroFaceLogicTest.mc) plus 4 in [HeroFaceScreenFitTest.mc](/Users/mbp/dev/garmin/HeroFace/source/test/HeroFaceScreenFitTest.mc) ([README.md:24](/Users/mbp/dev/garmin/HeroFace/README.md)). The 96 KB minimum memory matches `compiler.json`.

### Inferences
- A single pass over plan.md ("Status", "What's next", the screen sketch and the settings list), compatibility.md:50 and go-to-market §1/§5 would clear almost all of this. None of it changes a published URL.

### Gaps
- I did not diff the listing and site copy against behaviour. That is out of scope for this review.

---

## What is good and should NOT be changed?

### Takeaway
Keep the defensive contract parser, the minute-cached state, the measured text fit, the capability-checked single build, and the documented mirroring of HeroSet's visual constants.

### Cited Findings
- **The contract parser's "reject, don't guess" rules, and their tests.** It rejects unknown versions, empty or non-numeric fields and negatives, ignores extra fields, falls back on goal 0 or a missing goal, and expires stale data by day key ([HeroFaceContract.mc:27-74](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceContract.mc), [HeroFaceLogicTest.mc:33-89](/Users/mbp/dev/garmin/HeroFace/source/test/HeroFaceLogicTest.mc)). The append-only, no-version-bump policy of ADR-045 depends on exactly this behaviour.
- **The state cached per minute and invalidated by the link version** ([HeroFaceView.mc:21-26,72-83](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceView.mc)). It saves battery without making HeroSet updates late.
- **The minimal partial update and the power-budget fallback** ([HeroFaceView.mc:99-110](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceView.mc), [HeroFaceDelegate.mc:22-27](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceDelegate.mc)).
- **Measured text fit and the widest-state screen-fit suite** ([HeroFaceDraw.mc](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceDraw.mc), [HeroFaceScreenFitTest.mc](/Users/mbp/dev/garmin/HeroFace/source/test/HeroFaceScreenFitTest.mc)). It has run on all ten screen sizes ([compatibility.md:37-42](/Users/mbp/dev/garmin/HeroFace/docs/compatibility.md)).
- **One build, with every newer API behind `has`.** I verified that every unguarded API is at 3.0 or below; see (a).
- **Slot fallback chains resolved once**, so no bar is ever empty ([HeroFaceMetrics.mc:10-27](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceMetrics.mc)).
- **The streak persists past the 7-day history** with DST-safe day indexing ([HeroFaceStreak.mc:58-80](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceStreak.mc)), and it is unit-tested.
- **The settings reader tolerates missing and wrong-typed values** ([HeroFaceSettings.mc:24-42](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceSettings.mc)). It has no test yet, but the design is right.
- **The palette and ring mirroring with HeroSet** is identical, and each copy names its source ((d)).
- **The link's cached value plus the uninstall fallback** ([HeroFaceLink.mc:13-22,68-80](/Users/mbp/dev/garmin/HeroFace/source/HeroFaceLink.mc)). The reboot case was verified on the FR965 per ADR-044.

### Inferences
- The fixes recommended above are all additive, or deletions of dead code. None of them requires restructuring.

### Gaps
- None.
