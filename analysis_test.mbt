///|
test "budget variance preserves favorable direction" {
  let actual = [BudgetLine::new("hosting", 1000)]
  let observed = [BudgetLine::new("hosting", 750)]
  let result = budget_variance(actual, observed)
  assert_eq(result[0].variance, -250)
  assert_true(result[0].favorable)
}

///|
test "consolidation eliminates reciprocal entries" {
  let mappings = [
    AccountMapping::new("receivable", "Receivable", BalanceSheet),
    AccountMapping::new("payable", "Payable", BalanceSheet),
  ]
  let parent = [Entry::new("receivable", "2026-Q2", 500, 0)]
  let child = [Entry::new("payable", "2026-Q2", 0, 500)]
  let rule = EliminationRule::new("receivable", "payable")
  let result = consolidate_with_eliminations(
    "2026-Q2",
    [Entity::new("parent", parent), Entity::new("child", child)],
    mappings,
    [rule],
  )
  assert_eq(result.total, 0)
  assert_eq(result.line("Receivable"), Some(0))
  assert_eq(result.line("Payable"), Some(0))
}
