///|
#derive(Debug, Eq)
pub(all) enum AnomalyKind {
  LargeDebit
  LargeCredit
  UnmappedAccount
  InvalidPeriod
  DuplicateEntry
}

///|
pub extend AnomalyKind with Eq::{not_equal, equal}

///|
pub extend AnomalyKind with @debug.Debug::{to_repr}

///|
#derive(Debug, Eq)
pub struct Anomaly {
  kind : AnomalyKind
  account : String
  period : String
  amount : Amount
  detail : String
}

///|
pub extend Anomaly with Eq::{not_equal, equal}

///|
pub extend Anomaly with @debug.Debug::{to_repr}

///|
pub fn detect_large_entries(
  entries : Array[Entry],
  threshold : Amount,
) -> Array[Anomaly] {
  let result : Array[Anomaly] = []
  for entry in entries {
    let debit = if entry.debit < 0 { -entry.debit } else { entry.debit }
    let credit = if entry.credit < 0 { -entry.credit } else { entry.credit }
    if debit >= threshold {
      result.push({
        kind: LargeDebit,
        account: entry.account,
        period: entry.period,
        amount: entry.debit,
        detail: "debit exceeds threshold",
      })
    }
    if credit >= threshold {
      result.push({
        kind: LargeCredit,
        account: entry.account,
        period: entry.period,
        amount: entry.credit,
        detail: "credit exceeds threshold",
      })
    }
  }
  result
}

///|
pub fn detect_unmapped(
  entries : Array[Entry],
  mappings : Array[AccountMapping],
) -> Array[Anomaly] {
  let result : Array[Anomaly] = []
  for entry in entries {
    if find_mapping(mappings, entry.account) is None {
      result.push({
        kind: UnmappedAccount,
        account: entry.account,
        period: entry.period,
        amount: entry.debit - entry.credit,
        detail: "account has no statement mapping",
      })
    }
  }
  result
}

///|
pub fn detect_invalid_periods(entries : Array[Entry]) -> Array[Anomaly] {
  let result : Array[Anomaly] = []
  for entry in entries {
    if validate_period(entry.period) is InvalidPeriod(_) {
      result.push({
        kind: InvalidPeriod,
        account: entry.account,
        period: entry.period,
        amount: entry.debit - entry.credit,
        detail: "period must use YYYY-Qn",
      })
    }
  }
  result
}
