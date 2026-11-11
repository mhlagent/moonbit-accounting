///|
pub fn generate(
  kind : StatementKind,
  period : String,
  entries : Array[Entry],
  mappings : Array[AccountMapping],
  comparison? : String,
) -> Report {
  let lines : Array[LineItem] = []
  for entry in entries {
    if entry.period != period && !(comparison is Some(p) && entry.period == p) {
      continue
    }
    match find_mapping(mappings, entry.account) {
      None => continue
      Some(mapping) => {
        if mapping.kind != kind && kind != Management {
          continue
        }
        let value = entry.balance(kind) * mapping.factor
        let mut found = false
        for i, item in lines {
          if item.line == mapping.line {
            lines[i] = {
              ..item,
              amount: item.amount + value,
              entries: item.entries + 1,
            }
            found = true
            break
          }
        }
        if !found {
          lines.push({ line: mapping.line, amount: value, entries: 1, })
        }
      }
    }
  }
  let mut total = 0
  for item in lines {
    total += item.amount
  }
  { kind, period, lines, total, }
}

///|
pub fn Report::line(self : Report, name : String) -> Amount? {
  for item in self.lines {
    if item.line == name {
      return Some(item.amount)
    }
  }
  None
}
