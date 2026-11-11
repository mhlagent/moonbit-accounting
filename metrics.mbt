///|
/// Deterministic scalar metrics for dashboards and reports.
#derive(Debug, Eq)
pub struct DimensionTotal {
  dimension : String
  amount : Amount
  entries : Int32
}

///|
pub extend DimensionTotal with Eq::{not_equal, equal}

///|
pub extend DimensionTotal with @debug.Debug::{to_repr}

///|
pub fn group_by_dimension(
  entries : Array[Entry],
  period : String,
) -> Array[DimensionTotal] {
  let result : Array[DimensionTotal] = []
  for entry in entries {
    if entry.period != period {
      continue
    }
    let key = if entry.dimension == "" { "default" } else { entry.dimension }
    let amount = entry.credit - entry.debit
    for i, item in result {
      if item.dimension == key {
        result[i] = {
          ..item,
          amount: item.amount + amount,
          entries: item.entries + 1,
        }
        continue
      }
    }
    if find_dimension_total(result, key) is None {
      result.push({ dimension: key, amount, entries: 1, })
    }
  }
  result
}

///|
fn find_dimension_total(
  items : Array[DimensionTotal],
  dimension : String,
) -> DimensionTotal? {
  for item in items {
    if item.dimension == dimension {
      return Some(item)
    }
  }
  None
}

///|
pub fn growth_percent(previous : Amount, current : Amount) -> Amount? {
  if previous == 0 {
    None
  } else {
    Some((current - previous) * 100 / previous)
  }
}

///|
pub fn weighted_average(values : Array[(Amount, Int32)]) -> Amount? {
  let mut total = 0
  let mut weight = 0
  for pair in values {
    let value = pair.0
    let factor = pair.1
    if factor < 0 {
      continue
    }
    total += value * factor
    weight += factor
  }
  if weight == 0 {
    None
  } else {
    Some(total / weight)
  }
}

///|
pub fn net_margin(revenue : Amount, expenses : Amount) -> Amount? {
  if revenue == 0 {
    None
  } else {
    Some((revenue - expenses) * 100 / revenue)
  }
}

///|
pub fn burn_rate(expenses : Array[Amount], periods : Int32) -> Amount? {
  if periods <= 0 {
    None
  } else {
    let mut total = 0
    for expense in expenses {
      total += expense
    }
    Some(total / periods)
  }
}
