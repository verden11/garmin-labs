# Screenshots

I cannot capture these: this environment has no screen-recording permission and
the Connect IQ SDK has no screenshot command. They have to come from you, from
the simulator (or the watch, if you prefer real photos for the website).

## How

1. Start the simulator and load the face:
   ```sh
   monkeyc -d fr965 -f monkey.jungle -o bin/HeroFace.prg -y ~/.garmin-connectiq/keys/developer_key
   monkeydo bin/HeroFace.prg fr965
   ```
2. In the simulator, use its **File → Save Screenshot** (or the camera button).
3. Set the simulator's activity data (Simulation → Activity Monitor / Time) to
   get the states below rather than waiting for them.

## The set to capture

Per device family for the store; one of each is enough for the website.

| # | State | How to get it | Used for |
|---|---|---|---|
| 1 | Everyday, mid-day | Default sim data: part-filled bars, a streak line | Store hero, site "Everyday" |
| 2 | Goals met | Set steps/intensity/floors above their goals: three green bars with check marks, green ring | Store, site "Goals met" |
| 3 | With HeroSet | Needs HeroSet publishing — easiest on the watch, not the simulator | Site "With HeroSet" |
| 4 | Always on | Sleep the face in the simulator (Simulation → Always On / low power) | Store, site "Always on" |
| 5 | Small screen | Same as #1 on `fenix5` or `fr55` (208–240 px) | Shows it fits small watches |

## Where they go

- **Store:** upload in the submission form.
- **Website:** `../../../verden-site/public/heroface/screens/`, named
  `everyday.png`, `goals-met.png`, `heroset.png`, `always-on.png`, then set
  `src` on each entry in
  `../../../verden-site/src/apps/heroface/facts.ts`. Until then the site
  renders labelled "Screenshot pending" slots, so it is safe to deploy without
  them.

## Honesty rules

- Capture the real face, never a mock-up.
- The numbers on screen must be ones the watch could actually produce.
- No claim in the image that the listing itself could not make
  (`../go-to-market.md`).
