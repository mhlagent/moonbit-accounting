///|
/// A signed amount in the smallest currency unit (for example, cents).
pub type Amount = Int32

///|
#derive(Debug, Eq)
pub(all) enum StatementKind {
  BalanceSheet
  IncomeStatement
  CashFlowStatement
  Management
}

///|
pub extend StatementKind with Eq::{not_equal, equal}

///|
pub extend StatementKind with @debug.Debug::{to_repr}

///|

///|
#derive(Debug, Eq)
pub struct Entry {
  account : String
  period : String
  debit : Amount
  credit : Amount
  cash : Bool
  dimension : String
}

///|
pub extend Entry with Eq::{not_equal, equal}

///|
pub extend Entry with @debug.Debug::{to_repr}

///|
#derive(Debug, Eq)
pub struct AccountMapping {
  account : String
  line : String
  kind : StatementKind
  factor : Int32
}

///|
pub extend AccountMapping with Eq::{not_equal, equal}

///|
pub extend AccountMapping with @debug.Debug::{to_repr}

///|
#derive(Debug, Eq)
pub struct LineItem {
  line : String
  amount : Amount
  entries : Int32
}

///|
pub extend LineItem with Eq::{not_equal, equal}

///|
pub extend LineItem with @debug.Debug::{to_repr}

///|
#derive(Debug, Eq)
pub struct Report {
  kind : StatementKind
  period : String
  lines : Array[LineItem]
  total : Amount
}

///|
pub extend Report with Eq::{not_equal, equal}

///|
pub extend Report with @debug.Debug::{to_repr}
