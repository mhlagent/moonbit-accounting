///|
/// Escape text for HTML contexts without relying on a runtime or DOM.
pub fn escape_html(value : String) -> String {
  let out = StringBuilder()
  for c in value {
    match c {
      '&' => out.write_string("&amp;")
      '<' => out.write_string("&lt;")
      '>' => out.write_string("&gt;")
      '"' => out.write_string("&quot;")
      '\'' => out.write_string("&#39;")
      _ => out.write_string(c.to_string())
    }
  }
  out.to_string()
}

///|
pub fn Report::to_html(self : Report) -> String {
  let out = StringBuilder()
  out.write_string("<table class=\"financial-report\"><caption>")
  out.write_string(escape_html(statement_name(self.kind)))
  out.write_string(" — ")
  out.write_string(escape_html(self.period))
  out.write_string(
    "</caption><thead><tr><th>Line</th><th>Amount</th><th>Entries</th></tr></thead><tbody>",
  )
  for item in self.lines {
    out.write_string("<tr><td>")
    out.write_string(escape_html(item.line))
    out.write_string("</td><td class=\"amount\">")
    out.write_string(item.amount.to_string())
    out.write_string("</td><td>")
    out.write_string(item.entries.to_string())
    out.write_string("</td></tr>")
  }
  out.write_string("</tbody><tfoot><tr><th>Total</th><th>")
  out.write_string(self.total.to_string())
  out.write_string("</th><th></th></tr></tfoot></table>")
  out.to_string()
}

///|
pub fn report_document(report : Report, title : String) -> String {
  "<!doctype html><html><head><meta charset=\"utf-8\"><title>" +
  escape_html(title) +
  "</title><style>.financial-report{border-collapse:collapse}.financial-report td,.financial-report th{border:1px solid #ddd;padding:.4rem}.amount{text-align:right}</style></head><body>" +
  report.to_html() +
  "</body></html>"
}

///|
pub fn render_variances(variances : Array[Variance]) -> String {
  let out = StringBuilder()
  out.write_string(
    "| Line | Current | Prior | Variance | Percent |\n| --- | ---: | ---: | ---: | ---: |\n",
  )
  for item in variances {
    out.write_string("| ")
    out.write_string(item.line)
    out.write_string(" | ")
    out.write_string(item.current.to_string())
    out.write_string(" | ")
    out.write_string(item.prior.to_string())
    out.write_string(" | ")
    out.write_string(item.absolute.to_string())
    out.write_string(" | ")
    match item.percent {
      Some(value) => out.write_string(value.to_string())
      None => out.write_string("n/a")
    }
    out.write_string(" |\n")
  }
  out.to_string()
}
