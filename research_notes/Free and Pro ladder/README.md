# Free and Pro ladder: research notes

Behind `reports/Free and Pro ladder.md` (decisions), `reports/Free and Pro ladder execution plan.md`
(work packages). Pulled 2026-09-28 unless line says otherwise.

| File | What it holds |
|---|---|
| `garmin_rules.md` | Garmin's own rules read directly: price tiers, paid-device allow-list, 15% cut, re-review on pricing, review-guideline 4d, what is *not* documented |
| `reach_by_product.md` | Manifest products minus paid allow-list, per project: reach only free listing gets. Method, 33 products |
| `same_face_pairs.md` | What real free/Pro pairs put behind paid tier (GLANCE, GreenBlack), from live store descriptions |
| `revenue_model.md` + `revenue_model.py` | Break-even, scenario arithmetic. Decision rule, not forecast: every input assumption |
| `accent_roster.md` | Accent state in all five faces today, proposed family roster, contrast/64-colour checks |
| `garmin_questions.md` | One email to Connect IQ developer support, plus dashboard checklist |

Evidence grades used throughout: **measured** (read from Garmin page or store API on date shown),
**inferred** (reasoning from measured data), **assumed** (input nobody has data for), **unverified**.

Method notes:

- Garmin developer pages JS-rendered. Plain fetch returns navigation only. Read in browser (Chrome tool), take text from `article`.
- Store API (`apps.garmin.com/api/appsLibraryExternalServices/api/asw/apps/<id>?countryCode=US`) needs no browser.
  Descriptions under `appLocalizations[].description`, not top-level field.
- Simulator, desk numbers not device proof. Nothing here has run on a wrist.