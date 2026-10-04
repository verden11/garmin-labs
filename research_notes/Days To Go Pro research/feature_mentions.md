# What the listing descriptions promise (feature word counts)

Source: the 83 countdown-like faces in `countdown_faces.csv` marked `genuine = y` (public store API, 2026-10-04). A regex over the English description, so a count is a lower bound and a false positive is possible (for example `arc` or `phase`). **Fact: the word is in the text. Inference: nothing about what buyers want.**

| Feature word group | all genuine (n=83) | free (n=36) | free + external unlock (n=41) | paid (store) (n=6) | >=1000 downloads (n=18) |
|---|---:|---:|---:|---:|---:|
| countdown to hours/minutes/seconds | 29 | 8 | 19 | 2 | 6 |
| data lines / metrics beside the count | 64 | 20 | 39 | 5 | 14 |
| colour or theme choice | 53 | 14 | 34 | 5 | 13 |
| background / image / icon / animation | 52 | 11 | 36 | 5 | 8 |
| progress ring / bar / dot grid | 7 | 3 | 1 | 3 | 2 |
| always-on mode | 17 | 4 | 9 | 4 | 2 |
| repeats every year | 3 | 2 | 1 | 0 | 0 |
| several events | 4 | 2 | 1 | 1 | 1 |
| weeks / months units | 5 | 2 | 1 | 2 | 2 |
| celebration on the day | 7 | 4 | 2 | 1 | 3 |
| training phase / race plan | 5 | 2 | 2 | 1 | 1 |
| weather | 11 | 3 | 5 | 3 | 2 |

Regex per row (case-insensitive):

- countdown to hours/minutes/seconds: `(hours?|minutes?|seconds?)[^.\n]{0,30}(until|left|remain|countdown|tick)|countdown[^.\n]{0,60}(hours?|minutes|seconds)|days, hours|d:h:m|hh:mm`
- data lines / metrics beside the count: `steps|heart rate|calories|body battery|data field|metrics|complication`
- colour or theme choice: `colou?rs?|theme`
- background / image / icon / animation: `background|image|picture|icon|animat|logo|emoji`
- progress ring / bar / dot grid: `progress|ring around|ring that|dots? grid|empties|outer ring|\barc\b`
- always-on mode: `always.on|aod|low.power`
- repeats every year: `every year|yearly|annual|repeat|recurring`
- several events: `up to \d+ (configurable |named )?events|multiple events|several events|3 events|next event|nearest`
- weeks / months units: `weeks|months`
- celebration on the day: `confetti|celebrat|congrat|firework`
- training phase / race plan: `training|taper|race week|phase`
- weather: `weather|temperature`
