///|
test "generates a balanced statement from mapped entries" {
  let mappings = [
    AccountMapping::new("cash", "Cash", BalanceSheet),
    AccountMapping::new("sales", "Revenue", IncomeStatement),
    AccountMapping::new("rent", "Operating expense", IncomeStatement),
  ]
  let entries = [
    Entry::new("cash", "2026-Q2", 1000, 0, cash=true),
    Entry::new("sales", "2026-Q2", 0, 2500),
    Entry::new("rent", "2026-Q2", 800, 0),
  ]
  let income = generate(IncomeStatement, "2026-Q2", entries, mappings)
  assert_eq(income.line("Revenue"), Some(2500))
  assert_eq(income.line("Operating expense"), Some(-800))
  assert_eq(income.total, 1700)
  assert_true(income.to_csv().contains("Revenue"))
  assert_true(income.to_json().contains("\"total\":1700"))
}

///|
test "supports signed mapping factors and comparison periods" {
  let mappings = [AccountMapping::new("tax", "Tax", IncomeStatement, factor=-1)]
  let entries = [
    Entry::new("tax", "2026-Q1", 100, 0),
    Entry::new("tax", "2026-Q2", 120, 0),
  ]
  let report = generate(
    IncomeStatement,
    "2026-Q2",
    entries,
    mappings,
    comparison="2026-Q1",
  )
  assert_eq(report.line("Tax"), Some(220))
  assert_eq(report.lines[0].entries, 2)
}
