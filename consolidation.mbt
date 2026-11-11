///|
#derive(Debug, Eq)
pub struct Entity {
  name : String
  entries : Array[Entry]
}

///|
pub extend Entity with Eq::{not_equal, equal}

///|
pub extend Entity with @debug.Debug::{to_repr}

///|
pub fn Entity::new(name : String, entries : Array[Entry]) -> Entity {
  { name, entries, }
}

///|
/// A rule identifies reciprocal intercompany balances to remove.
#derive(Debug, Eq)
pub struct EliminationRule {
  debit_account : String
  credit_account : String
}

///|
pub extend EliminationRule with Eq::{not_equal, equal}

///|
pub extend EliminationRule with @debug.Debug::{to_repr}

///|
pub fn EliminationRule::new(
  debit_account : String,
  credit_account : String,
) -> EliminationRule {
  { debit_account, credit_account, }
}

///|
pub fn consolidate(
  period : String,
  entities : Array[Entity],
  mappings : Array[AccountMapping],
) -> Report {
  consolidate_with_eliminations(period, entities, mappings, [])
}

///|
pub fn consolidate_with_eliminations(
  period : String,
  entities : Array[Entity],
  mappings : Array[AccountMapping],
  rules : Array[EliminationRule],
) -> Report {
  let all : Array[Entry] = []
  for entity in entities {
    for entry in entity.entries {
      if entry.period == period {
        all.push(entry)
      }
    }
  }
  let base = generate(BalanceSheet, period, all, mappings)
  let adjusted : Array[LineItem] = []
  for item in base.lines {
    adjusted.push(item)
  }
  for rule in rules {
    let debit_amount = consolidation_account_balance(
      all,
      rule.debit_account,
      true,
    )
    let credit_amount = consolidation_account_balance(
      all,
      rule.credit_account,
      false,
    )
    let amount = if debit_amount < credit_amount {
      debit_amount
    } else {
      credit_amount
    }
    if amount > 0 {
      adjust_line(adjusted, mappings, rule.debit_account, -amount)
      adjust_line(adjusted, mappings, rule.credit_account, amount)
    }
  }
  let mut total = 0
  for item in adjusted {
    total += item.amount
  }
  { kind: BalanceSheet, period, lines: adjusted, total, }
}

///|
fn consolidation_account_balance(
  entries : Array[Entry],
  account : String,
  debit_normal : Bool,
) -> Amount {
  let mut total = 0
  for entry in entries {
    if entry.account == account {
      if debit_normal {
        total += entry.debit - entry.credit
      } else {
        total += entry.credit - entry.debit
      }
    }
  }
  if total < 0 {
    0
  } else {
    total
  }
}

///|
fn adjust_line(
  lines : Array[LineItem],
  mappings : Array[AccountMapping],
  account : String,
  delta : Amount,
) -> Unit {
  match find_mapping(mappings, account) {
    None => ()
    Some(mapping) =>
      for i, item in lines {
        if item.line == mapping.line {
          lines[i] = { ..item, amount: item.amount + delta * mapping.factor, }
          return
        }
      }
  }
}
