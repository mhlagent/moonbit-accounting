///|
/// A small dependency-free importer for normalized CSV exchange files.
pub struct CsvImportResult {
  entries : Array[Entry]
  errors : Array[String]
} derive(Debug, Eq)

///|
pub extend CsvImportResult with Eq::{not_equal, equal}

///|
pub extend CsvImportResult with @debug.Debug::{to_repr}

///|
pub fn import_entries_csv(csv : String) -> CsvImportResult {
  let entries : Array[Entry] = []
  let errors : Array[String] = []
  let mut row = 0
  for line_view in csv.split("\n") {
    let line = line_view.to_owned()
    if row == 0 {
      row += 1
      continue
    }
    if line.trim() == "" {
      row += 1
      continue
    }
    let fields : Array[String] = []
    for field in line.split(",") {
      fields.push(field.trim().to_owned())
    }
    if fields.length() != 6 {
      errors.push("row " + row.to_string() + ": expected 6 columns")
      row += 1
      continue
    }
    match parse_csv_entry(fields) {
      Some(entry) => entries.push(entry)
      None =>
        errors.push("row " + row.to_string() + ": invalid normalized entry")
    }
    row += 1
  }
  { entries, errors, }
}

///|
fn parse_csv_entry(fields : Array[String]) -> Entry? {
  let debit = parse_amount(fields[2])
  let credit = parse_amount(fields[3])
  let cash = parse_bool(fields[4])
  match (debit, credit, cash) {
    (Some(debit), Some(credit), Some(cash)) => {
      let entry = Entry::new_with_dimension(
        fields[0],
        fields[1],
        debit,
        credit,
        fields[5],
        cash~,
      )
      if validate_entry(entry) is ValidEntry {
        Some(entry)
      } else {
        None
      }
    }
    _ => None
  }
}

///|
fn parse_amount(text : String) -> Amount? {
  if text == "" {
    return None
  }
  let mut sign = 1
  let mut start = 0
  if text[0] == '-' {
    sign = -1
    start = 1
  }
  if start == text.length() {
    return None
  }
  let mut value = 0
  for i in start..<text.length() {
    let digit = text[i]
    if digit < '0' || digit > '9' {
      return None
    }
    value = value * 10 + digit.to_int() - '0'.to_int()
  }
  Some(value * sign)
}

///|
fn parse_bool(text : String) -> Bool? {
  match text {
    "true" => Some(true)
    "false" => Some(false)
    _ => None
  }
}
