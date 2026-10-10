# Garmin questions and dashboard checks

Owner sends (never decide/send alone). One email to Connect IQ developer support (find current contact on Garmin's developer pages or dashboard; address not verified in this research). Plain, numbered so reply can be matched.

**2026-10-04: owner will not email Garmin.** Questions 2, 3, 4 (partly), 5, 6 answered from Garmin's published pages + public store API in
`garmin_rules.md` "Re-read 2026-10-04" and `reports/Garmin policies and design guidelines.md`. Still unanswerable from published sources: paid-to-paid repricing, paid-to-free effects, duplicate-listing rules, why 11 products on paid list not offered.

## Email draft (not to be sent)

Subject: Free and paid listings of the same watch face: policy questions

1. Plan: publish free watch face + paid "Pro" version of same design as two separate listings, different app ids,
   each linking other. App Review Guidelines allow this? Any duplicate-listing rule to follow (naming, listing text)?
1b. Pro listing already holds name "Days To Go": may new free listing also use that name (and may we rename paid one to "Days To Go Pro" in same submission)? Any rule on two apps from one developer sharing display name or icon?
2. If we raise price of approved paid app (for example from $2.00 tier to $3.00 tier) in new version submission, is app removed from store and existing buyers asked to repurchase? Or only applies when free app becomes paid?
3. If we ever switch approved paid app to free, do ratings, reviews, download counts stay? (*Not* planning this; decides whether old plan to flip to free stays retired.)
4. Can promotion-code migration (App Sales, "marketing form") give buyers of paid listing another listing free? Which form?
5. Why are Descent Mk2/Mk2S, MARQ Gen 1, D2 Air X10 on App Sales product list but absent from paid listings' compatible devices?
6. Do free listings appear in mobile-app search for all manifest products, including products not on paid-sales list?

## Dashboard checklist (developer.garmin.com dashboard, owner logged in)

- [ ] TwoSuns: which price tier selected? Store page shows $2.25, ADR says $1.99. Correct in next upload.
- [ ] DaysToGo and TwoSuns: exact **approval dates**. Both live (owner, 2026-09-28), dates unknown; they set day-45 review dates that this
      plan retires (see strategy D1). Record in each `CLAUDE.md` and memory.
- [ ] Installs and sales report for each of HeroSet, HeroFace, DaysToGo, TwoSuns: record baseline for day-30/60 readouts.
- [ ] USD-capable payout account set up; merchant-fee renewal date recorded.
- [ ] Dashboard let category and description be edited without binary? (earlier open item)
- [ ] `hasTrialMode` toggle present for watch apps (HeroSet)? Earlier notes: trials require developer's own unlock server; confirm nothing changed.