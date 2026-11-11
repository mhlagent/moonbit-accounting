///|
/// Dataset validation combines structural and mapping checks for importers.
#derive(Debug, Eq)
pub enum DatasetIssue {
  InvalidEntry(Int32, EntryValidation)
  UnmappedEntry(Int32, String)
  DuplicateEntry(Int32, Int32)
}

///|
pub extend DatasetIssue with Eq::{not_equal, equal}

///|
pub extend DatasetIssue with @debug.Debug::{to_repr}

///|
pub fn validate_dataset(
  entries : Array[Entry],
  mappings : Array[AccountMapping],
) -> Array[DatasetIssue] {
  let issues : Array[DatasetIssue] = []
  for i, entry in entries {
    match validate_entry(entry) {
      ValidEntry => ()
      issue => issues.push(InvalidEntry(i, issue))
    }
    if find_mapping(mappings, entry.account) is None {
      issues.push(UnmappedEntry(i, entry.account))
    }
    for j in 0..<i {
      if entries[j] == entry {
        issues.push(DuplicateEntry(j, i))
        break
      }
    }
  }
  issues
}

///|
pub fn valid_entries(
  entries : Array[Entry],
  mappings : Array[AccountMapping],
) -> Array[Entry] {
  let result : Array[Entry] = []
  for entry in entries {
    if validate_entry(entry) is ValidEntry &&
      find_mapping(mappings, entry.account) is Some(_) {
      result.push(entry)
    }
  }
  result
}

///|
pub fn entries_for_period(
  entries : Array[Entry],
  period : String,
) -> Array[Entry] {
  let result : Array[Entry] = []
  for entry in entries {
    if entry.period == period {
      result.push(entry)
    }
  }
  result
}
