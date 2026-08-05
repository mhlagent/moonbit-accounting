// Learn more about moon.mod configuration:
// https://docs.moonbitlang.com/en/latest/toolchain/moon/module.html
//
// To add a dependency, run this command in your terminal:
//   moon add moonbitlang/x
//
// Or manually declare it in `import`, for example:
// import {
//   "moonbitlang/x@0.4.6",
// }

name = "mhlagent/moonbit-accounting"

version = "0.1.0"

readme = "README.mbt.md"

repository = "https://github.com/mhlagent/moonbit-accounting"

license = "Apache-2.0"

keywords = [ "accounting", "financial-report", "ledger", "moonbit" ]

preferred_target = "wasm-gc"

description = "Generate financial statements from normalized accounting entries."
