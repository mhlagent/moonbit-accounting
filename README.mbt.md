# moonbit-accounting

`moonbit-accounting` is a dependency-free MoonBit reporting layer. It turns
normalized debit/credit entries into balance sheet, income statement, cash
flow, or management reports. The library intentionally owns reporting rather
than bookkeeping, so it can be used with any ledger or import pipeline.

```mbt check
///|
test "readme example" {
  let mappings = [AccountMapping::new("sales", "Revenue", IncomeStatement)]
  let entries = [Entry::new("sales", "2026-Q2", 0, 1200)]
  let report = generate(IncomeStatement, "2026-Q2", entries, mappings)
  assert_eq(report.total, 1200)
}
```

The public API uses integer minor units, explicit account mappings, a period
selector, optional comparison periods, and deterministic CSV/JSON/Markdown
renderers. This keeps rounding policy outside the reporting layer and makes
the result suitable for tests and downstream exports.

## Development

```bash
moon check --target all
moon test --target all
moon fmt --deny-warn
moon info --deny-warn
moon run cmd/main
```

Planned extensions include consolidation and eliminations, dimensions,
Markdown/HTML reports, and XBRL export. See [申报书](docs/proposal.md).

