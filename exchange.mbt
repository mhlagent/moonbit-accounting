///|
/// Explicit exchange rates keep conversion policy outside report generation.
pub struct ExchangeRate {
  from : String
  to : String
  numerator : Int32
  denominator : Int32
} derive(Debug, Eq)

///|
pub extend ExchangeRate with Eq::{not_equal, equal}

///|
pub extend ExchangeRate with @debug.Debug::{to_repr}

///|
pub fn ExchangeRate::new(
  from : String,
  to : String,
  numerator : Int32,
  denominator : Int32,
) -> ExchangeRate {
  { from, to, numerator, denominator, }
}

///|
pub fn convert_amount(
  amount : Amount,
  from : Currency?,
  to : Currency?,
  rate : ExchangeRate,
) -> Amount? {
  match (from, to) {
    (Some(from), Some(to)) =>
      convert_minor(amount, from, to, rate.numerator, rate.denominator)
    _ => None
  }
}

///|
pub fn convert_entry(
  entry : Entry,
  from : Currency?,
  to : Currency?,
  rate : ExchangeRate,
) -> Entry? {
  match
    (
      convert_amount(entry.debit, from, to, rate),
      convert_amount(entry.credit, from, to, rate),
    ) {
    (Some(debit), Some(credit)) =>
      Some(
        Entry::new_with_dimension(
          entry.account,
          entry.period,
          debit,
          credit,
          entry.dimension,
          cash=entry.cash,
        ),
      )
    _ => None
  }
}

///|
pub fn convert_entries(
  entries : Array[Entry],
  from : Currency?,
  to : Currency?,
  rate : ExchangeRate,
) -> Array[Entry] {
  let result : Array[Entry] = []
  for entry in entries {
    match convert_entry(entry, from, to, rate) {
      Some(value) => result.push(value)
      None => ()
    }
  }
  result
}
