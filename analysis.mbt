///|
/// Financial analysis primitives operate on integer minor units.
pub struct RatioSet {
  current_ratio : Amount?
  quick_ratio : Amount?
  gross_margin : Amount?
  operating_margin : Amount?
  debt_ratio : Amount?
  return_on_assets : Amount?
} derive(Debug, Eq)

///|
pub fn analyze_ratios(
  assets : Amount,
  current_assets : Amount,
  inventory : Amount,
  liabilities : Amount,
  revenue : Amount,
  cost : Amount,
  operating_expense : Amount,
  net_income : Amount,
) -> RatioSet {
  let gross_profit = revenue - cost
  {
    current_ratio: safe_ratio(current_assets, liabilities),
    quick_ratio: safe_ratio(current_assets - inventory, liabilities),
    gross_margin: safe_ratio(gross_profit, revenue),
    operating_margin: safe_ratio(gross_profit - operating_expense, revenue),
    debt_ratio: safe_ratio(liabilities, assets),
    return_on_assets: safe_ratio(net_income, assets),
  }
}

///|
pub struct Variance {
  line : String
  current : Amount
  prior : Amount
  absolute : Amount
  percent : Amount?
} derive(Debug, Eq)

///|
pub fn variance(line : String, current : Amount, prior : Amount) -> Variance {
  {
    line,
    current,
    prior,
    absolute: current - prior,
    percent: safe_ratio(current - prior, prior),
  }
}

///|
pub fn report_variances(current : Report, prior : Report) -> Array[Variance] {
  let result : Array[Variance] = []
  for item in current.lines {
    let old = match prior.line(item.line) {
      Some(value) => value
      None => 0
    }
    result.push(variance(item.line, item.amount, old))
  }
  for item in prior.lines {
    if current.line(item.line) is None {
      result.push(variance(item.line, 0, item.amount))
    }
  }
  result
}

///|
pub struct HealthScore {
  liquidity : Amount
  profitability : Amount
  leverage : Amount
  overall : Amount
} derive(Debug, Eq)

///|
pub fn health_score(ratios : RatioSet) -> HealthScore {
  let liquidity = match ratios.current_ratio {
    Some(v) => v
    None => 0
  }
  let profitability = match ratios.operating_margin {
    Some(v) => v
    None => 0
  }
  let leverage = match ratios.debt_ratio {
    Some(v) => 100 - v
    None => 0
  }
  {
    liquidity,
    profitability,
    leverage,
    overall: (liquidity + profitability + leverage) / 3,
  }
}
