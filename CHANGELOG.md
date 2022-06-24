# Changelog

此处记载了项目中所有值得留意的改动。

格式参照 [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)，
并且此项目遵守 [Semantic Versioning](https://semver.org/spec/v2.0.0.html)。

## [Unreleased]

## [0.1.4] - 2022-06-24

### Added

- 给 `\fillin` 命令增加了可选参数接口
- `choices` 环境增加 `index` 接口

## [0.1.3] - 2022-06-22

### Added

- 增加密封线奇偶统一控制接口

### Fixed

- 修复密封线接口失效问题


## [0.1.2] - 2022-06-16

- 完成密封线的所有接口设计

## [0.1.2] - 2022-06-15

- 增加密封线


## [0.1.2] - 2022-06-14

### Added

- 新增页面尺寸 `a4paper` 和 `a3paper` 的控制
- 新增 `a3paper` 页面的“是否共用页脚”控制


## [0.1.1] - 2022-06-09

### Added

- 新增 `question` 环境的 `top-sep` 和 `bottom-sep` 选项控制前后距离（[#I4SLWN](https://gitee.com/zepinglee/exam-zh/issues/I4SLWN)）。
- 新增 `question` 环境的 `index` 选项设置题号（[#I4SQLI](https://gitee.com/zepinglee/exam-zh/issues/I4SQLI)）。
- 新增 `question` 环境的 `answer-color` 选项控制答案颜色（[#I4SW79](https://gitee.com/zepinglee/exam-zh/issues/I4SW79)）。
- 新增 `choices` 环境的 `label` 选项控制标签格式（[#I4SXC1](https://gitee.com/zepinglee/exam-zh/issues/I4SXC1)）。
- 新增 `\circlednumber` 使用中文字体生成带圈数字。
- 新增 `choices` 环境的 `label-align` 选项控制标签的对齐方式（[#I4TDSA](https://gitee.com/zepinglee/exam-zh/issues/I4TDSA)）。
- 新增 `exam-zh-font` 模块，提供西文字体 `font` 和数学字体 `math-font` 选项（[#I512EV](https://gitee.com/zepinglee/exam-zh/issues/I512EV)）。
- 新增 `fillin` 命令的 `type` 选项控制下划线和括号类型

### Fixed

- 答案的内容较高时调整深度（[#I4SXC1](https://gitee.com/zepinglee/exam-zh/issues/I4SXC1)）。

## [v0.1.0] - 2022-02-04

### Added

- 在 Gitee 发布。

[Unreleased]: https://gitee.com/zepinglee/exam-zh/compare/v0.1.0...HEAD
[v0.1.0]: https://gitee.com/zepinglee/exam-zh/releases/v0.1.0
[v0.1.1]: https://gitee.com/zepinglee/exam-zh/releases/v0.1.1
