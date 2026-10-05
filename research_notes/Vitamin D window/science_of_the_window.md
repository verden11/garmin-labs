# Science of the vitamin D "sun window" (research notes, 2026-10-04)

Purpose: cited, quantitative basis for a watch-side OPEN/CLOSED rule. Product logic, not medical advice. Conventions: "verified" = I read the source page or PDF text in this session. "Snippet only" = seen only in a search-result summary, treat as unverified. "Computed here" = my own arithmetic from a cited formula (scripts in the session scratchpad, not committed). "Secondary" = a paper quoting another paper.

## 1. Solar elevation / UVI threshold for effective vitamin D synthesis (and where sources disagree)

### Takeaway
No single authoritative threshold exists. Three families are in use: (a) sun elevation >= 45 deg, i.e. shadow <= your height (MacLaughlin 1982 / Webb 2011, as cited by a 2024 paper); (b) UV Index >= 3 (the WHO / Cancer Council "protection needed" line, which Australian guidance also treats as the point where sun is strong enough that a few minutes suffice); (c) lower elevation cut-offs of 15-30 deg that mark where any UVB reaches the ground. Computed here, clear-sky UVI 3 sits at about 37 deg elevation at 300 DU ozone (33-44 deg for 250-400 DU), which is between (c) and (a). The empirical anchor is Webb 1988: no previtamin D3 in Boston (42.2 N) Nov-Feb and Edmonton (52 N) Oct-Mar on cloudless days.

### Cited Findings
- Webb, Kline & Holick 1988 (JCEM): on cloudless days no previtamin D3 was produced in Boston (42.2 N) November through February, and in Edmonton (52 N) October through March; at 34 N and 18 N sunlight was effective even in mid-winter. — [PubMed 2839537 abstract via search summary, snippet only](https://pubmed.ncbi.nlm.nih.gov/2839537/) (PubMed page itself would not load; the same Boston Nov-Feb finding is verified in [Engelsen 2010, PMC3257661](https://pmc.ncbi.nlm.nih.gov/articles/PMC3257661/) and in [Wacker & Holick 2013](https://pmc.ncbi.nlm.nih.gov/articles/PMC3897598/))
- Engelsen 2010 (Nutrients 2(5):482-495) states "from November to February, there was insufficient solar UVB to synthesize vitamin D in Boston, MA (USA), but by March previtamin D was formed", and discusses solar zenith angle qualitatively (low sun means a longer ozone path). I found no elevation or UVI number in the text I could fetch. — [Engelsen 2010](https://pmc.ncbi.nlm.nih.gov/articles/PMC3257661/) (fetched through a summariser, so quotes are approximate)
- The NILU/Webb-Engelsen tool defines the no-production criterion as a biologically effective dose threshold: BED threshold = 0.024*0.92 + 1.0*0.45 = 0.472, built from Webb's Boston mid-February noon irradiances (0.024, 1.0, 10 mW m-2 nm-1 at 300, 306, 316 nm); no detectable photoconversion mid-Feb, small production mid-March in Boston. — [NILU FastRT VitD README](https://fastrt.nilu.no/README_VitD.html)
- Webb & Engelsen 2006 (Photochem Photobiol 82:1697) is the web tool that gives exposure time for a "standard vitamin D dose" for any time and place, depending on latitude, time, ozone, clouds, aerosols, albedo, altitude. Reference: Boston 21 March, 42.2 N, 350 DU ozone, cloudless, about 16 minutes at solar noon for quarter-MED on about 25 percent of skin. — [NILU description](https://fastrt.nilu.no/README_VitD_quartMED.html); [search summary of the paper, snippet only](https://www.nilu.com/publication/19772/)
- 45 deg family. A 2024 paper (Kallioglu et al., "UV index-based model for predicting synthesis of (pre-)vitamin D3 in the mediterranean basin") says "there is significant evidence of vitamin D3 production at solar altitude angle greater than 45 deg", attributing it to MacLaughlin et al. (1982) and Webb et al. (2011), and notes "with this angle value of 45 deg and above, the length of the shadow on a horizontal surface is equal to the height of the person". — [Kallioglu 2024, PMC10861575](https://pmc.ncbi.nlm.nih.gov/articles/PMC10861575/) (fetched through a summariser; secondary for the 45 deg attribution)
- Lower cut-offs, secondary. A 2024 Brazilian paper reports that McKenzie et al. (2009) used elevation > 20 deg (zenith < 70) as the reference for UVB incidence, that Engelsen (2010) assumes synthesis starts at low intensity above about 15 deg, and that Webb et al. (2011) considered elevation above 45 deg relevant. — [Leal & Leder 2024 (read from PDF text)](https://publicacoes.amigosdanatureza.org.br/index.php/gerenciamento_de_cidades/article/download/4190/4946/10686). I did not confirm the 15 deg claim in Engelsen 2010 itself (see Gaps).
- Shadow rule, search snippet only: shadow equal to height means elevation 45 deg; shadow more than twice your height (elevation under 30 deg) means UVI generally under 3 ("low"); shadow shorter than height means UVI can exceed 7. — [Te Ara, Shadow length rule](https://teara.govt.nz/mi/diagram/6157/the-shadow-length-rule) (page returned 403 to me; snippet only). The origin paper on the shadow rule is [PubMed 9671831, snippet only](https://pubmed.ncbi.nlm.nih.gov/9671831/).
- McKenzie, Liley & Bjorn 2009 (Photochem Photobiol 85:88-98): vitamin D-weighted UV depends more strongly on ozone and solar zenith angle than sunburn UV; an algorithm relates vitamin D production to the UV index; summer noon at mid-latitudes needs about 1 minute full-body for optimal vitamin D versus about 15 minutes to skin damage. — [Lund University record, snippet only](https://portal.research.lu.se/en/publications/uv-radiation-balancing-risks-and-benefits/)
- NIWA's write-up of that work (verified): at UVI 3 "skin damage occurs after about an hour, but optimal vitamin D can still be produced in a few minutes if at least the face, arms, and legs are exposed"; in winter vitamin D-producing UV is only about 5 percent of its summer value while peak sunburning UV is about 10 percent; when UVI is below 2 it is not possible to get sufficient UV for vitamin D from face and hands alone without sunburn (per the fetch summary). — [NIWA Water & Atmosphere 17(1), 2009](https://niwa.co.nz/water-atmosphere/vol17-no1-march-2009/balancing-risks-and-benefits-uv-radiation)
- UK SACN 2016: "At latitudes below 37 N, UVB radiation is sufficient for year round vitamin D synthesis. At higher latitude, vitamin D is not synthesised during the winter months." (S.7, 3.18, attributing Webb 1988); the UK is effective only from late March/early April to September, not from October. — [SACN Vitamin D and Health 2016 (PDF text, verified)](https://assets.publishing.service.gov.uk/media/5a804e36ed915d74e622dafa/SACN_Vitamin_D_and_Health_report.pdf)
- Kallioglu 2024 finds synthesis at 37 N and 41 N in Turkey lasts "from the beginning of March to the third week of October" and "between 10:00 and 16:00", with no synthesis in December at 37 N latitude Antalya, which sits right at SACN's 37 N boundary. — [Kallioglu 2024](https://pmc.ncbi.nlm.nih.gov/articles/PMC10861575/)
- Cancer Council Australia: "Sun protection is recommended when the UV Index is 3 or above"; "When the UV Index is 3 or above (such as during summer), most people maintain adequate vitamin D levels just by spending a few minutes outdoors on most days of the week"; "In late autumn and winter in some southern parts of Australia, when the UV Index falls below 3, spend time outdoors in the middle of the day with some skin uncovered." — [Cancer Council vitamin D page (verified via fetch)](https://www.cancer.org.au/preventing-cancer/sun-protection/vitamin-d/)
- Stalgis-Bilinski et al. 2011 (MJA 194:7): Australian campaigns advise protection "during peak UVI periods, typically promoted as between 10 am and 3 pm, or when the UVI reaches 3"; UV Index averages stay below 3 all day in Sydney, Adelaide and Melbourne in winter. — [MJA 2011 (verified via fetch)](https://www.mja.com.au/journal/2011/194/7/burning-daylight-balancing-vitamin-d-requirements-sensible-sun-exposure)
- Holick-group review: "Very little if any vitamin D3 can be produced in the skin before 10 a.m. and after 3 p.m. even in the summer time"; Boston (42 N) essentially none Nov-Feb; Edmonton (52 N) and Bergen (60 N) about 6 months with no significant production. — [Wacker & Holick 2013, Dermatoendocrinology 5(1):51-108](https://pmc.ncbi.nlm.nih.gov/articles/PMC3897598/)
- Snippet only, not attributable to ODS: "above 35 degrees latitude, vitamin D synthesis becomes negligible in winter" and "10 a.m. to 3 p.m." appeared in search summaries from teaching-site pages. I could not load the [NIH ODS fact sheet](https://ods.od.nih.gov/factsheets/VitaminD-Consumer/) (HTTP 403), so do not cite ODS for any number.

### Inferences
- Computed here (Allaart fit, see section 4), clear-sky UVI = 3 occurs at elevation 33.4 / 37.2 / 40.7 / 44.2 deg for ozone 250 / 300 / 350 / 400 DU. The two rules are not the same quantity: UVI is erythemally (sunburn) weighted, while the 45 deg rule descends from vitamin D action-spectrum work (MacLaughlin 1982, Webb). Per McKenzie 2009 and NIWA (section 1 findings) vitamin D-weighted UV falls off faster with zenith angle and with low ozone-path than sunburn UV (winter 5 percent of summer versus 10 percent). So at a given UVI, low sun carries proportionally less vitamin D-effective UV than high sun, and the UVI 3 elevations above are optimistic for synthesis specifically. That is a second reason, besides ozone, to prefer the 45 deg end for a synthesis-related rule; UVI 3 is best read as the erythemal / protection line.
- Calibration against Webb 1988 (my arithmetic): Boston mid-February noon elevation is 34.5 deg (no production), mid-March 45.4 deg (small production); Edmonton March noon is 34 deg (none), April 46 deg. So the observed on/off point lies between roughly 36 and 45 deg when spring ozone is high (about 350 DU in Boston per the NILU reference), and 34 N winter synthesis (Webb) is consistent with low subtropical winter ozone lowering the threshold toward 33 deg. This supports a rule of about 40-45 deg for northern-hemisphere temperate spring and about 35 deg when ozone is known to be low.
- The "shadow shorter than your height" rule is exactly elevation >= 45 deg. It is the most conservative of the common rules and the easiest to explain on a watch.
- Because the sources disagree, an OPEN/CLOSED rule should be named as a sun-height rule ("sun is high enough"), with the threshold as a single documented constant, and not as a claim about synthesis.

### Gaps
- Could not read Engelsen 2010 in full text for any elevation number; the "15 deg" attribution is secondary (Brazilian 2024 paper), and the odd ">75 deg" clause in that paper is unexplained, so I did not use it.
- Could not read MacLaughlin 1982 or Webb 2011 primary text; the "45 deg" attribution is secondary (Kallioglu 2024, Leal & Leder 2024).
- Could not confirm a source stating a 30 deg threshold as a synthesis rule; the only 30 deg numbers found are the shadow-rule UVI < 3 boundary (snippet only) and a search-engine summary claiming "some studies suggest ~30" (no citation, treat as unverified).
- NIH ODS fact sheet and Kazantzidis 2009 full text were inaccessible (403); Kazantzidis abstract confirmed only via Europe PMC: maximum daily vitamin D dose in late June is up to 250 times the winter minimum, and recommended vitamin D doses cannot be reached from sun during winter at northern European sites. — [Kazantzidis et al. 2009, Photochem Photobiol Sci](https://pubs.rsc.org/en/content/articlehtml/2009/pp/b811216a). A search summary also claimed the standard dose cannot be reached at Bilthoven (52 N) for 3 months or Jokioinen (60.8 N) for 4 months of the year; snippet only.

## 2. "Vitamin D winter": latitudes and months with no window

### Takeaway
Sources agree on the shape: no synthesis in winter above about 35-37 N, about 4 months at 42 N (Boston Nov-Feb), about 6 months at 52 N (Edmonton Oct-Mar) and the UK (October to late March). Computed here, a clear-sky elevation rule puts Vilnius (54.7 N) closed from about October to March under a UVI >= 3 rule and from about September to mid-April under the 45 deg rule; London about October to mid-March (UVI 3) or early September to early April (45 deg); Phoenix (33.4 N) is closed only about late November to late January under UVI 3, and about late October to mid-February under 45 deg.

### Cited Findings
- Boston 42.2 N: no previtamin D3 Nov-Feb, Edmonton 52 N: Oct-Mar (Webb 1988, above). — [Engelsen 2010](https://pmc.ncbi.nlm.nih.gov/articles/PMC3257661/); [PubMed 2839537, snippet only](https://pubmed.ncbi.nlm.nih.gov/2839537/)
- SACN: below 37 N year-round UVB sufficient; UK effective only from about April to September. — [SACN 2016](https://assets.publishing.service.gov.uk/media/5a804e36ed915d74e622dafa/SACN_Vitamin_D_and_Health_report.pdf)
- SACN, UK solar noon: spectral UVR at 300 nm at solar noon is "at least about ten times higher" than before 09:00 GMT or after 15:00 GMT, and 70 percent of the global UVR exposure is delivered in the four hours centred on noon; SACN adds that in the UK sunlight is not effective at sunrise or sunset and midday is most effective. — [SACN 2016, paras 3.7, 10.19](https://assets.publishing.service.gov.uk/media/5a804e36ed915d74e622dafa/SACN_Vitamin_D_and_Health_report.pdf)
- SACN notes the size of the latitude effect inside the UK is unclear: an Aberdeen (57 N) vs Guildford (51 N) difference of about 10 nmol/L in serum 25(OH)D that "might not be due to solar radiation". — [SACN 2016, para 3.18](https://assets.publishing.service.gov.uk/media/5a804e36ed915d74e622dafa/SACN_Vitamin_D_and_Health_report.pdf)
- Nordic (59 N) winter: search summary says no dermal vitamin D formation Nov-March at Oslo's latitude. Snippet only. — [search summary citing Nordic review, PubMed 18844844](https://pubmed.ncbi.nlm.nih.gov/18844844/)
- Turkey (37 N and 41 N): active synthesis early March to third week of October, 10:00-16:00. — [Kallioglu 2024](https://pmc.ncbi.nlm.nih.gov/articles/PMC10861575/)
- Phoenix, Vilnius and London have no direct study in what I found. Vilnius/Lithuania-specific vitamin D winter source: not found.
- Method for the computed tables below: noon elevation = 90 - |latitude - declination|; declination from the NOAA fractional-year series; window hours from the hour-angle form of NOAA's cos(zenith) = sin(lat)sin(decl) + cos(lat)cos(decl)cos(ha); mid-month day-of-year (15 Jan, 15 Feb, ...). No refraction, no ozone, solar (not clock) time. — [NOAA GML General Solar Position Calculations](https://gml.noaa.gov/grad/solcalc/solareqns.PDF) (equations read from the PDF)

### Inferences
Computed here, mid-month, degrees of noon elevation, by latitude (rows) and month (columns). Under a 45 deg rule a month is CLOSED all day wherever the value is below 45; under 30 deg wherever below 30.

| Lat | Jan | Feb | Mar | Apr | May | Jun | Jul | Aug | Sep | Oct | Nov | Dec |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 30 | 39 | 47 | 58 | 69 | 79 | 83 | 82 | 74 | 63 | 52 | 42 | 37 |
| 35 | 34 | 42 | 53 | 64 | 74 | 78 | 77 | 69 | 58 | 47 | 37 | 32 |
| 40 | 29 | 37 | 48 | 59 | 69 | 73 | 72 | 64 | 53 | 42 | 32 | 27 |
| 45 | 24 | 32 | 43 | 54 | 64 | 68 | 67 | 59 | 48 | 37 | 27 | 22 |
| 50 | 19 | 27 | 38 | 49 | 59 | 63 | 62 | 54 | 43 | 32 | 22 | 17 |
| 55 | 14 | 22 | 33 | 44 | 54 | 58 | 57 | 49 | 38 | 27 | 17 | 12 |
| 60 | 9 | 17 | 28 | 39 | 49 | 53 | 52 | 44 | 33 | 22 | 12 | 7 |

Caveat for the three mid-month tables: they sample the 15th, so a transition month can show 0 h even though the window opens later in that month (for example 55 N April reads 0 h under 45 deg, yet Vilnius at 54.7 N opens on 16 April); mid-month snapshots understate the first and last month of each window, and the dated place table further below is the better guide.

Hours per day with sun elevation >= 45 deg (clear geometry only), mid-month, solar time:

| Lat | Jan | Feb | Mar | Apr | May | Jun | Jul | Aug | Sep | Oct | Nov | Dec |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 30 | 0 | 1.7 | 4.4 | 5.7 | 6.4 | 6.7 | 6.6 | 6.1 | 5.1 | 3.3 | 0 | 0 |
| 35 | 0 | 0 | 3.6 | 5.4 | 6.3 | 6.7 | 6.6 | 5.9 | 4.6 | 1.8 | 0 | 0 |
| 40 | 0 | 0 | 2.2 | 5.0 | 6.2 | 6.7 | 6.5 | 5.7 | 3.9 | 0 | 0 | 0 |
| 45 | 0 | 0 | 0 | 4.3 | 5.9 | 6.5 | 6.3 | 5.2 | 2.6 | 0 | 0 | 0 |
| 50 | 0 | 0 | 0 | 3.1 | 5.4 | 6.2 | 6.0 | 4.5 | 0 | 0 | 0 | 0 |
| 55 | 0 | 0 | 0 | 0 | 4.7 | 5.8 | 5.4 | 3.3 | 0 | 0 | 0 | 0 |
| 60 | 0 | 0 | 0 | 0 | 3.3 | 5.0 | 4.5 | 0 | 0 | 0 | 0 | 0 |

Hours per day with clear-sky UVI >= 3 (Allaart-based estimate, 300 DU ozone, see section 4), mid-month:

| Lat | Jan | Feb | Mar | Apr | May | Jun | Jul | Aug | Sep | Oct | Nov | Dec |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 30 | 1.8 | 4.2 | 5.8 | 7.0 | 7.6 | 7.9 | 7.8 | 7.3 | 6.4 | 5.0 | 2.9 | 0 |
| 35 | 0 | 3.0 | 5.3 | 6.8 | 7.6 | 8.0 | 7.8 | 7.2 | 6.1 | 4.3 | 0 | 0 |
| 40 | 0 | 0 | 4.6 | 6.5 | 7.5 | 8.0 | 7.8 | 7.1 | 5.6 | 3.1 | 0 | 0 |
| 45 | 0 | 0 | 3.5 | 6.1 | 7.4 | 8.0 | 7.8 | 6.8 | 4.9 | 0 | 0 | 0 |
| 50 | 0 | 0 | 1.0 | 5.5 | 7.2 | 7.9 | 7.6 | 6.4 | 3.9 | 0 | 0 | 0 |
| 55 | 0 | 0 | 0 | 4.5 | 6.8 | 7.7 | 7.4 | 5.8 | 1.8 | 0 | 0 | 0 |
| 60 | 0 | 0 | 0 | 2.7 | 6.2 | 7.4 | 7.0 | 4.8 | 0 | 0 | 0 | 0 |

Named places (computed here), first/last day on which the noon sun reaches each threshold (clear sky; UVI row assumes 300 DU):

| Place (lat) | Noon UVI >= 3 (clear, 300 DU) | Noon elevation >= 45 deg | Months with no window, 45 deg rule | Months with no window, UVI>=3 rule |
|---|---|---|---|---|
| Phoenix (33.4 N) | 24 Jan - 19 Nov | 19 Feb - 24 Oct | late Oct-mid Feb | late Nov-late Jan |
| Boston (42.2 N) | 22 Feb - 21 Oct | 15 Mar - 30 Sep | Oct-Mar (6 months) | about Nov-mid Feb (Webb: Nov-Feb) |
| London (51.5 N) | 18 Mar - 27 Sep | 7 Apr - 6 Sep | early Sep-early Apr | late Sep-mid Mar |
| Vilnius (54.7 N) | 26 Mar - 18 Sep | 16 Apr - 28 Aug | about Sep-mid Apr | about Oct-Mar |
| Oslo (59.9 N) | 9 Apr - 5 Sep | 2 May - 13 Aug | about Aug-Apr | about Sep-Mar |

Cross-check: I compared my noon elevations (NOAA fractional-year declination, day-of-year based) against the sibling file `solar_elevation_fixtures.py` (NOAA/Meeus declination, read-only) for Vilnius, London and Phoenix on its six 2026 fixture dates (15 Jan, 20 Mar, 21 Jun, 15 Jul, 23 Sep, 21 Dec). They agree to within 0.45 deg (largest near the equinoxes, 20 Mar -0.42 and 23 Sep +0.44; solstices within 0.02 deg), which moves window edges by about a day or two.

Reading the table: the UVI >= 3 rule at 300 DU is more generous than Webb 1988 (it opens Boston on 22 February, when Webb found nothing in mid-February), which is the ozone effect in section 1; using about 350 DU for northern spring would move Boston's opening to roughly early-to-mid March. The 45 deg rule is closer to Webb and SACN for 42-52 N but closes Boston at the end of September while the Webb "Nov-Feb" statement leaves October open, so it is stricter than the observation in autumn.

### Gaps
- No source gives a Vilnius, London or Phoenix month-by-month "no window" list. The rows above are my computation; the only empirical anchors are Boston, Edmonton (Webb 1988) and SACN's UK statement.
- Webb's Boston and Edmonton results are cloudless-day measurements with a detection criterion; real days at those latitudes are cloudier, so real closure is longer.

## 3. Cloud attenuation of UV and a cloud-percentage-to-UVI mapping

### Takeaway
Clouds reduce UV much less than they reduce visible light, and the reduction is highly variable. The one citeable set of operational factors is the US National Weather Service / EPA table: clear 100 percent, scattered 89, broken 73, overcast 31 percent of clear-sky UV. WHO says up to 80 percent of UV can pass light cloud, and thin broken cloud near the sun can even raise UV. Garmin's Connect IQ weather API already supplies uvIndex and cloudCover (API 5.1.0), so a cloud-to-UVI mapping may be unnecessary on devices that have it.

### Cited Findings
- EPA (archived) on the National Weather Service UV Index: "Clear skies allow virtually 100% of UV to pass through, scattered clouds transmit 89%, broken clouds transmit 73%, and overcast skies transmit 31%." The NWS model uses forecast ozone, forecast cloud amounts and ground elevation (about +6 percent per km). — [EPA, Calculating the UV Index (Jan 2017 snapshot, verified)](https://19january2017snapshot.epa.gov/sunsafety/calculating-uv-index-0_.html). The page does not define the oktas or percent cloud cover behind "scattered/broken/overcast".
- WHO/UNEP/WMO/ICNIRP Global Solar UV Index guide: "Up to 80% of solar UV radiation can penetrate light cloud cover. Haze in the atmosphere can even increase UV radiation exposure"; "You can't get sunburnt on a cloudy day" is listed as a false belief; "UV radiation levels are highest under cloudless skies but even with cloud cover, UV radiation levels can be high"; forecasts not including cloud must be labelled "clear sky" or "cloud free" UVI; when cloud is variable present the UVI as a range. — [WHO 2002 Global Solar UV Index practical guide (PDF text, verified)](https://iris.who.int/server/api/core/bitstreams/94a908ec-14ee-4bb4-84eb-ace483c9eb51/content), landing page [WHO publication 9241590076](https://www.who.int/publications/i/item/9241590076)
- Engelsen 2010: "Completely overcast clouds always attenuate UVB rays, even up to 99% of UVB radiation in extreme cases." — [Engelsen 2010](https://pmc.ncbi.nlm.nih.gov/articles/PMC3257661/)
- KNMI (Allaart et al. 2004, Table 1): cloud amount and properties is the largest uncertainty in a practical UVI forecast, over 50 percent, versus 4 percent for a 3 percent ozone error. — [Allaart et al. 2004, Meteorol. Appl. 11:59-65 (PDF text, verified)](https://www.temis.nl/uvradiation/product/papers/200411105metappl.pdf)
- TEMIS (KNMI/ESA) cloud modification factor: clear sky 1, heavily clouded as low as about 0.2, scattering can produce values above 1, with uncertainty about 0.077 for cloudy cases. — [TEMIS, UV index and UV dose: cloud modification](https://temis.nl/uvradiation/product/clouds.html)
- Secondary, snippet only: cloud modification factor for overcast typically 0.3 to 0.7 depending on cloud type (Calbo, Pages, Gonzalez 2005, Reviews of Geophysics "Empirical studies of cloud effects on UV radiation: A review"), and cloud effect on UV is 15-45 percent weaker than on total solar radiation. — [recercat record, snippet only](https://www.recercat.cat/handle/2072/219104?show=full). A blog summary of Davos data puts average cloud transmission near an SPF 2 equivalent, with CMF about 1 when the sun is not obscured and about 0.5 when it is. — [UV substack, secondary](https://uv.substack.com/p/rule-of-thumb-for-uv-blocking-by)
- Garmin Connect IQ `Toybox.Weather.CurrentConditions` has `cloudCover` (Number or Null, "[0-100%]", since API 5.1.0) and `uvIndex` (Float or Null, "[0-10]", since API 5.1.0); `HourlyForecast` also has `cloudCover` and `uvIndex`; `DailyForecast` has neither; condition enum includes CONDITION_CLEAR, PARTLY_CLOUDY, MOSTLY_CLOUDY, CLOUDY, PARTLY_CLEAR, MOSTLY_CLEAR, THIN_CLOUDS, HAZE, HAZY, FAIR. — [Garmin API docs, CurrentConditions (HTML read directly)](https://developer.garmin.com/connect-iq/api-docs/Toybox/Weather/CurrentConditions.html); [HourlyForecast](https://developer.garmin.com/connect-iq/api-docs/Toybox/Weather/HourlyForecast.html); [DailyForecast](https://developer.garmin.com/connect-iq/api-docs/Toybox/Weather/DailyForecast.html); [Weather module](https://developer.garmin.com/connect-iq/api-docs/Toybox/Weather.html). Note: a web-search summary in this session wrongly said uvIndex does not exist; the HTML shows it does.

### Inferences
- A usable rough mapping from a weather-API cloud percentage c (0-100) to a multiplier on clear-sky UVI, built on the NWS factors: c < 25 percent: 1.0; 25-50: 0.89; 50-87: 0.73; above 87: 0.31. The percent cut points are my assumption from the standard eighths-of-sky categories (scattered 3-4/8, broken 5-7/8, overcast 8/8), not stated in the EPA page, so mark unverified. A continuous alternative is a linear interpolation through (0, 1.0), (40, 0.89), (70, 0.73), (100, 0.31), also my construction.
- Uncertainty on the multiplier is large (over 50 percent per Allaart; CMF 0.2-above 1 per TEMIS), and it is worse near cloud edges. So cloud should only demote OPEN to a softer state ("cloudy, sun may be weaker"), or lower the estimated UVI, and never be used to claim precise synthesis.
- Applied to Vilnius noon clear-sky UVI (computed here): May 6.4 clear, 5.7 scattered, 4.7 broken, 2.0 overcast; April 4.5 / 4.0 / 3.3 / 1.4; September 3.3 / 2.9 / 2.4 / 1.0. So under a UVI >= 3 rule overcast closes the window in every Vilnius month, broken cloud closes September, and scattered cloud barely changes anything.
- If the watch has uvIndex from the Garmin API, it replaces both the elevation formula and the cloud mapping, with the caveat that its source model, cloud treatment and capping are undocumented.

### Gaps
- Calbo 2005 and the cloud-percentage definitions behind the NWS table were not readable; vitamin D-weighted (as opposed to erythemal) cloud modification factors, which are not the same, were not found.
- Whether Garmin's uvIndex is cloud-adjusted, its update frequency, and which devices populate it (versus returning null) are not documented in what I read. The "[0-10]" in the docstring suggests a possible cap below the real 11+ range; unverified.

## 4. UVI estimate from solar elevation (clear sky): formula, error, caveats

### Takeaway
The best-documented clear-sky formula I could verify is Allaart et al. (KNMI, 2004), a fit to Brewer spectrophotometer data from De Bilt (mid-latitude) and Paramaribo (tropics), valid for 0 < SZA < 90 and a wide range of ozone, with fit RMS error 0.20 UVI units. For a watch, a one-line power law of sin(elevation) fitted to it reproduces it within about 10 percent for elevation 20-90 deg at 300 DU. It is an estimate for clear sky, sea level, typical aerosol, and is only as good as the ozone value assumed.

### Cited Findings
- Allaart et al. (2004): the clear-sky UVI is expressed as a function of two predictable quantities, solar zenith angle and total ozone, fitted to Brewer data (De Bilt April-September 2000, 510 points; Paramaribo 1999, 476 points); "good results for all solar zenith angles between 0 and 90 deg"; RMS error of the UVI fit 0.20; both stations at low altitude; add about 5 percent per km altitude; may apply outside the fitted ozone range. — [Allaart et al. 2004 (PDF text, verified)](https://www.temis.nl/uvradiation/product/papers/200411105metappl.pdf)
- Allaart's functional form, as extracted from the PDF text: UVA(mu0) = (D0/D)^2 * S * mux * exp(-tau/mux), with mux = mu0*(1-eps)+eps, mu0 = cos(SZA), S = 1.24 W m-2 nm-1, eps = 0.17, tau = 0.58 (RMS 0.009 W m-2 nm-1); then UVI/UVA = F*X^G + H/TO + J with X = 1000*mu0/TO, TO in Dobson units, F = 2.0, G = 1.62, H = 280.0, J = 1.4. The PDF's equation 8 layout is partly garbled in text extraction, so my reading of its exact arrangement is unverified; the sanity checks below are what make me trust it. — [Allaart et al. 2004](https://www.temis.nl/uvradiation/product/papers/200411105metappl.pdf)
- Allaart Table 1 uncertainty in a practical forecast: cloud over 50 percent; snow albedo 28 percent; ozone profile 8; aerosol (tau 0.42 +/- 0.26) 5; altitude 1 km 5; total ozone (3 percent) 4; latitude (1 deg) 3; Sun-Earth distance 3; stratospheric temperature (10 deg) 2; SO2 (1 DU) 1. — [Allaart et al. 2004](https://www.temis.nl/uvradiation/product/papers/200411105metappl.pdf)
- Definition: UVI = erythemally weighted (McKinlay-Diffey) UV divided by 25 mW/m2, i.e. UVI = UVR/0.025 in W/m2. — [TEMIS UVI/UVD details](https://www.temis.nl/uvradiation/product/uvi-uvd.html)
- WHO: about 90 percent of UVB is absorbed by ozone, water vapour, oxygen and CO2; UV rises 10-12 percent per 1000 m altitude; fresh snow can reflect as much as 80 percent; daily maximum occurs within the four hours around solar noon; reports should use a 30-minute average, rounded to whole numbers. — [WHO 2002 guide](https://iris.who.int/server/api/core/bitstreams/94a908ec-14ee-4bb4-84eb-ace483c9eb51/content)
- Wikipedia (secondary): operational UVI forecasts are typically accurate to within +/-1 UVI unit, worse when cloud is unexpectedly heavy or light. — [Wikipedia, Ultraviolet index](https://en.wikipedia.org/wiki/Ultraviolet_index) (via summariser; secondary)
- Madronich-type simple formulas exist (Anton, Serrano, Cancillo, Garcia & Madronich 2011, "Empirical evaluation of a simple analytical formula for the ultraviolet index", Photochem Photobiol 87:478-482) but I could not retrieve the coefficients. — [search result only](https://opendata.unex.es/investiga/publicaciones/2011-413)

### Inferences
Computed here from my reading of Allaart (300 DU):

| Elevation (deg) | 90 | 70 | 60 | 50 | 45 | 40 | 30 | 25 | 20 | 15 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Clear-sky UVI | 11.4 | 9.6 | 7.7 | 5.6 | 4.5 | 3.5 | 1.9 | 1.2 | 0.75 | 0.41 | 0.19 |

- Sanity checks passed: UVI under 3 below about 30 deg (agrees with the shadow-rule statement, snippet only); 11.4 at zenith for 300 DU is plausible mid-latitude summer-to-tropical; Phoenix January noon comes out 2.7 and London December noon 0.4.
- A one-line watch approximation fitted to those numbers (my construction, not published): UVI_clear approx 11.4 * sin(elevation)^2.66, within about 10 percent of the Allaart-based values for elevation 20-90 deg at 300 DU (check: 30 deg 1.8, 45 deg 4.5, 60 deg 7.8, 70 deg 9.6). Ozone scaling is not in this form; ozone shifts the UVI = 3 elevation by about 3.5 deg per 50 DU (33.4 / 37.2 / 40.7 / 44.2 deg at 250 / 300 / 350 / 400 DU), so it can be handled as a seasonal threshold shift (lower in tropics/winter, higher in northern spring).
- A widely quoted simple power-law (about 12.5 * cos(SZA)^2.42 * (O3/300)^-1.23) is from my memory and not source-verified here. Implemented, it gives about 12.5 at zenith and 5.4 at 45 deg elevation, 20-25 percent above the Allaart-based value at moderate elevations. That spread between two published-style fits is a fair indication of the realistic model error for a clear-sky estimate: about +/-20 percent, or +/-1 UVI unit at mid values, before cloud, aerosol, altitude or snow.
- Error budget for a clear-sky estimate with no ozone input: ozone alone can move the elevation for UVI 3 by +/-5 deg. Add the cloud multiplier, and cloud dominates every other term.
- Offline versus needing data: from date, latitude, longitude and time alone a watch can compute solar elevation, solar noon and sunrise/sunset (NOAA equations above), the elevation-threshold window, and a clear-sky UVI estimate with an assumed ozone. It cannot know cloud, aerosol, true ozone, snow cover or altitude effects; cloud needs weather data (the Garmin Weather API supplies cloudCover and uvIndex when the phone has synced).

### Gaps
- Allaart equation 8 arrangement is not independently verified; ozone input assumed constant 300 DU.
- No source found for typical seasonal ozone climatology by latitude (needed if a watch embeds an ozone-by-month table); not searched in depth.
- Primary source for the 12.5 / 2.42 / -1.23 form not retrieved.

## 5. Time-of-day window: OPEN hours around solar noon by latitude and season

### Takeaway
Sources use fixed clock windows (10:00-15:00 or 10:00-16:00) as a rule of thumb, and SACN gives an actual UV ratio (noon at least about 10 times the before-09:00/after-15:00 level at 300 nm). The sun-height alternative gives a window that is symmetric around solar noon and shrinks to nothing in winter at high latitude: computed here, a 45 deg rule gives about 6-7 h at 35-45 N in June, 3-4 h around the equinoxes at 40 N, and none from about October to March at 50 N.

### Cited Findings
- 10:00-15:00: Wacker & Holick 2013 ("very little if any" before 10 a.m. or after 3 p.m. even in summer); Australian campaigns promote 10 am-3 pm peak UVI periods. — [Wacker & Holick 2013](https://pmc.ncbi.nlm.nih.gov/articles/PMC3897598/); [Stalgis-Bilinski 2011](https://www.mja.com.au/journal/2011/194/7/burning-daylight-balancing-vitamin-d-requirements-sensible-sun-exposure)
- 10:00-16:00: Turkey active-synthesis window; US/WHO-style high-UVI advice (Wikipedia lists 10 a.m.-4 p.m. for UVI 6+). — [Kallioglu 2024](https://pmc.ncbi.nlm.nih.gov/articles/PMC10861575/); [Wikipedia UV index](https://en.wikipedia.org/wiki/Ultraviolet_index) (secondary)
- SACN: ratio about 10 between solar noon and the periods before 09:00 / after 15:00 GMT; 70 percent of UVR in the 4 hours around noon; UK exposure times for 1000 IU-equivalent (quarter MED, 25 percent body) 5-15 min in mid-summer and 15-60 min in mid-March and mid-September (Webb & Engelsen 2006); Diffey model 10-20 min daily in UK summer raises serum 25(OH)D by only 5-10 nmol/L; their own modelling uses noon 12:00-13:00 exposures. — [SACN 2016, 3.7, 5.27-5.28, 9.24-9.25](https://assets.publishing.service.gov.uk/media/5a804e36ed915d74e622dafa/SACN_Vitamin_D_and_Health_report.pdf)
- WHO: daily maximum UV occurs in the four-hour period around solar noon; solar noon is between local noon and 2 p.m. depending on location and daylight saving. — [WHO 2002 guide](https://iris.who.int/server/api/core/bitstreams/94a908ec-14ee-4bb4-84eb-ace483c9eb51/content)
- NOAA: solar noon = 720 - 4*longitude - eqtime (minutes UTC); sunrise/sunset hour angle uses zenith 90.833. — [NOAA GML](https://gml.noaa.gov/grad/solcalc/solareqns.PDF)

### Inferences
- Window length under the 45 deg rule (table in section 2, solar time, centred on solar noon): about 6.5 h in June at 30-40 N, 6.2 h at 50 N, 5.0 h at 60 N; at 40 N 5.0 h in April, 3.9 h in September, 2.2 h in March; at 50 N 3.1 h in April, 0 from September to March. Under UVI >= 3 (300 DU, clear) the window is about 7-8 h in June at 35-60 N, 4.5-6 h in April at 45-55 N, and 4-5 h in September at 45-50 N.
- Specific places (computed here, hours per day, rule 45 deg / rule UVI >= 3): Vilnius June 5.8 / 7.7, May 4.7 / 6.8, April 0 / 4.6, August 3.4 / 5.9, September 0 / 2.0, December 0 / 0 (clear-sky noon UVI only 0.3). London June 6.1 / 7.8, April 2.6 / 5.2, September 0 / 3.5. Phoenix June 6.7 / 7.9, December 0 / 0, January 0 / 0, March 3.8 / 5.5.
- The window is symmetric about solar noon in solar time, not clock time. On the watch convert with the longitude and equation-of-time offset (clock noon can differ by an hour or more, plus daylight saving).
- A fixed 10:00-15:00 clock window is a crude proxy for the same thing and would give wrong answers in high-latitude spring and autumn (sun not high enough) and a bit of slack in the tropics.

### Gaps
- No source specifies the shape of the hourly curve for vitamin D-weighted UV versus erythemal at specific latitudes beyond SACN's 10x noon ratio; the width of the useful window is therefore threshold-dependent and a product choice.

## 6. Safety, wording and claims

### Takeaway
WHO and Cancer Council both set UVI 3 as the point where sun protection starts, and WHO explicitly warns against messages that imply a "safe" unprotected duration. The only established benefit of solar UV is vitamin D synthesis (SACN), but the same wavelengths cause sunburn and skin cancer, and the consensus is contested for individuals. So an OPEN/CLOSED sun-height indicator should describe the sun, not the body, and should not carry vitamin D or health claims. Garmin's own health-science pages and the kit's watch-pm rule point the same way.

### Cited Findings
- WHO: UVI categories Low 0-2, Moderate 3-5, High 6-7, Very high 8-10, Extreme 11+. "Even for very sensitive fair-skinned people, the risk of short-term and long-term UV radiation damage below a UVI of 3 is limited, and under normal circumstances no protective measures are needed. Above the threshold value of 3, protection is necessary." — [WHO 2002 guide (verified)](https://iris.who.int/server/api/core/bitstreams/94a908ec-14ee-4bb4-84eb-ace483c9eb51/content)
- WHO: reporting burn times is not recommended, since people interpret them as a safe level of unprotected exposure; "The UVI should not imply that extending exposures is acceptable"; risk is cumulative; "small amounts of UV radiation are beneficial for people and essential in the production of vitamin D"; the guide is an educational tool. — [WHO 2002 guide](https://iris.who.int/server/api/core/bitstreams/94a908ec-14ee-4bb4-84eb-ace483c9eb51/content)
- WHO sun-protection scheme: no protection required at UVI 0-2 ("You can safely stay outside!"); protection required at 3-7; extra protection at 8+; includes seeking shade at midday, hat, clothing, SPF 15+ sunscreen. — [WHO 2002 guide](https://iris.who.int/server/api/core/bitstreams/94a908ec-14ee-4bb4-84eb-ace483c9eb51/content)
- Cancer Council Australia: protection recommended at UVI 3+; and "deliberate sun exposure without any form of sun protection when the UV Index is 3 or above is not recommended, even for those diagnosed with vitamin D deficiency" (search summary of the joint position statement, snippet only); the 2024 revised statement is tailored by risk group: very high skin-cancer risk, risks likely outweigh benefits; deeply pigmented skin, low skin-cancer risk but high deficiency risk so routine sun protection is not recommended. — [Cancer Council vitamin D page (verified)](https://www.cancer.org.au/preventing-cancer/sun-protection/vitamin-d/); [2024 statement summary, snippet only](https://pubmed.ncbi.nlm.nih.gov/38350754/)
- The joint statement notes the wavelengths linked to skin cancer are the same as those that produce vitamin D. — [Scimex summary, snippet only](https://www.scimex.org/newsfeed/new-sun-safety-advice-tailored-for-australia’s-diverse-population)
- SACN 2016: "Synthesis of vitamin D is the only established benefit of solar UV exposure"; for the UK, kept alongside sun-safety advice (children covering up, shade 11:00-15:00, sunscreen, March-October). — [SACN 2016](https://assets.publishing.service.gov.uk/media/5a804e36ed915d74e622dafa/SACN_Vitamin_D_and_Health_report.pdf)
- Garmin first-party wording (from the design kit's read of Garmin Technology Health Science pages): every page carries a footnoted disclaimer ("does not constitute medical advice") and points to garmin.com/ataccuracy for accuracy claims; Garmin's stress copy declines to say why a reading is high; Body Battery low-day copy is deliberately neutral ("the occasional low-energy day is no cause for alarm"). — [watch-design-kit health-science.md](/Users/mbp/dev/watch-design-kit/knowledge/health-science.md) (local file, read; its upstream is the [Garmin Health Science page](https://www.garmin.com/en-US/garmin-technology/health-science/))
- Kit rule: listing copy should "describe what's shown, never what it means for health/fitness"; the app template forbids "medical or health advice, or that a reading is good/bad". — [watch-pm SKILL.md](/Users/mbp/dev/watch-design-kit/skills/watch-pm/SKILL.md) and [release-contract.md](/Users/mbp/dev/watch-design-kit/templates/watch-app/docs/release-contract.md)

### Inferences
- Wording that stays on the safe side (all my suggestions, not from a source): state the sun, not the skin: "Sun high" / "Sun low", "Sun above 45 deg" / "Sun below 45 deg", "Strong sun window", "UV high enough to need sun protection" only if the data is UVI 3+. Avoid: "vitamin D", "make vitamin D", "safe", "healthy", "you need sun", "enough", "burn time", minutes of exposure.
- Pair OPEN with an unobtrusive note that UVI 3+ means protection is advised (mirrors both WHO and Cancer Council); do not turn it into a goal or a streak, since WHO warns that "safe time" framing causes harm.
- Because the same threshold (UVI 3) means "start protecting" for the sun-protection community and "enough UV to work with" for the vitamin D community, any single OPEN state is double-edged; this is the main contested point and it is why a neutral sun-height label is the safer product framing.
- Describe the feature as a computed sun position or estimate ("estimated", "approx.") and do not call the output a UV index unless it comes from the API's uvIndex.

### Gaps
- I did not find a Garmin first-party feature wording for sun exposure or vitamin D (none searched beyond the kit file); Garmin's own UV Index weather wording on devices was not checked.
- Skin-type dependence (Fitzpatrick I-VI) and age/body-area effects change the exposure time by factors of 2-10 (McKenzie via Leal & Leder, SACN) and cannot be captured by a date/latitude rule, so a rule cannot claim anything about an individual.
