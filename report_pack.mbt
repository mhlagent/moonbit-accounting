///|
/// A report pack groups the statements normally shown together.
#derive(Debug, Eq)
pub struct ReportPack {
  period : String
  reports : Array[Report]
}

///|
pub extend ReportPack with Eq::{not_equal, equal}

///|
pub extend ReportPack with @debug.Debug::{to_repr}

///|
pub fn build_report_pack(
  period : String,
  entries : Array[Entry],
  mappings : Array[AccountMapping],
) -> ReportPack {
  let reports = [
    generate(BalanceSheet, period, entries, mappings),
    generate(IncomeStatement, period, entries, mappings),
    generate(CashFlowStatement, period, entries, mappings),
    generate(Management, period, entries, mappings),
  ]
  { period, reports, }
}

///|
pub fn ReportPack::to_markdown(self : ReportPack) -> String {
  let out = StringBuilder()
  out.write_string("# Financial report pack — ")
  out.write_string(self.period)
  out.write_string("\n\n")
  for report in self.reports {
    out.write_string("## ")
    out.write_string(statement_name(report.kind))
    out.write_string("\n\n")
    out.write_string(report.to_markdown())
    out.write_string("\n")
  }
  out.to_string()
}
