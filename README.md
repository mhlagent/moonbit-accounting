# moonbit-accounting

Deterministic financial reporting for MoonBit applications. The library turns
normalized debit/credit entries into reusable financial statements without
owning a ledger, database, importer, or network service.

## Core capabilities

- Integer minor-unit amounts with explicit account mappings.
- Balance sheet, income statement, cash-flow, management, comparison, and
  dimensional reports.
- Batch and period validation, budget variance, consolidation, safe ratios,
  trends, anomaly detection, tax summaries, receivables aging, and
  multi-currency scaling.
- Deterministic CSV, JSON, Markdown, HTML, and CLI-friendly summaries.
- A curated standard account directory for import applications.
- CSV entry import, journal validation, trial balances, cash reconciliation,
  transparent forecasts, and report packs.

## Quick start

```moonbit
let mappings = [
  @moonbit_accounting.AccountMapping::new("cash", "Cash", @moonbit_accounting.BalanceSheet),
  @moonbit_accounting.AccountMapping::new("sales", "Revenue", @moonbit_accounting.IncomeStatement),
]
let entries = [
  @moonbit_accounting.Entry::new("cash", "2026-Q2", 12000, 0, cash=true),
  @moonbit_accounting.Entry::new("sales", "2026-Q2", 0, 12000),
]
let report = @moonbit_accounting.generate(@moonbit_accounting.IncomeStatement, "2026-Q2", entries, mappings)
println(report.to_markdown())
```

```bash
moon check --target all --deny-warn
moon test --target all
moon run cmd/main
```

## CLI

`moon run cmd/main` generates a deterministic sample statement and benchmark
summary using the public library API. Applications can embed the package and
choose their own input format, persistence, rounding, and authorization.

## Architecture

The root package owns public domain types. Validation, periods, aggregation,
dimensions, cash flow, consolidation, analysis, account catalogues, and
renderers are separated into focused MoonBit files. The CLI is only an adapter.

## Benchmark

The deterministic fixture reports input size, mapping count, output line count,
total, and measured runtime. Run `moon run cmd/main` for fresh output. The
recorded run is documented in [docs/benchmark.md](docs/benchmark.md).

## Testing and CI

Tests cover malformed periods, unbalanced batches, duplicate mappings,
comparisons, dimensions, ratios, budgets, consolidation, renderers, catalog
lookups, and deterministic fixtures. GitHub Actions checks formatting, strict
type checking, all targets, native tests, coverage, and generated interfaces
on Ubuntu, macOS, and Windows.

## License

Apache-2.0. See [LICENSE](LICENSE).
