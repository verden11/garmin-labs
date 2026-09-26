#!/usr/bin/env python3
"""Generate the settings resources the phone app shows.

Writes, relative to the project root:
  resources/settings/settings.xml     what Garmin Connect / Express render
  resources/settings/properties.xml   defaults (keys never change once shipped)
  resources/strings/generated.xml     the numbers-only strings (not translated), and a copy in every
                                      resources-<lang>/strings/ (languages do not inherit the default's ids)

Everything users read as words (titles, list entries, month names) lives in
the hand-maintained resources*/strings/strings.xml; `--ids` prints the ids the
generated XML expects there. Lists, not `date`/`numeric`, on purpose: see
docs/research (date pickers in Garmin Connect lose the value on iOS and Android;
numeric min/max validation broke a rival's setup).

Run:  python3 tools/gen_settings.py            # write files
      python3 tools/gen_settings.py --ids      # list ids you must define by hand
"""
import sys
from pathlib import Path

# Keep FIRST_YEAR/LAST_YEAR in step with DaysToGoConfig.PICKER_FIRST_YEAR/PICKER_LAST_YEAR (the on-watch picker).
FIRST_YEAR, LAST_YEAR = 2026, 2060       # bump LAST_YEAR each release year
MONTHS = 12
ACCENTS = ["mint", "amber", "sky", "pink", "violet", "white"]
XSI = ('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
       'xsi:noNamespaceSchemaLocation="https://developer.garmin.com/downloads/connect-iq/resources.xsd"')

# (property id, default, type). List values are never negative (untested in Garmin Connect):
# Hour is 0 = all day, 1..24 = 00:00..23:00; DaysToGoEvent.hourFromSetting converts.
PROPS = [("Event", 0, "number"), ("Name", "", "string"), ("Month", 1, "number"), ("Day", 1, "number"),
         ("Year", 0, "number"), ("Hour", 0, "number"), ("Unit", 0, "number"), ("DateStyle", 0, "number"),
         ("Footer", 0, "number"), ("Accent", 0, "number")]


def entry(value, string_id):
    return f'<listEntry value="{value}">@Strings.{string_id}</listEntry>'


def lst(prop, title, entries):
    body = "\n            ".join(entries)
    return (f'    <setting propertyKey="@Properties.{prop}" title="@Strings.{title}">\n'
            f'        <settingConfig type="list">\n            {body}\n        </settingConfig>\n    </setting>\n')


def settings_xml():
    out = [f"<settings {XSI}>\n\n"]
    out.append(lst("Event", "setting_event", [entry(0, "event_new_year"), entry(1, "event_christmas"), entry(2, "event_custom")]))
    out.append('    <setting propertyKey="@Properties.Name" title="@Strings.setting_name">\n'
               '        <settingConfig type="alphaNumeric" maxLength="16" />\n    </setting>\n')
    out.append(lst("Month", "setting_month", [entry(m, f"month_{m}") for m in range(1, MONTHS + 1)]))
    out.append(lst("Day", "setting_day", [entry(d, f"n{d}") for d in range(1, 32)]))
    out.append(lst("Year", "setting_year", [entry(0, "year_every")] + [entry(y, f"y{y}") for y in range(FIRST_YEAR, LAST_YEAR + 1)]))
    out.append(lst("Hour", "setting_hour", [entry(0, "hour_none")] + [entry(h + 1, f"h{h}") for h in range(24)]))
    out.append(lst("Unit", "setting_unit", [entry(0, "unit_days"), entry(1, "unit_weeks")]))
    out.append(lst("DateStyle", "setting_datestyle", [entry(0, "datestyle_auto"), entry(1, "datestyle_day"), entry(2, "datestyle_month")]))
    out.append(lst("Footer", "setting_footer", [entry(0, "footer_none"), entry(1, "footer_battery"), entry(2, "footer_steps")]))
    out.append(lst("Accent", "setting_accent", [entry(i, f"accent_{a}") for i, a in enumerate(ACCENTS)]))
    out.append("</settings>\n")
    return "".join(out)


def properties_xml():
    lines = [f"<properties {XSI}>\n",
             "    <!-- Values match DaysToGoConfig; ids never change once shipped. -->\n"]
    for pid, default, typ in PROPS:
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


def hand_ids():
    ids = ["setting_event", "event_new_year", "event_christmas", "event_custom", "setting_name",
           "setting_month", "setting_day", "setting_year", "year_every", "setting_hour", "hour_none",
           "setting_unit", "unit_days", "unit_weeks", "setting_datestyle", "datestyle_auto",
           "datestyle_day", "datestyle_month", "setting_footer", "footer_none", "footer_battery",
           "footer_steps", "setting_accent"]
    ids += [f"month_{m}" for m in range(1, MONTHS + 1)] + [f"accent_{a}" for a in ACCENTS]
    return ids


if __name__ == "__main__":
    if "--ids" in sys.argv:
        print("\n".join(hand_ids()))
        sys.exit(0)
    root = Path(__file__).resolve().parent.parent
    langs = sorted(p.parent.name for p in root.glob("resources-*/strings"))
    targets = [("resources/settings/settings.xml", settings_xml()),
               ("resources/settings/properties.xml", properties_xml()),
               ("resources/strings/generated.xml", generated_strings())]
    targets += [(f"{lang}/strings/generated.xml", generated_strings()) for lang in langs]
    for rel, text in targets:
        path = root / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)
        print("wrote", rel)
