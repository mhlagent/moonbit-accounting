///|
/// Build a stable report for each requested period.
pub fn generate_many(
  kind : StatementKind,
  periods : Array[String],
  entries : Array[Entry],
  mappings : Array[AccountMapping],
) -> Array[Report] {
  let reports : Array[Report] = []
  for period in periods {
    reports.push(generate(kind, period, entries, mappings))
  }
  reports
}

///|
pub fn period_totals(reports : Array[Report]) -> Array[(String, Amount)] {
  let result : Array[(String, Amount)] = []
  for report in reports {
    result.push((report.period, report.total))
  }
  result
}

///|
pub fn period_delta(reports : Array[Report]) -> Array[Amount] {
  let result : Array[Amount] = []
  let mut previous = 0
  let mut first = true
  for report in reports {
    if first {
      result.push(0)
      first = false
    } else {
      result.push(report.total - previous)
    }
    previous = report.total
  }
  result
}

///|
pub fn latest_report(reports : Array[Report]) -> Report? {
  if reports.length() == 0 {
    return None
  }
  let mut latest = reports[0]
  for report in reports {
    if compare_period(report.period, latest.period) > 0 {
      latest = report
    }
  }
  Some(latest)
}

///|
pub fn lowest_report(reports : Array[Report]) -> Report? {
  if reports.length() == 0 {
    return None
  }
  let mut lowest = reports[0]
  for report in reports {
    if report.total < lowest.total {
      lowest = report
    }
  }
  Some(lowest)
}
