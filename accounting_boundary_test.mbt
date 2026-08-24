///|
test "period validation rejects malformed values and orders quarters" {
  assert_true(validate_period("2026-Q3") is ValidPeriod(_))
  assert_true(validate_period("2026-Q9") is InvalidPeriod(_))
  assert_eq(compare_period("2026-Q4", "2026-Q2"), 1)
  assert_eq(compare_period("2026-Q2", "2026-Q2"), 0)
}

///|
test "batch validation catches imbalance and duplicate mappings" {
  let entries = [Entry::new("cash", "2026-Q1", 100, 0)]
  assert_true(validate_batch(entries) is UnbalancedBatch(_))
  let mappings = [
    AccountMapping::new("cash", "Cash", BalanceSheet),
    AccountMapping::new("cash", "Cash duplicate", BalanceSheet),
  ]
  assert_true(validate_mappings(mappings) is DuplicateAccount(_))
}

///|
test "comparison and dimensions expose variance without floating point" {
  let mappings = [AccountMapping::new("sales", "Revenue", IncomeStatement)]
  let entries = [
    Entry::new_with_dimension("sales", "2026-Q1", 0, 100, "north"),
    Entry::new_with_dimension("sales", "2026-Q2", 0, 160, "north"),
  ]
  let comparison = compare_reports(
    IncomeStatement,
    "2026-Q2",
    "2026-Q1",
    entries,
    mappings,
  )
  assert_eq(comparison.total_variance, 60)
  let dimensions = generate_by_dimension(
    IncomeStatement,
    "2026-Q2",
    entries,
    mappings,
  )
  assert_eq(dimensions[0].amount, 160)
}

///|
test "safe ratios return none for zero denominators" {
  assert_eq(safe_ratio(100, 0), None)
  assert_eq(safe_ratio(25, 100), Some(25))
}

///|
test "curated catalog provides stable mappings for importers" {
  assert_eq(standard_chart().length(), 21)
  assert_true(standard_account("1000") is Some(_))
  assert_true(standard_account("9999") is None)
}
