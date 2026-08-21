# MoonBit Accounting Hackathon Completion Design

## Goal

Turn `moonbit-accounting` into a reusable, deterministic financial reporting
library for normalized accounting data, with an executable CLI, meaningful
boundary coverage, reproducible benchmarks, and release-ready MoonBit CI.

## Scope

The public package remains independent of ledgers, databases, and network
services. It accepts normalized entries and explicit rules, then produces
validated reports and deterministic renderings. The implementation will add
real behavior in these bounded areas:

- domain and validation: currencies, periods, accounts, dimensions, entries,
  batches, and balance checks;
- reporting: statement aggregation, comparisons, cash-flow classification,
  dimensions, consolidation, eliminations, and budgets;
- analysis: ratios, trends, variance analysis, and anomaly summaries;
- output: CSV, JSON, Markdown, HTML, and stable CLI summaries;
- verification: edge cases, property-like invariant tests, large deterministic
  fixtures, and benchmark timing/count records.

The proposal document is reference material only and will not be edited.

## Architecture

The root package owns public domain types and high-level APIs. Focused source
files group validation, period arithmetic, aggregation, analysis, and output.
Private helpers remain package-local so the generated interface exposes only
intentional APIs. The CLI under `cmd/main` calls the same public API as library
users and contains no duplicate accounting logic.

All money values use integer minor units. Ordering is explicit and stable.
Validation returns structured results rather than silently repairing invalid
data. Report generation is pure with respect to its inputs, making native and
Wasm-family checks reproducible.

## Testing and benchmarks

Every new public behavior gets a black-box test before implementation. Tests
cover empty inputs, zero and negative values, duplicate mappings, malformed
periods, unbalanced batches, missing accounts, repeated dimensions, comparison
periods, elimination rules, and deterministic renderer output. A deterministic
benchmark fixture will report input size, generated line count, and elapsed
milliseconds; README values will be copied from a fresh local run rather than
estimated.

## CI and release

CI will use the current stable MoonBit installer on Ubuntu, macOS, and Windows,
run formatting checks, strict checks for all targets, tests for the default and
native targets, coverage analysis, and generated-interface cleanliness. A
separate guarded publish workflow will publish to Mooncakes only on a version
tag and will use the repository's existing authenticated publishing mechanism;
no credentials will be committed.

## Acceptance evidence

Before delivery, the repository will contain a reproducible source-line count,
benchmark output, test and check commands, a clean generated interface diff,
the final default branch, and a GitHub Actions run. Public documentation will
describe the project, capabilities, quick start, CLI, architecture, benchmark,
testing, CI, and Apache-2.0 license without internal submission language.
