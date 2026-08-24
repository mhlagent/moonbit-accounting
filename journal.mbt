///|
/// Journal entries preserve source-document boundaries before normalization.
pub struct JournalLine {
  account : String
  debit : Amount
  credit : Amount
} derive(Debug, Eq)

///|
pub fn JournalLine::new(
  account : String,
  debit : Amount,
  credit : Amount,
) -> JournalLine {
  { account, debit, credit }
}

///|
pub struct JournalEntry {
  id : String
  period : String
  description : String
  lines : Array[JournalLine]
} derive(Debug, Eq)

///|
pub fn JournalEntry::new(
  id : String,
  period : String,
  description : String,
) -> JournalEntry {
  { id, period, description, lines: [] }
}

///|
pub fn JournalEntry::add_line(self : JournalEntry, line : JournalLine) -> Unit {
  self.lines.push(line)
}

///|
pub enum JournalValidation {
  BalancedJournal
  EmptyJournal
  InvalidJournalPeriod
  UnbalancedJournal(Amount)
  InvalidJournalLine(String)
} derive(Debug, Eq)

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
