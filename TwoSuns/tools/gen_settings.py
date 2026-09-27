#!/usr/bin/env python3
"""Generate the settings resources the phone app shows.

Writes, relative to the project root:
  resources/settings/settings.xml     what Garmin Connect / Express render
  resources/settings/properties.xml   defaults (keys never change once shipped)

Everything users read as words (titles, list entries) lives in the hand-maintained
resources*/strings/strings.xml; `--ids` prints the ids it must define. Lists, not
`date`/`numeric`, on purpose: docs/spec.md D11 (Days To Go ADR-003).

Run:  python3 tools/gen_settings.py            # write files
      python3 tools/gen_settings.py --check    # exit 1 if the files differ from what the tables generate,
                                               # or a property id has no KEY_* constant in TwoSunsConfig.mc
      python3 tools/gen_settings.py --ids      # list ids you must define by hand
"""
import sys
from pathlib import Path

ACCENTS = ["sky", "mint", "autumn", "violet", "pink", "winter"]   # TwoSunsPalette.ACCENTS order
XSI = ('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
       'xsi:noNamespaceSchemaLocation="https://developer.garmin.com/downloads/connect-iq/resources.xsd"')

# (property id, title id, default, [(value, string id)]). Keep in step with TwoSunsConfig (KEY_*, ACCENT_COUNT, ON/OFF).
SETTINGS = [
    ("Accent", "setting_accent", 0, [(i, f"accent_{a}") for i, a in enumerate(ACCENTS)]),
    ("Orientation", "setting_orientation", 0, [(0, "orientation_noon"), (1, "orientation_midnight")]),
    ("Golden", "setting_golden", 0, [(0, "off"), (1, "on")]),
    ("Curve", "setting_curve", 1, [(0, "off"), (1, "on")]),
    ("Date", "setting_date", 1, [(0, "off"), (1, "on")]),
]


def settings_xml():
    out = [f"<settings {XSI}>\n\n"]
    for prop, title, _default, entries in SETTINGS:
        body = "\n            ".join(f'<listEntry value="{v}">@Strings.{s}</listEntry>' for v, s in entries)
        out.append(f'    <setting propertyKey="@Properties.{prop}" title="@Strings.{title}">\n'
                   f'        <settingConfig type="list">\n            {body}\n        </settingConfig>\n    </setting>\n')
    out.append("</settings>\n")
    return "".join(out)


def properties_xml():
    lines = [f"<properties {XSI}>\n",
             "    <!-- Values match TwoSunsConfig; ids never change once shipped. -->\n"]
    for prop, _title, default, _entries in SETTINGS:
        lines.append(f'    <property id="{prop}" type="number">{default}</property>\n')
    lines.append("</properties>\n")
    return "".join(lines)


def hand_ids():
    ids = []
    for _prop, title, _default, entries in SETTINGS:
        ids.append(title)
        ids += [s for _v, s in entries]
    return list(dict.fromkeys(ids))


def check(root):
    """The generated files match the tables, and every property id is a KEY_* constant (so a rename cannot drift)."""
    bad = 0
    for rel, text in (("resources/settings/settings.xml", settings_xml()),
                      ("resources/settings/properties.xml", properties_xml())):
        if (root / rel).read_text() != text:
            print(rel, "differs from the generated text"); bad += 1
    config = (root / "source" / "TwoSunsConfig.mc").read_text()
    for prop, _title, _default, _entries in SETTINGS:
        if f'= "{prop}";' not in config:
            print("TwoSunsConfig.mc has no key constant for", prop); bad += 1
    strings = (root / "resources" / "strings" / "strings.xml").read_text()
    for sid in hand_ids():
        if f'<string id="{sid}">' not in strings:
            print("strings.xml lacks", sid); bad += 1
    print("settings OK" if not bad else f"{bad} problem(s)")
    return bad


if __name__ == "__main__":
    if "--ids" in sys.argv:
        print("\n".join(hand_ids()))
        sys.exit(0)
    root = Path(__file__).resolve().parent.parent
    if "--check" in sys.argv:
        sys.exit(1 if check(root) else 0)
    for rel, text in (("resources/settings/settings.xml", settings_xml()),
                      ("resources/settings/properties.xml", properties_xml())):
        path = root / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)
        print("wrote", rel)
