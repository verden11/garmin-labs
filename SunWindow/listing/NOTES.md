# Sun Window — listing notes

Why each `paste.md` field is what it is, field limits, and history of
changes. Field order follows `paste.md` (the upload form's order;
`reports/listing-template.md`).

## Fields

1. **Title:** "Sun Window" (ADR-001). No "vitamin D" (ADR-005, option A).
2. **Description:** the sun is the subject; three states; times in the full
   view only (ADR-006); the guideline 1c line "For information only; not
   medical advice or a sun-safety tool" (ADR-005). The Location paragraph
   follows the Two Suns Pro model, **never** the Two Suns Free "No
   location" sentence, because Sun Window declares `Positioning`. No Pro
   lines, no price, no language names or counts, no watch model names
   (ROADMAP 10.23 rules).
3. **App Version:** 1.0.0. **What's New:** blank for the first release; each
   later version's block moves here when the next one replaces it.
4. **Category:** Utility (ADR-013; Two Suns precedent, avoids reading as a
   health app under guidelines 1b/1c). The owner confirms on the form.
5. **Collect user data:** No. The rounded place stays on the watch (ADR-013,
   `docs/release-contract.md`).
6. **Monetization:** No (ADR-013).
7. **Additional Hardware Requirements:** the bare site URL (studio
   convention: this field carries the website link).

## Languages

English only for v1 (ADR-013). Store text stays English; translated store
text needs a native read first.

## History

- 2026-10-05: drafted from the build plan and ADR-013; nothing uploaded.
