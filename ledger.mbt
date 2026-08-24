///|
/// Validation errors are explicit so importers can reject bad source data.
pub enum EntryValidation {
  ValidEntry
  EmptyAccount
  InvalidEntryPeriod(String)
  NegativeAmount
  UnbalancedEntry
} derive(Debug, Eq)

///|
pub fn validate_entry(entry : Entry) -> EntryValidation {
  if entry.account == "" {
    return EmptyAccount
  }
  match validate_period(entry.period) {
    InvalidPeriod(period) => return InvalidEntryPeriod(period)
    ValidPeriod(_) => ()
  }
  if entry.debit < 0 || entry.credit < 0 {
    return NegativeAmount
  }
  if (entry.debit > 0 && entry.credit > 0) ||
    (entry.debit == 0 && entry.credit == 0) {
    return UnbalancedEntry
  }
  ValidEntry
}

///|
pub struct TrialBalanceLine {
  account : String
  debit : Amount
  credit : Amount
  balance : Amount
} derive(Debug, Eq)

///|
pub struct TrialBalance {
  lines : Array[TrialBalanceLine]
  total_debit : Amount
  total_credit : Amount
  balanced : Bool
} derive(Debug, Eq)

///|
pub fn trial_balance(
  entries : Array[Entry],
  period? : String = "",
) -> TrialBalance {
  let lines : Array[TrialBalanceLine] = []
  let mut total_debit = 0
  let mut total_credit = 0
  for entry in entries {
    if period != "" && entry.period != period {
      continue
    }
    total_debit += entry.debit
    total_credit += entry.credit
    add_trial_line(lines, entry.account, entry.debit, entry.credit)
  }
  { lines, total_debit, total_credit, balanced: total_debit == total_credit }
}

///|
pub fn account_balance(
  entries : Array[Entry],
  account : String,
  period? : String = "",
) -> Amount {
  let mut debit = 0
  let mut credit = 0
  for entry in entries {
    if entry.account == account && (period == "" || entry.period == period) {
      debit += entry.debit
      credit += entry.credit
    }
  }
  debit - credit
}

///|
pub fn find_trial_line(
  balance : TrialBalance,
  account : String,
) -> TrialBalanceLine? {
  for line in balance.lines {
    if line.account == account {
      return Some(line)
    }
  }
  None
}

///|
fn add_trial_line(
  lines : Array[TrialBalanceLine],
  account : String,
  debit : Amount,
  credit : Amount,
) -> Unit {
  for i, line in lines {
    if line.account == account {
      lines[i] = {
        ..line,
        debit: line.debit + debit,
        credit: line.credit + credit,
        balance: line.balance + debit - credit,
      }
      return
    }
  }
  lines.push({ account, debit, credit, balance: debit - credit })
}
