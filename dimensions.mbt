///|
#derive(Debug, Eq)
pub struct DimensionLine {
  dimension : String
  amount : Amount
  entries : Int32
}

///|
pub extend DimensionLine with Eq::{not_equal, equal}

///|
pub extend DimensionLine with @debug.Debug::{to_repr}

///|
pub fn generate_by_dimension(
  kind : StatementKind,
  period : String,
  entries : Array[Entry],
  mappings : Array[AccountMapping],
) -> Array[DimensionLine] {
  let result : Array[DimensionLine] = []
  for entry in entries {
    if entry.period != period {
      continue
    }
    match find_mapping(mappings, entry.account) {
      None => continue
      Some(mapping) => {
        if mapping.kind != kind && kind != Management {
          continue
        }
        let key = if entry.dimension == "" {
          "default"
        } else {
          entry.dimension
        }
        let value = entry.balance(kind) * mapping.factor
        let mut found = false
        for i, line in result {
          if line.dimension == key {
            result[i] = {
              ..line,
              amount: line.amount + value,
              entries: line.entries + 1,
            }
            found = true
            break
          }
        }
        if !found {
          result.push({ dimension: key, amount: value, entries: 1, })
        }
      }
    }
  }
  result
}

///|
#derive(Debug, Eq)
pub struct ReportComparison {
  current : Report
  prior : Report
  total_variance : Amount
}

///|
pub extend ReportComparison with Eq::{not_equal, equal}

///|
pub extend ReportComparison with @debug.Debug::{to_repr}

///|
pub fn compare_reports(
  kind : StatementKind,
  current_period : String,
  prior_period : String,
  entries : Array[Entry],
  mappings : Array[AccountMapping],
) -> ReportComparison {
  let current = generate(kind, current_period, entries, mappings)
  let prior = generate(kind, prior_period, entries, mappings)
  { current, prior, total_variance: current.total - prior.total, }
}
