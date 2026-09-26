# Naming and listing

## Name candidates (store API `/apps/keywords`, WATCHFACE, US, 2026-09-26)

Exact = a face with exactly that name; contains = name includes it. Keyword results are relevance-capped near 90, so **absence is not proof**: check the store search by eye before choosing.

| Candidate | Exact | Contains (max downloads) | Notes |
|---|---|---|---|
| **Days To Go** | 0 | 0 | how people say it ("days to go until…"); descriptive for search |
| Big Day | 0 | 0 | short, warm; less searchable |
| T-Minus | 0 | 0 | space theme, narrower |
| Days Left | 0 | 1 ("Days Left - Battery Watch…", 1) | close to a battery face's name |
| Days Until | 0 | 1 ("Days Until Christmas", 10) | |
| Zero Day | 1 (1 download) | 0 | collision |
| Countdown | many | 66 of 89 results name-match | unusable; Countdown! holds 100k |
| Ahead | 1 (1,000) | 1 | collision |
| Tally | 0 | 5 (50,000: Tally Board) | crowded |

Recommendation: **Days To Go**. Owner to confirm by store search and, if wanted, a trademark search (not done).

## Listing form (from `HeroFace/listing/NOTES.md`, captured 2026-09-21, and the HeroFace README)

- Two steps: attach the `.iq`, then details. Title max 50; description max 4000, one box per language, plain text (the store shows `**` and `>` literally; every line break is kept), the first sentence carries the list-view weight.
- **Category options for watch faces**: Analog, Animal, Around the world, Cartoon, Digital, Family, Fantasy, Fun, Geek, Marine, Nature, Retro, Simple, Stylish, **Utility**. Recommendation: **Utility** (it is a utility face); Simple is the other defensible pick.
- Images: hero 1440×720 (<2048 KB, optional), cover 500×500 (<300 KB), screens <150 KB each (one device is enough; HeroSet passed review with five shots from one device), device icons 128×128 (64-colour and 24-bit).
- Answers for a no-permission, no-data face: collects user data **No**; ANT+ **No**; regional limits **No**; Monetization **No** (that field means in-app payment or donations, not store price); App migration **No** (support is the explicit tested list); review notification **Yes**; support URL only via the last line of the description.
- Discovery: the store's `/apps/keywords` scores name and description; there is no keyword field beyond the form's tags. Device names in the description are what an underserved user types (`reports/Garmin watch face market gap.md`).

## Languages

HeroFace ships English plus 14 translations (dan, deu, dut, fin, fre, ita, lit, nob, pol, por, spa, swe, tur, ukr). Rival reviews show demand in **Portuguese, Spanish, German, Chinese, Russian and Greek**. Russian and Chinese are not in HeroFace's set (Russian is a possible owner-level choice; Chinese needs the apac font set). Countdown needs few strings (about 35 hand-written ids plus month names).
Plural rules (Polish, Lithuanian, Ukrainian, Finnish) are avoided by using caption labels ("DAYS") rather than sentences.
