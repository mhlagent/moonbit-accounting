///|
test "report document wraps a rendered report" {
  let mappings = [AccountMapping::new("sales", "Revenue", IncomeStatement)]
  let entries = [Entry::new("sales", "2026-Q2", 0, 120)]
  let report = generate(IncomeStatement, "2026-Q2", entries, mappings)
  let document = report_document(report, "Q2 report")
  assert_true(document.contains("<title>Q2 report</title>"))
  assert_true(document.contains("Revenue"))
  assert_true(report.to_html().contains("<table class=\"financial-report\">"))
}
