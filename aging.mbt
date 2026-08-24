///|
/// Receivable aging uses quarter periods and integer minor units.
pub struct AgingBucket {
  label : String
  amount : Amount
  entries : Int
} derive(Debug, Eq)

///|
pub fn age_receivables(
  entries : Array[Entry],
  account : String,
  as_of : String,
) -> Array[AgingBucket] {
  let buckets = [
    { label: "current", amount: 0, entries: 0 },
    { label: "1 quarter", amount: 0, entries: 0 },
    { label: "2 quarters", amount: 0, entries: 0 },
    { label: "3+ quarters", amount: 0, entries: 0 },
  ]
  for entry in entries {
    if entry.account != account || entry.debit <= entry.credit {
      continue
    }
    let distance = period_distance(entry.period, as_of)
    let index = if distance <= 0 {
      0
    } else if distance == 1 {
      1
    } else if distance == 2 {
      2
    } else {
      3
    }
    let bucket = buckets[index]
    buckets[index] = {
      ..bucket,
      amount: bucket.amount + entry.debit - entry.credit,
      entries: bucket.entries + 1,
    }
  }
  buckets
}

///|
pub fn period_distance(older : String, newer : String) -> Int {
  match (period_parts(older), period_parts(newer)) {
    (Some((oy, oq)), Some((ny, nq))) => (ny - oy) * 4 + nq - oq
    _ => 0
  }
}

///|
fn period_parts(period : String) -> (Int, Int)? {
  match validate_period(period) {
    InvalidPeriod(_) => None
    ValidPeriod(value) => {
      let year = parse_year(value[:4].to_owned())
      let quarter = value[6].to_int() - '0'.to_int()
      Some((year, quarter))
    }
  }
}

///|
fn parse_year(text : String) -> Int {
  let mut value = 0
  for c in text {
    value = value * 10 + c.to_int() - '0'.to_int()
  }
  value
}
