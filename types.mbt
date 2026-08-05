///|
/// A signed amount in the smallest currency unit (for example, cents).
pub type Amount = Int

///|
pub(all) enum StatementKind {
  BalanceSheet
  IncomeStatement
  CashFlowStatement
  Management
} derive(Debug, Eq)

///|
pub struct Entry {
  account : String
  period : String
  debit : Amount
  credit : Amount
  cash : Bool
} derive(Debug, Eq)

///|
pub struct AccountMapping {
  account : String
  line : String
  kind : StatementKind
  factor : Int
} derive(Debug, Eq)

///|
pub struct LineItem {
  line : String
  amount : Amount
  entries : Int
} derive(Debug, Eq)

///|
pub struct Report {
  kind : StatementKind
  period : String
  lines : Array[LineItem]
  total : Amount
} derive(Debug, Eq)
