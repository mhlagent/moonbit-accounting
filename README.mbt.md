# moonbit-accounting

Deterministic financial reporting for MoonBit applications. It accepts
normalized entries and explicit mappings, then produces stable reports.

```mbt check
///|
test "readme example" {
  let mappings = [AccountMapping::new("sales", "Revenue", IncomeStatement)]
  let entries = [Entry::new("sales", "2026-Q2", 0, 1200)]
  let report = generate(IncomeStatement, "2026-Q2", entries, mappings)
  assert_eq(report.total, 1200)
  assert_eq(report.line("Revenue"), Some(1200))
}
```

Amounts are integer minor units. Reports can be rendered as CSV, JSON,
Markdown, or HTML. Validation, comparison periods, dimensions, budgets,
consolidation, ratios, trends, anomaly detection, and account catalogues are
available from the same dependency-free package.

```bash
moon check --target all --deny-warn
moon test --target all
moon run cmd/main
```

See [README.md](README.md) for architecture, CLI, benchmark, CI, and license
details.
