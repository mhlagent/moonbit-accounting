# Coverage record

Verified on 2026-11-11 with MoonBit 0.10.20.

```bash
moon test --target native --deny-warn --enable-coverage
moon coverage report -f summary
```

Result:

```text
Total: 738/752 (98.1%)
Tests: 59 passed
```

Remaining uncovered lines are mostly the CLI adapter (`cmd/main`), defensive
branches that are unreachable with the curated account catalogue, and narrow
error paths. The CLI is exercised separately by the native smoke test.
