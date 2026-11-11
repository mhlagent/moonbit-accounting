///|
pub fn AccountMapping::new(
  account : String,
  line : String,
  kind : StatementKind,
  factor~ : Int32 = 1,
) -> AccountMapping {
  { account, line, kind, factor, }
}

///|
pub fn Entry::new(
  account : String,
  period : String,
  debit : Amount,
  credit : Amount,
  cash~ : Bool = false,
) -> Entry {
  { account, period, debit, credit, cash, dimension: "", }
}

///|
pub fn Entry::new_with_dimension(
  account : String,
  period : String,
  debit : Amount,
  credit : Amount,
  dimension : String,
  cash~ : Bool = false,
) -> Entry {
  { account, period, debit, credit, cash, dimension, }
}

///|
fn Entry::balance(self : Entry, kind : StatementKind) -> Amount {
  match kind {
    IncomeStatement => self.credit - self.debit
    _ => self.debit - self.credit
  }
}

///|
fn find_mapping(
  mappings : Array[AccountMapping],
  account : String,
) -> AccountMapping? {
  for mapping in mappings {
    if mapping.account == account {
      return Some(mapping)
    }
  }
  None
}

///|
