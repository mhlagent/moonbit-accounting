///|
test "currency catalog covers every declared code" {
  let codes = currency_codes()
  for code in codes {
    let item = currency(code).unwrap()
    assert_eq(item.code, code)
    assert_true(item.minor_units >= 0)
  }
  assert_true(currency("XXX") is None)
}

///|
test "minor unit conversion handles scale boundaries" {
  let usd = currency("USD").unwrap()
  let jpy = currency("JPY").unwrap()
  assert_eq(convert_minor(100, usd, jpy, 100, 1), Some(100))
  assert_eq(convert_minor(100, jpy, usd, 1, 1), Some(10000))
  assert_eq(convert_minor(100, usd, usd, 2, 1), Some(200))
  assert_eq(convert_minor(100, usd, jpy, 1, 0), None)
}

///|
test "exchange conversion handles missing currencies and entries" {
  let usd = currency("USD").unwrap()
  let cny = currency("CNY").unwrap()
  let rate = ExchangeRate::new("USD", "CNY", 7, 1)
  let entry = Entry::new("cash", "2026-Q2", 100, 0)
  assert_eq(convert_amount(100, Some(usd), Some(cny), rate), Some(700))
  assert_eq(convert_amount(100, None, Some(cny), rate), None)
  assert_eq(
    convert_entry(entry, Some(usd), Some(cny), rate).unwrap().debit,
    700,
  )
  assert_eq(convert_entry(entry, None, Some(cny), rate), None)
  assert_eq(convert_entries([entry], Some(usd), Some(cny), rate).length(), 1)
  assert_eq(convert_entries([entry], None, Some(cny), rate).length(), 0)
}
