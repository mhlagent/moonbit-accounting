# moonbit-accounting

MoonBit financial statement generation for normalized accounting data.

See [README.mbt.md](README.mbt.md) for the tested API documentation and
[docs/proposal.md](docs/proposal.md) for the one-page project proposal.

The library is intentionally independent of bookkeeping and ledgers. It uses
integer minor units, explicit mappings, period filters, and deterministic
renderers so downstream applications can own their import and rounding policy.

## License

Apache-2.0. See [LICENSE](LICENSE).
