///|
pub(all) enum CashFlowKind {
  Operating
  Investing
  Financing
  Unclassified
} derive(Debug, Eq)

///|
pub struct CashFlowRule {
  account : String
  kind : CashFlowKind
  factor : Int
} derive(Debug, Eq)

///|
pub fn CashFlowRule::new(
  account : String,
  kind : CashFlowKind,
  factor? : Int = 1,
) -> CashFlowRule {
  { account, kind, factor }
}

///|
pub struct CashFlowLine {
  kind : CashFlowKind
  amount : Amount
  entries : Int
} derive(Debug, Eq)

///|
pub fn cash_flow(
  period : String,
  entries : Array[Entry],
  rules : Array[CashFlowRule],
) -> Array[CashFlowLine] {
  let result : Array[CashFlowLine] = []
  for entry in entries {
    if entry.period != period || !entry.cash {
      continue
    }
    let rule = find_cash_rule(rules, entry.account)
    let kind = match rule {
      Some(value) => value.kind
      None => Unclassified
    }
    let factor = match rule {
      Some(value) => value.factor
      None => 1
    }
    let value = (entry.debit - entry.credit) * factor
    add_cash_line(result, kind, value)
  }
  result
}

///|
fn find_cash_rule(
  rules : Array[CashFlowRule],
  account : String,
) -> CashFlowRule? {
  for rule in rules {
    if rule.account == account {
      return Some(rule)
    }
  }
  None
}

///|
fn add_cash_line(
  lines : Array[CashFlowLine],
  kind : CashFlowKind,
  amount : Amount,
) -> Unit {
  for i, line in lines {
    if line.kind == kind {
      lines[i] = {
        ..line,
        amount: line.amount + amount,
        entries: line.entries + 1,
      }
      return
    }
  }
  lines.push({ kind, amount, entries: 1 })
}
