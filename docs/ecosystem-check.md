# 生态与来源核查

核查日期：2026-08-05。

- MoonBit 官方比赛仓库：<https://github.com/moonbitlang/OSC2026>。仓库公开页面与源码用于核对项目方向、公开仓库、文档、测试和一页申报材料等要求。
- MoonBit 社区 CI 模板：<https://github.com/moonbit-community/.github/tree/main/workflow-templates>。本项目的 `.github/workflows/check.yml` 参考其中的多平台 `check.yml`，增加严格警告检查。
- 参照 CI：<https://github.com/PaiGack/moonbit_sshclient/blob/main/.github/workflows/test.yml>。用于核对 MoonBit 安装、`moon update`、跨平台测试和格式/API 检查的组织方式。
- Mooncakes 入口：<https://mooncakes.io/>。以 `accounting`、`ledger`、`financial report`、`balance sheet`、`cash flow` 等关键词查看检索结果与包文档；未发现与本项目“标准化分录到多种财务报表”的边界高度重合且成熟的包。

结论是：项目可与 ledger、CSV/JSON 导入器或未来的 XBRL 包组合，核心价值在稳定的报表模型和渲染接口，而非复制现有记账实现。若提交前 Mooncakes 出现新的同类成熟项目，应在 README 中补充兼容/差异说明并调整范围。

