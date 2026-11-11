///|
test "analyze ratios and health score" {
  let ratios = analyze_ratios(1000, 500, 100, 250, 800, 500, 100, 150)
  assert_eq(ratios.current_ratio, Some(200))
  assert_eq(ratios.quick_ratio, Some(160))
  assert_eq(ratios.gross_margin, Some(37))
  assert_eq(ratios.operating_margin, Some(25))
  assert_eq(ratios.debt_ratio, Some(25))
  assert_eq(ratios.return_on_assets, Some(15))
  let health = health_score(ratios)
  assert_eq(health.liquidity, 200)
  assert_eq(health.profitability, 25)
  assert_eq(health.leverage, 75)
  assert_eq(health.overall, 100)
}

///|
test "ratios and health score handle zero denominators" {
  let ratios = analyze_ratios(0, 0, 0, 0, 0, 0, 0, 0)
  assert_eq(ratios.current_ratio, None)
  assert_eq(ratios.quick_ratio, None)
  assert_eq(ratios.gross_margin, None)
  assert_eq(ratios.operating_margin, None)
  assert_eq(ratios.debt_ratio, None)
  assert_eq(ratios.return_on_assets, None)
  let health = health_score(ratios)
  assert_eq(health.liquidity, 0)
  assert_eq(health.profitability, 0)
  assert_eq(health.leverage, 0)
  assert_eq(health.overall, 0)
}

///|
test "variance and report variance cover missing lines" {
  let mappings = [
    @moonbit-accounting.AccountMapping::new(
      "sales",
      "Revenue",
      @moonbit-accounting.IncomeStatement,
    ),
    @moonbit-accounting.AccountMapping::new(
      "new",
      "New",
      @moonbit-accounting.IncomeStatement,
    ),
    @moonbit-accounting.AccountMapping::new(
      "old",
      "Old",
      @moonbit-accounting.IncomeStatement,
    ),
  ]
  let current = generate(
    @moonbit-accounting.IncomeStatement,
    "2026-Q2",
    [
      @moonbit-accounting.Entry::new("sales", "2026-Q2", 0, 120),
      @moonbit-accounting.Entry::new("new", "2026-Q2", 0, 20),
    ],
    mappings,
  )
  let prior = generate(
    @moonbit-accounting.IncomeStatement,
    "2026-Q1",
    [
      @moonbit-accounting.Entry::new("sales", "2026-Q1", 0, 100),
      @moonbit-accounting.Entry::new("old", "2026-Q1", 0, 30),
    ],
    mappings,
  )
  let variances = report_variances(current, prior)
  assert_eq(variances.length(), 3)
  assert_eq(variances[0].absolute, 20)
  assert_eq(variances[0].percent, Some(20))
  assert_eq(variances[1].prior, 0)
  assert_eq(variances[2].current, 0)
  assert_eq(variance("Zero", 10, 0).percent, None)
}
