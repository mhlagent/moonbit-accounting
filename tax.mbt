///|
/// Tax rules express how normalized accounts contribute to a tax base.
pub(all) enum TaxTreatment {
  TaxableRevenue
  DeductibleExpense
  Exempt
} derive(Debug, Eq)

///|
pub extend TaxTreatment with Eq::{not_equal, equal}

///|
pub extend TaxTreatment with @debug.Debug::{to_repr}

///|
pub struct TaxRule {
  account : String
  treatment : TaxTreatment
} derive(Debug, Eq)

///|
pub extend TaxRule with Eq::{not_equal, equal}

///|
pub extend TaxRule with @debug.Debug::{to_repr}

///|
pub fn TaxRule::new(account : String, treatment : TaxTreatment) -> TaxRule {
  { account, treatment, }
}

///|
pub struct TaxSummary {
  period : String
  revenue : Amount
  deductions : Amount
  base : Amount
  rate : Int32
  tax : Amount
} derive(Debug, Eq)

///|
pub extend TaxSummary with Eq::{not_equal, equal}

///|
pub extend TaxSummary with @debug.Debug::{to_repr}

///|
pub fn tax_summary(
  entries : Array[Entry],
  period : String,
  rules : Array[TaxRule],
  rate~ : Int32,
) -> TaxSummary {
  let mut revenue = 0
  let mut deductions = 0
  for entry in entries {
    if entry.period != period {
      continue
    }
    match find_tax_rule(rules, entry.account) {
      Some(rule) =>
        match rule.treatment {
          TaxableRevenue => revenue += entry.credit - entry.debit
          DeductibleExpense => deductions += entry.debit - entry.credit
          Exempt => ()
        }
      None => ()
    }
  }
  let base = if revenue > deductions { revenue - deductions } else { 0 }
  { period, revenue, deductions, base, rate, tax: base * rate / 100, }
}

///|
fn find_tax_rule(rules : Array[TaxRule], account : String) -> TaxRule? {
  for rule in rules {
    if rule.account == account {
      return Some(rule)
    }
  }
  None
}

///|
pub fn tax_amount(base : Amount, rate : Int32) -> Amount {
  if base <= 0 || rate <= 0 {
    0
  } else {
    base * rate / 100
  }
}
