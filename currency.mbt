///|
/// ISO-like currency metadata used by callers that need explicit scale.
pub struct Currency {
  code : String
  name : String
  minor_units : Int
} derive(Debug, Eq)

///|
pub fn Currency::new(
  code : String,
  name : String,
  minor_units : Int,
) -> Currency {
  { code, name, minor_units }
}

///|
pub fn currency(code : String) -> Currency? {
  match code {
    "USD" => Some({ code: "USD", name: "US dollar", minor_units: 2 })
    "EUR" => Some({ code: "EUR", name: "Euro", minor_units: 2 })
    "CNY" => Some({ code: "CNY", name: "Chinese yuan", minor_units: 2 })
    "JPY" => Some({ code: "JPY", name: "Japanese yen", minor_units: 0 })
    "GBP" => Some({ code: "GBP", name: "Pound sterling", minor_units: 2 })
    "AUD" => Some({ code: "AUD", name: "Australian dollar", minor_units: 2 })
    "CAD" => Some({ code: "CAD", name: "Canadian dollar", minor_units: 2 })
    "CHF" => Some({ code: "CHF", name: "Swiss franc", minor_units: 2 })
    "HKD" => Some({ code: "HKD", name: "Hong Kong dollar", minor_units: 2 })
    "SGD" => Some({ code: "SGD", name: "Singapore dollar", minor_units: 2 })
    "KRW" => Some({ code: "KRW", name: "South Korean won", minor_units: 0 })
    "INR" => Some({ code: "INR", name: "Indian rupee", minor_units: 2 })
    "BRL" => Some({ code: "BRL", name: "Brazilian real", minor_units: 2 })
    "MXN" => Some({ code: "MXN", name: "Mexican peso", minor_units: 2 })
    "NZD" => Some({ code: "NZD", name: "New Zealand dollar", minor_units: 2 })
    "SEK" => Some({ code: "SEK", name: "Swedish krona", minor_units: 2 })
    "NOK" => Some({ code: "NOK", name: "Norwegian krone", minor_units: 2 })
    "DKK" => Some({ code: "DKK", name: "Danish krone", minor_units: 2 })
    "PLN" => Some({ code: "PLN", name: "Polish zloty", minor_units: 2 })
    "THB" => Some({ code: "THB", name: "Thai baht", minor_units: 2 })
    "VND" => Some({ code: "VND", name: "Vietnamese dong", minor_units: 0 })
    "TWD" => Some({ code: "TWD", name: "New Taiwan dollar", minor_units: 0 })
    "ZAR" => Some({ code: "ZAR", name: "South African rand", minor_units: 2 })
    "AED" => Some({ code: "AED", name: "UAE dirham", minor_units: 2 })
    "SAR" => Some({ code: "SAR", name: "Saudi riyal", minor_units: 2 })
    "TRY" => Some({ code: "TRY", name: "Turkish lira", minor_units: 2 })
    "ILS" => Some({ code: "ILS", name: "Israeli new shekel", minor_units: 2 })
    "RUB" => Some({ code: "RUB", name: "Russian ruble", minor_units: 2 })
    _ => None
  }
}

///|
pub fn convert_minor(
  amount : Amount,
  from : Currency,
  to : Currency,
  rate_numerator : Int,
  rate_denominator : Int,
) -> Amount? {
  if rate_denominator == 0 {
    None
  } else {
    let scaled = amount * rate_numerator / rate_denominator
    if from.minor_units == to.minor_units {
      Some(scaled)
    } else if from.minor_units > to.minor_units {
      Some(scaled / scale10(from.minor_units - to.minor_units))
    } else {
      Some(scaled * scale10(to.minor_units - from.minor_units))
    }
  }
}

///|
fn scale10(power : Int) -> Int {
  let mut value = 1
  for _ in 0..<power {
    value *= 10
  }
  value
}

///|
pub fn currency_codes() -> Array[String] {
  [
    "AED", "AUD", "BRL", "CAD", "CHF", "CNY", "DKK", "EUR", "GBP", "HKD", "ILS",
    "INR", "JPY", "KRW", "MXN", "NOK", "NZD", "PLN", "RUB", "SAR", "SEK", "SGD",
    "THB", "TRY", "TWD", "USD", "VND", "ZAR",
  ]
}
