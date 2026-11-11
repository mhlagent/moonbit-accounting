///|
test "dataset validation covers duplicates and usable entries" {
  let mappings = [AccountMapping::new("cash", "Cash", BalanceSheet)]
  let valid = Entry::new("cash", "2026-Q2", 100, 0)
  let invalid = Entry::new("cash", "bad", 10, 0)
  let unmapped = Entry::new("other", "2026-Q2", 20, 0)
  let issues = validate_dataset([valid, valid, invalid, unmapped], mappings)
  assert_eq(issues.length(), 3)
  assert_eq(valid_entries([valid, invalid, unmapped], mappings).length(), 1)
  assert_eq(
    entries_for_period([valid, invalid, unmapped], "2026-Q2").length(),
    2,
  )
}
