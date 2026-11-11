///|
/// A compact standard chart helps applications bootstrap mappings.
pub enum AccountClass {
  Asset
  Liability
  Equity
  Revenue
  Expense
} derive(Debug, Eq)

///|
pub extend AccountClass with Eq::{not_equal, equal}

///|
pub extend AccountClass with @debug.Debug::{to_repr}

///|
pub struct AccountDefinition {
  code : String
  name : String
  class : AccountClass
  normal_debit : Bool
} derive(Debug, Eq)

///|
pub extend AccountDefinition with Eq::{not_equal, equal}

///|
pub extend AccountDefinition with @debug.Debug::{to_repr}

///|
pub fn AccountDefinition::new(
  code : String,
  name : String,
  class : AccountClass,
  normal_debit : Bool,
) -> AccountDefinition {
  { code, name, class, normal_debit, }
}

///|
pub fn standard_account(code : String) -> AccountDefinition? {
  match code {
    "1000" => Some(AccountDefinition::new("1000", "Cash", Asset, true))
    "1010" => Some(AccountDefinition::new("1010", "Bank deposits", Asset, true))
    "1100" =>
      Some(AccountDefinition::new("1100", "Accounts receivable", Asset, true))
    "1200" => Some(AccountDefinition::new("1200", "Inventory", Asset, true))
    "1300" =>
      Some(AccountDefinition::new("1300", "Prepaid expenses", Asset, true))
    "1500" =>
      Some(
        AccountDefinition::new("1500", "Property and equipment", Asset, true),
      )
    "1510" =>
      Some(
        AccountDefinition::new("1510", "Accumulated depreciation", Asset, false),
      )
    "2000" =>
      Some(AccountDefinition::new("2000", "Accounts payable", Liability, false))
    "2100" =>
      Some(AccountDefinition::new("2100", "Accrued expenses", Liability, false))
    "2200" =>
      Some(AccountDefinition::new("2200", "Deferred revenue", Liability, false))
    "2500" =>
      Some(AccountDefinition::new("2500", "Long-term debt", Liability, false))
    "3000" =>
      Some(AccountDefinition::new("3000", "Paid-in capital", Equity, false))
    "3100" =>
      Some(AccountDefinition::new("3100", "Retained earnings", Equity, false))
    "4000" =>
      Some(AccountDefinition::new("4000", "Product revenue", Revenue, false))
    "4100" =>
      Some(AccountDefinition::new("4100", "Service revenue", Revenue, false))
    "5000" =>
      Some(AccountDefinition::new("5000", "Cost of goods sold", Expense, true))
    "6000" =>
      Some(AccountDefinition::new("6000", "Payroll expense", Expense, true))
    "6100" =>
      Some(AccountDefinition::new("6100", "Rent expense", Expense, true))
    "6200" =>
      Some(AccountDefinition::new("6200", "Hosting expense", Expense, true))
    "6300" =>
      Some(
        AccountDefinition::new("6300", "Depreciation expense", Expense, true),
      )
    "6400" =>
      Some(AccountDefinition::new("6400", "Interest expense", Expense, true))
    _ => None
  }
}

///|
pub fn standard_chart() -> Array[AccountDefinition] {
  let result : Array[AccountDefinition] = []
  for
    code in [
      "1000", "1010", "1100", "1200", "1300", "1500", "1510", "2000", "2100", "2200",
      "2500", "3000", "3100", "4000", "4100", "5000", "6000", "6100", "6200", "6300",
      "6400",
    ] {
    match standard_account(code) {
      Some(account) => result.push(account)
      None => ()
    }
  }
  result
}
