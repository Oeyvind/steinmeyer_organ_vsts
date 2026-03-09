# Csound Programming Notes

Purpose: Keep short, general coding conventions for Csound/Cabbage work in this repo.

## Core Conventions
- Scalars: use `snake_case` (example: `k_step_changed`).
- Tables/arrays: use `camelCase` (example: `kThis_step[]`, `giProgTables`).
- Prefer clear, consistent naming over abbreviations when possible.

## GUI Update Rule (Queue Mode)
- In `guiMode("queue")`, use `cabbageSet` or `cabbageSetValue` for GUI/widget updates.
- Use trigger-based (k-rate) updates when changing properties like `visible`, `text`, `active`, or `value`.

## Common Syntax Reminder
- Use assignment when storing `changed(...)` output.
- Correct:

```csound
ktrig = changed(kval)
```

- Incorrect:

```csound
ktrig changed(kval)
```

## Channel Read Rate Rule (`chnget`)
- A control channel defined/updated at `k`-rate can still be read safely at `i`-rate with `chnget`.
- Do not assume an `i`-rate read is invalid just because the same channel is also read at `k`-rate elsewhere.
- Prefer `i`-rate reads for one-shot instrument initialization and `k`-rate reads for continuously polled logic.

## Instrument Stop Rule (Negative Instrument Number)
- Using a negative instrument number in an `event` call (for example `event "i", -50, ...`) only turns off running instances that were started with indefinite duration (`p3 = -1`).
- If an instrument was started with a finite duration, do not rely on negative instrument events for lifecycle control.

## Table Lookup Rate Rule
- If the table number/index source is `k`-rate (dynamic at control-rate), use `tablekt` instead of `table`.
- Use `table` only when table selection is `i`-rate/static.
- Example fix: replace `kval table kndx, k_table_id` with `kval tablekt kndx, k_table_id` when `k_table_id` can change at `k`-rate.

## Lightweight Checklist
- Variable naming follows scalar/table-array convention.
- Queue-mode GUI updates use `cabbageSet`/`cabbageSetValue` with proper triggers.
- `changed(...)` calls use `=` assignment.
- `tablekt` is used when table selection is `k`-rate.
- File compiles cleanly (no parser/perf errors).
