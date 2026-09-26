# Devices and platform

All from SDK 9.2.0 (`Devices/<id>/compiler.json`, `simulator.json`; docs under `doc/`), read 2026-09-26.

## Device set

- **145** products declare a watch-face app type. Taking each product's highest `connectIQVersion`, **95** are at CIQ 3.4+: **84 round**, 8 semi-octagon (Instinct 2 / 2S / 2X, Instinct 3 Solar 45 mm, Instinct Crossover, Instinct E 40 / 45 mm, Descent G1) and 3 rectangle (Venu Sq 2, Venu Sq 2 Music, Venu X1).
- HeroFace's manifest has **117** round products (CIQ 3.0+). All 84 round products at 3.4+ are in it; the other **33** are below 3.4 (fēnix 5 family, FR245/645/745/935/945, vívoactive 3 / 3 Music / 4 / 4S, Venu (first), Venu D, D2 Air / Charlie / Delta family, Descent Mk1, MARQ Gen 1 legacy sagas). Source: `HeroFace/manifest.xml`, `HeroFace/docs/compatibility.md`.
- Round screens by size (84 at 3.4+): 208 (1), 218 (2), 240 (14), 260 (10), 280 (9) all **MIP**; 360 (2), 390 (19), 416 (12), 454 (14), 466 (1) all **AMOLED**.
- Watch-face memory across the 84: 128 KB (68), 112 KB (3), 96 KB (13). Across HeroFace's 117 the smallest is 96 KB. No round product at 3.4+ has 64 KB (the 64 KB products are the semi-octagon Instincts).
- **Paid** sales only reach the products in the SDK's App_Sales tiers (lowest tier CIQ 3.4, names listed there). A free app is offered everywhere its manifest lists.

## Measured memory (2026-09-26, simulator, watch-face app mode, fēnix 6 Pro)

A throwaway watch face containing: the settings menu class, three Picker classes, the countdown logic, and ~100 generated setting strings reported
`System.getSystemStats()` **totalMemory 110,408 bytes, usedMemory 12,216 bytes** (about 11%) after building the menu inside `onUpdate`. Method: print in `onUpdate`, read `monkeydo` stdout.
A `(:test)` run reports the test harness's own budget (8 MB), so **memory must be read from a normal run, not a test run**. Not measured: the finished face's drawing, 15 languages.

## Fonts

`simulator.json` for the FR965 lists system TrueType fonts: Roboto (regular, italic, condensed), NotoNaskhArabic, NotoSansHebrew, NotoSansArmenian, NotoSansSC, Kosugi (Japanese), NanumGothic (Korean), Pridi (Thai), plus the numeric fonts
(`numberMild` 19, `numberMedium` 24, `numberHot` 29, `numberThaiHot` 33 pt on the FR965 at 454 px). Text that a user types (the event name) can therefore render Greek, Cyrillic, Arabic, Hebrew, CJK and Thai on current devices; older devices may lack glyphs (unverified per device).
HeroFace picks the largest of `FONT_NUMBER_THAI_HOT → HOT → MEDIUM → MILD` that fits, measured with `dc.getTextWidthInPixels` (128 px tall at 454, 36 px at 240): the same approach fits here.

## Always-on and MIP rules (SDK `docs/User_Experience_Guidelines/Watch_Faces.html`)

- Low-power faces update **once a minute**; high power (~10 s after a gesture) allows timers. A countdown needs neither: no seconds, no timers.
- **AMOLED always-on**: once a minute, "10% of the available pixels" (the SDK text; earlier research recorded the newer rule as under 10% of luminance and no pixel lit over 3 minutes, from `verification.md`; follow the stricter reading), burn-in prevention "may" apply; avoid white and bright blue, prefer light grey, thin fonts, move static elements up to 4 px per minute. HeroFace's `HeroFaceSleep` does exactly this (dim `#555555` time on a 3×3 shifting grid).
- "It is expected that Connect IQ watch faces for AMOLED devices support always-on mode."
- MIP full-face always on; `onPartialUpdate` (≤20 ms) only for seconds, not needed.
- Simulator has a Screen Heat Map (File > View Screen Heat Map) for the always-on budget.
- **Device evidence from memory** (HeroFace 2026-09-22, FR965): always-draws no frames off-wrist or in sleep mode; ghosting needs a night with sleep mode off.

## App review guidelines (SDK `docs/App_Review_Guidelines/Overview.html`, updated 2021-10-13)

Relevant: describe the app accurately and completely; disclose refund policy or lack of one; **no** rating manipulation (no paid or self-posted reviews); no infringement (avoid brand and logo names: "Christmas" and "New Year" are fine, a sports-brand race name is not); performance must not harm battery; test before submitting;
privacy policy needed if user data is collected (it is not); no gambling. Review takes about 72 hours (HeroFace notes).
