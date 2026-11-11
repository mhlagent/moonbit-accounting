///|
test "anomaly detectors cover large, unmapped and invalid entries" {
  let entries = [
    Entry::new("cash", "2026-Q2", 150, 0),
    Entry::new("sales", "2026-Q3", 0, 250),
    Entry::new("unknown", "2026-13", 10, 0),
  ]
  let mappings = [
    AccountMapping::new("cash", "Cash", BalanceSheet),
    AccountMapping::new("sales", "Revenue", IncomeStatement),
  ]
  let large = detect_large_entries(entries, 100)
  assert_eq(large.length(), 2)
  assert_eq(large[0].kind, @moonbit-accounting.LargeDebit)
  assert_eq(large[1].kind, @moonbit-accounting.LargeCredit)
  assert_eq(large[0].amount, 150)
  let unmapped = detect_unmapped(entries, mappings)
  assert_eq(unmapped.length(), 1)
  assert_eq(unmapped[0].kind, @moonbit-accounting.UnmappedAccount)
  assert_eq(unmapped[0].account, "unknown")
  let invalid = detect_invalid_periods(entries)
  assert_eq(invalid.length(), 1)
  assert_eq(invalid[0].kind, @moonbit-accounting.InvalidPeriod)
  assert_eq(invalid[0].period, "2026-13")
}

///|
test "large entry detector handles negative balances" {
  let entries = [Entry::new("cash", "2026-Q2", -200, -300)]
  let anomalies = detect_large_entries(entries, 100)
  assert_eq(anomalies.length(), 2)
  assert_eq(anomalies[0].amount, -200)
  assert_eq(anomalies[1].amount, -300)
}
