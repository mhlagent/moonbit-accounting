///|
test "csv import accepts normalized rows and reports bad rows" {
  let csv = "account,period,debit,credit,cash,dimension\n" +
    "cash,2026-Q2,1000,0,true,\n" +
    "sales,2026-Q2,0,1000,false,north\n" +
    "broken,2026-Q2,nope,1,false,"
  let imported = import_entries_csv(csv)
  assert_eq(imported.entries.length(), 2)
  assert_eq(imported.errors.length(), 1)
  assert_eq(imported.entries[1].dimension, "north")
}
