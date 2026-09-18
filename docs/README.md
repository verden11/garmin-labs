# HeroSet documentation

## New to the project? Read in this order

1. [`../README.md`](../README.md): what HeroSet is, status, how build.
2. [`go-to-market.md`](go-to-market.md) → **Status checkpoint**: where work
   stands, what blocked. Read first when resuming.
3. [`architecture.md`](architecture.md): code structure, layers, navigation,
   known debt.
4. [`decisions.md`](decisions.md): why things this way (ADRs).
   Start with five at top.
5. [`development.md`](development.md): build, test, debug on real watch.

## By topic

| Doc | What it covers | Kind |
|---|---|---|
| [`architecture.md`](architecture.md) | File structure, layers, modules, data flow, style, navigation, debt | Living |
| [`decisions.md`](decisions.md) | Every durable decision (ADR-001…) with status | Append-only log |
| [`input-and-ux.md`](input-and-ux.md) | What each screen show, what every button do | Living |
| [`development.md`](development.md) | Setup, commands, device crash logs, on-watch test procedures | Living |
| [`testing-plan.md`](testing-plan.md) | What tested where (unit / simulator / device) | Living |
| [`go-to-market.md`](go-to-market.md) | Status checkpoint, launch decisions, ordered path to publish, launch gates, listing | Status-dated |
| [`launch-checklist.md`](launch-checklist.md) | Tick-box steps: watch session, then before-upload chores | Status-dated |
| [`release-contract.md`](release-contract.md) | What current build may honestly claim (check before any user-facing copy) | Status-dated |
| [`store-release.md`](store-release.md) | Store economics, upload-form answers | Reference |
| [`validation-log.md`](validation-log.md) | Physical accuracy trial template, results | Data |
| [`calories-connect.md`](calories-connect.md) | How HR/calories read, their limits | Status-dated |
| [`compatibility.md`](compatibility.md) | Supported watches, why others not yet, how add one | Status-dated |
| [`../site/`](../site/) | Public privacy policy, support page (hosted separately) | Public copy |

## Keeping docs useful

- Change behavior → update doc that describe it, same change.
- New durable decision → new ADR at end of `decisions.md`.
- Status-dated docs carry `Status` date line; bump when edit.
- One fact, one home: link, no copy (e.g. launch blockers live only
  in go-to-market status checkpoint).