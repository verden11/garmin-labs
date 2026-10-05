#!/usr/bin/env python3
"""Daily read of our public Connect IQ store listings (WP9, ROADMAP 6.2).

Reads only the public store API, no login, no key, no browser:
  GET https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/<id>?countryCode=US
and appends one CSV row per listing per day to research_notes/Free and Pro ladder/poll.csv.

  tools/store_poll.py                      poll every id in tools/store_poll_ids.txt
  tools/store_poll.py ID [ID ...]          poll these store ids instead
  tools/store_poll.py --fixture DIR        offline: read DIR/<id>.json instead of the network
  tools/store_poll.py --selftest           offline self-check against tools/fixtures/ (no network, no CSV)

Ids are the STORE ids (the last part of the listing URL), not the manifest app ids.
A listing already polled today is skipped, so running twice a day adds nothing.
downloadCount is a bucket (1, 10, 100, 1000, 10k, ...), never an exact count; do not turn it into revenue.
price is what the store returns for countryCode=US: euros so far ("2.49 EUR"); 0 for a free listing.

Rank columns (ROADMAP 15.7): the listing's 1-based place in the store's mostPopular list for one
device, all app types mixed (the list the store shows per device), read through
  GET .../asw/apps?startPageIndex=<n>&pageSize=30&sortType=mostPopular&countryCode=US&partNumber=<part>
paged 30 at a time until every wanted listing is found, the list ends, or MAX_PAGES. Instinct 3 Solar
45 mm for every listing, Instinct 2 for free listings only (the paid apps are not sold there).
Blank = not checked (paid on Instinct 2, or the listing does not support the device);
"none" = checked, not in the list (both lists ended at 120 places on 2026-10-05; MAX_PAGES caps at 300).
"""
import csv
import datetime
import json
import os
import sys
import time
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
IDS = os.path.join(HERE, "store_poll_ids.txt")
CSV_PATH = os.path.join(ROOT, "research_notes", "Free and Pro ladder", "poll.csv")
URL = "https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/{}?countryCode=US"
LIST_URL = ("https://apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps"
            "?startPageIndex={}&pageSize={}&sortType=mostPopular&countryCode=US&partNumber={}")
# (part number, CSV column, free listings only)
RANK_DEVICES = [("006-B4585-00", "rankInstinct3Solar45", False),
                ("006-B3888-00", "rankInstinct2", True)]
HEADER = ["date", "id", "downloadCount", "reviewCount", "averageRating",
          "compatibleDeviceTypeIds", "latestExternalVersion", "price"] + [c for _, c, _ in RANK_DEVICES]
PAGE_SIZE = 30  # the API answers 400 to pageSize=100
MAX_PAGES = 10
PAUSE_S = 3  # between requests: we read a handful of pages, never a crawl


def fetch(app_id, url=URL):
    req = urllib.request.Request(url.format(app_id), headers={"User-Agent": "verden-store-poll/1 (hello@verden.watch)"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.load(r)


def ranks(pages, wanted):
    """{id: 1-based first place} for the wanted ids found in pages (lists of store items), in order."""
    found, place = {}, 0
    for page in pages:
        for item in page:
            place += 1
            if item.get("id") in wanted and item["id"] not in found:
                found[item["id"]] = place
        if set(wanted) <= set(found):
            break
    return found


def list_pages(part):
    """Yields mostPopular pages for one device until a short page or MAX_PAGES; ranks() stops early."""
    for n in range(MAX_PAGES):
        time.sleep(PAUSE_S)
        page = fetch(None, LIST_URL.format(n * PAGE_SIZE, PAGE_SIZE, part))
        yield page
        if len(page) < PAGE_SIZE:
            return


def rank_cells(docs, pages_for=list_pages):
    """One rank cell per RANK_DEVICES entry for each listing doc, keyed by its id."""
    cells = {d["id"]: [] for d in docs}
    for part, _, free_only in RANK_DEVICES:
        wanted = [d["id"] for d in docs
                  if not (free_only and price(d) != "0")
                  and part in d.get("compatibleDevicePartNumbers", [part])]
        found = ranks(pages_for(part), wanted) if wanted else {}
        for d in docs:
            cells[d["id"]].append(found.get(d["id"], "none") if d["id"] in wanted else "")
    return cells


def price(d):
    sale = ((d.get("pricing") or {}).get("salePrice")) or {}
    if not sale.get("price"):
        return "0"
    return "%s %s" % (sale["price"], sale.get("currencyCode", ""))


def row(d, today, app_id):
    """One CSV row from one store response. compatibleDeviceTypeIds is the COUNT of device types."""
    return [today, d.get("id", app_id), d["downloadCount"], d["reviewCount"], d["averageRating"],
            len(d.get("compatibleDeviceTypeIds") or []), d["latestExternalVersion"], price(d)]


def read_ids():
    with open(IDS) as f:
        return [ln.split()[0] for ln in f if ln.strip() and not ln.startswith("#")]


def append(rows, path=CSV_PATH):
    new = not os.path.exists(path)
    seen = set()
    if not new:
        with open(path, newline="") as f:
            lines = f.read().splitlines(True)
        seen = {(r["date"], r["id"]) for r in csv.DictReader(lines)}
        if lines and lines[0].strip() != ",".join(HEADER):  # older file: new columns go on the end
            with open(path, "w", newline="") as f:
                f.writelines([",".join(HEADER) + "\n"] + lines[1:])
    rows = [r for r in rows if (r[0], r[1]) not in seen]
    with open(path, "a", newline="") as f:
        w = csv.writer(f)
        if new:
            w.writerow(HEADER)
        w.writerows(rows)
    return len(rows)


def selftest():
    import tempfile
    d = json.load(open(os.path.join(HERE, "fixtures", "store_poll_heroset.json")))
    r = row(d, "2026-10-04", d["id"])
    assert r == ["2026-10-04", "54bbf625-82af-4715-8af0-f2f16a5d1377", 1, 0, 0, 97, "1.3.0", "2.49 EUR"], r
    assert row({**d, "pricing": None}, "x", "i")[-1] == "0"                 # free listing
    assert row({k: v for k, v in d.items() if k != "id"}, "x", "fallback")[1] == "fallback"
    with tempfile.TemporaryDirectory() as t:
        p = os.path.join(t, "poll.csv")
        assert append([r], p) == 1 and append([r], p) == 0                   # same day twice: one row
        assert append([["2026-10-05"] + r[1:]], p) == 1                      # next day: a second row
        lines = open(p).read().splitlines()
        assert lines[0] == ",".join(HEADER) and len(lines) == 3, lines
        old = os.path.join(t, "old.csv")                                    # 8-column file from 2026-10-04
        open(old, "w").write(",".join(HEADER[:8]) + "\n" + ",".join(map(str, r)) + "\n")
        assert append([r], old) == 0 and append([["2026-10-05"] + r[1:] + [12, ""]], old) == 1
        lines = open(old).read().splitlines()
        assert lines[0] == ",".join(HEADER) and lines[1] == ",".join(map(str, r)) and lines[2].endswith(",12,"), lines
    # rank parsing: 1-based across pages, first place wins, stops once all are found
    page = lambda *ids: [{"id": i} for i in ids]
    assert ranks([page("a", "b"), page("c", "a", "d")], ["c", "x", "d"]) == {"c": 3, "d": 5}
    assert ranks([page("a"), page("b")], ["a"]) == {"a": 1}
    assert ranks([], ["a"]) == {}
    def no_more():
        yield page("a")
        raise AssertionError("paged on after every wanted id was found")
    assert ranks(no_more(), ["a"]) == {"a": 1}
    paid, free = {**d, "id": "p", "compatibleDevicePartNumbers": ["006-B4585-00", "006-B3888-00"]}, {**d, "id": "f", "pricing": None}
    lists = {"006-B4585-00": [page("x", "f")], "006-B3888-00": [page("p", "y")]}
    assert rank_cells([paid, free], lambda part: lists[part]) == {"p": ["none", ""], "f": [2, "none"]}
    assert rank_cells([{**paid, "compatibleDevicePartNumbers": []}], lambda part: lists[part]) == {"p": ["", ""]}
    print("selftest ok")


def main(argv):
    if argv[:1] == ["--selftest"]:
        return selftest()
    fixture = None
    if argv[:1] == ["--fixture"]:
        fixture, argv = argv[1], argv[2:]
    ids = argv or read_ids()
    today = datetime.date.today().isoformat()
    docs, failed = [], 0
    for i, app_id in enumerate(ids):
        try:
            if fixture:
                d = json.load(open(os.path.join(fixture, app_id + ".json")))
            else:
                if i:
                    time.sleep(PAUSE_S)
                d = fetch(app_id)
            docs.append({**d, "id": d.get("id", app_id)})
        except Exception as e:  # one dead listing must not stop the others
            failed += 1
            print("FAILED %s: %s" % (app_id, e), file=sys.stderr)
    cells = {d["id"]: [""] * len(RANK_DEVICES) for d in docs}
    if not fixture:
        try:
            cells = rank_cells(docs)
        except Exception as e:  # ranks are extra: the bucket rows still go in
            failed += 1
            print("FAILED ranks: %s" % e, file=sys.stderr)
    rows = [row(d, today, d["id"]) + cells[d["id"]] for d in docs]
    for r in rows:
        print("  " + ",".join(map(str, r)))
    print("added %d row(s) to %s" % (append(rows), os.path.relpath(CSV_PATH, ROOT)))
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
