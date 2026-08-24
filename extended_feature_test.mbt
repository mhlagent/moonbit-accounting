///|
test "journal entries flatten into normalized records" {
  let journal = JournalEntry::new("INV-1", "2026-Q2", "invoice")
  journal.add_line(JournalLine::new("receivable", 1000, 0))
  journal.add_line(JournalLine::new("sales", 0, 1000))
  assert_true(validate_journal(journal) is BalancedJournal)
  assert_eq(flatten_journal(journal).length(), 2)
}

///|
test "dataset validation reports unmapped and invalid entries" {
  let entries = [
    Entry::new("cash", "2026-Q2", 100, 0),
    Entry::new("unknown", "2026-Q9", 0, 100),
  ]
  let issues = validate_dataset(entries, [
    AccountMapping::new("cash", "Cash", BalanceSheet),
  ])
  assert_eq(issues.length(), 2)
}

///|
test "tax summary calculates taxable base and tax" {
  let entries = [
    Entry::new("sales", "2026-Q2", 0, 1000),
    Entry::new("returns", "2026-Q2", 100, 0),
  ]
  let summary = tax_summary(
    entries,
    "2026-Q2",
    [
      TaxRule::new("sales", TaxableRevenue),
      TaxRule::new("returns", DeductibleExpense),
    ],
    rate=10,
  )
  assert_eq(summary.base, 900)
  assert_eq(summary.tax, 90)
}

///|
test "grouping and metrics preserve deterministic order" {
  let entries = [
    Entry::new_with_dimension("sales", "2026-Q1", 0, 100, "north"),
    Entry::new_with_dimension("sales", "2026-Q2", 0, 160, "north"),
    Entry::new_with_dimension("sales", "2026-Q2", 0, 40, "south"),
  ]
  assert_eq(group_by_dimension(entries, "2026-Q2")[0].amount, 160)
  assert_eq(growth_percent(100, 160), Some(60))
  assert_eq(weighted_average([(100, 2), (200, 1)]), Some(133))
}
