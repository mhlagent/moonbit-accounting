# Accounting Hackathon Completion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deliver a tested, documented, multi-target MoonBit accounting/reporting library with honest source scale, benchmarks, CI, and Mooncakes release metadata.

**Architecture:** Keep public accounting types in the root package and add cohesive files for validation, periods, dimensions, consolidation, analysis, renderers, and benchmark fixtures. The CLI remains a thin consumer of the public package.

**Tech Stack:** MoonBit stable toolchain, Moon CLI, GitHub Actions, Mooncakes module metadata, Apache-2.0.

---

### Task 1: Establish failing boundary tests

**Files:**
- Create: `accounting_boundary_test.mbt`
- Create: `analysis_test.mbt`

- [ ] Add tests for malformed periods, unbalanced batches, duplicate mappings, empty reports, comparison variance, dimension totals, and ratio divide-by-zero behavior.
- [ ] Run `moon test` and confirm failures name missing APIs rather than syntax errors.

### Task 2: Add domain validation and period utilities

**Files:**
- Create: `periods.mbt`
- Create: `validation.mbt`
- Modify: `types.mbt`

- [ ] Add explicit period parsing/comparison, validation result types, batch balance checks, account and mapping validation, and dimension-aware entry constructors.
- [ ] Run targeted tests, then `moon check`.

### Task 3: Add dimensions, cash flow, consolidation, and budgets

**Files:**
- Create: `dimensions.mbt`
- Create: `cashflow.mbt`
- Create: `consolidation.mbt`
- Create: `budget.mbt`

- [ ] Implement deterministic dimension aggregation, cash-flow classification, entity consolidation with elimination entries, and budget variance summaries.
- [ ] Extend boundary tests for empty, negative, duplicate, and cross-period inputs.

### Task 4: Add financial analysis APIs

**Files:**
- Create: `analysis.mbt`
- Create: `trend.mbt`
- Create: `anomalies.mbt`

- [ ] Implement safe ratio calculations, trend points, variance summaries, and deterministic anomaly flags without floating-point money arithmetic.
- [ ] Run all tests and review generated public interface changes.

### Task 5: Add renderers, CLI output, and benchmark fixture

**Files:**
- Create: `html.mbt`
- Create: `benchmark.mbt`
- Modify: `serialize.mbt`
- Modify: `cmd/main/main.mbt`

- [ ] Add HTML and stable summary output, a deterministic large fixture, and a CLI demo that uses the public APIs.
- [ ] Run the benchmark command, record measured input size and elapsed time in `docs/benchmark.md`, and do not estimate values.

### Task 6: Expand tests and finish documentation

**Files:**
- Create: `benchmark_test.mbt`
- Create: `renderer_boundary_test.mbt`
- Modify: `README.md`
- Modify: `README.mbt.md`
- Modify: `CHANGELOG.md`

- [ ] Add deterministic renderer, large-fixture, and edge-case tests.
- [ ] Document project positioning, capabilities, quick start, CLI, architecture, benchmark, tests, CI, and license.
- [ ] Verify no internal submission language is present in public README files.

### Task 7: Harden CI and release workflow

**Files:**
- Modify: `.github/workflows/check.yml`
- Create: `.github/workflows/publish.yml`
- Modify: `moon.mod`

- [ ] Use the stable installer, `moon fmt --check`, strict all-target checks, default/native tests, coverage, and generated-interface cleanliness.
- [ ] Add tag-gated Mooncakes publishing with no credentials in source.

### Task 8: Final verification and publication

- [ ] Run `moon info --target all && moon fmt --check && moon check --target all --deny-warn && moon test --target all`.
- [ ] Count compiled `.mbt` source lines and record the exact command output.
- [ ] Run the repository self-check against structure, README, license, history, default branch, CI, and source scale.
- [ ] Commit changes, push `main` to GitHub, verify remote state, and publish the tagged module to Mooncakes using the authenticated CLI.
