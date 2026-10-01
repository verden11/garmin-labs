# Free and Pro ladder: research notes

Behind `reports/Free and Pro ladder.md` (decisions) and `reports/Free and Pro ladder execution plan.md`
(work packages). Pulled 2026-09-28 unless a line says otherwise.

| File | What it holds |
|---|---|
| `garmin_rules.md` | Garmin's own rules read directly: price tiers, the paid-device allow-list, 15% cut, re-review on pricing, review-guideline 4d, what is *not* documented |
| `reach_by_product.md` | Manifest products minus the paid allow-list, per project: the reach only a free listing gets. Method and the 33 products |
| `same_face_pairs.md` | What real free/Pro pairs put behind the paid tier (GLANCE, GreenBlack), taken from their live store descriptions |
| `revenue_model.md` + `revenue_model.py` | Break-even and scenario arithmetic. A decision rule, not a forecast: every input is an assumption |
| `accent_roster.md` | Accent state in all five faces today, the proposed family roster, and its contrast/64-colour checks |
| `garmin_questions.md` | One email to Connect IQ developer support, plus a dashboard checklist |

Evidence grades used throughout: **measured** (read from a Garmin page or the store API on the date shown),
**inferred** (reasoning from measured data), **assumed** (an input nobody has data for), **unverified**.

Method notes worth knowing:

- Garmin's developer pages are JS-rendered. Plain fetch returns navigation only. Read them in a browser (Chrome tool) and take text from `article`.
- The store API (`apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/<id>?countryCode=US`) needs no browser.
  Descriptions are under `appLocalizations[].description`, not a top-level field.
- Simulator and desk numbers are not device proof. Nothing here has run on a wrist.
