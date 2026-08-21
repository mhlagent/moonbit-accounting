///|
pub struct TrendPoint {
  period : String
  amount : Amount
  change : Amount
  direction : String
} derive(Debug, Eq)

///|
pub fn trend_points(values : Array[(String, Amount)]) -> Array[TrendPoint] {
  let result : Array[TrendPoint] = []
  let mut previous = 0
  let mut first = true
  for pair in values {
    let period = pair.0
    let amount = pair.1
    let change = if first { 0 } else { amount - previous }
    let direction = if change > 0 {
      "up"
    } else if change < 0 {
      "down"
    } else {
      "flat"
    }
    result.push({ period, amount, change, direction })
    previous = amount
    first = false
  }
  result
}

///|
pub fn moving_average(values : Array[Amount], window : Int) -> Array[Amount] {
  let result : Array[Amount] = []
  if window <= 0 {
    return result
  }
  for i in 0..<values.length() {
    let start = if i + 1 < window { 0 } else { i + 1 - window }
    let mut sum = 0
    let mut count = 0
    for j in start..<=i {
      sum += values[j]
      count += 1
    }
    result.push(sum / count)
  }
  result
}

///|
pub fn compound_change(first : Amount, last : Amount, periods : Int) -> Amount? {
  if periods <= 0 || first == 0 {
    None
  } else {
    safe_ratio(last - first, first)
  }
}
