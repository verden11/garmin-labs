#!/usr/bin/env python3
"""Every resources-<lang>/strings/strings.xml must have exactly English's ids and placeholders, and the
sentences that have no shorter wording must stay short (they sit low on the round screen).
Run from the project root: python3 tools/check_strings.py

AppName is the one string that differs by tier (docs/decisions.md ADR-020 (Free + Pro ladder)): it must live ONLY in
resources-free/strings and resources-pro/strings, never in resources/ or a resources-<lang>/ (a language that defined it
would override the tier's name on a non-English watch), both jungles must append the tier folder to every
base.lang.<l> path (a language does not inherit the default's strings), both manifests must list the same languages,
and no "Pro" may appear in any string the Free build ships."""
import glob
import re
import sys

PAIR = re.compile(r'<string id="([^"]+)">(.*?)</string>', re.S)
base = dict(PAIR.findall(open("resources/strings/strings.xml").read()))
# Sentences with a single wording (no shorter fallback): keep them under this many characters.
SINGLE_WORDING = ("sky_no_place", "sky_no_data", "sky_sun_up", "sky_midnight_sun_min", "sky_polar_night_min")
SINGLE_LIMIT = 14
# The three wordings of one sentence must not get longer: (full, shorter, shortest).
LADDERS = (("sky_midnight_sun", "sky_midnight_sun_short", "sky_midnight_sun_min"),
           ("sky_polar_night", "sky_polar_night_short", "sky_polar_night_min"),
           ("sky_sunrise", "sky_sunrise_short"), ("sky_sunrise_estimate", "sky_sunrise_estimate_short"), ("sky_sunset", "sky_sunset_short"),
           ("sky_daylight_left", "sky_daylight_left_short"), ("sky_no_sunrise", "sky_no_sunrise_short"))
# The last-resort wording of each sentence, with a time in it, must fit a narrow row (characters, a proxy:
# the pixel fit is tools/fit_languages.sh).
LAST_RESORT = ("sky_sunrise_short", "sky_sunrise_estimate_short", "sky_sunset_short", "sky_daylight_left_short", "sky_no_sunrise_short",
               "sky_midnight_sun_min", "sky_polar_night_min", "sky_no_place", "sky_no_data", "sky_sun_up")
LAST_RESORT_LIMIT = 16
bad = 0
TIERS = {"free": "resources-free/strings/strings.xml", "pro": "resources-pro/strings/strings.xml"}
JUNGLES = {"free": "monkey.free.jungle", "pro": "monkey.jungle"}
MANIFESTS = {"free": "manifest.free.xml", "pro": "manifest.xml"}
LANGUAGE_FILES = [p for p in sorted(glob.glob("resources-*/strings/strings.xml")) if p not in TIERS.values()]
if "AppName" in base:
    print("resources/strings/strings.xml defines AppName: it belongs in the tier folders only"); bad += 1
names = {tier: dict(PAIR.findall(open(path).read())).get("AppName") for tier, path in TIERS.items()}
if names != {"free": "Two Suns", "pro": "Two Suns Pro"}:
    print("AppName must be 'Two Suns' (free) and 'Two Suns Pro' (pro), got", names); bad += 1
folders = {p.split("/")[0][len("resources-"):] for p in LANGUAGE_FILES} | {"eng"}
for tier, manifest in MANIFESTS.items():
    manifest_languages = set(re.findall(r"<iq:language>(\w+)</iq:language>", open(manifest).read()))
    if manifest_languages != folders:
        print(manifest, "languages and resources-<lang> folders differ:", sorted(manifest_languages ^ folders)); bad += 1
    jungle = open(JUNGLES[tier]).read()
    for lang in sorted(folders - {"eng"}):
        if f"base.lang.{lang} = $(base.lang.{lang});resources-{tier}" not in jungle.splitlines():
            print(JUNGLES[tier], f"lacks the line: base.lang.{lang} = $(base.lang.{lang});resources-{tier}"); bad += 1
for path in LANGUAGE_FILES:
    got = dict(PAIR.findall(open(path).read()))
    missing, extra = set(base) - set(got), set(got) - set(base)
    if missing or extra:
        print(path, "missing", sorted(missing), "extra", sorted(extra)); bad += 1
    for key in set(base) & set(got):
        if sorted(re.findall(r"\$\d\$", base[key])) != sorted(re.findall(r"\$\d\$", got[key])):
            print(path, key, "placeholder mismatch"); bad += 1
    if "AppName" in got:
        print(path, "defines AppName: it would override the tier's name on a non-English watch"); bad += 1
    if "Machine-drafted" not in open(path).read():
        print(path, "lacks the machine-drafted note"); bad += 1
    for key in LAST_RESORT:
        text = got.get(key, "").replace("$1$", "18:47")
        if len(text) > LAST_RESORT_LIMIT:
            print(path, key, f"longer than {LAST_RESORT_LIMIT} characters with a time in it:", text); bad += 1
    for key in SINGLE_WORDING:
        if len(got.get(key, "")) > SINGLE_LIMIT:
            print(path, key, f"longer than {SINGLE_LIMIT} characters:", got[key]); bad += 1
    for ladder in LADDERS:
        lengths = [len(got.get(k, "")) for k in ladder]
        if lengths != sorted(lengths, reverse=True):
            print(path, "wordings get longer:", [got.get(k) for k in ladder]); bad += 1
# The shared strings ship in the Free build too: the word "Pro" must not appear in any of them.
for path in ["resources/strings/strings.xml"] + LANGUAGE_FILES + [TIERS["free"]]:
    if re.search(r"\bPro\b", re.sub(r"<!--.*?-->", "", open(path).read(), flags=re.S)):
        print(path, 'contains the word "Pro" (the Free build ships it)'); bad += 1
print("strings OK" if not bad else f"{bad} problem(s)")
sys.exit(1 if bad else 0)
