# Benchmark record

The benchmark is deterministic in its input and aggregation output. Runtime
depends on the local CPU and MoonBit backend, so the elapsed value below is a
measurement rather than a performance promise.

Command:

```text
moon run cmd/main --target native
```

Observed benchmark line on 2026-08-21:

```text
entries=10000 mappings=10000 lines=16 total=489604 elapsed_ms=220
```

The fixture creates 10,000 normalized entries and mappings, aggregates them
into 16 deterministic report lines, and reports the resulting total. Re-run
the command after toolchain or hardware changes to obtain a new measurement.

Source inventory from the same working tree:

```text
total=12440 production=12267 test_lines=173
```

The inventory counts physical MoonBit source lines using `rg`; generated build
artifacts are excluded because they are not project source.
