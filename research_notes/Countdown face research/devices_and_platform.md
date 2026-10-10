# Devices and platform

All from SDK 9.2.0 (`Devices/<id>/compiler.json`, `simulator.json`; docs under `doc/`), read 2026-09-26.

## Device set

- **145** products declare watch-face app type. Taking each product's highest `connectIQVersion`, **95** at CIQ 3.4+: **84 round**, 8 semi-octagon (Instinct 2 / 2S / 2X, Instinct 3 Solar 45 mm, Instinct Crossover, Instinct E 40 / 45 mm, Descent G1), 3 rectangle (Venu Sq 2, Venu Sq 2 Music, Venu X1).
- HeroFace manifest: **117** round products (CIQ 3.0+). All 84 round at 3.4+ in it; other **33** below 3.4 (fēnix 5 family, FR245/645/745/935/945, vívoactive 3 / 3 Music / 4 / 4S, Venu (first), Venu D, D2 Air / Charlie / Delta family, Descent Mk1, MARQ Gen 1 legacy sagas). Source: `HeroFace/manifest.xml`, `HeroFace/docs/compatibility.md`.
- Round screens by size (84 at 3.4+): 208 (1), 218 (2), 240 (14), 260 (10), 280 (9) all **MIP**; 360 (2), 390 (19), 416 (12), 454 (14), 466 (1) all **AMOLED**.
- Watch-face memory across 84: 128 KB (68), 112 KB (3), 96 KB (13). Across HeroFace's 117 smallest 96 KB. No round product at 3.4+ has 64 KB (64 KB products = semi-octagon Instincts).
- **Paid** sales only reach products in SDK's App_Sales tiers (lowest tier CIQ 3.4, names listed there). Free app offered everywhere manifest lists.

## Measured memory (2026-09-26, simulator, watch-face app mode, fēnix 6 Pro)

Throwaway watch face containing: settings menu class, three Picker classes, countdown logic, ~100 generated setting strings reported
`System.getSystemStats()` **totalMemory 110,408 bytes, usedMemory 12,216 bytes** (about 11%) after building menu inside `onUpdate`. Method: print in `onUpdate`, read `monkeydo` stdout.
`(:test)` run reports test harness's own budget (8 MB), so **memory must be read from normal run, not test run**. Not measured: finished face's drawing, 15 languages.

## Fonts

`simulator.json` for FR965 lists system TrueType fonts: Roboto (regular, italic, condensed), NotoNaskhArabic, NotoSansHebrew, NotoSansArmenian, NotoSansSC, Kosugi (Japanese), NanumGothic (Korean), Pridi (Thai), plus numeric fonts
(`numberMild` 19, `numberMedium` 24, `numberHot` 29, `numberThaiHot` 33 pt on FR965 at 454 px). User-typed text (event name) can render Greek, Cyrillic, Arabic, Hebrew, CJK, Thai on current devices; older devices may lack glyphs (unverified per device).
HeroFace picks largest of `FONT_NUMBER_THAI_HOT → HOT → MEDIUM → MILD` that fits, measured with `dc.getTextWidthInPixels` (128 px tall at 454, 36 px at 240): same approach fits here.

## Always-on and MIP rules (SDK `docs/User_Experience_Guidelines/Watch_Faces.html`)

- Low-power faces update **once a minute**; high power (~10 s after gesture) allows timers. Countdown needs neither: no seconds, no timers.
- **AMOLED always-on**: once a minute, "10% of the available pixels" (SDK text; earlier research recorded newer rule as under 10% of luminance and no pixel lit over 3 minutes, from `verification.md`; follow stricter reading), burn-in prevention "may" apply; avoid white and bright blue, prefer light grey, thin fonts, move static elements up to 4 px per minute. HeroFace's `HeroFaceSleep` does exactly this (dim `#555555` time on 3×3 shifting grid).
- "It is expected that Connect IQ watch faces for AMOLED devices support always-on mode."
- MIP full-face always on; `onPartialUpdate` (≤20 ms) only for seconds, not needed.
- Simulator has Screen Heat Map (File > View Screen Heat Map) for always-on budget.
- **Device evidence from memory** (HeroFace 2026-09-22, FR965): always-draws no frames off-wrist or in sleep mode; ghosting needs night with sleep mode off.

## App review guidelines (SDK `docs/App_Review_Guidelines/Overview.html`, updated 2021-10-13)

Relevant: describe app accurately, completely; disclose refund policy or lack of one; **no** rating manipulation (no paid or self-posted reviews); no infringement (avoid brand and logo names: "Christmas" and "New Year" are fine, sports-brand race name is not); performance must not harm battery; test before submitting;
privacy policy needed if user data collected (it is not); no gambling. Review takes about 72 hours (HeroFace notes).