///|
/// Journal entries preserve source-document boundaries before normalization.
#derive(Debug, Eq)
pub struct JournalLine {
  account : String
  debit : Amount
  credit : Amount
}

///|
pub extend JournalLine with Eq::{not_equal, equal}

///|
pub extend JournalLine with @debug.Debug::{to_repr}

///|
pub fn JournalLine::new(
  account : String,
  debit : Amount,
  credit : Amount,
) -> JournalLine {
  { account, debit, credit, }
}

///|
#derive(Debug, Eq)
pub struct JournalEntry {
  id : String
  period : String
  description : String
  lines : Array[JournalLine]
}

///|
pub extend JournalEntry with Eq::{not_equal, equal}

///|
pub extend JournalEntry with @debug.Debug::{to_repr}

///|
pub fn JournalEntry::new(
  id : String,
  period : String,
  description : String,
) -> JournalEntry {
  { id, period, description, lines: [], }
}

///|
pub fn JournalEntry::add_line(self : JournalEntry, line : JournalLine) -> Unit {
  self.lines.push(line)
}

///|
#derive(Debug, Eq)
pub enum JournalValidation {
  BalancedJournal
  EmptyJournal
  InvalidJournalPeriod
  UnbalancedJournal(Amount)
  InvalidJournalLine(String)
}

///|
pub extend JournalValidation with Eq::{not_equal, equal}

///|
pub extend JournalValidation with @debug.Debug::{to_repr}

///|
pub fn validate_journal(journal : JournalEntry) -> JournalValidation {
  if journal.lines.length() == 0 {
    return EmptyJournal
  }
  if validate_period(journal.period) is InvalidPeriod(_) {
    return InvalidJournalPeriod
  }
  let mut debit = 0
  let mut credit = 0
  for line in journal.lines {
    if line.account == "" ||
      line.debit < 0 ||
      line.credit < 0 ||
      (line.debit > 0 && line.credit > 0) {
      return InvalidJournalLine(line.account)
    }
    debit += line.debit
    credit += line.credit
  }
  if debit == credit {
    BalancedJournal
  } else {
    UnbalancedJournal(debit - credit)
  }
}

///|
pub fn flatten_journal(journal : JournalEntry) -> Array[Entry] {
  let entries : Array[Entry] = []
  for line in journal.lines {
    entries.push(
      Entry::new(line.account, journal.period, line.debit, line.credit),
    )
  }
  entries
}

///|
pub fn journal_totals(journal : JournalEntry) -> (Amount, Amount) {
  let mut debit = 0
  let mut credit = 0
  for line in journal.lines {
    debit += line.debit
    credit += line.credit
  }
  (debit, credit)
}
