///|
/// Deterministic fixture generation keeps benchmark comparisons meaningful.
pub struct BenchmarkResult {
  entries : Int32
  mappings : Int32
  lines : Int32
  total : Amount
  elapsed_ms : Int32
} derive(Debug, Eq)

///|
pub extend BenchmarkResult with Eq::{not_equal, equal}

///|
pub extend BenchmarkResult with @debug.Debug::{to_repr}

///|
pub fn benchmark_fixture(size : Int32) -> (Array[Entry], Array[AccountMapping]) {
  let entries : Array[Entry] = []
  let mappings : Array[AccountMapping] = []
  let count = if size < 0 { 0 } else { size }
  for i in 0..<count {
    let account = "account-" + i.to_string()
    let line = "Line " + (i % 16).to_string()
    mappings.push(AccountMapping::new(account, line, IncomeStatement))
    let amount = i % 97 + 1
    entries.push(Entry::new(account, "2026-Q2", 0, amount))
  }
  (entries, mappings)
}

///|
pub fn run_benchmark(size : Int32) -> BenchmarkResult {
  let started = @env.now()
  let (entries, mappings) = benchmark_fixture(size)
  let report = generate(IncomeStatement, "2026-Q2", entries, mappings)
  let elapsed_ms = (@env.now() - started).to_int()
  {
    entries: entries.length(),
    mappings: mappings.length(),
    lines: report.lines.length(),
    total: report.total,
    elapsed_ms,
  }
}

///|
pub fn benchmark_summary(result : BenchmarkResult) -> String {
  "entries=" +
  result.entries.to_string() +
  " mappings=" +
  result.mappings.to_string() +
  " lines=" +
  result.lines.to_string() +
  " total=" +
  result.total.to_string() +
  " elapsed_ms=" +
  result.elapsed_ms.to_string()
}
