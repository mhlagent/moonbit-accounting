///|
fn statement_name(kind : StatementKind) -> String {
  match kind {
    BalanceSheet => "balance_sheet"
    IncomeStatement => "income_statement"
    CashFlowStatement => "cash_flow_statement"
    Management => "management"
  }
}

///|
fn escape_csv(value : String) -> String {
  if value.contains(",") || value.contains("\"") {
    "\"" + value.replace(old="\"", new="\"\"") + "\""
  } else {
    value
  }
}

///|
fn escape_json(value : String) -> String {
  let out = StringBuilder::new()
  for c in value {
    match c {
      '"' => out.write_string("\\\"")
      '\\' => out.write_string("\\\\")
      '\n' => out.write_string("\\n")
      '\r' => out.write_string("\\r")
      '\t' => out.write_string("\\t")
      _ => out.write_string(c.to_string())
    }
  }
  out.to_string()
}

///|
pub fn Report::to_csv(self : Report) -> String {
  let out = StringBuilder::new()
  out.write_string("statement,period,line,amount,entries\n")
  for item in self.lines {
    out.write_string(escape_csv(statement_name(self.kind)))
    out.write_string(",")
    out.write_string(escape_csv(self.period))
    out.write_string(",")
    out.write_string(escape_csv(item.line))
    out.write_string(",")
    out.write_string(item.amount.to_string())
    out.write_string(",")
    out.write_string(item.entries.to_string())
    out.write_string("\n")
  }
  out.write_string("TOTAL,")
  out.write_string(self.period)
  out.write_string(",,")
  out.write_string(self.total.to_string())
  out.write_string(",\n")
  out.to_string()
}

///|
pub fn Report::to_json(self : Report) -> String {
  let parts : Array[String] = []
  for item in self.lines {
    parts.push(
      "{\"line\":\"" +
      escape_json(item.line) +
      "\",\"amount\":" +
      item.amount.to_string() +
      ",\"entries\":" +
      item.entries.to_string() +
      "}",
    )
  }
  "{\"statement\":\"" +
  escape_json(statement_name(self.kind)) +
  "\",\"period\":\"" +
  escape_json(self.period) +
  "\",\"total\":" +
  self.total.to_string() +
  ",\"lines\":[" +
  parts.join(",") +
  "]}"
}

///|
pub fn Report::to_markdown(self : Report) -> String {
  let out = StringBuilder::new()
  out.write_string("| Line | Amount | Entries |\n| --- | ---: | ---: |\n")
  for item in self.lines {
    out.write_string(
      "| " +
      item.line +
      " | " +
      item.amount.to_string() +
      " | " +
      item.entries.to_string() +
      " |\n",
    )
  }
  out.write_string("| **Total** | **" + self.total.to_string() + "** | |\n")
  out.to_string()
}
