///|
test "tax edge branches" {
  let entries = [
    Entry::new("sales", "2026-Q2", 0, 100),
    Entry::new("expense", "2026-Q2", 30, 0),
    Entry::new("exempt", "2026-Q2", 0, 20),
    Entry::new("unknown", "2026-Q2", 0, 5),
    Entry::new("sales", "2026-Q1", 0, 50),
  ]
  let rules = [
    TaxRule::new("sales", TaxableRevenue),
    TaxRule::new("expense", DeductibleExpense),
    TaxRule::new("exempt", Exempt),
  ]
  let summary = tax_summary(entries, "2026-Q2", rules, rate=10)
  assert_eq(summary.revenue, 100)
  assert_eq(summary.deductions, 30)
  assert_eq(summary.base, 70)
  assert_eq(summary.tax, 7)
  assert_eq(tax_amount(100, 10), 10)
  assert_eq(tax_amount(0, 10), 0)
  assert_eq(tax_amount(100, 0), 0)
}

///|
test "variance rendering and apostrophe escaping" {
  let variances = [variance("A'B", 20, 10), variance("Zero", 10, 0)]
  let markdown = render_variances(variances)
  assert_true(markdown.contains("A'B"))
  assert_true(markdown.contains("n/a"))
  assert_true(markdown.contains("100"))
  assert_eq(escape_html("'"), "&#39;")
}

///|
test "aging edge branches" {
  let entries = [
    Entry::new("other", "2025-Q1", 100, 0),
    Entry::new("ar", "2026-Q3", 0, 10),
    Entry::new("ar", "bad", 50, 0),
    Entry::new("ar", "2025-Q1", 100, 0),
  ]
  let buckets = age_receivables(entries, "ar", "2026-Q2")
  assert_eq(buckets[0].amount, 50)
  assert_eq(buckets[3].amount, 100)
  assert_eq(period_distance("bad", "2026-Q2"), 0)
}

///|
test "trend edge branches" {
  assert_eq(moving_average([], 0).length(), 0)
  assert_eq(moving_average([10], 2), [10])
  assert_eq(compound_change(0, 10, 2), None)
  assert_eq(compound_change(100, 121, 2), Some(21))
  assert_eq(compound_change(100, 121, 0), None)
}

///|
test "ledger period filters and lookups" {
  let entries = [
    Entry::new("cash", "2026-Q1", 100, 0),
    Entry::new("cash", "2026-Q2", 50, 0),
    Entry::new("cash", "2026-Q2", 0, 20),
  ]
  let balance = trial_balance(entries, period="2026-Q2")
  assert_eq(balance.total_debit, 50)
  assert_eq(balance.total_credit, 20)
  assert_eq(find_trial_line(balance, "cash").unwrap().balance, 30)
  assert_eq(account_balance(entries, "cash", period="2026-Q2"), 30)
  assert_eq(trial_balance(entries).total_debit, 150)
}

///|
test "journal validation edge branches" {
  let empty = JournalEntry::new("E", "2026-Q2", "empty")
  assert_true(validate_journal(empty) is EmptyJournal)
  let invalid_period = JournalEntry::new("P", "bad", "invalid")
  invalid_period.add_line(JournalLine::new("cash", 100, 0))
  assert_true(validate_journal(invalid_period) is InvalidJournalPeriod)
  let bad_line = JournalEntry::new("L", "2026-Q2", "bad line")
  bad_line.add_line(JournalLine::new("", 100, 0))
  assert_true(validate_journal(bad_line) is InvalidJournalLine(_))
  let unbalanced = JournalEntry::new("U", "2026-Q2", "unbalanced")
  unbalanced.add_line(JournalLine::new("cash", 100, 0))
  unbalanced.add_line(JournalLine::new("sales", 0, 50))
  assert_true(validate_journal(unbalanced) is UnbalancedJournal(50))
  let balanced = JournalEntry::new("B", "2026-Q2", "balanced")
  balanced.add_line(JournalLine::new("cash", 100, 0))
  balanced.add_line(JournalLine::new("sales", 0, 100))
  assert_true(validate_journal(balanced) is BalancedJournal)
  assert_eq(journal_totals(balanced), (100, 100))
}

///|
test "metrics edge branches" {
  let entries = [
    Entry::new_with_dimension("sales", "2026-Q2", 0, 100, "north"),
    Entry::new_with_dimension("sales", "2026-Q2", 0, 50, "north"),
    Entry::new_with_dimension("sales", "2026-Q2", 0, 40, "south"),
    Entry::new_with_dimension("sales", "2026-Q1", 0, 10, "old"),
  ]
  let totals = group_by_dimension(entries, "2026-Q2")
  assert_eq(totals.length(), 2)
  assert_eq(totals[0].amount, 150)
  assert_eq(totals[0].entries, 2)
  assert_eq(growth_percent(0, 10), None)
  assert_eq(weighted_average([]), None)
  assert_eq(weighted_average([(10, 2), (20, -1)]), Some(10))
  assert_eq(net_margin(0, 10), None)
  assert_eq(net_margin(100, 40), Some(60))
  assert_eq(burn_rate([10, 20], 2), Some(15))
  assert_eq(burn_rate([10], 0), None)
}

///|
test "forecast edge branches" {
  assert_eq(forecast_run_rate([], 3).length(), 0)
  let run_rate = forecast_run_rate([10, 20], 2)
  assert_eq(forecast_total(run_rate), 30)
  let linear = forecast_linear([100, 120], 2)
  assert_eq(linear[0].amount, 130)
  assert_eq(linear[1].amount, 150)
  assert_eq(forecast_linear([100], 1)[0].amount, 100)
  assert_eq(forecast_linear([100], 0).length(), 0)
}

///|
test "serialization and import edge branches" {
  let mappings = [
    AccountMapping::new("sales", "Revenue, \"quoted\"", IncomeStatement),
  ]
  let report = generate(
    IncomeStatement,
    "2026-Q2",
    [Entry::new("sales", "2026-Q2", 0, 120)],
    mappings,
  )
  assert_true(report.to_csv().contains("\"Revenue, \"\"quoted\"\"\""))
  assert_true(report.to_json().contains("\\\"quoted\\\""))
  assert_true(report.to_markdown().contains("Revenue, \"quoted\""))
  let csv = "account,period,debit,credit,cash,dimension\n" +
    "cash,2026-Q2,100,0,true,\n" +
    "broken\n" +
    "cash,2026-Q2,nope,0,true,\n" +
    "cash,2026-Q2,1,0,maybe,\n"
  let imported = import_entries_csv(csv)
  assert_eq(imported.entries.length(), 1)
  assert_eq(imported.errors.length(), 3)
}

///|
test "consolidation and period edge branches" {
  let mappings = [
    AccountMapping::new("a", "A", BalanceSheet),
    AccountMapping::new("b", "B", BalanceSheet),
  ]
  let entries = [
    Entry::new("a", "2026-Q2", 100, 0),
    Entry::new("b", "2026-Q2", 0, 100),
  ]
  let base = consolidate("2026-Q2", [Entity::new("e", entries)], mappings)
  assert_eq(base.total, 0)
  let rule = EliminationRule::new("a", "b")
  let eliminated = consolidate_with_eliminations(
    "2026-Q2",
    [Entity::new("e", entries)],
    mappings,
    [rule],
  )
  assert_eq(eliminated.total, 0)
  let reports = [
    generate(
      IncomeStatement,
      "2026-Q2",
      [Entry::new("sales", "2026-Q2", 0, 10)],
      [AccountMapping::new("sales", "Revenue", IncomeStatement)],
    ),
    generate(IncomeStatement, "2026-Q1", [], []),
  ]
  assert_eq(lowest_report(reports).unwrap().period, "2026-Q1")
  let matched = reconcile_cash([CashRecord::new("x", 10)], [
    CashRecord::new("x", 10),
  ])
  assert_true(reconciliation_is_balanced(matched))
  let unmatched = reconcile_cash([CashRecord::new("x", 10)], [])
  assert_false(reconciliation_is_balanced(unmatched))
}

///|
test "report, period and cashflow edge branches" {
  let mappings = [AccountMapping::new("sales", "Revenue", IncomeStatement)]
  let unmapped = generate(
    IncomeStatement,
    "2026-Q2",
    [Entry::new("missing", "2026-Q2", 0, 100)],
    mappings,
  )
  assert_eq(unmapped.total, 0)
  assert_eq(compare_period("2026-Q1", "2026-Q2"), -1)
  let flows = cash_flow(
    "2026-Q2",
    [Entry::new("sales", "2026-Q2", 0, 100, cash=true)],
    [],
  )
  assert_eq(flows.length(), 1)
  assert_eq(flows[0].kind, Unclassified)
}

///|
test "dimension default and unmapped branches" {
  let mappings = [AccountMapping::new("sales", "Revenue", IncomeStatement)]
  let lines = generate_by_dimension(
    IncomeStatement,
    "2026-Q2",
    [
      Entry::new_with_dimension("sales", "2026-Q2", 0, 100, ""),
      Entry::new("missing", "2026-Q2", 0, 20),
    ],
    mappings,
  )
  assert_eq(lines.length(), 1)
  assert_eq(lines[0].dimension, "default")
  assert_eq(lines[0].amount, 100)
}

///|
test "validation batch empty and balanced" {
  assert_true(validate_batch([]) is EmptyBatch)
  assert_true(
    validate_batch([
      Entry::new("cash", "2026-Q2", 100, 0),
      Entry::new("sales", "2026-Q2", 0, 100),
    ])
    is BalancedBatch,
  )
}

///|
test "currency constructor and json backslash" {
  let custom = Currency::new("XTS", "Test currency", 2)
  assert_eq(custom.minor_units, 2)
  let mappings = [AccountMapping::new("sales", "A\\B", IncomeStatement)]
  let report = generate(
    IncomeStatement,
    "2026-Q2",
    [Entry::new("sales", "2026-Q2", 0, 120)],
    mappings,
  )
  assert_true(report.to_json().contains("A\\\\B"))
}

///|
test "csv import empty and negative amount branches" {
  let csv = "account,period,debit,credit,cash,dimension\n" +
    "cash,2026-Q2,,0,true,\n" +
    "cash,2026-Q2,-100,0,true,\n" +
    "cash,2026-Q2,1,0,maybe,\n"
  let imported = import_entries_csv(csv)
  assert_eq(imported.entries.length(), 0)
  assert_eq(imported.errors.length(), 3)
}

///|
test "consolidation negative and missing mapping branches" {
  let mappings = [
    AccountMapping::new("a", "A", BalanceSheet),
    AccountMapping::new("b", "B", BalanceSheet),
  ]
  let credit_only = [
    Entry::new("a", "2026-Q2", 0, 100),
    Entry::new("b", "2026-Q2", 0, 50),
  ]
  let clamped = consolidate_with_eliminations(
    "2026-Q2",
    [Entity::new("e", credit_only)],
    mappings,
    [EliminationRule::new("a", "b")],
  )
  assert_eq(clamped.total, -150)
  let missing_mapping = consolidate_with_eliminations(
    "2026-Q2",
    [
      Entity::new("e", [
        Entry::new("a", "2026-Q2", 100, 0),
        Entry::new("c", "2026-Q2", 0, 50),
      ]),
    ],
    mappings,
    [EliminationRule::new("a", "c")],
  )
  assert_true(missing_mapping.total != 0)
}
