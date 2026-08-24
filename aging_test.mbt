///|
test "receivables aging classifies periods relative to the report period" {
  let entries = [
    Entry::new("receivable", "2026-Q2", 100, 0),
    Entry::new("receivable", "2026-Q1", 200, 0),
    Entry::new("receivable", "2025-Q4", 300, 0),
    Entry::new("receivable", "2025-Q1", 400, 0),
  ]
  let buckets = age_receivables(entries, "receivable", "2026-Q2")
  assert_eq(buckets[0].amount, 100)
  assert_eq(buckets[1].amount, 200)
  assert_eq(buckets[2].amount, 300)
  assert_eq(buckets[3].amount, 400)
}
