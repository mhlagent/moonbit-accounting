///|
fn main {
  let mappings = [
    @moonbit_accounting.AccountMapping::new(
      "cash",
      "Cash",
      @moonbit_accounting.BalanceSheet,
    ),
    @moonbit_accounting.AccountMapping::new(
      "sales",
      "Revenue",
      @moonbit_accounting.IncomeStatement,
    ),
  ]
  let entries = [
    @moonbit_accounting.Entry::new("cash", "2026-Q2", 12000, 0, cash=true),
    @moonbit_accounting.Entry::new("sales", "2026-Q2", 0, 12000),
  ]
  let report = @moonbit_accounting.generate(
    @moonbit_accounting.IncomeStatement,
    "2026-Q2",
    entries,
    mappings,
  )
  println(report.to_markdown())
  let benchmark = @moonbit_accounting.run_benchmark(10000)
  println(@moonbit_accounting.benchmark_summary(benchmark))
}
