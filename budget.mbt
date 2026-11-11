///|
pub struct BudgetLine {
  line : String
  amount : Amount
} derive(Debug, Eq)

///|
pub extend BudgetLine with Eq::{not_equal, equal}

///|
pub extend BudgetLine with @debug.Debug::{to_repr}

///|
pub fn BudgetLine::new(line : String, amount : Amount) -> BudgetLine {
  { line, amount, }
}

///|
pub struct BudgetVariance {
  line : String
  budget : Amount
  actual : Amount
  variance : Amount
  favorable : Bool
} derive(Debug, Eq)

///|
pub extend BudgetVariance with Eq::{not_equal, equal}

///|
pub extend BudgetVariance with @debug.Debug::{to_repr}

///|
pub fn budget_variance(
  budget : Array[BudgetLine],
  actual : Array[BudgetLine],
) -> Array[BudgetVariance] {
  let result : Array[BudgetVariance] = []
  for expected in budget {
    let mut observed = 0
    for item in actual {
      if item.line == expected.line {
        observed = item.amount
        break
      }
    }
    let variance = observed - expected.amount
    result.push({
      line: expected.line,
      budget: expected.amount,
      actual: observed,
      variance,
      favorable: variance <= 0,
    })
  }
  result
}
