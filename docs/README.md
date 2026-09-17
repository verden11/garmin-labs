# HeroSet documentation

## New to the project? Read in this order

1. [`../README.md`](../README.md): what HeroSet is, current status, how to build.
2. [`go-to-market.md`](go-to-market.md) → **Status checkpoint**: where work
   stands and what's blocked. Read this first when resuming.
3. [`architecture.md`](architecture.md): code structure, layers, navigation,
   known debt.
4. [`decisions.md`](decisions.md): why things are the way they are (ADRs).
   Start with the five listed at the top.
5. [`development.md`](development.md): build, test, and debug on a real watch.

## By topic

| Doc | What it covers | Kind |
|---|---|---|
| [`architecture.md`](architecture.md) | File structure, layers, modules, data flow, style, navigation, debt | Living |
| [`decisions.md`](decisions.md) | Every durable decision (ADR-001…) with status | Append-only log |
| [`input-and-ux.md`](input-and-ux.md) | What each screen shows and every button does | Living |
| [`development.md`](development.md) | Setup, commands, device crash logs, on-watch test procedures | Living |
| [`testing-plan.md`](testing-plan.md) | What is tested where (unit / simulator / device) | Living |
| [`go-to-market.md`](go-to-market.md) | Status checkpoint, launch decisions, ordered path to publish, launch gates, listing | Status-dated |
| [`release-contract.md`](release-contract.md) | What the current build may honestly claim (check before any user-facing copy) | Status-dated |
| [`store-release.md`](store-release.md) | Store economics and upload-form answers | Reference |
| [`validation-log.md`](validation-log.md) | Physical accuracy trial template and results | Data |
| [`calories-connect.md`](calories-connect.md) | How HR/calories are read, and their limits | Status-dated |
| [`compatibility.md`](compatibility.md) | Policy for adding devices beyond FR965 | Policy |

## Keeping docs useful

- Change behavior → update the doc that describes it in the same change.
- New durable decision → new ADR at the end of `decisions.md`.
- Status-dated docs carry a `Status` date line; bump it when you edit them.
- One fact, one home: link instead of copying (e.g. launch blockers live only
  in the go-to-market status checkpoint).
