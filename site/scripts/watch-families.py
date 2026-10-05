#!/usr/bin/env python3
"""Prints a site `watchFamilies` list from Connect IQ manifests, so a page lists exactly the watches the builds support.

Usage (from the repo root): python3 site/scripts/watch-families.py <manifest.xml> [<manifest.xml> ...]
Several manifests (a Free and a Pro build) are merged. Names come from the SDK's own device files
(~/Library/Application Support/Garmin/ConnectIQ/Devices/<id>/compiler.json, "displayName"), grouped by family.
Paste the output into src/apps/<slug>/facts.ts. The store's device tab stays the final word (a paid app is sold only on
Garmin's paid-app list), which each page says.
"""
import json, os, re, sys

DEVICES = os.path.expanduser("~/Library/Application Support/Garmin/ConnectIQ/Devices")
FAMILIES = ["fēnix", "Forerunner", "epix", "Enduro", "MARQ", "D2", "Descent", "Venu", "vívoactive", "Approach", "Instinct",
            "quatix", "tactix", "Captain Marvel", "First Avenger", "Darth Vader", "Rey"]
LEGACY = {"Captain Marvel", "First Avenger", "Darth Vader", "Rey"}


def name(dev):
    with open(os.path.join(DEVICES, dev, "compiler.json")) as f:
        n = json.load(f).get("displayName", dev)
    return re.sub(r"[®™]", "", n).replace("fenix", "fēnix").replace("vivoactive", "vívoactive").replace("Fenix", "fēnix").strip()


def family_of(n):
    for fam in FAMILIES:   # the name's own first word decides; containment only for the Legacy heroes
        if n.lower().startswith(fam.lower()):
            return fam
    for fam in LEGACY:
        if fam.lower() in n.lower():
            return "Legacy"
    return n.split()[0]


def tidy(rest):
    """'8 47mm / 51mm / tactix 8' -> '8'; '165 Music' -> '165'; '(Gen 2) Athlete / ...' -> 'Gen 2'; one name per model line."""
    rest = rest.split(" / ")[0]
    rest = re.sub(r"\s*-\s*Solar Edition.*|\s*\(no Wi-Fi\)|\s+Music\b|\s*\d+mm\b|\s+MicroLED", "", rest)
    rest = re.sub(r"^\((Gen \d)\).*", r"\1", rest)
    rest = re.sub(r"\((Gen \d)\)", r"(\1)", rest).strip()
    return rest


def main(manifests):
    ids = set()
    for m in manifests:
        ids |= set(re.findall(r'<iq:product id="([^"]+)"', open(m).read()))
    groups = {}
    for dev in sorted(ids):
        n = name(dev)
        fam = family_of(n)
        rest = tidy(n[len(fam):].strip()) if n.lower().startswith(fam.lower()) else tidy(n)
        if fam == "MARQ" and not rest.startswith("Gen"):
            rest = "Gen 1"   # the first MARQ editions are named by edition (Athlete, Aviator...), not by generation
        groups.setdefault(fam, set()).add(rest or fam)
    order = [f for f in ["Forerunner", "fēnix", "epix", "Enduro", "MARQ", "Venu", "vívoactive", "Instinct", "Descent", "D2",
                         "Approach", "Legacy"] if f in groups] + sorted(set(groups) - set(FAMILIES) - {"Legacy"})
    print(f"export const watchCount = {len(ids)}")
    print("export const watchFamilies: [string, string][] = [")
    for fam in order:
        models = sorted(groups[fam], key=lambda s: [int(t) if t.isdigit() else t.lower() for t in re.split(r"(\d+)", s)])
        print(f"  ['{fam}', '{', '.join(models)}'],")
    print("]")


if __name__ == "__main__":
    main(sys.argv[1:])
