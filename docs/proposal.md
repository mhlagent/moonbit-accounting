# MoonBit 黑客松项目申报书

**项目标识：** `moonbit-accounting`　　**项目名称：** MoonBit 财务报表生成器

**项目简介**　面向小型组织、开源项目和 MoonBit 应用开发者，提供一个与记账系统解耦的报表层：把标准化借贷分录和账户映射转换为资产负债表、利润表、现金流量表及管理报表，并以 CSV、JSON、Markdown 输出。项目不重复实现账簿、凭证或数据库，重点解决“同一份账务数据如何稳定、可测试地生成不同报表”的公共能力。

**为什么适合 MoonBit**　MoonBit 的强类型数据建模、代数数据类型和多后端编译适合表达报表类型、期间筛选和规则分派；整数最小货币单位避免浮点误差，纯计算核心便于 wasm、wasm-gc、JS 与 native 使用。项目将以独立库形式发布，可与 `moonbit-ledger` 或用户自有导入器组合，而不绑定某一种账务来源。

**MVP 范围**　定义 `Entry`、`AccountMapping`、`LineItem`、`Report` 等公共类型；支持账户映射、报表期间、可选比较期间、借贷汇总、期初/期末余额表达、符号因子和三类标准报表；提供 CSV/JSON/Markdown 渲染器、README 中的可执行例子、跨后端测试与 CI。现金流报表先复用带现金标记的标准化分录，保持边界清楚并为后续现金流规则留接口。

**扩展路线**　第一阶段加入比较期间差异和维度分析；第二阶段加入合并报表、抵销分录、可插拔汇总规则与 HTML 渲染；第三阶段提供 XBRL 导出、校验报告和与 ledger/importer 包的适配层。每个阶段都以公开 issue、测试用例、变更记录和可运行示例推进，避免一次性堆叠不可验证的功能。

**实施与验收**　仓库使用 Apache-2.0，保留清晰的单一作者提交历史；核心库按职责拆分，所有新增行为先补黑盒测试。验收标准为：`moon check --target all --deny-warn`、`moon test --target all`、格式化和 `moon info` 检查通过；README 能在干净环境完成构建；示例能生成三种机器/人类可读输出；公共 API 不泄露内部实现。CI 参考 MoonBit 社区 workflow template，覆盖 Ubuntu、macOS、Windows。

**生态差异**　已在 Mooncakes 以 accounting、ledger、financial statement 等关键词检索，并抽查相关文档；截至检索日未发现成熟的、以 MoonBit 财务报表生成为核心且与本项目同边界的包。现有 ledger 类项目可作为数据源，本项目明确保持独立报表层，降低重合和耦合风险。来源与核查记录见 `docs/ecosystem-check.md`。

