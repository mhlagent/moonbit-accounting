///|
test "html renderer escapes report content" {
  assert_eq(
    escape_html("<cash & \"bank\">"),
    "&lt;cash &amp; &quot;bank&quot;&gt;",
  )
  let mappings = [AccountMapping::new("x", "A < B", Management)]
  let report = generate(
    Management,
    "2026-Q2",
    [Entry::new("x", "2026-Q2", 3, 0)],
    mappings,
  )
  let html = report.to_html()
  assert_true(html.contains("A &lt; B"))
  assert_true(report_document(report, "Demo").contains("doctype"))
}

///|
test "cash flow rules aggregate only cash entries" {
  let rules = [
    CashFlowRule::new("sales", Operating),
    CashFlowRule::new("loan", Financing),
  ]
  let entries = [
    Entry::new("sales", "2026-Q2", 0, 100, cash=true),
    Entry::new("loan", "2026-Q2", 0, 500, cash=true),
    Entry::new("sales", "2026-Q2", 0, 100),
  ]
  let lines = cash_flow("2026-Q2", entries, rules)
  assert_eq(lines.length(), 2)
  assert_eq(lines[0].amount, -100)
  assert_eq(lines[1].amount, -500)
}

///|
test "currency conversion respects minor units and zero rates" {
  let usd = currency("USD")
  let jpy = currency("JPY")
  match (usd, jpy) {
    (Some(from), Some(to)) => {
      assert_eq(convert_minor(100, from, to, 150, 1), Some(150))
      assert_eq(convert_minor(100, from, to, 1, 0), None)
    }
    _ => fail("built-in currencies missing")
  }
}

///|
test "trend and moving average preserve input order" {
  let points = trend_points([
    ("2026-Q1", 100),
    ("2026-Q2", 160),
    ("2026-Q3", 120),
  ])
  assert_eq(points[1].change, 60)
  assert_eq(points[2].direction, "down")
  assert_eq(moving_average([10, 20, 30], 2), [10, 15, 25])
}
