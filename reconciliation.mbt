///|
/// Reconciliation compares normalized balances with an external statement.
pub struct CashRecord {
  reference : String
  amount : Amount
} derive(Debug, Eq)

///|
pub extend CashRecord with Eq::{not_equal, equal}

///|
pub extend CashRecord with @debug.Debug::{to_repr}

///|
pub fn CashRecord::new(reference : String, amount : Amount) -> CashRecord {
  { reference, amount, }
}

///|
pub struct ReconciliationResult {
  matched : Int32
  outstanding_ledger : Int32
  outstanding_statement : Int32
  ledger_total : Amount
  statement_total : Amount
  difference : Amount
} derive(Debug, Eq)

///|
pub extend ReconciliationResult with Eq::{not_equal, equal}

///|
pub extend ReconciliationResult with @debug.Debug::{to_repr}

///|
pub fn reconcile_cash(
  ledger : Array[CashRecord],
  statement : Array[CashRecord],
) -> ReconciliationResult {
  let mut matched = 0
  for item in ledger {
    if find_cash_record(statement, item) is Some(_) {
      matched += 1
    }
  }
  let mut statement_matches = 0
  for item in statement {
    if find_cash_record(ledger, item) is Some(_) {
      statement_matches += 1
    }
  }
  let mut ledger_total = 0
  let mut statement_total = 0
  for item in ledger {
    ledger_total += item.amount
  }
  for item in statement {
    statement_total += item.amount
  }
  {
    matched,
    outstanding_ledger: ledger.length() - matched,
    outstanding_statement: statement.length() - statement_matches,
    ledger_total,
    statement_total,
    difference: ledger_total - statement_total,
  }
}

///|
fn find_cash_record(
  records : Array[CashRecord],
  wanted : CashRecord,
) -> CashRecord? {
  for record in records {
    if record.reference == wanted.reference && record.amount == wanted.amount {
      return Some(record)
    }
  }
  None
}

///|
pub fn reconciliation_is_balanced(result : ReconciliationResult) -> Bool {
  result.difference == 0 &&
  result.outstanding_ledger == 0 &&
  result.outstanding_statement == 0
}
