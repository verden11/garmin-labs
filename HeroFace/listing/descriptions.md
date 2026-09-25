# Description openings, per language

The Connect IQ Store takes one Description per supported language, max 4000
characters — there is **no separate short-description field** (upload form,
captured 2026-09-21). These lines are the *opening* of each language's
description; the store truncates them itself in list views.

English is the fallback; the rest match the in-app translations
(`resources-<lang>/`).

**Stale as of 2026-09-21:** the English row below was replaced by option B (see
[`listing/README.md`](README.md)), which adds the HeroSet clause. The other 14 rows are still the
old wording and say nothing about HeroSet. Either retranslate them to match, or
accept that non-English listings open differently — but do not ship a mix
silently.

| Language | Short description |
|---|---|
| English (eng) | The time first, today's goals right under it. Three bars you choose, a ring for the whole day, a streak worth keeping — or your HeroSet reps and rank, if you have it. |
| Deutsch (deu) | Zuerst die Uhrzeit, direkt darunter die Tagesziele. Schritte, Intensitätsminuten und Etagen als drei Balken, die du ändern kannst, ein Ring für den ganzen Tag und eine Reihe, die sich zu halten lohnt. |
| Français (fre) | L'heure d'abord, et juste en dessous les objectifs du jour. Pas, minutes d'intensité et étages sous forme de trois barres modifiables, un anneau pour toute la journée et une série à entretenir. |
| Español (spa) | Primero la hora y, justo debajo, los objetivos del día. Pasos, minutos de intensidad y pisos en tres barras que puedes cambiar, un anillo para todo el día y una racha que merece la pena mantener. |
| Italiano (ita) | Prima l'ora, e subito sotto gli obiettivi di oggi. Passi, minuti di intensità e piani in tre barre che puoi cambiare, un anello per l'intera giornata e una serie da non interrompere. |
| Português (por) | Primeiro a hora e, logo abaixo, as metas do dia. Passos, minutos de intensidade e andares em três barras que pode alterar, um anel para o dia inteiro e uma sequência que vale a pena manter. |
| Nederlands (dut) | Eerst de tijd, en daaronder de doelen van vandaag. Stappen, intensiteitsminuten en verdiepingen als drie balken die je zelf kiest, een ring voor de hele dag en een reeks die het waard is. |
| Polski (pol) | Najpierw godzina, a tuż pod nią cele dnia. Kroki, minuty intensywności i piętra jako trzy paski, które możesz zmienić, pierścień całego dnia i seria, którą warto utrzymać. |
| Svenska (swe) | Tiden först, och dagens mål direkt under. Steg, intensitetsminuter och våningar som tre staplar du kan ändra, en ring för hela dagen och en svit värd att hålla igång. |
| Dansk (dan) | Tiden først, og dagens mål lige under. Skridt, intensitetsminutter og etager som tre bjælker, du selv vælger, en ring for hele dagen og en serie, der er værd at holde. |
| Norsk bokmål (nob) | Tiden først, og dagens mål rett under. Skritt, intensitetsminutter og etasjer som tre stolper du kan endre, en ring for hele dagen og en rekke verdt å holde på. |
| Suomi (fin) | Ensin kello, ja heti sen alla päivän tavoitteet. Askeleet, tehominuutit ja kerrokset kolmena palkkina, jotka voit vaihtaa, rengas koko päivälle ja putki, joka kannattaa pitää. |
| Türkçe (tur) | Önce saat, hemen altında günün hedefleri. Değiştirebileceğin üç çubukta adım, yoğunluk dakikaları ve kat sayısı, tüm gün için bir halka ve sürdürmeye değer bir seri. |
| Lietuvių (lit) | Pirmiausia laikas, o po juo – dienos tikslai. Žingsniai, intensyvumo minutės ir aukštai trimis juostomis, kurias gali pakeisti, viso dienos žiedas ir serija, kurią verta išlaikyti. |
| Українська (ukr) | Спершу час, а одразу під ним — цілі дня. Кроки, хвилини інтенсивності та поверхи у вигляді трьох смуг, які можна змінити, кільце на весь день і серія, яку варто берегти. |

## Longer descriptions

Only English is drafted ([`listing/README.md`](README.md)). If the store asks for a full
description per language, either paste the English one for all of them (common,
and honest) or translate the sections in [`listing/README.md`](README.md) the same way. **FILL**:
your call.
