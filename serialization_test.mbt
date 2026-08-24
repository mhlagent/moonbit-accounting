///|
test "json renderer escapes control characters" {
  let mappings = [AccountMapping::new("x", "line \"quoted\"", Management)]
  let report = generate(
    Management,
    "2026-Q2",
    [Entry::new("x", "2026-Q2", 3, 0)],
    mappings,
  )
  let json = report.to_json()
  assert_true(json.contains("line \\\"quoted\\\""))
}
