#!/usr/bin/env python3
"""Every resources-<lang>/strings/strings.xml must have exactly English's ids and
placeholders. Run from the project root: python3 tools/check_strings.py

AppName is the one string that differs by tier (docs/decisions.md ADR-014 (Free + Pro ladder)): it must live ONLY in
resources-free/strings and resources-pro/strings, never in resources/ or a resources-<lang>/ (a language that
defined it would override the tier's name on a non-English watch), and no "Pro" may appear in the Free build's strings."""
import glob
import re
import sys

PAIR = re.compile(r'<string id="([^"]+)">(.*?)</string>', re.S)
base = dict(PAIR.findall(open("resources/strings/strings.xml").read()))
bad = 0
TIERS = ("resources-free/strings/strings.xml", "resources-pro/strings/strings.xml")
if "AppName" in base:
    print("resources/strings/strings.xml defines AppName: it belongs in the tier folders only"); bad += 1
names = {t: dict(PAIR.findall(open(t).read())).get("AppName") for t in TIERS}
if names[TIERS[0]] != "Days To Go" or names[TIERS[1]] != "Days To Go Pro":
    print("AppName must be 'Days To Go' (free) and 'Days To Go Pro' (pro), got", names); bad += 1
for path in sorted(glob.glob("resources-*/strings/strings.xml")):
    if path in TIERS:
        continue
    got = dict(PAIR.findall(open(path).read()))
    missing, extra = set(base) - set(got), set(got) - set(base)
    if missing or extra:
        print(path, "missing", sorted(missing), "extra", sorted(extra)); bad += 1
    for key in set(base) & set(got):
        if sorted(re.findall(r"\$\d\$", base[key])) != sorted(re.findall(r"\$\d\$", got[key])):
            print(path, key, "placeholder mismatch"); bad += 1
    # Captions are one line in a small font; the SET A DATE hero shrinks through the font chain.
    for key, limit in (("cap_since_days", 14), ("cap_since_day", 14), ("cap_invalid", 18), ("cap_days", 8), ("cap_weeks", 10), ("cap_hours", 10)):
        if len(got.get(key, "")) > limit:
            print(path, key, f"longer than {limit} characters:", got[key]); bad += 1
# The shared strings ship in the Free build too: the word "Pro" must not appear in any of them.
shared = [p for p in glob.glob("resources-*/strings/strings.xml") if p != TIERS[1]]
for path in ["resources/strings/strings.xml"] + sorted(shared):
    if re.search(r"\bPro\b", re.sub(r"<!--.*?-->", "", open(path).read(), flags=re.S)):
        print(path, 'contains the word "Pro" (the Free build ships it)'); bad += 1
print("strings OK" if not bad else f"{bad} problem(s)")
sys.exit(1 if bad else 0)
