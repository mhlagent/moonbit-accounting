///|
/// A signed amount in the smallest currency unit (for example, cents).
pub type Amount = Int32

///|
pub(all) enum StatementKind {
  BalanceSheet
  IncomeStatement
  CashFlowStatement
  Management
} derive(Debug, Eq)

///|
pub extend StatementKind with Eq::{not_equal, equal}

///|
pub extend StatementKind with @debug.Debug::{to_repr}

///|
pub struct Entry {
  account : String
  period : String
  debit : Amount
  credit : Amount
  cash : Bool
  dimension : String
} derive(Debug, Eq)

///|
pub extend Entry with Eq::{not_equal, equal}

///|
pub extend Entry with @debug.Debug::{to_repr}

///|
pub struct AccountMapping {
  account : String
  line : String
  kind : StatementKind
  factor : Int32
} derive(Debug, Eq)

///|
pub extend AccountMapping with Eq::{not_equal, equal}

///|
pub extend AccountMapping with @debug.Debug::{to_repr}

///|
pub struct LineItem {
  line : String
  amount : Amount
  entries : Int32
} derive(Debug, Eq)

///|
pub extend LineItem with Eq::{not_equal, equal}

///|
pub extend LineItem with @debug.Debug::{to_repr}

///|
pub struct Report {
  kind : StatementKind
  period : String
  lines : Array[LineItem]
  total : Amount
} derive(Debug, Eq)

///|
pub extend Report with Eq::{not_equal, equal}

///|
pub extend Report with @debug.Debug::{to_repr}
