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

## Lightweight Checklist
- Variable naming follows scalar/table-array convention.
- Queue-mode GUI updates use `cabbageSet`/`cabbageSetValue` with proper triggers.
- `changed(...)` calls use `=` assignment.
- File compiles cleanly (no parser/perf errors).
