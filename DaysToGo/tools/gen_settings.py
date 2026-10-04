#!/usr/bin/env python3
"""Generate the settings resources the phone app shows.

Writes, relative to the project root, for each tier asked for (free, pro; default both):
  resources-<tier>/settings/settings.xml     what Garmin Connect / Express render
  resources-<tier>/settings/properties.xml   defaults (keys never change once shipped)
  resources-accent-<tier>/settings/accent.xml   the Accent list, alone, so the Instinct products can leave it out (ADR-015)
and, tier-independent, every run:
  resources/strings/generated.xml     the numbers-only strings (not translated), and a copy in every
                                      resources-<lang>/strings/ (languages do not inherit the default's ids)
  resources-pro/strings/generated.xml the Pro-only numbers-only strings (minute and time zone labels, ADR-018); every
                                      language's jungle line already searches resources-pro, and Free never sees them

Tiers (docs/decisions.md ADR-014 (Free + Pro ladder)): Pro has every setting; Free omits Hour, Minute, EventZone and Footer (the Pro-only keys) and
shows Accent ids 0-5. There is NO settings file in the shared resources/: two files would overlap.

Everything users read as words (titles, list entries, month names) lives in
the hand-maintained resources*/strings/strings.xml; `--ids` prints the ids the
generated XML expects there. Lists, not `date`/`numeric`, on purpose: see
docs/research (date pickers in Garmin Connect lose the value on iOS and Android;
numeric min/max validation broke a rival's setup).

Run:  python3 tools/gen_settings.py            # write both tiers
      python3 tools/gen_settings.py free       # write one tier (free | pro)
      python3 tools/gen_settings.py --ids      # list ids you must define by hand
"""
import sys
from pathlib import Path

# Keep FIRST_YEAR/LAST_YEAR in step with DaysToGoConfig.PICKER_FIRST_YEAR/PICKER_LAST_YEAR (the on-watch picker).
FIRST_YEAR, LAST_YEAR = 2026, 2060       # bump LAST_YEAR each release year
MONTHS = 12
# Accent ids are append-only. 0-5 are shipped and are the Free list too; ids 6-11 (cyan, lime, yellow, orange,
# coral, magenta) are deferred, and when they land they are Pro-only (research_notes/Free and Pro ladder/accent_roster.md).
ACCENTS = ["mint", "amber", "sky", "pink", "violet", "white"]
FREE_ACCENT_COUNT = 6
TIERS = ("free", "pro")
PRO_ONLY_KEYS = ("Hour", "Minute", "EventZone", "Footer")
# The event time zone list (ADR-018): the list value is a quarter-hour index, 1 = UTC-12:00, 49 = UTC+00:00, 105 = UTC+14:00
# (0 = the watch's own zone). The mapping is frozen once shipped; only real zones are offered, in minutes east of UTC.
# Keep ZONE_UTC_INDEX / ZONE_SETTING_LAST in step with DaysToGoConfig.
ZONE_UTC_INDEX, ZONE_LAST = 49, 105
ZONE_MINUTES = [-720, -660, -600, -570, -540, -480, -420, -360, -300, -240, -210, -180, -150, -120, -60, 0, 60, 120, 180, 210,
                240, 270, 300, 330, 345, 360, 390, 420, 480, 525, 540, 570, 600, 630, 660, 720, 765, 780, 825, 840]
XSI = ('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
       'xsi:noNamespaceSchemaLocation="https://developer.garmin.com/downloads/connect-iq/resources.xsd"')

# (property id, default, type). List values are never negative (untested in Garmin Connect):
# Hour is 0 = all day, 1..24 = 00:00..23:00; DaysToGoEvent.hourFromSetting converts. Minute is 0..59 (read only with an Hour).
# EventZone is 0 = the watch's own zone, else a quarter-hour index (above); DaysToGoEvent.zoneOffset converts.
PROPS = [("Event", 0, "number"), ("Name", "", "string"), ("Month", 1, "number"), ("Day", 1, "number"),
         ("Year", 0, "number"), ("Hour", 0, "number"), ("Minute", 0, "number"), ("EventZone", 0, "number"),
         ("Unit", 0, "number"), ("DateStyle", 0, "number"),
         ("Footer", 0, "number"), ("Accent", 0, "number")]


def zone_index(minutes):
    return ZONE_UTC_INDEX + minutes // 15


def zone_label(minutes):
    sign = "-" if minutes < 0 else "+"
    return f"UTC{sign}{abs(minutes) // 60:02d}:{abs(minutes) % 60:02d}"


def entry(value, string_id):
    return f'<listEntry value="{value}">@Strings.{string_id}</listEntry>'


def lst(prop, title, entries):
    body = "\n            ".join(entries)
    return (f'    <setting propertyKey="@Properties.{prop}" title="@Strings.{title}">\n'
            f'        <settingConfig type="list">\n            {body}\n        </settingConfig>\n    </setting>\n')


def settings_xml(tier):
    pro = tier == "pro"
    out = [f"<settings {XSI}>\n\n"]
    out.append(lst("Event", "setting_event", [entry(0, "event_new_year"), entry(1, "event_christmas"), entry(2, "event_custom")]))
    out.append('    <setting propertyKey="@Properties.Name" title="@Strings.setting_name">\n'
               '        <settingConfig type="alphaNumeric" maxLength="16" />\n    </setting>\n')
    out.append(lst("Month", "setting_month", [entry(m, f"month_{m}") for m in range(1, MONTHS + 1)]))
    out.append(lst("Day", "setting_day", [entry(d, f"n{d}") for d in range(1, 32)]))
    out.append(lst("Year", "setting_year", [entry(0, "year_every")] + [entry(y, f"y{y}") for y in range(FIRST_YEAR, LAST_YEAR + 1)]))
    if pro:
        out.append(lst("Hour", "setting_hour", [entry(0, "hour_none")] + [entry(h + 1, f"h{h}") for h in range(24)]))
        out.append(lst("Minute", "setting_minute", [entry(m, f"mi{m}") for m in range(60)]))
        out.append(lst("EventZone", "setting_zone", [entry(0, "zone_watch")] + [entry(zone_index(m), f"zone_{zone_index(m)}") for m in ZONE_MINUTES]))
    out.append(lst("Unit", "setting_unit", [entry(0, "unit_days"), entry(1, "unit_weeks")]))
    out.append(lst("DateStyle", "setting_datestyle", [entry(0, "datestyle_auto"), entry(1, "datestyle_day"), entry(2, "datestyle_month")]))
    if pro:
        out.append(lst("Footer", "setting_footer", [entry(0, "footer_none"), entry(1, "footer_battery"), entry(2, "footer_steps")]))
    out.append("</settings>\n")
    return "".join(out)


def accent_xml(tier):
    """The Accent list alone, in its own file: the Instinct products' resourcePath leaves this folder out (ADR-015)."""
    accents = ACCENTS if tier == "pro" else ACCENTS[:FREE_ACCENT_COUNT]
    return (f"<settings {XSI}>\n\n"
            + lst("Accent", "setting_accent", [entry(i, f"accent_{a}") for i, a in enumerate(accents)])
            + "</settings>\n")


def properties_xml(tier):
    lines = [f"<properties {XSI}>\n",
             "    <!-- Values match DaysToGoConfig; ids never change once shipped. -->\n"]
    for pid, default, typ in PROPS:
        if tier == "free" and pid in PRO_ONLY_KEYS:
            continue
        lines.append(f'    <property id="{pid}" type="{typ}">{default}</property>\n')
    lines.append("</properties>\n")
    return "".join(lines)


def generated_strings():
    out = [f"<strings {XSI}>\n"]
    out += [f'    <string id="n{d}">{d}</string>\n' for d in range(1, 32)]
    out += [f'    <string id="y{y}">{y}</string>\n' for y in range(FIRST_YEAR, LAST_YEAR + 1)]
    out += [f'    <string id="h{h}">{h:02d}:00</string>\n' for h in range(24)]
    out.append("</strings>\n")
    return "".join(out)


def pro_generated_strings():
    """Pro-only, numbers only (not translated): minute labels and UTC offsets. Lives in resources-pro/strings."""
    out = [f"<strings {XSI}>\n"]
    out += [f'    <string id="mi{m}">{m:02d}</string>\n' for m in range(60)]
    out += [f'    <string id="zone_{zone_index(m)}">{zone_label(m)}</string>\n' for m in ZONE_MINUTES]
    out.append("</strings>\n")
    return "".join(out)


def hand_ids(tier="pro"):
    ids = ["setting_event", "event_new_year", "event_christmas", "event_custom", "setting_name",
           "setting_month", "setting_day", "setting_year", "year_every", "setting_hour", "hour_none", "setting_minute",
           "setting_zone", "zone_watch",
           "setting_unit", "unit_days", "unit_weeks", "setting_datestyle", "datestyle_auto",
           "datestyle_day", "datestyle_month", "setting_footer", "footer_none", "footer_battery",
           "footer_steps", "setting_accent"]
    ids += [f"month_{m}" for m in range(1, MONTHS + 1)] + [f"accent_{a}" for a in ACCENTS]
    if tier == "free":
        ids = [i for i in ids if not i.startswith(("setting_hour", "hour_none", "setting_minute", "setting_zone", "zone_watch", "setting_footer", "footer_"))]
    return ids


if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    tiers = args or list(TIERS)
    if any(t not in TIERS for t in tiers):
        sys.exit("usage: gen_settings.py [free|pro ...] [--ids]")
    if "--ids" in sys.argv:
        print("\n".join(hand_ids(tiers[0] if args else "pro")))
        sys.exit(0)
    root = Path(__file__).resolve().parent.parent
    if (root / "resources" / "settings").exists():
        sys.exit("resources/settings must not exist: settings live in resources-free/ and resources-pro/ only")
    langs = sorted(p.parent.name for p in root.glob("resources-*/strings") if p.parent.name not in ("resources-free", "resources-pro") and not p.parent.name.startswith("resources-pro-"))
    targets = []
    for tier in tiers:
        targets += [(f"resources-{tier}/settings/settings.xml", settings_xml(tier)),
                    (f"resources-{tier}/settings/properties.xml", properties_xml(tier)),
                    (f"resources-accent-{tier}/settings/accent.xml", accent_xml(tier))]
    targets += [("resources/strings/generated.xml", generated_strings()),
                ("resources-pro/strings/generated.xml", pro_generated_strings())]
    targets += [(f"{lang}/strings/generated.xml", generated_strings()) for lang in langs]
    for rel, text in targets:
        path = root / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)
        print("wrote", rel)
