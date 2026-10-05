#!/usr/bin/env python3
"""Generate the settings resources the phone app shows.

Writes, relative to the project root, for each tier asked for (free, pro; default both):
  resources-<tier>/settings/settings.xml     what Garmin Connect / Express render
  resources-<tier>/settings/properties.xml   defaults (keys never change once shipped)

Tiers (docs/decisions.md ADR-020 (Free + Pro ladder)): Pro has all seven settings. Free has Accent only (ids 0-5): Orientation,
Golden, Curve, Date, Weather and Battery are Pro-only. There is NO settings file in the shared resources/: two files would overlap.

Everything users read as words (titles, list entries) lives in the hand-maintained
resources*/strings/strings.xml; `--ids` prints the ids it must define. Lists, not
`date`/`numeric`, on purpose: docs/spec.md D11 (Days To Go ADR-003).

Run:  python3 tools/gen_settings.py            # write both tiers
      python3 tools/gen_settings.py free       # write one tier (free | pro)
      python3 tools/gen_settings.py --check    # exit 1 if either tier's files differ from what the tables generate,
                                               # a property id has no KEY_* constant in TwoSunsConfig.mc, or
                                               # resources/settings exists
      python3 tools/gen_settings.py --ids      # list ids you must define by hand (Pro's; "free --ids" for Free's)
"""
import sys
from pathlib import Path

ACCENTS = ["sky", "mint", "autumn", "violet", "pink", "winter"]   # TwoSunsPalette.ACCENTS order
XSI = ('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
       'xsi:noNamespaceSchemaLocation="https://developer.garmin.com/downloads/connect-iq/resources.xsd"')

TIERS = ("free", "pro")
PRO_ONLY_KEYS = ("Orientation", "Golden", "Curve", "Date", "Weather", "Battery")

# (property id, title id, default, [(value, string id)]). Keep in step with TwoSunsConfig (KEY_*, ACCENT_COUNT, ON/OFF).
# Accent ids are append-only. 0-5 are shipped and are the Free list too; ids 6-11 (cyan, lime, yellow, magenta; orange and coral
# are not admitted here) are deferred, and when they land they are Pro-only (research_notes/Free and Pro ladder/accent_roster.md).
SETTINGS = [
    ("Accent", "setting_accent", 0, [(i, f"accent_{a}") for i, a in enumerate(ACCENTS)]),
    ("Orientation", "setting_orientation", 0, [(0, "orientation_noon"), (1, "orientation_midnight")]),
    ("Golden", "setting_golden", 0, [(0, "off"), (1, "on")]),
    ("Curve", "setting_curve", 1, [(0, "off"), (1, "on")]),
    ("Date", "setting_date", 1, [(0, "off"), (1, "on")]),
    ("Weather", "setting_weather", 0, [(0, "off"), (1, "on")]),
    ("Battery", "setting_battery", 0, [(0, "off"), (1, "on")]),
]


def tier_settings(tier):
    return [s for s in SETTINGS if tier == "pro" or s[0] not in PRO_ONLY_KEYS]


# The settings files, in the order the phone shows them (the compiler merges the files in resourcePath order). Accent and
# Golden are each their own folder so the Instinct products, whose 1-bit display can show neither, leave them out of their
# resourcePath (docs/decisions.md ADR-024); the pieces between keep the shipped order.
GROUPS = {
    "pro": [("resources-accent-pro", ["Accent"]), ("resources-pro", ["Orientation"]), ("resources-golden-pro", ["Golden"]),
            ("resources-pro-tail", ["Curve", "Date", "Weather", "Battery"])],
    "free": [("resources-accent-free", ["Accent"])],
}


def settings_xml(tier, keys):
    out = [f"<settings {XSI}>\n\n"]
    for prop, title, _default, entries in [s for s in tier_settings(tier) if s[0] in keys]:
        body = "\n            ".join(f'<listEntry value="{v}">@Strings.{s}</listEntry>' for v, s in entries)
        out.append(f'    <setting propertyKey="@Properties.{prop}" title="@Strings.{title}">\n'
                   f'        <settingConfig type="list">\n            {body}\n        </settingConfig>\n    </setting>\n')
    out.append("</settings>\n")
    return "".join(out)


def properties_xml(tier):
    lines = [f"<properties {XSI}>\n",
             "    <!-- Values match TwoSunsConfig; ids never change once shipped. -->\n"]
    for prop, _title, default, _entries in tier_settings(tier):
        lines.append(f'    <property id="{prop}" type="number">{default}</property>\n')
    lines.append("</properties>\n")
    return "".join(lines)


def hand_ids(tier="pro"):
    ids = []
    for _prop, title, _default, entries in tier_settings(tier):
        ids.append(title)
        ids += [s for _v, s in entries]
    return list(dict.fromkeys(ids))


def tier_files(tier):
    files = [(f"{folder}/settings/settings.xml", settings_xml(tier, keys)) for folder, keys in GROUPS[tier]]
    return tuple(files) + ((f"resources-{tier}/settings/properties.xml", properties_xml(tier)),)


def check(root):
    """The generated files match the tables for both tiers, no settings file sits in the shared resources/,
    and every property id is a KEY_* constant (so a rename cannot drift)."""
    bad = 0
    if (root / "resources" / "settings").exists():
        print("resources/settings exists: settings live in resources-free/ and resources-pro/ only"); bad += 1
    for tier in TIERS:
        for rel, text in tier_files(tier):
            if not (root / rel).exists() or (root / rel).read_text() != text:
                print(rel, "differs from the generated text"); bad += 1
        if tier == "free" and (root / "resources-free" / "settings" / "settings.xml").exists():
            print("resources-free/settings/settings.xml must not exist: Free's one setting is in resources-accent-free"); bad += 1
    config = (root / "source" / "TwoSunsConfig.mc").read_text()
    for prop, _title, _default, _entries in SETTINGS:
        if f'= "{prop}";' not in config:
            print("TwoSunsConfig.mc has no key constant for", prop); bad += 1
    menu = (root / "source" / "settings" / "TwoSunsSettingsMenu.mc").read_text()
    for prop, _title, _default, _entries in SETTINGS:
        if f"ITEM_{prop.upper()} = :" not in menu:
            print("TwoSunsSettingsMenu.mc has no ITEM_ for", prop, "(the on-watch Customize screen would lack it)"); bad += 1
    strings = (root / "resources" / "strings" / "strings.xml").read_text()
    for sid in hand_ids("pro"):
        if f'<string id="{sid}">' not in strings:
            print("strings.xml lacks", sid); bad += 1
    print("settings OK" if not bad else f"{bad} problem(s)")
    return bad


if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    tiers = args or list(TIERS)
    if any(t not in TIERS for t in tiers):
        sys.exit("usage: gen_settings.py [free|pro ...] [--check|--ids]")
    if "--ids" in sys.argv:
        print("\n".join(hand_ids(tiers[0] if args else "pro")))
        sys.exit(0)
    root = Path(__file__).resolve().parent.parent
    if "--check" in sys.argv:
        sys.exit(1 if check(root) else 0)
    if (root / "resources" / "settings").exists():
        sys.exit("resources/settings must not exist: settings live in resources-free/ and resources-pro/ only")
    for tier in tiers:
        for rel, text in tier_files(tier):
            path = root / rel
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text)
            print("wrote", rel)
