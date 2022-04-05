# Changelog

此处记载了项目中所有值得留意的改动。

格式参照 [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)，
并且此项目遵守 [Semantic Versioning](https://semver.org/spec/v2.0.0.html)。

## [Unreleased]

### Added

- 新增 `question` 环境的 `top-sep` 和 `bottom-sep` 选项控制前后距离（[#I4SLWN](https://gitee.com/zepinglee/exam-zh/issues/I4SLWN)）。
- 新增 `question` 环境的 `index` 选项设置题号（[#I4SQLI](https://gitee.com/zepinglee/exam-zh/issues/I4SQLI)）。
- 新增 `question` 环境的 `answer-color` 选项控制答案颜色（[#I4SW79](https://gitee.com/zepinglee/exam-zh/issues/I4SW79)）。
- 新增 `choices` 环境的 `label` 选项控制标签格式（[#I4SXC1](https://gitee.com/zepinglee/exam-zh/issues/I4SXC1)）。
- 新增 `\circlednumber` 使用中文字体生成带圈数字。
- 新增 `choices` 环境的 `label-align` 选项控制标签的对齐方式（[#I4TDSA](https://gitee.com/zepinglee/exam-zh/issues/I4TDSA)）。
- 新增 `exam-zh-font` 模块，提供西文字体 `font` 和数学字体 `math-font` 选项（[#I512EV](https://gitee.com/zepinglee/exam-zh/issues/I512EV)）。

### Fixed

- 答案的内容较高时调整深度（[#I4SXC1](https://gitee.com/zepinglee/exam-zh/issues/I4SXC1)）。

## [v0.1.0] - 2022-02-04

### Added

- 在 Gitee 发布。

[Unreleased]: https://gitee.com/zepinglee/exam-zh/compare/v0.1.0...HEAD
[v0.1.0]: https://gitee.com/zepinglee/exam-zh/releases/releases/v0.1.0
