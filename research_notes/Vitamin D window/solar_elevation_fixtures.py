#!/usr/bin/env python3
"""Reference solar-elevation fixtures for the Vitamin D sun-window app.

Reference algorithm : NOAA Solar Calculator spreadsheet formulas (Meeus, Astronomical Algorithms),
                      geometric elevation (no refraction) unless stated.
Independent checks  : NASA/JPL Horizons (DE441, topocentric, AIRLESS) and MET Norway sunrise API v3.
Simplified formulas : Spencer 1971 Fourier series, and Cooper declination + EoT approximation.

Usage:  python3 solar_elevation_fixtures.py > tables.md      (needs network for Horizons / MET)
Python 3.9+, stdlib only. Network results are cached in $TMPDIR/solar_cache.
"""
import datetime as dt
import hashlib
import json
import math
import os
import re
import tempfile
import time
import urllib.parse
import urllib.request

R = math.radians
D = math.degrees
CACHE = os.path.join(tempfile.gettempdir(), "solar_cache")
os.makedirs(CACHE, exist_ok=True)

PLACES = {  # name: (lat N+, lon E+, standard offset h, {date: actual offset h in 2026})
    "Vilnius": (54.687, 25.280, 2),
    "London": (51.507, -0.128, 0),
    "Phoenix": (33.448, -112.074, -7),
    "Reykjavik": (64.147, -21.940, 0),
    "Singapore": (1.352, 103.820, 8),
    "Sydney": (-33.868, 151.209, 10),
}
DATES = [dt.date(2026, 1, 15), dt.date(2026, 3, 20), dt.date(2026, 6, 21),
         dt.date(2026, 7, 15), dt.date(2026, 9, 23), dt.date(2026, 12, 21)]
# DST assumption (verified with zoneinfo): actual civil offset on each fixture date, hours from UTC.
# EU DST 2026: Mar 29 - Oct 25. Sydney DST: until Apr 5 2026, from Oct 4 2026. Phoenix/Singapore/Reykjavik: none.
OFFSET = {
    "Vilnius": [2, 2, 3, 3, 3, 2], "London": [0, 0, 1, 1, 1, 0], "Phoenix": [-7] * 6,
    "Reykjavik": [0] * 6, "Singapore": [8] * 6, "Sydney": [11, 11, 10, 10, 10, 11],
}


def off(place, date):
    return OFFSET[place][DATES.index(date)]


# ---------------------------------------------------------------- NOAA algorithm
def jd(date, minutes=0.0):
    """Julian Date of (UTC date 00:00) + minutes."""
    return (date - dt.date(2000, 1, 1)).days + 2451544.5 + minutes / 1440.0


def sun_params(j):
    """NOAA spreadsheet: (declination deg, equation of time minutes)."""
    T = (j - 2451545.0) / 36525.0
    L0 = (280.46646 + T * (36000.76983 + T * 0.0003032)) % 360
    M = 357.52911 + T * (35999.05029 - 0.0001537 * T)
    e = 0.016708634 - T * (0.000042037 + 0.0000001267 * T)
    C = (math.sin(R(M)) * (1.914602 - T * (0.004817 + 0.000014 * T))
         + math.sin(R(2 * M)) * (0.019993 - 0.000101 * T) + math.sin(R(3 * M)) * 0.000289)
    true_long = L0 + C
    omega = 125.04 - 1934.136 * T
    app = true_long - 0.00569 - 0.00478 * math.sin(R(omega))
    mean_obl = 23 + (26 + (21.448 - T * (46.815 + T * (0.00059 - T * 0.001813))) / 60) / 60
    obl = mean_obl + 0.00256 * math.cos(R(omega))
    decl = D(math.asin(math.sin(R(obl)) * math.sin(R(app))))
    y = math.tan(R(obl / 2)) ** 2
    eot = 4 * D(y * math.sin(2 * R(L0)) - 2 * e * math.sin(R(M))
                + 4 * e * y * math.sin(R(M)) * math.cos(2 * R(L0))
                - 0.5 * y * y * math.sin(4 * R(L0)) - 1.25 * e * e * math.sin(2 * R(M)))
    return decl, eot


def elev_from(lat, lon, utc_min_of_day, decl, eot):
    tst = utc_min_of_day + eot + 4 * lon          # true solar time, minutes
    ha = tst / 4 - 180                            # hour angle, deg (cos is periodic, no wrap needed)
    s = (math.sin(R(lat)) * math.sin(R(decl)) + math.cos(R(lat)) * math.cos(R(decl)) * math.cos(R(ha)))
    return 90 - D(math.acos(max(-1, min(1, s))))


def elev_noaa(lat, lon, date, minutes):
    """Geometric elevation (deg). `minutes` = minutes after UTC midnight of `date` (may be <0 or >1440)."""
    j = jd(date, minutes)
    decl, eot = sun_params(j)
    return elev_from(lat, lon, minutes % 1440, decl, eot)


def refraction(el):
    """NOAA spreadsheet atmospheric refraction (deg) for true elevation el (deg)."""
    if el > 85:
        return 0.0
    te = math.tan(R(el))
    if el > 5:
        r = 58.1 / te - 0.07 / te ** 3 + 0.000086 / te ** 5
    elif el > -0.575:
        r = 1735 + el * (-518.2 + el * (103.4 + el * (-12.79 + el * 0.711)))
    else:
        r = -20.774 / te
    return r / 3600


def noon_min(lat, lon, date, w0):
    """Solar transit (HA=0) in minutes after UTC midnight of `date`, shifted into window [w0, w0+1440)."""
    n = 720 - 4 * lon
    for _ in range(5):
        n = 720 - 4 * lon - sun_params(jd(date, n))[1]
    while n < w0:
        n += 1440
    while n >= w0 + 1440:
        n -= 1440
    return n


def day_model(lat, lon, date, offset_h, elev=elev_noaa):
    """Local civil day [00:00, 24:00) at fixed `offset_h`. Returns dict with noon, max, crossings (minutes after UTC midnight of date)."""
    w0 = -offset_h * 60
    n = noon_min(lat, lon, date, w0)
    lo, hi = n - 30, n + 30                       # golden-ish ternary search for true max
    for _ in range(60):
        m1, m2 = lo + (hi - lo) / 3, hi - (hi - lo) / 3
        if elev(lat, lon, date, m1) < elev(lat, lon, date, m2):
            lo = m1
        else:
            hi = m2
    tmax = (lo + hi) / 2
    mx = elev(lat, lon, date, tmax)
    out = {"noon": n, "tmax": tmax, "max": mx}

    def cross(thr):
        if mx < thr:
            return None
        def bis(a, b, rising):
            for _ in range(60):
                m = (a + b) / 2
                if (elev(lat, lon, date, m) >= thr) == rising:
                    b = m
                else:
                    a = m
            return (a + b) / 2
        # rising edge: a below threshold, b above ; setting edge: a above, b below -> mirror
        r = bis(tmax - 720, tmax, True)
        s = bis(tmax + 720, tmax, True)          # search from far side toward the max
        return r, s
    for thr in (45, 30, -0.833):
        out[thr] = cross(thr)
    return out


def fmt_hm(minutes_utc, offset_h, secs=False):
    t = minutes_utc + offset_h * 60
    t %= 1440
    h, m = int(t // 60), t % 60
    return f"{h:02d}:{int(m):02d}" + (f":{int(round((m % 1) * 60)) % 60:02d}" if secs else "")


def first_last_min(c):
    """whole-minute window: first minute with elev >= thr (ceil), last minute (floor) -> (a, b) minutes."""
    return math.ceil(c[0] - 1e-9), math.floor(c[1] + 1e-9)


# ---------------------------------------------------------------- simplified formulas
def _doy(date):
    return date.timetuple().tm_yday


def elev_spencer(lat, lon, date, minutes):
    d = date + dt.timedelta(days=minutes // 1440)
    mod = minutes % 1440
    g = 2 * math.pi / 365 * (_doy(d) - 1 + (mod / 60 - 12) / 24)
    decl = (0.006918 - 0.399912 * math.cos(g) + 0.070257 * math.sin(g) - 0.006758 * math.cos(2 * g)
            + 0.000907 * math.sin(2 * g) - 0.002697 * math.cos(3 * g) + 0.00148 * math.sin(3 * g))
    eot = 229.18 * (0.000075 + 0.001868 * math.cos(g) - 0.032077 * math.sin(g)
                    - 0.014615 * math.cos(2 * g) - 0.040849 * math.sin(2 * g))
    return elev_from(lat, lon, mod, D(decl), eot)


def _cooper(date, minutes, with_eot):
    d = date + dt.timedelta(days=minutes // 1440)
    n = _doy(d) + (minutes % 1440) / 1440
    decl = 23.45 * math.sin(R(360 / 365 * (284 + n)))
    b = R(360 / 364 * (n - 81))
    eot = (9.87 * math.sin(2 * b) - 7.53 * math.cos(b) - 1.5 * math.sin(b)) if with_eot else 0.0
    return decl, eot


def elev_cooper(lat, lon, date, minutes):
    decl, eot = _cooper(date, minutes, True)
    return elev_from(lat, lon, minutes % 1440, decl, eot)


def elev_cooper_noeot(lat, lon, date, minutes):
    decl, eot = _cooper(date, minutes, False)
    return elev_from(lat, lon, minutes % 1440, decl, eot)


SIMPLE = {"Spencer": elev_spencer, "Cooper+EoT": elev_cooper, "Cooper, EoT=0": elev_cooper_noeot}


# ---------------------------------------------------------------- network references
def _get(url, headers=None):
    key = os.path.join(CACHE, hashlib.sha1(url.encode()).hexdigest())
    if os.path.exists(key):
        return open(key).read()
    for attempt in range(4):
        try:
            req = urllib.request.Request(url, headers=headers or {})
            txt = urllib.request.urlopen(req, timeout=60).read().decode()
            open(key, "w").write(txt)
            time.sleep(0.3)
            return txt
        except Exception:
            time.sleep(2 * (attempt + 1))
    raise RuntimeError("fetch failed " + url)


def horizons(lat, lon, start_utc, minutes_span, step="1min"):
    """Topocentric airless elevation from JPL Horizons. Returns {datetime_utc: elev_deg}."""
    stop = start_utc + dt.timedelta(minutes=minutes_span)
    q = {"format": "text", "COMMAND": "10", "OBJ_DATA": "NO", "MAKE_EPHEM": "YES", "EPHEM_TYPE": "OBSERVER",
         "CENTER": "coord@399", "SITE_COORD": f"'{lon},{lat},0'", "QUANTITIES": "4", "ANG_FORMAT": "DEG",
         "APPARENT": "AIRLESS", "START_TIME": start_utc.strftime("%Y-%m-%d %H:%M"),
         "STOP_TIME": stop.strftime("%Y-%m-%d %H:%M"), "STEP_SIZE": step}
    txt = _get("https://ssd.jpl.nasa.gov/api/horizons.api?" + urllib.parse.urlencode(q, quote_via=urllib.parse.quote))
    body = txt.split("$$SOE")[1].split("$$EOE")[0]
    res = {}
    for line in body.strip().splitlines():
        m = re.match(r"\s*(\d{4}-\w{3}-\d\d \d\d:\d\d)\s+(.*)", line)
        t = dt.datetime.strptime(m.group(1), "%Y-%b-%d %H:%M")
        res[t] = float(m.group(2).split()[-1])
    return res


def met_noon(lat, lon, date, offset_h):
    """MET Norway sunrise API v3: (solar noon HH:MM local, disc-centre elevation deg)."""
    sign = "+" if offset_h >= 0 else "-"
    url = (f"https://api.met.no/weatherapi/sunrise/3.0/sun?lat={lat}&lon={lon}&date={date.isoformat()}"
           f"&offset={urllib.parse.quote(sign)}{abs(offset_h):02d}:00")
    j = json.loads(_get(url, {"User-Agent": "verden-research/1.0 justinas.reigis@gmail.com"}))
    p = j["properties"]
    sn = p["solarnoon"]
    return sn["time"][11:16], sn["disc_centre_elevation"], p["sunrise"]["time"][11:16], p["sunset"]["time"][11:16]


def utc_start(date, offset_h):
    return dt.datetime(date.year, date.month, date.day) - dt.timedelta(hours=offset_h)


# ---------------------------------------------------------------- report sections
def hm_or_never(c, offset_h):
    if c is None:
        return "never", ""
    a, b = first_last_min(c)
    return fmt_hm(a, offset_h), fmt_hm(b, offset_h)


def table_summary():
    print("### A. Per place and date: solar noon, maximum elevation, windows, day length (NOAA algorithm, geometric)\n")
    print("Local = UTC + offset shown. `>=45` / `>=30` columns are the first and last WHOLE MINUTE with geometric elevation >= threshold "
          "(first = ceil, last = floor). Day length = time with geometric elevation >= -0.833 deg (standard sunrise/sunset).\n")
    print("| Place | Date (2026) | UTC off | Noon local | Noon UTC | Max elev (deg) | >=45 first | >=45 last | >=30 first | >=30 last | Day length |")
    print("|---|---|---|---|---|---|---|---|---|---|---|")
    for p, (lat, lon, std) in PLACES.items():
        for d in DATES:
            o = off(p, d)
            m = day_model(lat, lon, d, o)
            a45 = hm_or_never(m[45], o)
            a30 = hm_or_never(m[30], o)
            ss = m[-0.833]
            dl = "no sunrise" if ss is None else (lambda x: f"{int(x // 60)}h{int(round(x % 60)):02d}")(ss[1] - ss[0])
            print(f"| {p} | {d.isoformat()} | {o:+d} | {fmt_hm(m['noon'], o, True)} | {fmt_hm(m['noon'], 0, True)} | "
                  f"{m['max']:.3f} | {a45[0]} | {a45[1]} | {a30[0]} | {a30[1]} | {dl} |")
    print()


def table_hourly():
    print("### B. Elevation at local whole hours (NOAA algorithm, geometric, degrees; negative = below horizon)\n")
    print("Each cell is for that place's civil local hour using the offset in the header; UTC = local hour - offset.\n")
    for p, (lat, lon, std) in PLACES.items():
        print(f"**{p}** (lat {lat:+.3f}, lon {lon:+.3f})\n")
        print("| Local hour | " + " | ".join(f"{d.isoformat()} (UTC{off(p, d):+d})" for d in DATES) + " |")
        print("|---|" + "---|" * len(DATES))
        for h in range(4, 23):
            cells = []
            for d in DATES:
                o = off(p, d)
                cells.append(f"{elev_noaa(lat, lon, d, h * 60 - o * 60):.2f}")
            print(f"| {h:02d}:00 | " + " | ".join(cells) + " |")
        print()


def spot_checks():
    print("### C0. Ten named spot checks (elevation in degrees, geometric/airless)\n")
    print("| Place | Date | Local time (UTC off) | UTC | NOAA algorithm | JPL Horizons | NOAA - Horizons | Spencer simplified | Cooper+EoT simplified |")
    print("|---|---|---|---|---|---|---|---|---|")
    pts = [("Vilnius", 5, 12), ("London", 1, 12), ("Phoenix", 5, 12), ("Reykjavik", 3, 12), ("Singapore", 1, 13),
           ("Sydney", 4, 10), ("Vilnius", 4, 9), ("Phoenix", 2, 8), ("Sydney", 5, 17), ("Reykjavik", 2, 21)]
    for p, di, hh in pts:
        lat, lon, std = PLACES[p]
        d = DATES[di]
        o = off(p, d)
        h = horizons(lat, lon, utc_start(d, o), 1440)
        t = dt.datetime(d.year, d.month, d.day, hh) - dt.timedelta(hours=o)
        mins = hh * 60 - o * 60
        n = elev_noaa(lat, lon, d, mins)
        print(f"| {p} | {d.isoformat()} | {hh:02d}:00 ({o:+d}) | {t:%Y-%m-%d %H:%M} | {n:.3f} | {h[t]:.3f} | {n - h[t]:+.4f} | "
              f"{elev_spencer(lat, lon, d, mins):.3f} | {elev_cooper(lat, lon, d, mins):.3f} |")
    print()


def horizons_compare():
    print("### C. Full-day cross-check against JPL Horizons (1-minute samples, local civil day)\n")
    print("For every place/date: 1441 one-minute samples (local 00:00 to 24:00 inclusive) of NOAA-algorithm elevation vs Horizons topocentric airless elevation. "
          "Window columns: first/last whole minute >= threshold from Horizons samples minus the same from NOAA (minutes; 0 = identical).\n")
    print("| Place | Date | max abs dev (deg) | mean dev (deg) | max elev NOAA | max elev Horizons | d>=45 first/last (min) | d>=30 first/last (min) |")
    print("|---|---|---|---|---|---|---|---|")
    worst = 0
    allmean = []
    for p, (lat, lon, std) in PLACES.items():
        for d in DATES:
            o = off(p, d)
            s0 = utc_start(d, o)
            h = horizons(lat, lon, s0, 1440)
            base = dt.datetime(d.year, d.month, d.day)
            devs, hs, ns = [], [], []
            for t, e in h.items():
                mins = (t - base).total_seconds() / 60
                n = elev_noaa(lat, lon, d, mins)
                devs.append(n - e); hs.append((mins, e)); ns.append((mins, n))
            mx = max(abs(x) for x in devs); worst = max(worst, mx)
            allmean.append(sum(devs) / len(devs))
            cells = []
            for thr in (45, 30):
                def fl(ser):
                    ok = [m for m, e in ser if e >= thr]
                    return (min(ok), max(ok)) if ok else None
                a, b = fl(hs), fl(ns)
                cells.append("never/never" if a is None and b is None else
                             "MISMATCH" if (a is None) != (b is None) else f"{a[0] - b[0]:+.0f}/{a[1] - b[1]:+.0f}")
            print(f"| {p} | {d.isoformat()} | {mx:.4f} | {sum(devs) / len(devs):+.4f} | {max(e for _, e in ns):.3f} | "
                  f"{max(e for _, e in hs):.3f} | {cells[0]} | {cells[1]} |")
    print(f"\nWorst single-sample |NOAA - Horizons| over all 36 days x 1441 samples: **{worst:.4f} deg**.\n")


def met_compare():
    print("### D. Solar-noon cross-check against MET Norway (api.met.no sunrise v3), disc-centre elevation\n")
    print("Sunrise/sunset: NOAA = geometric elevation -0.833 deg crossing (rounded to nearest minute); MET = its published sunrise/sunset (minute).\n")
    print("| Place | Date | UTC off | NOAA noon local | MET noon local | NOAA max elev | MET noon elev | dev elev (deg) | sunrise NOAA / MET | sunset NOAA / MET |")
    print("|---|---|---|---|---|---|---|---|---|---|")
    mx = 0
    for p, (lat, lon, std) in PLACES.items():
        for d in DATES:
            o = off(p, d)
            m = day_model(lat, lon, d, o)
            nt, ne, mr, ms = met_noon(lat, lon, d, o)
            dev = m["max"] - ne
            mx = max(mx, abs(dev))
            sr, ss = m[-0.833]
            print(f"| {p} | {d.isoformat()} | {o:+d} | {fmt_hm(m['noon'], o)} | {nt} | {m['max']:.3f} | {ne:.2f} | {dev:+.3f} | "
                  f"{fmt_hm(round(sr), o)} / {mr} | {fmt_hm(round(ss), o)} / {ms} |")
    print(f"\nMax |NOAA - MET| elevation deviation: **{mx:.3f} deg** (MET prints 2 decimals; noon time printed to the minute).\n")


def year_scan():
    print("### E. 2026 scan: days whose maximum elevation >= threshold (NOAA algorithm, every day of 2026)\n")
    print("A day is the civil date at the place's STANDARD offset (Vilnius +2, London 0, Phoenix -7, Reykjavik 0, Singapore +8, Sydney +10); "
          "the daily maximum does not depend on that choice to within 0.001 deg.\n")
    print("| Place | threshold | date ranges with max >= threshold | days | lowest margin inside (deg) | highest max just outside (deg) |")
    print("|---|---|---|---|---|---|")
    boundary = {}
    days = [dt.date(2026, 1, 1) + dt.timedelta(days=i) for i in range(365)]
    series = {}
    for p, (lat, lon, std) in PLACES.items():
        series[p] = {d: day_model(lat, lon, d, std)["max"] for d in days}
        for thr in (45, 30):
            ok = [series[p][d] >= thr for d in days]
            ranges, i = [], 0
            while i < 365:
                if ok[i]:
                    j = i
                    while j + 1 < 365 and ok[j + 1]:
                        j += 1
                    ranges.append((i, j)); i = j + 1
                else:
                    i += 1
            txt = "; ".join(f"{days[a].strftime('%b %d')} - {days[b].strftime('%b %d')}" for a, b in ranges) or "never"
            if len(ranges) == 1 and ranges[0] == (0, 364):
                txt = "all year"
            n = sum(ok)
            ins = [series[p][d] - thr for d, k in zip(days, ok) if k]
            outs = [series[p][d] - thr for d, k in zip(days, ok) if not k]
            # edge margins
            edges = []
            for a, b in ranges:
                for x in (a, b):
                    edges.append(series[p][days[x]] - thr)
            outedge = []
            for a, b in ranges:
                if a > 0: outedge.append(series[p][days[a - 1]] - thr)
                if b < 364: outedge.append(series[p][days[b + 1]] - thr)
            boundary[(p, thr)] = ranges
            print(f"| {p} | {thr} | {txt} | {n} | {min(ins):+.3f} | {max(outs):+.3f} |" if ins and outs
                  else f"| {p} | {thr} | {txt} | {n} | - | - |")
    print()
    print("Edge days (max elevation in deg; NOAA, then JPL Horizons sampled at 1-minute steps within +/-15 min of NOAA noon):\n")
    print("| Place | threshold | edge | date | NOAA max | Horizons max | in/out |")
    print("|---|---|---|---|---|---|---|")
    for (p, thr), ranges in boundary.items():
        lat, lon, std = PLACES[p]
        for a, b in ranges:
            for label, idx, inside in (("first in", a, True), ("day before", a - 1, False), ("last in", b, True), ("day after", b + 1, False)):
                if idx < 0 or idx > 364:
                    continue
                d = days[idx]
                m = day_model(lat, lon, d, std)
                s0 = dt.datetime(d.year, d.month, d.day) + dt.timedelta(minutes=round(m["tmax"]) - 15)
                h = horizons(lat, lon, s0, 30)
                print(f"| {p} | {thr} | {label} | {d.isoformat()} | {m['max']:.4f} | {max(h.values()):.4f} | {'in' if inside else 'out'} |")
    print()
    return series


def tolerance_sensitivity(series):
    print("### H. How far the date ranges move if the elevation is off by +/-0.5 or +/-1.0 deg (NOAA daily maxima, 2026)\n")
    print("Range of dates whose daily max >= (threshold + shift). shift -0.5 = an implementation that reads 0.5 deg too HIGH counts a day as in-window when the true max is 0.5 deg lower.\n")
    print("| Place | thr | shift -1.0 | shift -0.5 | shift 0 | shift +0.5 | shift +1.0 |")
    print("|---|---|---|---|---|---|---|")
    days = [dt.date(2026, 1, 1) + dt.timedelta(days=i) for i in range(365)]
    for p in PLACES:
        for thr in (45, 30):
            cells = []
            for sh in (-1.0, -0.5, 0, 0.5, 1.0):
                ok = [series[p][d] >= thr + sh for d in days]
                ranges, i = [], 0
                while i < 365:
                    if ok[i]:
                        j = i
                        while j + 1 < 365 and ok[j + 1]:
                            j += 1
                        ranges.append((i, j)); i = j + 1
                    else:
                        i += 1
                cells.append("all year" if ranges == [(0, 364)] else "; ".join(f"{days[a].strftime('%b %d')}-{days[b].strftime('%b %d')}" for a, b in ranges) or "never")
            print(f"| {p} | {thr} | " + " | ".join(cells) + " |")
    print()


def simplified_accuracy():
    print("### F. Accuracy of simplified formulas versus the NOAA algorithm (all 6 places, every day of 2026)\n")
    print("Elevation error: every 10 minutes over the whole UTC day, only samples with NOAA elevation >= 10 deg (the region the app cares about). "
          "Max-elevation error: daily max (sampled at NOAA transit). Crossing error: shift of the 45-deg and 30-deg crossing times in minutes (days where both define one).\n")
    print("| Formula | max abs elev err (deg) | RMS elev err (deg) | 99th pct abs (deg) | max abs daily-max err (deg) | max abs 45-deg crossing shift (min) | max abs 30-deg crossing shift (min) | days where >=45 yes/no verdict differs (of 2190) |")
    print("|---|---|---|---|---|---|---|---|")
    days = [dt.date(2026, 1, 1) + dt.timedelta(days=i) for i in range(365)]
    for name, f in SIMPLE.items():
        errs, mxerr = [], []
        sh = {45: 0.0, 30: 0.0}
        flips = 0
        for p, (lat, lon, std) in PLACES.items():
            for d in days:
                n = noon_min(lat, lon, d, -std * 60)
                ref_max = elev_noaa(lat, lon, d, n)
                mxerr.append(abs(f(lat, lon, d, n) - ref_max))
                flips += (max(f(lat, lon, d, n + k) for k in (-2, -1, 0, 1, 2)) >= 45) != (ref_max >= 45)
                for k in range(0, 1440, 10):
                    t = -std * 60 + k
                    e0 = elev_noaa(lat, lon, d, t)
                    if e0 >= 10:
                        errs.append(abs(f(lat, lon, d, t) - e0))
                for thr in (45, 30):
                    if ref_max < thr + 1:
                        continue
                    def cx(fn, rising):
                        a, b = (n - 720, n) if rising else (n + 720, n)
                        for _ in range(40):
                            m = (a + b) / 2
                            if fn(lat, lon, d, m) >= thr:
                                b = m
                            else:
                                a = m
                        return (a + b) / 2
                    if f(lat, lon, d, n) < thr:
                        continue
                    for rising in (True, False):
                        sh[thr] = max(sh[thr], abs(cx(f, rising) - cx(elev_noaa, rising)))
        errs.sort()
        rms = math.sqrt(sum(e * e for e in errs) / len(errs))
        print(f"| {name} | {errs[-1]:.3f} | {rms:.3f} | {errs[int(.99 * len(errs))]:.3f} | {max(mxerr):.3f} | {sh[45]:.1f} | {sh[30]:.1f} | {flips} |")
    print()


def refraction_table():
    print("### G. Refraction (NOAA spreadsheet approximation) and parallax\n")
    print("| True elevation (deg) | refraction added (deg) | (arcmin) |")
    print("|---|---|---|")
    for e in (0, 5, 10, 15, 20, 30, 45, 60, 80):
        r = refraction(e)
        print(f"| {e} | {r:.4f} | {r * 60:.2f} |")
    print("\nSolar parallax: 8.794 arcsec x cos(elevation) = 0.0024 deg at the horizon, 0.0017 deg at 45 deg (negligible).\n")


if __name__ == "__main__":
    # sanity self-check: NOAA elevation must match Horizons within 0.02 deg at one point (Vilnius, 2026-06-21 09:00 UTC)
    h = horizons(54.687, 25.28, dt.datetime(2026, 6, 21, 9, 0), 1)
    assert abs(elev_noaa(54.687, 25.28, dt.date(2026, 6, 21), 540) - list(h.values())[0]) < 0.02
    table_summary()
    table_hourly()
    spot_checks()
    horizons_compare()
    met_compare()
    tolerance_sensitivity(year_scan())
    simplified_accuracy()
    refraction_table()
