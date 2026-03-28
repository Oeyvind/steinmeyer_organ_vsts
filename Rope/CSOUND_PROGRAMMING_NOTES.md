# Csound Programming Notes

## OSCsend trigger behavior (`kwhen`)

`OSCsend` is edge/trigger-driven via its `kwhen` argument.

- Do not use a static value like `1` for `kwhen` if you expect send-on-change behavior.
- Use a trigger signal that actually changes, typically from `changed()`.
- This usually lets you call `OSCsend` directly without wrapping it in an `if` block.

Example:

```csound
khex_size_x chnget "hexgrid_size_x"
ktrig_hex_size_x changed khex_size_x
OSCsend ktrig_hex_size_x, "127.0.0.1", 9801, "/hex_size_x", "f", khex_size_x
```

Likewise for layout updates:

```csound
klayout_hex chnget "hexgrid_layout"
ktrig_hex_layout changed klayout_hex
OSCsend ktrig_hex_layout, "127.0.0.1", 9801, "/hex_layout", "f", klayout_hex
```
