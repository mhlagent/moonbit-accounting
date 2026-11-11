///|
test "benchmark fixture and summary are deterministic" {
  let (entries, mappings) = benchmark_fixture(10)
  assert_eq(entries.length(), 10)
  assert_eq(mappings.length(), 10)
  let result = run_benchmark(100)
  assert_eq(result.entries, 100)
  assert_eq(result.mappings, 100)
  assert_eq(result.lines, 16)
  assert_eq(result.total, 4759)
  assert_true(benchmark_summary(result).contains("total=4759"))
  let empty = run_benchmark(-5)
  assert_eq(empty.entries, 0)
  assert_eq(empty.mappings, 0)
  assert_eq(empty.lines, 0)
  assert_eq(empty.total, 0)
}
