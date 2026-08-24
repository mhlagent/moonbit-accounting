///|
test "trial balance groups entries and exposes account balances" {
  let entries = [
    Entry::new("cash", "2026-Q2", 1000, 0),
    Entry::new("cash", "2026-Q2", 0, 200),
    Entry::new("sales", "2026-Q2", 0, 800),
  ]
  let balance = trial_balance(entries, period="2026-Q2")
  assert_eq(balance.total_debit, 1000)
  assert_eq(balance.total_credit, 1000)
  assert_true(balance.balanced)
  assert_eq(account_balance(entries, "cash", period="2026-Q2"), 800)
}

///|
test "entry validation reports malformed source records" {
  assert_true(validate_entry(Entry::new("", "2026-Q2", 1, 0)) is EmptyAccount)
  assert_true(
    validate_entry(Entry::new("cash", "2026-Q9", 1, 0)) is InvalidEntryPeriod(_),
  )
  assert_true(
    validate_entry(Entry::new("cash", "2026-Q2", -1, 0)) is NegativeAmount,
  )
  assert_true(
    validate_entry(Entry::new("cash", "2026-Q2", 1, 1)) is UnbalancedEntry,
  )
}
