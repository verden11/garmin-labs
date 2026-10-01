# Garmin questions and dashboard checks

Owner sends (never decide/send alone). One email to Connect IQ developer support (find the current contact on Garmin's developer
pages or the dashboard; the address was not verified in this research). Plain, numbered so the reply can be matched.

## Email draft

Subject: Free and paid listings of the same watch face: policy questions

1. We plan to publish a free watch face and a paid "Pro" version of the same design as two separate listings with different app ids,
   each linking the other. Do the App Review Guidelines allow this? Is there any duplicate-listing rule we should follow (naming, listing text)?
1b. When the Pro listing already holds the name "Days To Go", may a new free listing also use that name (and may we rename the paid one to "Days To Go Pro" in the same submission)? Any rule on two apps from one developer sharing a display name or icon?
2. If we raise the price of an approved paid app (for example from the $2.00 tier to the $3.00 tier) in a new version submission, is the
   app removed from the store and are existing buyers asked to repurchase? Or does that only apply when a free app becomes paid?
3. If we ever switch an approved paid app to free, do ratings, reviews and download counts stay? (We are *not* planning this; it decides whether
   the old plan to flip to free stays retired.)
4. Can the promotion-code migration (App Sales, "marketing form") be used to give buyers of a paid listing another listing free? Which form?
5. Why are Descent Mk2/Mk2S, MARQ Gen 1 and D2 Air X10 on the App Sales product list but absent from paid listings' compatible devices?
6. Do free listings appear in mobile-app search for all manifest products, including products that are not on the paid-sales list?

## Dashboard checklist (developer.garmin.com dashboard, owner logged in)

- [ ] TwoSuns: which price tier is selected? The store page shows $2.25, the ADR says $1.99. Correct in the next upload.
- [ ] DaysToGo and TwoSuns: exact **approval dates**. Both are live (owner, 2026-09-28) but dates are unknown; they set the day-45 review dates that this
      plan retires (see strategy D1). Record in each `CLAUDE.md` and memory.
- [ ] Installs and sales report for each of HeroSet, HeroFace, DaysToGo, TwoSuns: record the baseline for the day-30/60 readouts.
- [ ] USD-capable payout account set up; merchant-fee renewal date recorded.
- [ ] Does the dashboard let category and description be edited without a binary? (earlier open item)
- [ ] `hasTrialMode` toggle present for watch apps (HeroSet)? Earlier notes say trials require the developer's own unlock server; confirm nothing changed.
