///|
pub enum PeriodResult {
  ValidPeriod(String)
  InvalidPeriod(String)
} derive(Debug, Eq)

///|
pub extend PeriodResult with Eq::{not_equal, equal}

///|
pub extend PeriodResult with @debug.Debug::{to_repr}

///|
pub fn validate_period(period : String) -> PeriodResult {
  if period.length() != 7 || period[4] != '-' || period[5] != 'Q' {
    return InvalidPeriod(period)
  }
  let year = period[:4].to_owned()
  let quarter = period[6]
  if year[0] < '0' ||
    year[0] > '9' ||
    year[1] < '0' ||
    year[1] > '9' ||
    year[2] < '0' ||
    year[2] > '9' ||
    year[3] < '0' ||
    year[3] > '9' ||
    quarter < '1' ||
    quarter > '4' {
    InvalidPeriod(period)
  } else {
    ValidPeriod(period)
  }
}

///|
pub fn compare_period(left : String, right : String) -> Int32 {
  if left == right {
    return 0
  }
  if left < right {
    -1
  } else {
    1
  }
}
