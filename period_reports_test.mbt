///|
test "period reports generate totals deltas latest and lowest" {
  let mappings = [
    AccountMapping::new("sales", "Revenue", @moonbit-accounting.IncomeStatement),
  ]
  let entries = [
    Entry::new("sales", "2026-Q1", 0, 100),
    Entry::new("sales", "2026-Q2", 0, 150),
  ]
  let reports = generate_many(
    @moonbit-accounting.IncomeStatement,
    ["2026-Q1", "2026-Q2"],
    entries,
    mappings,
  )
  assert_eq(reports.length(), 2)
  let totals = period_totals(reports)
  assert_eq(totals[0], ("2026-Q1", 100))
  assert_eq(totals[1], ("2026-Q2", 150))
  assert_eq(period_delta(reports), [0, 50])
  assert_eq(latest_report(reports).unwrap().period, "2026-Q2")
  assert_eq(lowest_report(reports).unwrap().period, "2026-Q1")
}

///|
test "empty period report helpers" {
  let reports : Array[Report] = []
  assert_eq(period_totals(reports).length(), 0)
  assert_eq(period_delta(reports).length(), 0)
  assert_true(latest_report(reports) is None)
  assert_true(lowest_report(reports) is None)
}
