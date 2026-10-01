#!/usr/bin/env python3
"""Every resources-<lang>/strings/strings.xml must have exactly English's ids and
placeholders. Run from the project root: python3 tools/check_strings.py

AppName is the one string that differs by tier (docs/decisions.md ADR-001, the Free + Pro ladder): it must live ONLY in
resources-free/strings and resources-pro/strings, never in resources/ or a resources-<lang>/ (a language that defined it
would override the tier's name on a non-English watch), and no "Pro" may appear in the Free build's strings. Each jungle
must also add its tier folder to every language's search path (base.lang.<l>): a language does not inherit the default
folder's strings, so without that line AppName is undefined for that language."""
import glob
import re
import sys

PAIR = re.compile(r'<string id="([^"]+)">(.*?)</string>', re.S)
base = dict(PAIR.findall(open("resources/strings/strings.xml").read()))
bad = 0
FREE, PRO = "resources-free/strings/strings.xml", "resources-pro/strings/strings.xml"
TIERS = (FREE, PRO)
if "AppName" in base:
    print("resources/strings/strings.xml defines AppName: it belongs in the tier folders only"); bad += 1
names = {t: dict(PAIR.findall(open(t).read())).get("AppName") for t in TIERS}
if names[FREE] != "HeroFace" or names[PRO] != "HeroFace Pro":
    print("AppName must be 'HeroFace' (free) and 'HeroFace Pro' (pro, placeholders until the owner names them), got", names); bad += 1
langs = []
for path in sorted(glob.glob("resources-*/strings/strings.xml")):
    if path in TIERS:
        continue
    langs.append(path.split("/")[0][len("resources-"):])
    got = dict(PAIR.findall(open(path).read()))
    missing, extra = set(base) - set(got), set(got) - set(base)
    if missing or extra:
        print(path, "missing", sorted(missing), "extra", sorted(extra)); bad += 1
    for key in set(base) & set(got):
        if sorted(re.findall(r"\$\d\$", base[key])) != sorted(re.findall(r"\$\d\$", got[key])):
            print(path, key, "placeholder mismatch"); bad += 1
# The shared strings ship in the Free build too: the word "Pro" must not appear in any of them.
shared = [p for p in glob.glob("resources-*/strings/strings.xml") if p != PRO]
for path in ["resources/strings/strings.xml"] + sorted(shared):
    if re.search(r"\bPro\b", re.sub(r"<!--.*?-->", "", open(path).read(), flags=re.S)):
        print(path, 'contains the word "Pro" (the Free build ships it)'); bad += 1
# Every language searches its tier folder, in each jungle.
for jungle, tier in (("monkey.jungle", "resources-pro"), ("monkey.free.jungle", "resources-free")):
    text = open(jungle).read()
    for lang in langs:
        if not re.search(rf"^base\.lang\.{lang} = \$\(base\.lang\.{lang}\);{tier}$", text, re.M):
            print(jungle, f"base.lang.{lang} must be '$(base.lang.{lang});{tier}'"); bad += 1
if glob.glob("resources/settings/*"):
    print("resources/settings must be empty: settings live in resources-free/ and resources-pro/ only"); bad += 1
print("strings OK" if not bad else f"{bad} problem(s)")
sys.exit(1 if bad else 0)
