///|
test "cash reconciliation distinguishes matched and unexplained items" {
  let ledger = [CashRecord::new("bank-1", 1000), CashRecord::new("bank-2", 200)]
  let statement = [
    CashRecord::new("bank-1", 1000),
    CashRecord::new("bank-3", 500),
  ]
  let result = reconcile_cash(ledger, statement)
  assert_eq(result.matched, 1)
  assert_eq(result.outstanding_ledger, 1)
  assert_eq(result.outstanding_statement, 1)
}

///|
test "forecast uses deterministic run-rate and exchange conversion" {
  let forecast = forecast_linear([100, 120, 140], 2)
  assert_eq(forecast[0].amount, 140)
  assert_eq(forecast[1].amount, 160)
  let rate = ExchangeRate::new("USD", "CNY", 7, 1)
  assert_eq(
    convert_amount(100, currency("USD"), currency("CNY"), rate),
    Some(700),
  )
}

///|
test "report pack renders multiple statements with a stable title" {
  let mappings = [AccountMapping::new("sales", "Revenue", IncomeStatement)]
  let entries = [Entry::new("sales", "2026-Q2", 0, 100)]
  let pack = build_report_pack("2026-Q2", entries, mappings)
  assert_eq(pack.reports.length(), 4)
  assert_true(pack.to_markdown().contains("2026-Q2"))
}
