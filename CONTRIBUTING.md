# Contributing

Issues and pull requests are welcome. Keep public APIs small, add a black-box
test for behavior changes, and document a new renderer or accounting rule.

Before opening a pull request, run:

```bash
moon check --target all --deny-warn
moon test --target all
moon fmt --warn
moon info --target all
```

Use one author identity for local commits and describe the user-facing reason
for each change. Do not commit credentials, imported ledgers, or generated
build directories.

