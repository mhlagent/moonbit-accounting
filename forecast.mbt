///|
/// Forecasts are intentionally transparent run-rate projections.
#derive(Debug, Eq)
pub struct ForecastPoint {
  period : Int32
  amount : Amount
  source_average : Amount
}

///|
pub extend ForecastPoint with Eq::{not_equal, equal}

///|
pub extend ForecastPoint with @debug.Debug::{to_repr}

///|
pub fn forecast_run_rate(
  history : Array[Amount],
  periods : Int32,
) -> Array[ForecastPoint] {
  let result : Array[ForecastPoint] = []
  if history.length() == 0 || periods <= 0 {
    return result
  }
  let mut total = 0
  for value in history {
    total += value
  }
  let average = total / history.length()
  for index in 0..<periods {
    result.push({ period: index + 1, amount: average, source_average: average, })
  }
  result
}

///|
pub fn forecast_linear(
  history : Array[Amount],
  periods : Int32,
) -> Array[ForecastPoint] {
  let result : Array[ForecastPoint] = []
  if history.length() == 0 || periods <= 0 {
    return result
  }
  let mut total = 0
  for value in history {
    total += value
  }
  let average = total / history.length()
  let slope = if history.length() < 2 {
    0
  } else {
    history[history.length() - 1] - history[history.length() - 2]
  }
  for index in 0..<periods {
    let amount = average + slope * (index + 1)
    result.push({ period: index + 1, amount, source_average: average, })
  }
  result
}

///|
pub fn forecast_total(points : Array[ForecastPoint]) -> Amount {
  let mut total = 0
  for point in points {
    total += point.amount
  }
  total
}
