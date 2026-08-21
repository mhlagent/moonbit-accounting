///|
pub enum BatchValidation {
  BalancedBatch
  UnbalancedBatch(Amount)
  EmptyBatch
} derive(Debug, Eq)

///|
pub enum MappingValidation {
  ValidMappings
  DuplicateAccount(String)
} derive(Debug, Eq)

///|
pub fn validate_batch(entries : Array[Entry]) -> BatchValidation {
  if entries.length() == 0 {
    return EmptyBatch
  }
  let mut total_debit = 0
  let mut total_credit = 0
  for entry in entries {
    total_debit += entry.debit
    total_credit += entry.credit
  }
  if total_debit == total_credit {
    BalancedBatch
  } else {
    UnbalancedBatch(total_debit - total_credit)
  }
}

///|
pub fn validate_mappings(mappings : Array[AccountMapping]) -> MappingValidation {
  for i, mapping in mappings {
    for j in 0..<i {
      if mappings[j].account == mapping.account {
        return DuplicateAccount(mapping.account)
      }
    }
  }
  ValidMappings
}

///|
pub fn safe_ratio(numerator : Amount, denominator : Amount) -> Amount? {
  if denominator == 0 {
    None
  } else {
    Some(numerator * 100 / denominator)
  }
}
