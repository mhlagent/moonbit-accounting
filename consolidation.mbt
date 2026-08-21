///|
pub struct Entity {
  name : String
  entries : Array[Entry]
} derive(Debug, Eq)

///|
pub fn Entity::new(name : String, entries : Array[Entry]) -> Entity {
  { name, entries }
}

///|
pub fn consolidate(
  period : String,
  entities : Array[Entity],
  mappings : Array[AccountMapping],
) -> Report {
  let all : Array[Entry] = []
  for entity in entities {
    for entry in entity.entries {
      if entry.period == period {
        all.push(entry)
      }
    }
  }
  generate(BalanceSheet, period, all, mappings)
}
